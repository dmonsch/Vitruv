package mir.reactions;

import tools.vitruv.framework.change.processing.impl.CompositeChangePropagationSpecification;

/**
 * The {@link class tools.vitruv.framework.change.processing.impl.CompositeChangePropagationSpecification} for transformations between the metamodels http://www.emftext.org/java and http://palladiosimulator.org/PalladioComponentModel/5.1.
 * To add further change processors overwrite the setup method.
 */
public abstract class AbstractChangePropagationSpecificationJavaTo5_1 extends CompositeChangePropagationSpecification {
	private final tools.vitruv.framework.util.datatypes.MetamodelPair metamodelPair;
	
	public AbstractChangePropagationSpecificationJavaTo5_1() {
		super(new tools.vitruv.framework.userinteraction.impl.UserInteractor());
		this.metamodelPair = new tools.vitruv.framework.util.datatypes.MetamodelPair("http://www.emftext.org/java", "http://palladiosimulator.org/PalladioComponentModel/5.1");
		setup();
	}
	
	public tools.vitruv.framework.util.datatypes.MetamodelPair getMetamodelPair() {
		return metamodelPair;
	}	
	
	/**
	 * Adds the reactions change processors to this {@link AbstractChangePropagationSpecificationJavaTo5_1}.
	 * For adding further change processors overwrite this method and call the super method at the right place.
	 */
	protected void setup() {
		this.addChangeMainprocessor(new mir.reactions.reactionsJavaTo5_1.ejbjava2pcm.ExecutorJavaTo5_1(getUserInteracting()));
	}
	
}