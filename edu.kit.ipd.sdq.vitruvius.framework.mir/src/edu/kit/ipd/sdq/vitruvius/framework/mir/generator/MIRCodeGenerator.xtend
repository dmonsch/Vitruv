package edu.kit.ipd.sdq.vitruvius.framework.mir.generator

import com.google.inject.Inject
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.Blackboard
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.Change
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.CorrespondenceInstance
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.EMFModelChange
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.TransformationResult
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.VURI
import edu.kit.ipd.sdq.vitruvius.framework.meta.change.EChange
import edu.kit.ipd.sdq.vitruvius.framework.contracts.meta.correspondence.Correspondence
import edu.kit.ipd.sdq.vitruvius.framework.mir.executor.api.MappedCorrespondenceInstance
import edu.kit.ipd.sdq.vitruvius.framework.mir.executor.helpers.EclipseHelper
import edu.kit.ipd.sdq.vitruvius.framework.mir.executor.helpers.EcoreHelper
import edu.kit.ipd.sdq.vitruvius.framework.mir.executor.helpers.JavaHelper
import edu.kit.ipd.sdq.vitruvius.framework.mir.executor.helpers.MIRMappingHelper
import edu.kit.ipd.sdq.vitruvius.framework.mir.executor.impl.AbstractMIRChange2CommandTransforming
import edu.kit.ipd.sdq.vitruvius.framework.mir.executor.impl.AbstractMIRMappingRealization
import edu.kit.ipd.sdq.vitruvius.framework.mir.executor.interfaces.MIRMappingRealization
import edu.kit.ipd.sdq.vitruvius.framework.mir.executor.interfaces.MIRModelInformationProvider
import edu.kit.ipd.sdq.vitruvius.framework.mir.helpers.MIRHelper
import edu.kit.ipd.sdq.vitruvius.framework.mir.intermediate.MIRintermediate.ClassMapping
import edu.kit.ipd.sdq.vitruvius.framework.mir.intermediate.MIRintermediate.ReferenceMapping
import edu.kit.ipd.sdq.vitruvius.framework.mir.intermediate.MIRintermediate.MIR
import edu.kit.ipd.sdq.vitruvius.framework.mir.intermediate.MIRintermediate.Mapping
import edu.kit.ipd.sdq.vitruvius.framework.mir.intermediate.MIRintermediate.NamedEReference
import edu.kit.ipd.sdq.vitruvius.framework.mir.intermediate.MIRintermediate.NamedTyped
import edu.kit.ipd.sdq.vitruvius.framework.mir.intermediate.MIRintermediate.StaticMethodCall
import edu.kit.ipd.sdq.vitruvius.framework.mir.intermediate.MIRintermediate.WhenWhereJavaPredicate
import edu.kit.ipd.sdq.vitruvius.framework.mir.intermediate.MIRintermediate.WithBlockPostCondition
import edu.kit.ipd.sdq.vitruvius.framework.util.datatypes.ClaimableHashMap
import edu.kit.ipd.sdq.vitruvius.framework.util.datatypes.ClaimableMap
import edu.kit.ipd.sdq.vitruvius.framework.util.datatypes.Pair
import java.util.ArrayList
import java.util.Collection
import java.util.Collections
import java.util.HashMap
import java.util.HashSet
import java.util.List
import java.util.Map
import java.util.Optional
import java.util.Set
import org.apache.log4j.Logger
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EClassifier
import org.eclipse.emf.ecore.EFactory
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator

import static edu.kit.ipd.sdq.vitruvius.framework.mir.executor.helpers.JavaHelper.*
import static edu.kit.ipd.sdq.vitruvius.framework.mir.executor.impl.AbstractMIRChange2CommandTransforming.*
import edu.kit.ipd.sdq.vitruvius.framework.mir.helpers.EMFHelper
import org.eclipse.emf.ecore.EAttribute
import java.util.UUID
import java.util.Random
import edu.kit.ipd.sdq.vitruvius.framework.mir.intermediate.MIRintermediate.WithAttributePostCondition
import edu.kit.ipd.sdq.vitruvius.dsls.mapping.helpers.MappingPluginProjectHelper

