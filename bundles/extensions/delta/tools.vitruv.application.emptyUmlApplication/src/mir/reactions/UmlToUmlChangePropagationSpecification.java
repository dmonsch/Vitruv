package mir.reactions;

import tools.vitruv.framework.change.processing.impl.CompositeDecomposingChangePropagationSpecification;
import tools.vitruv.framework.change.processing.ChangePropagationSpecification;
import tools.vitruv.domains.uml.UmlDomainProvider;
import java.util.List;
import java.util.function.Supplier;
import java.util.Arrays;

/**
 * The {@link class tools.vitruv.framework.change.processing.impl.CompositeDecomposingChangePropagationSpecification} for transformations between the metamodels Uml and Uml.
 * To add further change processors override the setup method.
 *
 * <p> This file is generated! Do not edit it but extend it by inheriting from it!
 * 
 * <p> Generated from template version 1
 */
public class UmlToUmlChangePropagationSpecification extends CompositeDecomposingChangePropagationSpecification {
	
	private final List<Supplier<? extends ChangePropagationSpecification>> executors = Arrays.asList(
		// begin generated executor list
			
		// end generated executor list
	);
	
	public UmlToUmlChangePropagationSpecification() {
		super(new UmlDomainProvider().getDomain(), 
			new UmlDomainProvider().getDomain());
		setup();
	}
	
	/**
	 * Adds the reactions change processors to this {@link UmlToUmlChangePropagationSpecification}.
	 * For adding further change processors overwrite this method and call the super method at the right place.
	 */
	protected void setup() {
		for (final Supplier<? extends ChangePropagationSpecification> executorSupplier : executors) {
			this.addChangeMainprocessor(executorSupplier.get());
		}	
	}
}
