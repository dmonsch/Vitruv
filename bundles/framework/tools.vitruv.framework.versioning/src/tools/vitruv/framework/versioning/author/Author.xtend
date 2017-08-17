package tools.vitruv.framework.versioning.author

import java.util.List
import java.util.Set

import tools.vitruv.framework.versioning.Named
import tools.vitruv.framework.versioning.author.impl.AuthorImpl
import tools.vitruv.framework.versioning.branch.Branch
import tools.vitruv.framework.versioning.branch.UserBranch
import tools.vitruv.framework.versioning.common.commit.Commit

/**
 * The author of commits to the {@link Repository}.
 * @author Patrick Stoeckle <p.stoeckle@gmx.net> 
 */
interface Author extends Named {
	/**
	 * Creates an author with the given name.
	 * @param name the name of the author
	 */
	static def Author createAuthor(String name) {
		new AuthorImpl(name)
	}

	def String getEmail()

	def void setEmail(String value)

	def Set<UserBranch> getOwnedBranches()

	def Set<Branch> getContributedBranches()

	def List<Commit> getCommits()

//	def Repository getCurrentRepository()
//	def void setCurrentRepository(Repository value)
//
//	def Branch getCurrentBranch()
//	def void setCurrentBranch(Branch value)
//	def UserBranch createBranch(String branchName)
//
//	def void switchToBranch(Branch targetBranch)
//
//	def void switchToRepository(Repository repository)
}