package tools.vitruv.framework.change.processing

import tools.vitruv.framework.correspondence.CorrespondenceModel
import tools.vitruv.framework.change.description.TransactionalChange
import tools.vitruv.framework.util.command.TransformationResult
import tools.vitruv.framework.util.datatypes.MetamodelPair

interface ChangeProcessor {
	def MetamodelPair getMetamodelPair();
	def boolean doesHandleChange(TransactionalChange change, CorrespondenceModel correspondenceModel);
	def TransformationResult propagateChange(TransactionalChange change, CorrespondenceModel correspondenceModel);
}