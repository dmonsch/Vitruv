package edu.kit.ipd.sdq.vitruvius.framework.mir.generator

import com.google.inject.Inject
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.Change
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.CorrespondenceInstance
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.EMFChangeResult
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.EMFModelChange
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.VURI
import edu.kit.ipd.sdq.vitruvius.framework.contracts.interfaces.EMFModelTransformationExecuting
import edu.kit.ipd.sdq.vitruvius.framework.meta.change.EChange
import edu.kit.ipd.sdq.vitruvius.framework.mir.executor.helpers.EcoreHelper
import edu.kit.ipd.sdq.vitruvius.framework.mir.executor.impl.AbstractMIRMapping
import edu.kit.ipd.sdq.vitruvius.framework.mir.executor.impl.AbstractMIRTransformationExecuting
import edu.kit.ipd.sdq.vitruvius.framework.mir.executor.interfaces.MIRMapping
import edu.kit.ipd.sdq.vitruvius.framework.mir.executor.interfaces.MIRModelInformationProvider
import edu.kit.ipd.sdq.vitruvius.framework.mir.helpers.EMFHelper
import edu.kit.ipd.sdq.vitruvius.framework.mir.helpers.MIRHelper
import edu.kit.ipd.sdq.vitruvius.framework.mir.intermediate.MIRintermediate.ClassMapping
import edu.kit.ipd.sdq.vitruvius.framework.mir.intermediate.MIRintermediate.FeatureMapping
import edu.kit.ipd.sdq.vitruvius.framework.mir.intermediate.MIRintermediate.MIR
import edu.kit.ipd.sdq.vitruvius.framework.mir.intermediate.MIRintermediate.Mapping
import edu.kit.ipd.sdq.vitruvius.framework.util.datatypes.Pair
import java.util.ArrayList
import java.util.HashMap
import java.util.HashSet
import java.util.List
import java.util.Map
import java.util.Set
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.EClass
import edu.kit.ipd.sdq.vitruvius.framework.mir.intermediate.MIRintermediate.WhenWhereJavaClass
import org.eclipse.emf.ecore.EPackage
import edu.kit.ipd.sdq.vitruvius.framework.mir.intermediate.MIRintermediate.NamedTyped

/**
 * @author Dominik Werle
 */
class MIRCodeGenerator implements IGenerator {
	private static final String CONTEXT_NAME = "context";
	private static final String RESULT_NAME = "result";
	private static final String SRC_GEN_FOLDER = "src-gen/";
	private static final String MAPPING_PKG_NAME = "mappings";
	
	@Inject IGeneratorStatus generatorStatus;
	
	var Map<ClassMapping, String> predicateCheckMethodNames
	var Map<ClassMapping, String> createMethodNames

	var Map<Mapping, String> mappingClassNames;


	var List<ClassMapping> ClassMappings
	
	@Override
	public override doGenerate(Resource input, IFileSystemAccess fsa) {
		val resourcePath = input.URI.trimSegments(1)
		val mirFile = MIRHelper.getMIR(input)
		
		resetState
		val il = generatorStatus.getIntermediateForMIR(mirFile)
		
		val fqn = il.configuration.package + "." + il.configuration.type
		val projectName = MIRHelper.getProjectName(MIRHelper.getMIR(input));
		
		MIRPluginProjectCreator.createPluginXML(fsa, fqn);
		MIRPluginProjectCreator.createManifest(fsa, projectName, mirFile.bundles.map[bundleFQN])
		
		for (mapping : il.classMappings) {
			generateMappingClass(mapping, il.configuration.package, fsa)
		}
		
		generateTransformationExecuting(il, resourcePath, fsa)
	}
	
	private def resetState() {
		predicateCheckMethodNames = new HashMap<ClassMapping, String>()
		createMethodNames = new HashMap<ClassMapping, String>()
		mappingClassNames = new HashMap<Mapping, String>()
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
	private static final List<? extends Class<?>> IMPORTED_CLASSES = #[
		EObject, Map, HashMap, List, ArrayList,
		IllegalArgumentException,
		Pair, EMFModelTransformationExecuting, EMFChangeResult, VURI,
		AbstractMIRTransformationExecuting,
		CorrespondenceInstance, EMFModelChange, Change,
		EChange, EcoreHelper
	]
	
	/**
	 * Creates the import statements for {@link #IMPORTED_CLASSES}.
	 */
	private static def String getImportStatements() {
		'''
		«FOR i : IMPORTED_CLASSES»
		import «i.name»;
		«ENDFOR»
		'''
	}

