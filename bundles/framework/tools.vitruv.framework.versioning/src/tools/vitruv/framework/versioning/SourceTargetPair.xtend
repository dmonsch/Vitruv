package tools.vitruv.framework.versioning

import java.util.Collection
import tools.vitruv.framework.util.datatypes.VURI

/**
 * Data class to store the relationship of source and correspondent targets of consistency preserving 
 * changes.
 * 
 * @author Patrick Stoeckle <p.stoeckle@gmx.net>
 * @version 0.1.0
 * @since 2017-06-12
 */
interface SourceTargetPair {
	def VURI getSource()

	def Collection<VURI> getTargets()
}