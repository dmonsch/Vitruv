/*
 * generated by Xtext 2.12.0
 */
package tools.vitruv.dsls.mappings

import com.google.inject.Binder
import com.google.inject.name.Names
import org.eclipse.xtext.generator.IGenerator2
import org.eclipse.xtext.linking.ILinkingService
import org.eclipse.xtext.naming.IQualifiedNameConverter
import org.eclipse.xtext.scoping.IGlobalScopeProvider
import org.eclipse.xtext.scoping.IScopeProvider
import org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider
import tools.vitruv.dsls.mappings.generator.MappingsLanguageGenerator
import tools.vitruv.dsls.mappings.scoping.MappingsLanguageScopeProviderDelegate
import tools.vitruv.dsls.mirbase.scoping.MirBaseQualifiedNameConverter
import tools.vitruv.dsls.reactions.linking.ReactionsLinkingService
import tools.vitruv.dsls.reactions.scoping.ReactionsLanguageGlobalScopeProvider

/**
 * Use this class to register components to be used at runtime / without the Equinox extension registry.
 */
class MappingsLanguageRuntimeModule extends AbstractMappingsLanguageRuntimeModule {
	def Class<? extends IGenerator2> bindIGenerator2() {
		MappingsLanguageGenerator
	}
	
	public override void configureIScopeProviderDelegate(Binder binder) {
		binder.bind(IScopeProvider)
		      .annotatedWith(Names.named(AbstractDeclarativeScopeProvider.NAMED_DELEGATE))
		      .to(MappingsLanguageScopeProviderDelegate);
	}
	
	public override Class<? extends IQualifiedNameConverter> bindIQualifiedNameConverter() {
		return MirBaseQualifiedNameConverter;
	}
	
	override Class<? extends IGlobalScopeProvider> bindIGlobalScopeProvider() {
		return ReactionsLanguageGlobalScopeProvider;
	}
	
	public override Class<? extends ILinkingService> bindILinkingService() {
		return ReactionsLinkingService;
	}
}
