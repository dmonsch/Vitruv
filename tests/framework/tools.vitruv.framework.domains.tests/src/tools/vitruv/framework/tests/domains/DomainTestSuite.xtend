package tools.vitruv.framework.tests.domains

import org.junit.runner.RunWith
import org.junit.runners.Suite
import org.junit.runners.Suite.SuiteClasses

@SuiteClasses(UmlStateChangeTest, PcmStateChangeTest, EdgeCaseStateChangeTest)
@RunWith(Suite)
class DomainTestSuite {
	// JUnit test suite for the domain tests.
}
