package tools.vitruv.dsls.mappings.generator.conditions.impl

import org.eclipse.xtext.xbase.XbaseFactory
import tools.vitruv.dsls.mappings.generator.conditions.MultiValueConditionGenerator
import tools.vitruv.dsls.mappings.mappingsLanguage.MappingParameter
import tools.vitruv.dsls.mappings.mappingsLanguage.MultiValueCondition
import tools.vitruv.dsls.mappings.mappingsLanguage.MultiValueConditionOperator
import tools.vitruv.dsls.reactions.builder.FluentRoutineBuilder.RoutineTypeProvider

import static extension tools.vitruv.dsls.mappings.generator.conditions.FeatureConditionGeneratorUtils.*
import static extension tools.vitruv.dsls.mappings.generator.utils.XBaseMethodFinder.*
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.emf.ecore.EReference

class EqualsValueConditionGenerator extends MultiValueConditionGenerator {

	new(MultiValueCondition condition) {
		super(condition, MultiValueConditionOperator.EQUALS)
	}

	override feasibleForParameter(MappingParameter parameter) {
		featureCondition.feature.parameter == parameter
	}

	override generateFeatureCondition(RoutineTypeProvider typeProvider, XExpression variable) {
		XbaseFactory.eINSTANCE.createXBinaryOperation => [
			leftOperand = typeProvider.generateLeftFeatureConditionValue(featureCondition)
			rightOperand = typeProvider.generateRightSideCall(variable)
			if (negated) {
				feature = typeProvider.tripleNotEquals
			} else {
				feature = typeProvider.tripleEquals
			}
		]
	}

	override hasCorrespondenceInitialization() {
		val feature = featureCondition.feature.feature
		if (feature instanceof EReference) {
			// references have to be set with In-Relations not Equals
			return false
		}
		!negated && feature.changeable
	}

	override generateCorrespondenceInitialization(RoutineTypeProvider typeProvider) {
		return typeProvider.parameterFeatureCallSetter(featureCondition,
			typeProvider.generateLeftFeatureConditionValue(featureCondition))
	}

	private def generateRightSideCall(RoutineTypeProvider typeProvider, XExpression variable) {
		XbaseFactory.eINSTANCE.createXMemberFeatureCall => [
			explicitOperationCall = true
			memberCallTarget = variable
			feature = typeProvider.findMetaclassMethodGetter(rightSide)
		]
	}

}
