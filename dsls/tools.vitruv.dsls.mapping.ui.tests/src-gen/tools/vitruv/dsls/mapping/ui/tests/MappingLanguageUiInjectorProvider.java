/*
 * generated by Xtext 2.9.1
 */
package tools.vitruv.dsls.mapping.ui.tests;

import com.google.inject.Injector;
import tools.vitruv.dsls.mapping.ui.internal.MappingActivator;
import org.eclipse.xtext.junit4.IInjectorProvider;

public class MappingLanguageUiInjectorProvider implements IInjectorProvider {

	@Override
	public Injector getInjector() {
		return MappingActivator.getInstance().getInjector("tools.vitruv.dsls.mapping.MappingLanguage");
	}

}