/**
 * @author Dominik Werle
 * TODO: refactor god class
 */
class MIRCodeGenerator implements IGenerator {
	private static final String SRC_GEN_FOLDER = "src-gen/";
	private static final String MAPPING_PKG_NAME = "mappings";
	private static final String LOGGER_NAME = "LOGGER";
	private static final String CONSTANTS_CLASS_NAME = "Constants";
	
	@Inject IGeneratorStatus generatorStatus;
	
	var Map<ClassMapping, String> predicateCheckMethodNames
	var Map<ClassMapping, String> createMethodNames

	var ClaimableMap<Mapping, String> mappingClassNames;

	var List<ClassMapping> classMappings
	
	@Override
	public override doGenerate(Resource input, IFileSystemAccess fsa) {
		val resourcePath = input.URI.trimSegments(1)
		val mirFile = MIRHelper.getMIR(input)
		
		resetState
		val il = generatorStatus.getIntermediateForMIR(mirFile)
		
		il.packages.forEach[
			addEntity(it)
		]
		
		val fqn = il.configuration.package + "." + il.configuration.type
		val projectName = MIRHelper.getProjectName(MIRHelper.getMIR(input));
		
		MappingPluginProjectHelper.createPluginXML(fsa, fqn);
		MappingPluginProjectHelper.createManifest(fsa, projectName,
			mirFile.bundles.map[bundleFQN],
			#[il.configuration.package,
			  il.configuration.package.mappingPackageName]
		)
		
		for (mapping : il.classMappings) {
			allocateMappingClassName(mapping)
		}
		
		for (mapping : il.classMappings) {
			generateMappingClass(mapping, il.configuration.package, fsa)
		}
		
		generateTransformationExecuting(il, resourcePath, fsa)
		
