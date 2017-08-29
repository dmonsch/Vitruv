package tools.vitruv.extensions.dslsruntime.mappings

import java.util.List
import java.util.Map
import java.util.Set
import org.apache.log4j.Logger
import org.eclipse.emf.ecore.EObject

class MappingRegistryHalf<H extends MappingInstanceHalf> {
	static extension Logger LOGGER = Logger.getLogger(MappingRegistryHalf.getSimpleName())
	val String mappingName
	val String sideName
	val Map<List<EObject>,H> candidatesRegistry = newHashMap()
	val Map<List<EObject>,H> instanceHalvesRegistry = newHashMap()

	new(String mappingName, String sideName) {
		this.mappingName = mappingName
		this.sideName = sideName
	}
	
	/********** BEGIN GETTER METHODS **********/
	def Iterable<H> getCandidates() {
		return candidatesRegistry.values
	}
	
	def Iterable<H> getInstanceHalves() {
		return instanceHalvesRegistry.values
	}
	
	def H getCandidateForElements(List<Object> elements) {
		return candidatesRegistry.get(elements)
	}
	
	def H getInstanceHalfForElements(List<Object> elements) {
		return instanceHalvesRegistry.get(elements)
	}
	
	/********** BEGIN SETTER METHODS **********/	
	def void addCandidates(Iterable<H> candidates) {
		candidates.forEach[addCandidatesOrInstanceHalf(candidatesRegistry, it, "candidate")]
	}
	
	private def void removeCandidate(H candidate) {
		removeCandidateOrInstanceHalf(candidatesRegistry, candidate, "candidate")
	}
	
	def void addInstanceHalf(H instanceHalf) {
		addCandidatesOrInstanceHalf(instanceHalvesRegistry, instanceHalf, "instance half")
	}
	
	def void removeInstanceHalf(H instanceHalf) {
		removeCandidateOrInstanceHalf(instanceHalvesRegistry, instanceHalf, "instance half")
	}
	
	private def void addCandidatesOrInstanceHalf(Map<List<EObject>,H> registry, H candidateOrInstanceHalf, String type) {
		val previouslyRegistered = registry.put(candidateOrInstanceHalf.getElements(), candidateOrInstanceHalf)
		if (previouslyRegistered !== null) {
			throw new IllegalStateException('''Cannot register the «sideName» mapping «type» '«candidateOrInstanceHalf»' for the mapping '«mappingName»'
			because the  «sideName» mapping «type» '«previouslyRegistered»' is already registered for
			the «sideName» elements '«candidateOrInstanceHalf.getElements()»'!''')
		}
	}
	
	private def void removeCandidateOrInstanceHalf(Map<List<EObject>,H> registry, H candidateOrInstanceHalf, String type) {
		val registered = registry.remove(candidateOrInstanceHalf.getElements())
		if (registered === null) {
			throw new IllegalStateException(getDeregisterMessage(candidateOrInstanceHalf,"nothing ", type))
		} else if (registered != candidateOrInstanceHalf) {
			throw new IllegalStateException(getDeregisterMessage(candidateOrInstanceHalf,'''the «sideName» mapping instance half '«registered»' ''', type))
		}
	}

	private def String getDeregisterMessage(H candidateOrInstanceHalf, String mapped, String type) '''Cannot deregister the «sideName» mapping «type» '«candidateOrInstanceHalf»' for the mapping '«mappingName»'
			and the «sideName» elements '«candidateOrInstanceHalf.getElements()» because «mapped»was registered for these elements!'''
	
	/********** BEGIN CANDIDATE METHODS **********/
	def void removeCandidatesForElement(EObject element) {
		val iterator = candidatesRegistry.keySet().iterator()
		var atLeastOneSetRemoved = false
		while (iterator.hasNext()) {
			val pivot = iterator.next()
			if (pivot.contains(element)) {
				iterator.remove()
				atLeastOneSetRemoved = true
			}
		}
		if (!atLeastOneSetRemoved) {
			info('''No «sideName» candidates to be removed are registered for the element '«element»'
			in '«iterator.toList»' of the mapping '«mappingName»'.''')
		}
	}
	
	def Set<H> getCandidatesAndInstances() {
		val candidatesAndInstances = newHashSet()
		candidatesAndInstances.addAll(candidates)
		candidatesAndInstances.addAll(instanceHalves)
		return candidatesAndInstances
	}

	/********** BEGIN INSTANCE METHODS **********/
	def promoteCandidateToInstanceHalf(H candidate) {
		removeCandidate(candidate)
		addInstanceHalf(candidate)
	}
}