package tools.vitruv.applications.pcmjava.gplimplementation.tests.pojotransformations.java2pcm

import tools.vitruv.applications.pcmjava.tests.pojotransformations.java2pcm.TypeReferenceMappingTransformationTest

class TypeReferenceMappingGplTransformationTest extends TypeReferenceMappingTransformationTest {
	override protected createChange2CommandTransformingProviding() {
		Change2CommandTransformingProvidingFactory.createJava2PcmGplImplementationTransformingProviding();
	}
}