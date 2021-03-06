package tools.vitruv.framework.applications

import tools.vitruv.framework.change.processing.ChangePropagationSpecification
import tools.vitruv.framework.domains.VitruvDomain
import java.util.Set

interface VitruvApplication {
	def Set<ChangePropagationSpecification> getChangePropagationSpecifications();
	def Set<VitruvDomain> getVitruvDomains();
	def String getName();
}
