package edu.kit.ipd.sdq.vitruvius.integration.traversal.test;

import static org.junit.Assert.assertEquals;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.palladiosimulator.pcm.core.composition.AssemblyContext;
import org.palladiosimulator.pcm.core.composition.Connector;
import org.palladiosimulator.pcm.repository.ProvidedRole;
import org.palladiosimulator.pcm.repository.Repository;
import org.palladiosimulator.pcm.repository.RequiredRole;

import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.Change;
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.CompositeChange;
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.EMFModelChange;
import edu.kit.ipd.sdq.vitruvius.framework.meta.change.feature.reference.containment.CreateNonRootEObjectInList;
import edu.kit.ipd.sdq.vitruvius.integration.pcm.traversal.composite.CompositeTraversalStrategy;
import edu.kit.ipd.sdq.vitruvius.integration.pcm.traversal.repository.RepositoryTraversalStrategy;
import edu.kit.ipd.sdq.vitruvius.integration.traversal.ITraversalStrategy;
import edu.kit.ipd.sdq.vitruvius.integration.util.RepositoryModelLoader;

/**
 * This test case is executed on a model which contains Composite Components.
 *
 * @author Sven Leonhardt
 */

public class CompositeComponentsTraversalTest {

    private static Resource testmodel;
    private static final String path = "JUnitTestmodels/compositeTestcaseModel.repository";

    /**
     * Sets the up before class.
     *
     * @throws Exception
     *             the exception
     */
    @BeforeClass
    public static void setUpBeforeClass() throws Exception {

        testmodel = RepositoryModelLoader.loadPCMResource(path);
    }

    /**
     * Tear down after class.
     *
     * @throws Exception
     *             the exception
     */
    @AfterClass
    public static void tearDownAfterClass() throws Exception {
        testmodel = null;
    }

    /**
     * Sets the up.
     *
     * @throws Exception
     *             the exception
     */
    @Before
    public void setUp() throws Exception {
    }

    /**
     * Tear down.
     *
     * @throws Exception
     *             the exception
     */
    @After
    public void tearDown() throws Exception {
    }

    /**
     * Composite traversel test.
     */
    @Test
    public void compositeTraverselTest() {

        // traverse model and get a list of changes
        final Repository repo = (Repository) testmodel.getContents().get(0);
        final ITraversalStrategy<Repository> repoTraversal = new RepositoryTraversalStrategy();
        final ITraversalStrategy<Repository> compTraversal = new CompositeTraversalStrategy();
        EList<Change> changes = null;
        final URI uri = URI.createPlatformResourceURI(path, true);

        try {
            changes = repoTraversal.traverse(repo, uri, null);
            changes = compTraversal.traverse(repo, uri, changes);
        } catch (final UnsupportedOperationException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        // Don't validate earlier changes. This is covered by BasicRepositoryTraversalTest

        EMFModelChange basicChange = null;
        CompositeChange compChange = null;

        AssemblyContext assemblyContext = null;
        ProvidedRole provRole = null;
        RequiredRole reqRole = null;
        Connector connector = null;

        // AssemblyContexts (2x)
        basicChange = (EMFModelChange) changes.get(17);
        assemblyContext = (AssemblyContext) ((CreateNonRootEObjectInList<EObject>) basicChange.getEChange())
                .getNewValue();
        assertEquals("_231GoKSKEeSbnMsEKXLSVg", assemblyContext.getId());

        basicChange = (EMFModelChange) changes.get(18);
        assemblyContext = (AssemblyContext) ((CreateNonRootEObjectInList<EObject>) basicChange.getEChange())
                .getNewValue();
        assertEquals("_45e1UKSKEeSbnMsEKXLSVg", assemblyContext.getId());

        // CompositeChange: Inner provided role + delegation
        compChange = (CompositeChange) changes.get(19);
        basicChange = (EMFModelChange) compChange.getChanges().get(0);
        provRole = (ProvidedRole) ((CreateNonRootEObjectInList<EObject>) basicChange.getEChange()).getNewValue();
        assertEquals("_Ipz9v6SPEeSog9_tMitgaA", provRole.getId());

        basicChange = (EMFModelChange) compChange.getChanges().get(1);
        connector = (Connector) ((CreateNonRootEObjectInList<EObject>) basicChange.getEChange()).getNewValue();
        assertEquals("_PqX2ZKSPEeSog9_tMitgaA", connector.getId());

        // CompositeChange: Inner required role + delegation
        compChange = (CompositeChange) changes.get(20);
        basicChange = (EMFModelChange) compChange.getChanges().get(0);
        reqRole = (RequiredRole) ((CreateNonRootEObjectInList<EObject>) basicChange.getEChange()).getNewValue();
        assertEquals("_2ibk06SSEeSVEJcCUfjH2Q", reqRole.getId());

        basicChange = (EMFModelChange) compChange.getChanges().get(1);
        connector = (Connector) ((CreateNonRootEObjectInList<EObject>) basicChange.getEChange()).getNewValue();
        assertEquals("_8Loo9aSSEeSVEJcCUfjH2Q", connector.getId());

        // Assembly Connector
        basicChange = (EMFModelChange) changes.get(21);
        connector = (Connector) ((CreateNonRootEObjectInList<EObject>) basicChange.getEChange()).getNewValue();
        assertEquals("_UNsW9qSXEeSVEJcCUfjH2Q", connector.getId());

        // AssemblyContexts (2x)
        basicChange = (EMFModelChange) changes.get(22);
        assemblyContext = (AssemblyContext) ((CreateNonRootEObjectInList<EObject>) basicChange.getEChange())
                .getNewValue();
        assertEquals("_pcimMKSKEeSbnMsEKXLSVg", assemblyContext.getId());

        basicChange = (EMFModelChange) changes.get(23);
        assemblyContext = (AssemblyContext) ((CreateNonRootEObjectInList<EObject>) basicChange.getEChange())
                .getNewValue();
        assertEquals("_snqeYKSKEeSbnMsEKXLSVg", assemblyContext.getId());

        // CompositeChange: Inner provided role + delegation
        compChange = (CompositeChange) changes.get(24);
        basicChange = (EMFModelChange) compChange.getChanges().get(0);
        provRole = (ProvidedRole) ((CreateNonRootEObjectInList<EObject>) basicChange.getEChange()).getNewValue();
        assertEquals("_EBE7P6STEeSVEJcCUfjH2Q", provRole.getId());

        basicChange = (EMFModelChange) compChange.getChanges().get(1);
        connector = (Connector) ((CreateNonRootEObjectInList<EObject>) basicChange.getEChange()).getNewValue();
        assertEquals("_IP0zlKSTEeSVEJcCUfjH2Q", connector.getId());

        // CompositeChange: Inner required role + delegation
        compChange = (CompositeChange) changes.get(25);
        basicChange = (EMFModelChange) compChange.getChanges().get(0);
        reqRole = (RequiredRole) ((CreateNonRootEObjectInList<EObject>) basicChange.getEChange()).getNewValue();
        assertEquals("_CJpqI6SUEeSVEJcCUfjH2Q", reqRole.getId());

        basicChange = (EMFModelChange) compChange.getChanges().get(1);
        connector = (Connector) ((CreateNonRootEObjectInList<EObject>) basicChange.getEChange()).getNewValue();
        assertEquals("_dr1zxaSUEeSVEJcCUfjH2Q", connector.getId());

        return;

    }

}