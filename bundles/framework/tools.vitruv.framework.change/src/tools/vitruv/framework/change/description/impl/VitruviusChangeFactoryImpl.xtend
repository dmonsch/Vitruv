package tools.vitruv.framework.change.description.impl

import java.util.List

import org.apache.log4j.Level
import org.apache.log4j.Logger

import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.change.ChangeDescription
import org.eclipse.emf.ecore.resource.Resource

import tools.vitruv.framework.change.description.ChangeCloner
import tools.vitruv.framework.change.description.TransactionalChange
import tools.vitruv.framework.change.description.VitruviusChange
import tools.vitruv.framework.change.description.VitruviusChangeFactory
import tools.vitruv.framework.change.echange.EChange
import tools.vitruv.framework.change.echange.TypeInferringCompoundEChangeFactory
import tools.vitruv.framework.change.echange.compound.CreateAndInsertRoot
import tools.vitruv.framework.change.echange.compound.RemoveAndDeleteRoot
import tools.vitruv.framework.change.preparation.ChangeDescription2EChangesTransformation
import tools.vitruv.framework.util.datatypes.VURI
import org.eclipse.emf.ecore.util.EcoreUtil

/**
 * @version 0.2.0
 * @since 2017-06-06
 */
class VitruviusChangeFactoryImpl implements VitruviusChangeFactory {
	static extension  TypeInferringCompoundEChangeFactory = TypeInferringCompoundEChangeFactory::instance
	static extension ChangeCloner = new ChangeClonerImpl
	static extension Logger = Logger::getLogger(VitruviusChangeFactory)

	private new() {
	}

	static def VitruviusChangeFactory init() {
		level = Level::DEBUG
		new VitruviusChangeFactoryImpl
	}

	/**
	 * Generates a change from the given {@link ChangeDescription}. This factory method has to be called when the model
	 * is in the state right before the change described by the recorded {@link ChangeDescription}.
	 */
	override createEMFModelChange(ChangeDescription changeDescription) {
		val changes = new ChangeDescription2EChangesTransformation(changeDescription).transform()
		return new EMFModelChangeImpl(changes);
	}

	override copy(TransactionalChange changeToCopy) {
		val echanges = changeToCopy.EChanges
		if (!echanges.forall[!resolved])
			error("There are some resolved changes!")
		return new EMFModelChangeImpl(echanges)
	}

	override createEMFModelChangeFromEChanges(List<EChange> echanges) {
		new EMFModelChangeImpl(echanges)
	}

	override createLegacyEMFModelChange(ChangeDescription changeDescription) {
		val changes = new ChangeDescription2EChangesTransformation(changeDescription).transform()
		return new LegacyEMFModelChangeImpl(changeDescription, changes);
	}

	override createConcreteApplicableChange(EChange change) {
		return new ConcreteApplicableChangeImpl(change);
	}

	override createConcreteChange(EChange change) {
		return new ConcreteChangeImpl(change);
	}

	override createConcreteChangeWithVuri(EChange change, VURI vuri) {
		return new ConcreteChangeWithUriImpl(vuri, change);
	}

	override createFileChange(FileChangeKind kind, Resource changedFileResource) {
		var EChange eChange = null
		if (kind == FileChangeKind.Create) {
			eChange = generateFileCreateChange(changedFileResource);
		} else {
			eChange = generateFileDeleteChange(changedFileResource);
		}
		return new ConcreteChangeImpl(eChange)
	}

	override createCompositeContainerChange() {
		new CompositeContainerChangeImpl
	}

	override createCompositeTransactionalChange() {
		new CompositeTransactionalChangeImpl
	}

	override createEmptyChange(VURI vuri) {
		new EmptyChangeImpl(vuri)
	}

	override createCompositeChange(Iterable<? extends VitruviusChange> innerChanges) {
		val compositeChange = new CompositeContainerChangeImpl
		innerChanges.forEach[compositeChange.addChange(it)]
		compositeChange
	}

	override <T extends VitruviusChange> clone(T originalChange) {
		return cloneVitruviusChange(originalChange) as T
	}

	private def EChange generateFileCreateChange(Resource resource) {
		var EObject rootElement = null
		var index = 0
		if (1 == resource.contents.size)
			rootElement = resource.contents.get(0)
		else if (1 < resource.contents.size)
			throw new RuntimeException(
				"The requested model instance resource '" + resource + "' has to contain at most one root element " +
					"in order to be added to the VSUM without an explicit import!")
				else { // resource.contents.size === null --> no element in newModelInstance
					info("Empty model file created: " + VURI::getInstance(resource) +
						". Propagation of 'root element created' not triggered.")
					return null
				}
				val CreateAndInsertRoot<EObject> createRootEObj = createCreateAndInsertRootChange(
					rootElement,
					resource,
					index,
					EcoreUtil::getID(rootElement)
				)
				createRootEObj
			}

			private def EChange generateFileDeleteChange(Resource resource) {
				if (0 < resource.contents.size) {
					val index = 0
					val rootElement = resource.contents.get(index)
					val RemoveAndDeleteRoot<EObject> deleteRootObj = createRemoveAndDeleteRootChange(
						rootElement,
						resource,
						index,
						EcoreUtil::getID(rootElement)
					)
					return deleteRootObj
				}
				info("Deleted resource " + VURI::getInstance(resource) + " did not contain any EObject")
				return null
			}

		}
		