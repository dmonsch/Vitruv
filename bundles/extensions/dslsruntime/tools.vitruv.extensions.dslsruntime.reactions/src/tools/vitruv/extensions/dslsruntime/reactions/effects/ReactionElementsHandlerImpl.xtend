package tools.vitruv.extensions.dslsruntime.reactions.effects

import org.eclipse.emf.ecore.EObject
import tools.vitruv.framework.correspondence.CorrespondenceModel
import tools.vitruv.framework.tuid.TuidManager
import tools.vitruv.extensions.dslsruntime.reactions.helper.ReactionsCorrespondenceHelper
import org.eclipse.emf.ecore.util.EcoreUtil
import org.apache.log4j.Logger
import tools.vitruv.extensions.dslsruntime.reactions.ReactionElementsHandler

class ReactionElementsHandlerImpl implements ReactionElementsHandler {
	private static val logger = Logger.getLogger(ReactionElementsHandlerImpl);
	
	private final CorrespondenceModel correspondenceModel;
	
	public new(CorrespondenceModel correspondenceModel) {
		this.correspondenceModel = correspondenceModel;
	}
	
	override void addCorrespondenceBetween(EObject firstElement, EObject secondElement, String tag) {
		registerObjectUnderModification(firstElement);
		registerObjectUnderModification(secondElement);
		ReactionsCorrespondenceHelper.addCorrespondence(correspondenceModel, firstElement, secondElement, tag);
	}
	
	override void deleteObject(EObject element) {
		if (element === null) {
			return;
		}
		ReactionsCorrespondenceHelper.removeCorrespondencesOfObject(correspondenceModel, element);
		logger.debug("Removing object " + element + " from container " + element.eContainer());
		EcoreUtil.remove(element);
		// If we delete an object, we have to update Tuids because Tuids of child elements 
		// may have to be resolved for removing correspondences as well and must therefore be up-to-date
		TuidManager.instance.updateTuidsOfRegisteredObjects();
	}
	
	override void removeCorrespondenceBetween(EObject firstElement, EObject secondElement, String tag) {
		ReactionsCorrespondenceHelper.removeCorrespondencesBetweenElements(correspondenceModel, 
			firstElement, secondElement, tag);
	}
	
	override registerObjectUnderModification(EObject element) {
		if (element !== null) {
			TuidManager.instance.registerObjectUnderModification(element);
			if (element.eContainer !== null) {
				TuidManager.instance.registerObjectUnderModification(element.eContainer);
			}

		}
	}
	
	override postprocessElements() {
		// Modifications are finished, so update the Tuids
		TuidManager.instance.updateTuidsOfRegisteredObjects();
	}
	
}