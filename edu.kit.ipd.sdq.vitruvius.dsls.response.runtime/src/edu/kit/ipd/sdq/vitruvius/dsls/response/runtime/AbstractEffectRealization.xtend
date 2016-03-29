package edu.kit.ipd.sdq.vitruvius.dsls.response.runtime

import org.eclipse.emf.ecore.EObject
import java.io.IOException
import java.util.Map
import java.util.HashMap
import org.eclipse.xtext.xbase.lib.Functions.Function0
import org.eclipse.xtext.xbase.lib.Functions.Function1
import edu.kit.ipd.sdq.vitruvius.dsls.response.runtime.helper.CorrespondenceHelper
import edu.kit.ipd.sdq.vitruvius.dsls.response.runtime.effects.PersistableEffectElement.PersistenceInformation
import edu.kit.ipd.sdq.vitruvius.dsls.response.runtime.effects.EffectElement
import edu.kit.ipd.sdq.vitruvius.dsls.response.runtime.effects.EffectElementCreate
import edu.kit.ipd.sdq.vitruvius.dsls.response.runtime.effects.EffectElementRetrieve
import edu.kit.ipd.sdq.vitruvius.dsls.response.runtime.effects.EffectElementDelete
import edu.kit.ipd.sdq.vitruvius.dsls.response.runtime.effects.PersistableEffectElement
import edu.kit.ipd.sdq.vitruvius.dsls.response.runtime.structure.CallHierarchyHaving

abstract class AbstractEffectRealization extends CallHierarchyHaving {
	private extension val ResponseExecutionState executionState;
	private Map<EObject, EffectElement> elementStates;
	
	public new(ResponseExecutionState executionState, CallHierarchyHaving calledBy) {
		super(calledBy);
		this.executionState = executionState;
		this.elementStates = new HashMap<EObject, EffectElement>();
	}
	
	protected def ResponseExecutionState getExecutionState() {
		return executionState;
	}
	
	protected def <T extends EObject> T initializeCreateElementState(Function0<EObject> correspondenceSourceSupplier,
		Function0<T> newObjectSupplier, Function0<String> tagSupplier, Class<T> elementClass
	) {
		val correspondenceSource = correspondenceSourceSupplier.apply();
		val createElement = newObjectSupplier.apply();
		val tag = tagSupplier.apply();
		this.elementStates.put(createElement, 
			new EffectElementCreate(createElement, correspondenceSource, executionState, tag)
		);
		return createElement;
	}
	
	protected def <T extends EObject> T initializeRetrieveElementState(Function0<EObject> correspondenceSourceSupplier, 
		Function1<T, Boolean> correspondencePreconditionMethod, Function0<String> tagSupplier, Class<T> elementClass, boolean optional) {
		val correspondenceSource = correspondenceSourceSupplier.apply();
		val tag = tagSupplier.apply();
		val retrievedElement = CorrespondenceHelper.getCorrespondingModelElement(correspondenceSource, elementClass, optional, tag, correspondencePreconditionMethod, blackboard);
		this.elementStates.put(retrievedElement, 
			new EffectElementRetrieve(retrievedElement, correspondenceSource, executionState)
		);
		return retrievedElement;
	}
	
	
	protected def <T extends EObject> T initializeDeleteElementState(Function0<EObject> correspondenceSourceSupplier,
		Function1<T, Boolean> correspondencePreconditionMethod, Function0<String> tagSupplier, Class<T> elementClass, boolean optional
	) {
		val correspondenceSource = correspondenceSourceSupplier.apply();
		val tag = tagSupplier.apply();
		val retrievedElement = CorrespondenceHelper.getCorrespondingModelElement(correspondenceSource, elementClass, optional, tag, correspondencePreconditionMethod, blackboard);
		this.elementStates.put(retrievedElement, 
			new EffectElementDelete(retrievedElement, correspondenceSource, executionState)
		);
		return retrievedElement;
	}
	
	protected def setPersistenceInformation(EObject element, Function0<String> persistencePathSupplier, boolean pathIsSourceRelative) {
		val persistenceInformation = new PersistenceInformation(pathIsSourceRelative, persistencePathSupplier);
		val state = elementStates.get(element);
		if (!(state instanceof PersistableEffectElement)) {
			throw new IllegalArgumentException("Element to set persistence path for must be persistable");
		} 
		(state as PersistableEffectElement).persistenceInformation = persistenceInformation;
		
	}
	
	protected def preProcessElements() {
		for (element : elementStates.keySet) {
			elementStates.get(element).preProcess();
		}
	}
	
	protected def postProcessElements() {
		for (element : elementStates.keySet) {
			elementStates.get(element).postProcess();
		}
		for (element : elementStates.keySet) {
			elementStates.get(element).updateTUIDs();
		}
	}
	
	public def void applyEffect() {
		// If not all parameters are set this is not a lightweight error caused by erroneous responses but an implementation
		// error of the response mechanism, so throw an exception
		if (!allParametersSet()) {
			getLogger().error('''Not all parameters were set for executing effect («this.class.simpleName»)''');
			throw new IllegalStateException('''Not all parameters were set for executing effect («this.class.simpleName»)''');
		}
		try {
			executeEffect();
		} catch (Exception exception) {
			// If an error occured during execution, avoid an application shutdown and print the error.
			getLogger().error('''«exception.class.simpleName» during execution of effect «calledByString»: «exception.message»''');
		}
	}
	
	protected abstract def boolean allParametersSet();
	protected abstract def void executeEffect() throws IOException;
	
}