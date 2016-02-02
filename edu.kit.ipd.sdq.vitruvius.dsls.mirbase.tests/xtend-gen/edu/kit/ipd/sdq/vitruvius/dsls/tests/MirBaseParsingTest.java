/**
 * generated by Xtext 2.10.0-SNAPSHOT
 */
package edu.kit.ipd.sdq.vitruvius.dsls.tests;

import com.google.inject.Inject;
import edu.kit.ipd.sdq.vitruvius.dsls.mirBase.MetamodelImport;
import edu.kit.ipd.sdq.vitruvius.dsls.tests.MirBaseInjectorProvider;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.junit4.InjectWith;
import org.eclipse.xtext.junit4.XtextRunner;
import org.eclipse.xtext.junit4.util.ParseHelper;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;

@RunWith(XtextRunner.class)
@InjectWith(MirBaseInjectorProvider.class)
@SuppressWarnings("all")
public class MirBaseParsingTest {
  @Inject
  private ParseHelper<MetamodelImport> parseHelper;
  
  @Test
  public void loadModel() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("Hello Xtext!");
      _builder.newLine();
      final MetamodelImport result = this.parseHelper.parse(_builder);
      Assert.assertNotNull(result);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
}