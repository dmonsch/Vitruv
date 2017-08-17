package tools.vitruv.framework.server

import javax.annotation.PostConstruct
import javax.annotation.PreDestroy

import org.bson.Document
import org.eclipse.xtend.lib.annotations.Accessors

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.JsonParser

import com.mongodb.MongoClient
import com.mongodb.client.MongoCollection
import com.mongodb.client.MongoDatabase

abstract class MongoResource {
	protected static extension Gson = new GsonBuilder().create
	protected static extension JsonParser = new JsonParser
	protected MongoClient mongoClient
	@Accessors(PROTECTED_GETTER)
	MongoDatabase database
	@Accessors(PROTECTED_GETTER)
	MongoCollection<Document> collection

	protected abstract def String getCollectionName()

	@PostConstruct
	def void postConstruct() {
		mongoClient = new MongoClient
		database = mongoClient.getDatabase("vitruv_versioning")
		collection = database.getCollection(collectionName)
	}

	@PreDestroy
	def void preDestroy() {
		mongoClient.close
	}

	protected def collectionExists(String collectionName) {
		return database.listCollectionNames.exists[it == collectionName]
	}
}