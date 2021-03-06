package tools.vitruv.framework.change.processing

import java.util.List
import tools.vitruv.framework.domains.VitruvDomain

interface ChangePropagationSpecificationProvider extends Iterable<ChangePropagationSpecification> {
	public def List<ChangePropagationSpecification> getChangePropagationSpecifications(VitruvDomain sourceDomain);
}