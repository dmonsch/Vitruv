/*
 * generated by Xtext 2.9.0
 */
package edu.kit.ipd.sdq.vitruvius.dsls.response.jvmmodel

import com.google.inject.Inject
import edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.Response
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.common.types.JvmVisibility
import org.eclipse.xtext.xbase.jvmmodel.AbstractModelInferrer
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor

import static extension edu.kit.ipd.sdq.vitruvius.dsls.response.generator.ResponseLanguageGeneratorUtils.*;
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1
import java.util.Map
import java.util.HashMap
import org.apache.log4j.Logger
import org.eclipse.xtext.common.types.JvmField
import edu.kit.ipd.sdq.vitruvius.dsls.response.api.interfaces.IResponseRealization

/**
 * <p>Infers a JVM model for the Xtend code blocks of the response file model.</p> 
 *
 * <p>The resulting classes are not to be persisted but only to be used for content assist purposes.</p>
 * 
 * @author Heiko Klare     
 */
class ResponseLanguageJvmModelInferrer extends AbstractModelInferrer implements IJvmOperationRegistry {

	@Inject extension JvmTypesBuilderWithoutAssociations _typesBuilder
	private Map<String, JvmOperation> methodMap;
	
	def dispatch void infer(Response response, IJvmDeclaredTypeAcceptor acceptor, boolean isPreIndexingPhase) {
		if (isPreIndexingPhase) {
			return;
		}
		
		acceptor.accept(generateClass(response, response));
		if (response.hasOppositeResponse()) {
			acceptor.accept(generateClass(response.oppositeResponse, response));
		}
	}
	
	public def JvmGenericType generateClass(Response response, EObject sourceElement) {
		this.methodMap = new HashMap<String, JvmOperation>();
		val methodGenerator = new ResponseMethodGenerator(response, this, _typeReferenceBuilder, _typesBuilder);
		methodGenerator.generateMethodGetTrigger();
		methodGenerator.generateMethodApplyChange();
		
		sourceElement.toClass(response.responseQualifiedName) [
			visibility = JvmVisibility.DEFAULT;
			superTypes += typeRef(IResponseRealization);
			members += generateLoggerInitialization(it);
			members += methodMap.values;
		];
	}
	
	private def JvmField generateLoggerInitialization(JvmGenericType clazz) {
		generateUnassociatedField("LOGGER", typeRef(Logger)) [
			visibility = JvmVisibility.PUBLIC;
			initializer = '''«Logger».getLogger(«clazz».class)'''
		]
	}
			
	override JvmOperation getOrGenerateMethod(EObject contextObject, String methodName, JvmTypeReference returnType, Procedure1<? super JvmOperation> initializer) {
		if (!methodMap.containsKey(methodName)) {
			val operation = contextObject.toMethod(methodName, returnType, initializer);
			methodMap.put(operation.simpleName, operation);
		}
		
		return methodMap.get(methodName);
	}
	
	override JvmOperation getOrGenerateMethod(String methodName, JvmTypeReference returnType, Procedure1<? super JvmOperation> initializer) {
		if (!methodMap.containsKey(methodName)) {
			val operation = generateUnassociatedMethod(methodName, returnType, initializer);
			methodMap.put(operation.simpleName, operation);
		}
		
		return methodMap.get(methodName);
	}
	
}