		generateConstants(il.configuration.package, fsa)
	}
	
	private def getFqn(MIR mir) {
		mir.configuration.package + "." + mir.configuration.type
	}
	
	private def getSimpleName(MIR mir) {
		mir.configuration.type
	}
	
	private def classNameToJavaPath(String name) {
		name.replace('.', PATH_SEPERATOR) + ".java"
	}
	
	private def resetState() {
		predicateCheckMethodNames = new HashMap<ClassMapping, String>()
		createMethodNames = new HashMap<ClassMapping, String>()
		mappingClassNames = new ClaimableHashMap<Mapping, String>()
		
		referencedEMFEntities = new HashMap<EPackage, List<Object>>()
	}
	
	new() {
		resetState
	}

	private static final char PATH_SEPERATOR = '/';
	
	private def packageNameToPath(String pkgName) {
		pkgName.replace('.', PATH_SEPERATOR) + PATH_SEPERATOR
	}
	
	/**
	 * The classes that are imported <strong>inside the generated class</strong>.
	 */
	private static final List<? extends Class<?>> IMPORTED_CLASSES_TRANSFORMATION_EXECUTING = #[
		EObject, Map, HashMap, List, ArrayList, Set, HashSet,
		IllegalArgumentException,
		Pair, VURI,
		AbstractMIRChange2CommandTransforming,
		CorrespondenceInstance, EMFModelChange, Change,
		EChange, EcoreHelper,
		Logger,
		MIRMappingRealization
	]
	
	private static final List<? extends Class<?>> IMPORTED_CLASSES_MAPPING = #[
		MIRMappingRealization, AbstractMIRMappingRealization,
		EChange, CorrespondenceInstance, MIRModelInformationProvider, EStructuralFeature,
		EClass, AbstractMIRChange2CommandTransforming, EObject, List, ArrayList,
		Set, HashSet, EPackage, Pair, MIRMappingHelper, MappedCorrespondenceInstance,
		Logger, JavaHelper, Collections, Blackboard, Optional, EcoreHelper,
		Collection, VURI, EclipseHelper, TransformationResult, EReference,
		Correspondence
	]
	
	/**
	 * Creates the import statements for {@link #IMPORTED_CLASSES}.
	 */
	private static def String getImportStatements(List<? extends Class<?>> classes) {
		'''
		«FOR i : classes»
		import «i.name»;
		«ENDFOR»
		'''
	}

	def createLoggerField(String className) {
		'''private static final Logger «LOGGER_NAME» = Logger.getLogger(«className».class);'''
	}

	private def generateTransformationExecuting(MIR file, URI resourcePath, IFileSystemAccess fsa) {
		classMappings = file.classMappings
		
		fsa.generateFile(SRC_GEN_FOLDER + file.fqn.classNameToJavaPath, '''
			package «file.configuration.package»;
			
			«getImportStatements(IMPORTED_CLASSES_TRANSFORMATION_EXECUTING)»
			
			import «file.configuration.package».«CONSTANTS_CLASS_NAME»;
			
			/**
			 * {@link AbstractMIRChange2CommandTransforming} for keeping the following meta models consistent:
			 * <ol>
			 *   <li>«file.packages.get(0).nsURI»</li>
			 *   <li>«file.packages.get(1).nsURI»</li>
			 * </ol>.
			 */
			@SuppressWarnings("unused")
			public class «file.configuration.type» extends «AbstractMIRChange2CommandTransforming.simpleName» {
				«createLoggerField(file.configuration.type)»
				
				/** The first mapped metamodel. **/
				public final static String «MM_ONE_FIELD_NAME» = "«file.packages.get(0).nsURI»";
				/** The second mapped metamodel. **/
				public final static String «MM_TWO_FIELD_NAME» = "«file.packages.get(1).nsURI»";
				
				/** The mappings. **/
				public final static Set<«MIRMappingRealization.simpleName»> «MAPPINGS_FIELD_NAME» = new HashSet<«MIRMappingRealization.simpleName»>();
				
				static {
					«FOR name : mappingClassNames.values»
					«MAPPINGS_FIELD_NAME».add(«file.configuration.package».mappings.«name».INSTANCE);
					«ENDFOR»
				}
				
				/** The correspondence instance for this TransformationExecuting. */
				
				public final static VURI «VURI_ONE_FIELD_NAME» = VURI.getInstance(«MM_ONE_FIELD_NAME»);
				public final static VURI «VURI_TWO_FIELD_NAME» = VURI.getInstance(«MM_TWO_FIELD_NAME»);
				
				/* Transformable metamodels. */
				private final List<Pair<VURI, VURI>> transformableMetamodels;
				
				public «file.configuration.type»() {
					transformableMetamodels = new ArrayList<Pair<VURI, VURI>>();
					transformableMetamodels.add(new Pair<VURI, VURI>(«VURI_ONE_FIELD_NAME», «VURI_TWO_FIELD_NAME»));
					transformableMetamodels.add(new Pair<VURI, VURI>(«VURI_TWO_FIELD_NAME», «VURI_ONE_FIELD_NAME»));
				}
				
				@Override
				protected void setup() {
					«FOR name : mappingClassNames.values»
					addMIRMapping(«file.configuration.package».mappings.«name».INSTANCE);
					«ENDFOR»
				}
				
				@Override
				public List<Pair<VURI, VURI>> getTransformableMetamodels() {
					return transformableMetamodels;
				}
			}
		''')
	}
	
	def String nextMappingClassName() {
		'''Mapping''' + mappingClassNames.size
	}
	
	def dispatch String createMappingClassName(ClassMapping mapping) {
		val leftTypeName = mapping.left.type.name
		val rightTypeName = mapping.right.type.name
		nextMappingClassName + "C_" + leftTypeName + "_" + rightTypeName
	}
	
	def dispatch String createMappingClassName(ReferenceMapping mapping) {
		val leftTypeName = mapping.left.get(0).name
		val rightTypeName = mapping.right.get(0).name
		nextMappingClassName + "_Feature_" + leftTypeName + "_" + rightTypeName
	}
	
	def String mappingPackageName(String rootPkgName) {
		rootPkgName + "." + MAPPING_PKG_NAME
	}
	
	def String checkWhenWhereJava(WhenWhereJavaPredicate predicate) '''
		«predicate.checkExpression.toJavaExpression»
	'''
	
	def private void allocateMappingClassName(Mapping mapping) {
		val className = createMappingClassName(mapping)
		mappingClassNames.put(mapping, className)
	}
	
	def static FQN(NamedTyped nt) {
		nt?.type?.instanceTypeName
	}
	
	def dispatch generateMappingClass(ClassMapping mapping, String pkgName, IFileSystemAccess fsa) {
		val left = mapping.left
		val right = mapping.right
		
		val leftType = mapping.left.type
		val rightType = mapping.right.type
		
		val hasFeatureMapping = (mapping.featureMapping != null)

		val featureMapping = mapping.featureMapping
		val hasLeftParents = hasFeatureMapping && !featureMapping.left.empty
		val baseClassMapping = featureMapping?.parent
		val leftBase = baseClassMapping?.left
		val rightBase = baseClassMapping?.right
		
		val baseClassMappingClass = mappingClassNames.get(baseClassMapping)
		
		val className = mappingClassNames.claimValueForKey(mapping)
		val reverseClassName = mappingClassNames.claimValueForKey(mapping.opposite)

		fsa.generateFile(SRC_GEN_FOLDER + (pkgName.mappingPackageName + "." + className).classNameToJavaPath,
		'''
			package «pkgName.mappingPackageName»;
			
			«getImportStatements(IMPORTED_CLASSES_MAPPING)»
			
			import «pkgName».«CONSTANTS_CLASS_NAME»;
			
			/**
			 * Class Mapping from
			 * <ul>
			 *   <li>{@link «left.FQN»} to</li>
			 *   <li>{@link «right.FQN»}</li>
			 * </ul>.
			 *
			 * Reverse mapping is {@link «reverseClassName»}.
			 */
			@SuppressWarnings("unused")
			public class «className» extends «AbstractMIRMappingRealization.simpleName» {
				«createLoggerField(className)»
				private static final long serialVersionUID = «(new Random).nextLong.toString
					/* TODO: maybe do more intelligent calculation */»L;
				
				// Singleton
				public final static «className» INSTANCE = new «className»();
				
				private «className»() {}
				
				private final static «MIRMappingRealization.simpleName» REVERSE = «reverseClassName».INSTANCE;
				
				protected boolean checkConditions(EObject context,
					Blackboard blackboard) {

					if (!(context instanceof «left.FQN»)) {
						return false;
					}
					
					«left.FQN» «left.name» =
						(«left.FQN») context;

					«IF hasFeatureMapping»
					if (!getBase(«left.name»).isPresent()) {
						return false;
					}
					«ENDIF»
					
					
					«FOR predicate : mapping.predicates.filter(WhenWhereJavaPredicate)»
					if (!(«predicate.checkWhenWhereJava»)) {
						return false;
					}
					«ENDFOR»
					
					«FOR predicate : mapping.predicates.filter[!(it instanceof WhenWhereJavaPredicate)]»
						// unsupported predicate: «predicate»
					«ENDFOR»
					
					return true;
				}
			
				@Override
				protected EClass getMappedEClass() {
					return «referenceConstant(leftType)»;
				}
				
				@Override
				public String getMappingID() {
					return «className».class.getName();
				}
			
				@Override
				protected void restorePostConditions(EObject eObject, EObject target, EChange change,
						Blackboard blackboard) {
					LOGGER.trace("restorePostConditions(" + eObject.toString() + ", " + target.toString() + ", " + change.toString() + ")");
					
					final «left.FQN» «left.name» = «JavaHelper.simpleName».requireType(eObject, «left.FQN».class);
					final «right.FQN» «right.name» = «JavaHelper.simpleName».requireType(target, «right.FQN».class);
					
					«IF hasFeatureMapping»
					final «leftBase.FQN» «leftBase.name» = «className».claimBase(«left.name»);
					final «rightBase.FQN» «rightBase.name» = «reverseClassName».claimBase(«right.name»);
					«ENDIF»
					
					/*
						«IF hasFeatureMapping»
						«tryBindFeatureMapping(featureMapping.left, left.name, false)»
						«tryBindFeatureMapping(featureMapping.right, right.name, false)»
						«ENDIF»
					*/
					
					// TODO: bind all necessary elements 
					// TODO: restore post conditions
					«FOR with_block : mapping.postconditions.filter(WithBlockPostCondition)»
					«restorePostCondition(with_block)»
					«ENDFOR»
					
					«FOR withAttribute : mapping.postconditions.filter(WithAttributePostCondition)»
					«restorePostCondition(withAttribute)»
					«ENDFOR»
				}
			
				@Override
				protected Collection<Pair<EObject, VURI>> createCorresponding(EObject eObject,
						Blackboard blackboard) {
					LOGGER.trace("createCorresponding(" + eObject.toString() + ", " + blackboard.toString() + ")");
					final «MappedCorrespondenceInstance.name» ci = getMappedCorrespondenceInstanceFromBlackboard(blackboard);
					
					final Collection<Pair<EObject, VURI>> result = new HashSet<Pair<EObject, VURI>>();
					
					«left.FQN» «left.name» = «JavaHelper.simpleName».requireType(eObject, «left.FQN».class);
					
					«IF hasFeatureMapping»
						final «rightBase.FQN» «rightBase.name» = claimBaseCorresponding(«left.name», blackboard);
						
						«createReferenceStructure(featureMapping.right, rightBase.name)»
					«ELSE»
						«right.FQN» «right.name» = «createConstant(rightType)»;
					«ENDIF»

					result.addAll(handleNonContainedEObjects(Collections.singleton(«right.name»)));
					
					// create here, since containment is decided here
					// TODO: what is the correspondence structure when feature hopping?
					Correspondence stc = ci.createAndAddEObjectCorrespondence(«left.name», «right.name»);
					ci.registerMappingForCorrespondence(stc, this);
					ci.registerMappingForCorrespondence(stc, «className».REVERSE);
					
					return result;
				}
				
				«/*@Override
				protected void deleteCorresponding(EObject eObject, EObject target, Blackboard blackboard, TransformationResult transformationResult) {
					LOGGER.trace("deleteCorresponding(" + eObject.toString()
						+ ", " + target.toString()
						+ ", " + blackboard.toString() + ")");
					
					super.deleteCorresponding(eObject, target, blackboard, transformationResult);
				}*/»
				
				public static Optional<«right.FQN»> getCorresponding(«left.FQN» «left.name», «Blackboard.simpleName» blackboard) {
					final «MappedCorrespondenceInstance.simpleName» ci =
						getMappedCorrespondenceInstanceFromBlackboard(blackboard);
						
					final Optional<«right.FQN»> «right.name» = JavaHelper.tryCast(
						ci.getMappingTarget(«left.name», «className».INSTANCE), «right.FQN».class);
						
					return «right.name»;
				}
				
				public static «right.FQN» claimCorresponding(«left.FQN» «left.name», «Blackboard.simpleName» blackboard) {
					final «right.FQN» «right.name» = getCorresponding(«left.name», blackboard)
						.orElseThrow(() ->
							new IllegalStateException("Could not find mapped «right.FQN» for «left.FQN» " + «left.name».toString()));
					
					return «right.name»;
				}
				
				«IF hasFeatureMapping»
				public static Optional<«leftBase.FQN»> getBase(«left.FQN» «left.name») {
					«tryBindFeatureMapping(featureMapping.left, left.name, true)»
				}
				
				public static «leftBase.FQN» claimBase(«left.FQN» «left.name») {
					final Optional<«leftBase.FQN»> «leftBase.name» = getBase(«left.name»);
					return «leftBase.name».orElseThrow(() -> new IllegalStateException(
						"Could not find the correct reference structure from «leftBase.FQN» to «left.FQN» " + «left.name».toString()));
				}
				
				public static Optional<«rightBase.FQN»> getBaseCorresponding(«left.FQN» «left.name», Blackboard blackboard) {
					return getBase(«left.name»).map(it ->
						«baseClassMappingClass».getCorresponding(it, blackboard).orElse(null));
				}
				
				public static «rightBase.FQN» claimBaseCorresponding(«left.FQN» «left.name», Blackboard blackboard) {
					final «leftBase.FQN» «leftBase.name» = claimBase(«left.name»);
					final «rightBase.FQN» «rightBase.name» =
						«baseClassMappingClass».claimCorresponding(«leftBase.name», blackboard);
						
					return «rightBase.name»;
				}
				«ENDIF»
			}
		'''
		)
	}
	
	private Map<EPackage, List<Object>> referencedEMFEntities
	
	// TODO: Multimap Class!
	private def void addEntity(EPackage pkg, Object obj) {
		if (!referencedEMFEntities.containsKey(pkg))
			referencedEMFEntities.put(pkg, new ArrayList)
		
		if (!referencedEMFEntities.get(pkg).contains(obj))
			referencedEMFEntities.get(pkg).add(obj)
	}
	
	private def List<Object> getFromMultimap(EPackage pkg) {
		referencedEMFEntities.get(pkg).immutableCopy ?: Collections.emptyList
	}
	
	def private addEntity(EPackage pkg) {
		addEntity(pkg, pkg)
		addEntity(pkg, pkg.EFactoryInstance)
	}
	
	def dispatch private referenceConstant(EClass eClass) {
		addEntity(eClass.EPackage, eClass)
		
		'''«CONSTANTS_CLASS_NAME».«eClass.EPackage.constantClassName».«eClass.fieldName»'''
	}
	
	def dispatch private referenceConstant(EStructuralFeature feature) {
		val eClass = feature.EContainingClass
		addEntity(eClass.EPackage, eClass)
		addEntity(eClass.EPackage, feature)
		
		'''«CONSTANTS_CLASS_NAME».«eClass.EPackage.constantClassName».«feature.fieldName»'''
	}
	
	def private createConstant(EClass eClass) {
		'''«CONSTANTS_CLASS_NAME».«eClass.EPackage.constantClassName».create«eClass.name.toFirstUpper»()'''
	}
	
	def private constantClassName(EPackage pkg) {
		pkg.name.toFirstUpper
	}
	
	def dispatch private CharSequence fieldName(EPackage pkg) {
		"_PACKAGE"
	}
	
	def dispatch private CharSequence fieldName(EFactory factory) {
		"_FACTORY"
	}
	
	def dispatch private CharSequence fieldName(EClass eClass) {
		eClass.name.toUpperCase + "_ECLASS"
	}
	
	def dispatch private CharSequence fieldName(EStructuralFeature feature) {
		val containerClass = feature.EContainingClass
		
		'''«containerClass.name.toUpperCase»__«feature.name.toUpperCase»'''
	}
	
	def dispatch private createReferenceable(Object obj) '''
		// no static constant created for «obj.toString»
	'''
	
	def dispatch private createReferenceable(EPackage pkg) '''
		public static final «EPackage.simpleName» «pkg.fieldName» =
			«EMFHelper.getJavaExpressionThatReturns(pkg, false)»;
	'''
	
	def dispatch private createReferenceable(EFactory factory) '''
		public static final «EFactory.simpleName» «factory.fieldName» =
			«factory.EPackage.fieldName».getEFactoryInstance();
	'''
	
	def dispatch private createReferenceable(EClass eClass) {
		val classifierID = eClass.classifierID
		val pkg = eClass.EPackage
		val factory = pkg.EFactoryInstance
		
		'''
		public static final «EClass.simpleName» «eClass.fieldName» =
			(«EClass.simpleName») «pkg.fieldName».getEClassifiers().get(«classifierID»);
			
		public static «eClass.instanceTypeName» create«eClass.name.toFirstUpper»() {
			return («eClass.instanceTypeName») («factory.fieldName».create(«eClass.fieldName»));
		}
		'''
	}
	
	def dispatch private createReferenceable(EAttribute feature) {
		val featureID = feature.featureID
		val containerClass = feature.EContainingClass
		
		'''
		public static final «EAttribute.simpleName» «feature.fieldName» =
			(«EAttribute.simpleName») «containerClass.fieldName».getEStructuralFeature(«featureID»);
		'''
	}
	
	def dispatch private createReferenceable(EReference feature) {
		val featureID = feature.featureID
		val containerClass = feature.EContainingClass
		
		'''
		public static final «EReference.simpleName» «feature.fieldName» =
			(«EReference.simpleName») «containerClass.fieldName».getEStructuralFeature(«featureID»);
		'''
	}
	
	def private generateConstants(String pkgName, IFileSystemAccess fsa) {
		fsa.generateFile(SRC_GEN_FOLDER + (pkgName + "." + CONSTANTS_CLASS_NAME).classNameToJavaPath, '''
		package «pkgName»;
		
		«getImportStatements(#[EPackage, EFactory, EClass, EStructuralFeature, EReference, EAttribute])»
		
		@SuppressWarnings("unused")
		public final class «CONSTANTS_CLASS_NAME» {
			«FOR pkg : referencedEMFEntities.keySet»
			// EPackage «pkg.commentString»
			public static class «pkg.constantClassName» {
				«FOR referenceable : getFromMultimap(pkg)»
				«referenceable.createReferenceable»
				
				«ENDFOR»
			}
			
			«ENDFOR»
		}
		''')
	}
	
	def tryBindFeatureMapping(List<NamedEReference> references, String checkVarName, boolean returnOptional) {
		val result = new StringBuilder
		var previousOptionalName = '''Optional.ofNullable(«checkVarName»)'''
		
		for (ref : references) {
			val containerTypeName = ref.EClass.instanceTypeName
			val referVarName = ref.name + "Referencee"
			
			result.append('''
			Optional<«containerTypeName»> «referVarName» = «previousOptionalName».flatMap(
				(it) -> EcoreHelper.findOneReferencee(it, «referenceConstant(ref.EReference)», «containerTypeName».class)
			);
			''')
			
			previousOptionalName = referVarName
		}
		
		if (returnOptional) {
			result.append('''
				return «previousOptionalName»; 
			''')
		}
		
		return result.toString
	}
	
	def createReferenceStructure(List<NamedEReference> references, String baseName) {
		var previousName = baseName
		
		val result = new StringBuilder
		
		for (ref : references.reverseView) {
			result.append('''
			«ref.FQN» «ref.name» = «createConstant(ref.type)»;
			
			«IF ref.EReference.many»
				«JavaHelper.simpleName».requireCollectionType(
					«previousName».eGet(«referenceConstant(ref.EReference)»),
					«ref.FQN».class)
					.add(«ref.name»);
			«ELSE»
				«previousName».eSet(«referenceConstant(ref.EReference)», «ref.name»);
			«ENDIF»
			
			«IF ref.EReference.containment»
			// TODO: omit handling, reference is containment
			«ENDIF»
			''')
			
			previousName = ref.name
		}
		
		return result.toString
	}
	
	def restorePostCondition(WithBlockPostCondition pc) '''
		«pc.assignmentExpression.toJavaExpression»;
	'''
	
	def restorePostCondition(WithAttributePostCondition pc) '''
		«pc.rightVariableName».eSet(«referenceConstant(pc.right)», «pc.leftVariableName».eGet(«referenceConstant(pc.left)»));
	'''
	
	def toJavaExpression(StaticMethodCall smc) {
		return '''«smc.methodFQN»(«String.join(", ", smc.parameterNames)»)'''
	}
	
	def static dispatch String commentString(EStructuralFeature feature) '''
		«feature.containerClass.name» . «feature.name»
	'''
	
	def static dispatch String commentString(EClassifier clazz) '''
		«clazz.instanceTypeName»
	'''
	
	def static dispatch String commentString(NamedEReference nERef) '''
		«nERef.EReference.commentString»
	'''
	
	def static dispatch String commentString(EPackage pkg) '''
		«pkg.name» («pkg.nsURI»)
	'''
}