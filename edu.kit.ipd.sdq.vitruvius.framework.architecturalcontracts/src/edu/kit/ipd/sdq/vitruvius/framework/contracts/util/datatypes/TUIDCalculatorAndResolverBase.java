package edu.kit.ipd.sdq.vitruvius.framework.contracts.util.datatypes;

import org.apache.log4j.Logger;
import org.eclipse.emf.ecore.EObject;

import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.VURI;
import edu.kit.ipd.sdq.vitruvius.framework.contracts.interfaces.user.TUIDCalculatorAndResolver;
import edu.kit.ipd.sdq.vitruvius.framework.util.VitruviusConstants;

/**
 * Base class for TUID calculators and resolvers. It handles the default parts of the TUID like
 * generator identifier and URI inclusion for TUID calculation and resolution.
 */
public abstract class TUIDCalculatorAndResolverBase implements TUIDCalculatorAndResolver {

    private static final Logger LOGGER = Logger.getLogger(TUIDCalculatorAndResolverBase.class.getSimpleName());

    @Override
    public boolean isValidTUID(final String tuid) {
        try {
            getTUIDWithoutDefaultPart(tuid);
        } catch (IllegalArgumentException e) {
            return false;
        }
        return true;
    }

    @Override
    public String calculateTUIDFromEObject(final EObject eObject) {
        if (eObject.eResource() == null) {
            LOGGER.warn("The given EObject " + eObject
                    + " has no resource attached, which is necessary to generate a TUID.");
            return getDefaultTUID();
        }

        String tuidPrefix = getDefaultTUID() + VURI.getInstance(eObject.eResource());
        return calculateTUIDFromEObject(eObject, null, tuidPrefix);
    }

    /**
     * @return The default prefix for all TUIDs of this calculator.
     */
    public String getDefaultTUID() {
        return getTUIDIdentifier() + VitruviusConstants.getTUIDSegmentSeperator();
    }

    @Override
    public VURI getModelVURIContainingIdentifiedEObject(final String extTuid) {
        String tuid = getTUIDWithoutDefaultPart(extTuid);
        String[] ids = tuid.split(VitruviusConstants.getTUIDSegmentSeperator());
        String vuriKey = ids[0];
        return VURI.getInstance(vuriKey);

    }

    @Override
    public EObject resolveEObjectFromRootAndFullTUID(final EObject root, final String extTuid) {
        String identifier = getTUIDWithoutRootObjectPart(root, extTuid);
        if (identifier == null) {
            return null;
        }

        String[] ids = identifier.split(VitruviusConstants.getTUIDSegmentSeperator());
        if (identifier.length() == 0) {
            ids = new String[0];
        }

        EObject foundElement = getIdentifiedEObjectWithinRootEObjectInternal(root, ids);
        if (foundElement != null) {
            return foundElement;
        }

        LOGGER.warn("No EObject found for TUID: " + extTuid + " in root object: " + root);
        return null;
    }

    /**
     * Removes the root object prefix from the given TUID and returns the result.
     *
     * @param root
     *            The root object.
     * @param extTuid
     *            The TUID to process.
     * @return The TUID without the root object prefix.
     */
    private String getTUIDWithoutRootObjectPart(final EObject root, final String extTuid) {
        String rootTUID = calculateTUIDFromEObject(root);
        if (!extTuid.startsWith(rootTUID)) {
            LOGGER.warn("TUID " + extTuid + " is not in EObject " + root);
            return null;
        }

        String identifyingTUIDPart = extTuid.substring(rootTUID.length());
        if (identifyingTUIDPart.startsWith(VitruviusConstants.getTUIDSegmentSeperator())) {
            identifyingTUIDPart = identifyingTUIDPart.substring(VitruviusConstants.getTUIDSegmentSeperator().length());
        }
        return identifyingTUIDPart;
    }

    /**
     * Finds the object described by the given IDs in the given root object.
     *
     * @param root
     *            The root object.
     * @param ids
     *            The IDs of the object to find.
     * @return The found object or null if no such object exists.
     */
    protected abstract EObject getIdentifiedEObjectWithinRootEObjectInternal(final EObject root, final String[] ids);

    /**
     * @param tuid
     *            The TUID.
     * @return The given TUID without the default part.
     */
    private String getTUIDWithoutDefaultPart(final String tuid) {
        if (!tuid.startsWith(getDefaultTUID())) {
            throw new IllegalArgumentException("TUID: " + tuid + " not generated by class " + getTUIDIdentifier());
        }
        return tuid.substring(getDefaultTUID().length());
    }

    /**
     * @return The identifier for the TUID calculator and resolver (e.g. the name of the class).
     */
    protected abstract String getTUIDIdentifier();

}
