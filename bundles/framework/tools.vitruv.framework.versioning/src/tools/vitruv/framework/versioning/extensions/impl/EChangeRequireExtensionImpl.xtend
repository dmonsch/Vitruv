package tools.vitruv.framework.versioning.extensions.impl

import tools.vitruv.framework.change.echange.EChange
import tools.vitruv.framework.change.echange.compound.CreateAndInsertEObject
import tools.vitruv.framework.change.echange.compound.CreateAndInsertNonRoot
import tools.vitruv.framework.change.echange.compound.CreateAndInsertRoot
import tools.vitruv.framework.change.echange.compound.CreateAndReplaceNonRoot
import tools.vitruv.framework.change.echange.feature.attribute.ReplaceSingleValuedEAttribute
import tools.vitruv.framework.versioning.extensions.EChangeRequireExtension

class EChangeRequireExtensionImpl implements EChangeRequireExtension {
	private new() {
	}

	static def EChangeRequireExtension init() {
		new EChangeRequireExtensionImpl
	}

	override checkForRequireEdge(EChange parent, EChange child) {
		checkForRequireEdgeImpl(parent, child)
	}

	private dispatch def boolean checkForRequireEdgeImpl(EChange e1, EChange e2) {
		false
	}

	private dispatch def checkForRequireEdgeImpl(
		CreateAndReplaceNonRoot<?, ?> e1,
		ReplaceSingleValuedEAttribute<?, ?> e2
	) {
		return e1.createChange.affectedEObject === e2.affectedEObject
	}

	private dispatch def checkForRequireEdgeImpl(
		CreateAndInsertRoot<?> e1,
		ReplaceSingleValuedEAttribute<?, ?> e2
	) {
		return e1.createChange.affectedEObject === e2.affectedEObject
	}

	private dispatch def checkForRequireEdgeImpl(
		CreateAndInsertRoot<?> e1,
		CreateAndReplaceNonRoot<?, ?> e2
	) {
		return e1.createChange.affectedEObject === e2.insertChange.affectedEObject
	}

	private dispatch def checkForRequireEdgeImpl(
		CreateAndInsertEObject<?, ?> e1,
		ReplaceSingleValuedEAttribute<?, ?> e2
	) {
		return e1.createChange.affectedEObject === e2.affectedEObject
	}

	private dispatch def checkForRequireEdgeImpl(
		CreateAndReplaceNonRoot<?, ?> e1,
		CreateAndInsertNonRoot<?, ?> e2
	) {
		return e1.createChange.affectedEObject === e2.insertChange.affectedEObject
	}

}