/**
 * generated by Xtext 2.10.0-SNAPSHOT
 */
package edu.kit.ipd.sdq.vitruvius.dsls.mirbase;

import edu.kit.ipd.sdq.vitruvius.dsls.mirbase.MirBaseStandaloneSetupGenerated;

/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
@SuppressWarnings("all")
public class MirBaseStandaloneSetup extends MirBaseStandaloneSetupGenerated {
  public static void doSetup() {
    MirBaseStandaloneSetup _mirBaseStandaloneSetup = new MirBaseStandaloneSetup();
    _mirBaseStandaloneSetup.createInjectorAndDoEMFRegistration();
  }
}