/*
 * generated by Xtext 2.9.0
 */
package tools.vitruv.dsls.reactions.validation

import org.eclipse.xtext.validation.Check
import tools.vitruv.dsls.reactions.reactionsLanguage.ReactionsLanguagePackage
import java.util.HashMap
import tools.vitruv.dsls.reactions.reactionsLanguage.Routine
import tools.vitruv.dsls.reactions.reactionsLanguage.RetrieveModelElement
import tools.vitruv.dsls.reactions.reactionsLanguage.CreateModelElement
import tools.vitruv.dsls.reactions.reactionsLanguage.Reaction
import tools.vitruv.dsls.reactions.reactionsLanguage.ReactionsSegment
import static extension tools.vitruv.dsls.reactions.codegen.helper.ClassNamesGenerators.*

/**
 * This class contains custom validation rules. 
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class ReactionsLanguageValidator extends AbstractReactionsLanguageValidator {

	@Check
	def checkReactionsFile(ReactionsSegment reactionsSegment) {
		val alreadyCheckedReactions = new HashMap<String, Reaction>();
		for (reaction : reactionsSegment.reactions) {
			val reactionName = reaction.reactionClassNameGenerator.simpleName;
			if (alreadyCheckedReactions.containsKey(reactionName)) {
				val errorMessage = "Duplicate reaction name: " + reactionName;
				error(errorMessage, reaction, ReactionsLanguagePackage.Literals.REACTION__NAME);
				error(
					errorMessage,
					alreadyCheckedReactions.get(reactionName),
					ReactionsLanguagePackage.Literals.REACTION__NAME
				);
			}
			alreadyCheckedReactions.put(reactionName, reaction);
		}
		val alreadyCheckedRoutines = new HashMap<String, Routine>();
//		for (implicitRoutine : reactionSegment.reactions.map[routine]) {
//			alreadyCheckedEffects.put(implicitRoutine.routineClassNameGenerator.simpleName, implicitRoutine);
//		}
		for (routine : reactionsSegment.routines) {
			val routineName = routine.routineClassNameGenerator.simpleName
			if (alreadyCheckedRoutines.containsKey(routineName)) {
				val errorMessage = "Duplicate effect name: " + routineName;
				error(errorMessage, routine, ReactionsLanguagePackage.Literals.ROUTINE__NAME);
				val duplicateNameRoutine = alreadyCheckedRoutines.get(routineName);
				error(errorMessage, duplicateNameRoutine, ReactionsLanguagePackage.Literals.ROUTINE__NAME);
			}
			alreadyCheckedRoutines.put(routineName, routine);
		}
	}

	@Check
	def checkRetrieveElementName(RetrieveModelElement element) {
		if (!element.name.nullOrEmpty && element.name.startsWith("_")) {
			error("Element names must not start with an underscore.",
				ReactionsLanguagePackage.Literals.RETRIEVE_MODEL_ELEMENT__NAME);
		}
	}
	
		@Check
	def checkCreateElementName(CreateModelElement element) {
		if (!element.name.nullOrEmpty && element.name.startsWith("_")) {
			error("Element names must not start with an underscore.",
				ReactionsLanguagePackage.Literals.CREATE_MODEL_ELEMENT__NAME);
		}
	}

//	@Check
//	def checkEffects(Effect effect) {
//		if (effect.impact.codeBlock == null && !effect.impact..filter(CorrespondingModelElementCreate).nullOrEmpty) {
//			warning("Created elements must be initialized and inserted into the target model in the execute block.",
//				ReactionsLanguagePackage.Literals.EFFECT__CODE_BLOCK);
//		}
//	}
	
//	@Check
//	def checkEffectInput(RoutineInput effectInput) {
//		if (!effectInput.javaInputElements.empty) {
//			warning("Using plain Java elements is discouraged. Try to use model elements and make list inputs to single valued input of other effect that is called for each element.",
//				ReactionsLanguagePackage.Literals.ROUTINE_INPUT__JAVA_INPUT_ELEMENTS);
//		}
//	}
	
	@Check
	def checkRoutine(Routine routine) {
		if (!Character.isLowerCase(routine.name.charAt(0))) {
			warning("Routine names should start lower case",
				ReactionsLanguagePackage.Literals.ROUTINE__NAME);
		}
	}
	
	@Check
	def checkRoutine(Reaction reaction) {
		if (!Character.isUpperCase(reaction.name.charAt(0))) {
			warning("Reaction names should start upper case",
				ReactionsLanguagePackage.Literals.REACTION__NAME);
		}
	}

}
