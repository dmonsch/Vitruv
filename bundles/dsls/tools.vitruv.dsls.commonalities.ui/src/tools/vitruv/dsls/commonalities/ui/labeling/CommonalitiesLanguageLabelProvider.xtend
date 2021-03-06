/*
 * generated by Xtext 2.12.0
 */
package tools.vitruv.dsls.commonalities.ui.labeling

import com.google.inject.Inject
import org.eclipse.emf.edit.ui.provider.AdapterFactoryLabelProvider
import org.eclipse.jface.viewers.StyledString
import org.eclipse.xtext.xbase.ui.labeling.XbaseLabelProvider
import tools.vitruv.dsls.commonalities.language.CommonalityAttribute
import tools.vitruv.dsls.commonalities.language.CommonalityReference
import tools.vitruv.dsls.commonalities.language.Participation
import tools.vitruv.dsls.commonalities.language.elements.Wrapper

import static extension tools.vitruv.dsls.commonalities.language.extensions.CommonalitiesLanguageModelExtensions.*

/**
 * Provides labels for EObjects.
 * 
 * See https://www.eclipse.org/Xtext/documentation/304_ide_concepts.html#label-provider
 */
class CommonalitiesLanguageLabelProvider extends XbaseLabelProvider {

	@Inject
	new(AdapterFactoryLabelProvider delegate) {
		super(delegate);
	}

	// Labels and icons can be computed like this:
//	def text(Greeting ele) {
//		'A greeting to ' + ele.name
//	}
//
//	def image(Greeting ele) {
//		'Greeting.gif'
//	}
	def text(Participation participation) {
		val participationClasses = participation.classes.toList
		val result = new StyledString().append(participation.domainName ?: '?')
		if (participationClasses.size == 1) {
			result.append(':').append(participationClasses.head.name ?: '?')
		} else if (participationClasses.size > 1) {
			result.append(':(').append(participationClasses.map[name].join(', ')).append(')')
		}
		return result
	}

	def text(CommonalityAttribute attribute) {
		val typeName = attribute.type?.name
		val sstring = new StyledString(attribute.name)
		if (typeName !== null) {
			sstring.appendInfo(': ').appendInfo(typeName)
		}
		return sstring
	}

	def text(CommonalityReference reference) {
		val typeName = reference.referenceType?.name
		val sstring = new StyledString(reference.name)
		if (typeName !== null) {
			sstring.appendInfo(' -> ').appendInfo(typeName)
		}
		return sstring
	}

	def image(Wrapper<?> wrapper) {
		getImage(wrapper.wrapped)
	}

	def private appendInfo(StyledString sstring, String text) {
		sstring.append(text, StyledString.QUALIFIER_STYLER)
	}
}
