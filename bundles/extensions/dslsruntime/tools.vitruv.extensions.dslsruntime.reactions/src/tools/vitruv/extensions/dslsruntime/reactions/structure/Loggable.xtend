package tools.vitruv.extensions.dslsruntime.reactions.structure

import org.apache.log4j.Logger

class Loggable {
	private val Logger LOGGER;
	
	public new() {
		LOGGER = Logger.getLogger(this.class);
	}
	
	protected def Logger getLogger() {
		return LOGGER;
	}
}