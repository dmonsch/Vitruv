package tools.vitruv.dsls.reactions.tests.simpleChangesTests

import allElementTypes.AllElementTypesFactory
import allElementTypes.Root
import java.util.Map
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.util.EcoreUtil
import org.junit.Test

import tools.vitruv.framework.versioning.BranchDiff
import tools.vitruv.framework.versioning.BranchDiffCreator
import tools.vitruv.framework.versioning.ConflictDetector
import tools.vitruv.framework.versioning.conflict.Conflict
import tools.vitruv.framework.versioning.impl.ConflictDetectorImpl

import static org.hamcrest.CoreMatchers.equalTo
import static org.hamcrest.CoreMatchers.is
import static org.hamcrest.CoreMatchers.not
import static org.junit.Assert.assertThat

class NoConflict extends ConflictTest {
	protected BranchDiff branchDiff
	protected Conflict conflict

	override setup() {
		super.setup
		val targetVURI = TEST_TARGET_MODEL_NAME.calculateVURI
		sourceVURI = TEST_SOURCE_MODEL_NAME.calculateVURI

		stRecorder.recordOriginalAndCorrespondentChanges(sourceVURI, #[targetVURI])

		val newTargetVURI = newTestTargetModelName.calculateVURI
		newSourceVURI = newTestSourceModelName.calculateVURI

		val rootElement2 = AllElementTypesFactory::eINSTANCE.createRoot
		roots = #[rootElement, rootElement2]
		rootElement2.id = newTestSourceModelName
		newTestSourceModelName.projectModelPath.createAndSynchronizeModel(rootElement2)
		stRecorder.recordOriginalAndCorrespondentChanges(newSourceVURI, #[newTargetVURI])

		assertThat(newSourceVURI, not(equalTo(sourceVURI)))
		assertThat(newTargetVURI, not(equalTo(targetVURI)))
		assertThat(newSourceVURI.hashCode, not(is(sourceVURI.hashCode)))
		assertThat(newTargetVURI.hashCode, not(is(targetVURI.hashCode)))

		val container1 = AllElementTypesFactory::eINSTANCE.createNonRootObjectContainerHelper
		container1.id = containerId
		rootElement.nonRootObjectContainerHelper = container1

		checkChangeMatchesLength(1, 0)

		val container2 = AllElementTypesFactory::eINSTANCE.createNonRootObjectContainerHelper
		container2.id = containerId
		rootElement2.nonRootObjectContainerHelper = container2

		checkChangeMatchesLength(1, 1)

		// Create and add non roots
		NON_CONTAINMENT_NON_ROOT_IDS.forEach[createAndAddNonRoot(container1)]
		checkChangeMatchesLength(4, 1)

		NON_CONTAINMENT_NON_ROOT_IDS.forEach[createAndAddNonRoot(container2)]
		checkChangeMatchesLength(4, 4)

		assertModelsEqual
		assertMappedModelsAreEqual
		val Map<String, String> rootToRootMap = #{sourceVURI.EMFUri.toPlatformString(false) ->
			newSourceVURI.EMFUri.toPlatformString(false)}
		val ConflictDetector conflictDetector = new ConflictDetectorImpl(rootToRootMap)
		val sourceChanges = stRecorder.getChangeMatches(sourceVURI)
		val targetChanges = stRecorder.getChangeMatches(newSourceVURI)
		branchDiff = BranchDiffCreator::instance.createVersionDiff(sourceChanges, targetChanges)
		conflict = conflictDetector.detectConlicts(branchDiff)

	}

	@Test
	def void testLevenshteinDistance() {
		assertThat(conflict.originalChangesLevenshteinDistance, is(0))
	}

	private final def assertMappedModelsAreEqual() {
		assertMappedModelsEqual(TEST_SOURCE_MODEL_NAME.projectModelPath, newTestSourceModelName.projectModelPath)
		assertMappedModelsEqual(TEST_TARGET_MODEL_NAME.projectModelPath, newTestTargetModelName.projectModelPath)
	}

	private final def void assertMappedModelsEqual(String firstModelPathWithinProject,
		String secondModelPathWithinProject) {
		val testResourceSet = new ResourceSetImpl
		val firstRoot = getFirstRootElement(firstModelPathWithinProject, testResourceSet) as Root
		val secondRoot = getFirstRootElement(secondModelPathWithinProject, testResourceSet) as Root

		assertThat(firstRoot.eContents.length, is(secondRoot.eContents.length))
		firstRoot.eContents.forEach [ firstElement |
			val element = secondRoot.eContents.findFirst[EcoreUtil::equals(it, firstElement)]
			assertThat(element, not(equalTo(null)))
		]
		val id = firstRoot.id
		if (modelPairs.containsKey(id)) {
			val mappedId = modelPairs.get(id)
			assertThat(secondRoot.id, equalTo(mappedId))
		} else
			throw new IllegalStateException("ID should be contained in the map.")
	}
}