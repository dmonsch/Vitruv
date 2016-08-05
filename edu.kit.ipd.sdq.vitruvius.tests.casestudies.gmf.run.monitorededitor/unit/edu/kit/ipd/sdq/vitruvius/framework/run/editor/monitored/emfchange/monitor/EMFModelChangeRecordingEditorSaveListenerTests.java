/*******************************************************************************
 * Copyright (c) 2014 Felix Kutzner.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Felix Kutzner - initial implementation.
 ******************************************************************************/

package edu.kit.ipd.sdq.vitruvius.framework.run.editor.monitored.emfchange.monitor;

import static org.junit.Assert.assertTrue;

import java.util.List;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EcoreFactory;
import org.eclipse.ui.IEditorPart;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import edu.kit.ipd.sdq.vitruvius.framework.contracts.change.recorded.EMFModelChange;
import edu.kit.ipd.sdq.vitruvius.framework.run.editor.monitored.emfchange.IEditorPartAdapterFactory.IEditorPartAdapter;
import edu.kit.ipd.sdq.vitruvius.framework.run.editor.monitored.emfchange.test.mocking.EclipseMock;
import edu.kit.ipd.sdq.vitruvius.framework.run.editor.monitored.emfchange.test.mocking.EclipseMock.SaveEventKind;
import edu.kit.ipd.sdq.vitruvius.framework.run.editor.monitored.emfchange.test.testmodels.Files;
import edu.kit.ipd.sdq.vitruvius.framework.run.editor.monitored.emfchange.test.utils.BasicTestCase;
import edu.kit.ipd.sdq.vitruvius.framework.run.editor.monitored.emfchange.test.utils.EnsureExecuted;
import edu.kit.ipd.sdq.vitruvius.framework.run.editor.monitored.emfchange.test.utils.EnsureNotExecuted;
import edu.kit.ipd.sdq.vitruvius.framework.run.editor.monitored.emfchange.tools.EclipseAdapterProvider;
import edu.kit.ipd.sdq.vitruvius.framework.run.editor.monitored.emfchange.tools.IEclipseAdapter;

public class EMFModelChangeRecordingEditorSaveListenerTests extends BasicTestCase {
    private EclipseMock eclipseCtrl;
    private IEclipseAdapter mockedEclipseUtils;

    private IEditorPart editorPart;
    private IEditorPartAdapter editorPartAdapter;

    private final EObject DUMMY_EOBJECT = EcoreFactory.eINSTANCE.createEClass();

    @Before
    public void setUp() {
        this.eclipseCtrl = new EclipseMock();
        this.mockedEclipseUtils = eclipseCtrl.getEclipseUtils();
        EclipseAdapterProvider.getInstance().setProvidedEclipseAdapter(mockedEclipseUtils);
        DefaultEditorPartAdapterFactoryImpl adapterFactory = new DefaultEditorPartAdapterFactoryImpl(
                Files.ECORE_FILE_EXTENSION);
        editorPart = eclipseCtrl.openNewEMFTreeEditorPart(Files.EXAMPLEMODEL_ECORE);
        editorPartAdapter = adapterFactory.createAdapter(editorPart);
    }

    @After
    public void tearDown() {
        assert !eclipseCtrl.hasListeners() : "Listeners were not fully removed from Eclipse";
    }

    @Test
    public void savesAreDetected() {
        final EnsureExecuted ensureExecuted = new EnsureExecuted();

        EMFModelChangeRecordingEditorSaveListener listener = new EMFModelChangeRecordingEditorSaveListener(
                editorPartAdapter) {
            @Override
            protected void onSavedResource(List<EMFModelChange> changeDescriptions) {
                assert changeDescriptions != null;
                changeDescriptions.forEach((EMFModelChange descr) -> assertTrue(
                        descr.getChangeDescription().getObjectChanges().isEmpty()));
                ensureExecuted.markExecuted();
            }
        };
        listener.initialize();

        eclipseCtrl.issueSaveEvent(SaveEventKind.SAVE);

        assert !ensureExecuted.isIndicatingFail() : "The save listenener was not executed.";
        listener.dispose();
    }

    @Test
    public void changesArePassedToTheListener() {
        final EnsureExecuted ensureExecuted = new EnsureExecuted();
        final String newRootObjName = "Foobar";
        final EPackage rootObj = (EPackage) editorPartAdapter.getEditingDomain().getRoot(DUMMY_EOBJECT);

        // Set up the listener.
        EMFModelChangeRecordingEditorSaveListener listener = new EMFModelChangeRecordingEditorSaveListener(
                editorPartAdapter) {
            @Override
            protected void onSavedResource(List<EMFModelChange> changeDescriptions) {
                assert changeDescriptions != null;
                // assert changeDescriptions.size() == 1;
                int counter = 0;
                for (EMFModelChange descr : changeDescriptions) {
                    counter += descr.getChangeDescription().getObjectChanges().size();
                }
                assert counter == 1;

                assert changeDescriptions.get(0).getChangeDescription().getObjectChanges().containsKey(rootObj);

                ensureExecuted.markExecuted();
            }
        };
        listener.initialize();

        // Change the model.
        rootObj.setName(newRootObjName);

        // Simulate a save event.
        eclipseCtrl.issueSaveEvent(SaveEventKind.SAVE);

        assert !ensureExecuted.isIndicatingFail() : "The save listenener was not executed.";
        listener.dispose();
    }

    @Test
    public void savesForOtherEditorsAreIgnored() {
        eclipseCtrl.openNewEMFTreeEditorPart(Files.DATATYPE_ECORE);
        // Now, the currently active editor part in the mocked eclipse environment is ep

        final EnsureNotExecuted ensureNotExecuted = new EnsureNotExecuted();

        EMFModelChangeRecordingEditorSaveListener listener = new EMFModelChangeRecordingEditorSaveListener(
                editorPartAdapter) {
            @Override
            protected void onSavedResource(List<EMFModelChange> changeDescriptions) {
                ensureNotExecuted.markExecuted();
            }
        };
        listener.initialize();

        eclipseCtrl.issueSaveEvent(SaveEventKind.SAVE);

        assert !ensureNotExecuted
                .isIndicatingFail() : "The save listener was executed though another editor was active.";
        listener.dispose();
    }
}