	private def generateTransformationExecuting(MIR file, URI resourcePath, IFileSystemAccess fsa) {
		ClassMappings = file.classMappings
		
		fsa.generateFile(SRC_GEN_FOLDER + file.configuration.package.packageNameToPath + file.configuration.type + ".java", '''
			package «file.configuration.package»;
			
			«importStatements»
			
			/**
			 * {@link EMFModelTransformationExecuting} for keeping the following meta models consistent:
			 * <ol>
			 *   <li>«file.packages.get(0).nsURI»</li>
			 *   <li>«file.packages.get(1).nsURI»</li>
			 * </ol>.
			 */
			class «file.configuration.type» extends «AbstractMIRTransformationExecuting.simpleName» {
				/** The first mapped metamodel. **/
				public final String MM_ONE = "«file.packages.get(0).nsURI»";
				/** The second mapped metamodel. **/
				public final String MM_TWO = "«file.packages.get(1).nsURI»";
				
				private final VURI VURI_ONE = VURI.getInstance(MM_ONE);
				private final VURI VURI_TWO = VURI.getInstance(MM_TWO);
				
				/* Transformable metamodels. */
				private final List<Pair<VURI, VURI>> transformableMetamodels;
				
				private final Map<EObject, Integer> currentMappingID;
				
				public «file.configuration.type»() {
					currentMappingID = new HashMap<EObject, Integer>();
					
					transformableMetamodels = new ArrayList<Pair<VURI, VURI>>();
					transformableMetamodels.add(new Pair<VURI, VURI>(VURI_ONE, VURI_TWO));
					transformableMetamodels.add(new Pair<VURI, VURI>(VURI_TWO, VURI_ONE));
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
	
	def String mappingPackageName(String rootPkgName) {
		rootPkgName + "." + MAPPING_PKG_NAME
	}
	
	def String checkWhenWhereJava(WhenWhereJavaClass predicate) {
		'''
		«predicate.methodFQN»(
			«predicate.parameterNames.map[it].join(", ")»
		)
		'''
	}
	
	def dispatch generateMappingClass(ClassMapping mapping, String pkgName, IFileSystemAccess fsa) {
		val className = nextMappingClassName
		mappingClassNames.put(mapping, className)
		
		fsa.generateFile(SRC_GEN_FOLDER + pkgName.mappingPackageName.packageNameToPath + className + ".java",
		'''
			package «pkgName.mappingPackageName»;
			
			import «MIRMapping.name»;
			import «AbstractMIRMapping.name»;
			import «EMFChangeResult.name»;
			import «EChange.name»;
			import «CorrespondenceInstance.name»;
			import «MIRModelInformationProvider.name»;
			
			import «EStructuralFeature.name»;
			import «EClass.name»;
			
			import «AbstractMIRTransformationExecuting.name»;
			import «EObject.name»;
			
			import «List.name»;
			import «ArrayList.name»;
			import «Set.name»;
			import «HashSet.name»;
			
			import «EPackage.name»;
			
			import «Pair.name»;
			
			/**
			 * Class Mapping
			 */
			public class «className» extends «AbstractMIRMapping.simpleName» {
				// final static Logger logger = Logger.getLogger(«className».class);
				
				final Set<EObject> managedEObjects = new HashSet<EObject>();
				
				// Singleton
				public final static «className» INSTANCE = new «className»();
				
				private «className»() {}
				
				protected boolean checkConditions(EObject context, CorrespondenceInstance correspondenceInstance,
						AbstractMIRTransformationExecuting transformationExecuting) {

					if (!(context instanceof «mapping.left.type.instanceTypeName»)) {
						return false;
					}
					
					«mapping.left.type.instanceTypeName» «mapping.left.name» =
						(«mapping.left.type.instanceTypeName») context;

					«featureMappingCheckAndBindingJava(mapping, 0)»
					
					«FOR predicate : mapping.predicates.filter(WhenWhereJavaClass)»
					if (!(«predicate.checkWhenWhereJava»)) {
						return false;
					}
					«ENDFOR»
					
					«FOR predicate : mapping.predicates.filter[!(it instanceof WhenWhereJavaClass)]»
						// unsupported predicate: «predicate»
					«ENDFOR»
					
					return true;
				}
				
				@Override
				protected EClass getMappedEClass() {
					// TODO Auto-generated method stub
					return null;
				}
			
				@Override
				protected void restorePostConditions(EChange eChange,
						CorrespondenceInstance correspondenceInstance,
						AbstractMIRTransformationExecuting transformationExecuting) {
					// TODO Auto-generated method stub
					
				}
			
				@Override
				protected void createCorresponding(EObject eObject,
						CorrespondenceInstance correspondenceInstance,
						AbstractMIRTransformationExecuting transformationExecuting) {
					// TODO Auto-generated method stub
					
				}
			
				@Override
				protected void deleteCorresponding(EObject eObject,
						CorrespondenceInstance correspondenceInstance,
						AbstractMIRTransformationExecuting transformationExecuting) {
					// TODO Auto-generated method stub
					
				}
			}
		'''
		)
	}
	
	
	def String featureMappingCheckAndBindingJava(ClassMapping mapping, int index) {
		if (mapping.featureMapping != null) {
			val classMappingLeftName = mapping.left.name
			
			val leftType = mapping.featureMapping.parent.left.type
			val leftName = mapping.featureMapping.parent.left.name
			
			val rightType = mapping.featureMapping.parent.right.type
			val rightName = mapping.featureMapping.parent.right.name
			
			val pairName = '''parentAndMappedEObject_«index»'''
			val featureName = '''feature_«index»'''
			val mappingName = '''mapping_«index»'''
			
			
			'''
			// feature «mapping.featureMapping.left.get(0).feature.name»
			EStructuralFeature «featureName» =
			  «EMFHelper.getJavaExpressionThatReturns(mapping.featureMapping.left.get(0).feature, true)»;
			
			MIRMapping «mappingName» =
			  «mappingClassNames.get(mapping.featureMapping.parent)».INSTANCE;
			
			Pair<EObject, EObject> «pairName» =
				transformationExecuting.getReverseFeatureMappedBy(«classMappingLeftName»,
					«featureName», correspondenceInstance, «mappingName»);
					
			«leftType.instanceTypeName» «leftName» =
				(«leftType.instanceTypeName») «pairName».getFirst();
				
			if ((«pairName».getSecond() == null)
			   || !(«pairName».getSecond() instanceof
			          «mapping.featureMapping.left.get(0).EClass.instanceTypeName»))
				{ return false; }
			
			// else: type of mapped element is correct
			«rightType.instanceTypeName» «rightName» =
				(«rightType.instanceTypeName») «pairName».getSecond();
			
			
			«featureMappingCheckAndBindingJava(mapping.featureMapping.parent, index + 1)»
			'''
		} else {
			""
		}
	}
	
	def dispatch generateMappingClass(FeatureMapping mapping, String pkgName, IFileSystemAccess fsa) {
	}
}