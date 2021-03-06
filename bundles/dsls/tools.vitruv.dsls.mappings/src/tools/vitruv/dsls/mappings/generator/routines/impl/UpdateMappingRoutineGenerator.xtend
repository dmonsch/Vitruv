package tools.vitruv.dsls.mappings.generator.routines.impl

import tools.vitruv.dsls.mappings.generator.routines.AbstractMappingRoutineGenerator
import tools.vitruv.dsls.reactions.builder.FluentRoutineBuilder.InputBuilder
import tools.vitruv.dsls.reactions.builder.FluentRoutineBuilder.MatcherOrActionBuilder

class UpdateMappingRoutineGenerator extends AbstractMappingRoutineGenerator {

	new() {
		super('BidirectionalUpdate')
	}

	override generateInput(InputBuilder builder) {
		builder.generateMappingParameterInput
	}

	override generate(MatcherOrActionBuilder builder) {
		builder.action [ actionBuilder |
			if (bidirectionConditions.empty) {
				// just create an return
				actionBuilder.noAction
			}
			bidirectionConditions.forEach [
				it.generate(actionBuilder)
			]
		]
	}

}
