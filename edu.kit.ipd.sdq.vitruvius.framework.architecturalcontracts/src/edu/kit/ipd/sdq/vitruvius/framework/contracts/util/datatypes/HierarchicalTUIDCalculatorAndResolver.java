package edu.kit.ipd.sdq.vitruvius.framework.contracts.util.datatypes;

import java.util.Arrays;
import java.util.LinkedList;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EReference;

import edu.kit.ipd.sdq.vitruvius.framework.util.VitruviusConstants;

/**
 * Base class for hierarchical TUID calculators. Hierarchical means that the TUID reflects the
 * containment hierarchy and for each element in this hierarchy a segment is added. The subclasses
 * only have to provide the strings for the individual segments. The string does not have to be
 * unique but has to become unique in combination with the segments from higher hierarchical levels.
 *
 * @param <T>
 *            The type of the meta-models's root object.
 */
public abstract class HierarchicalTUIDCalculatorAndResolver<T extends EObject> extends TUIDCalculatorAndResolverBase {

    private static final Logger LOGGER = Logger.getLogger(HierarchicalTUIDCalculatorAndResolver.class);
    protected static final String SUBDIVIDER = "-_-";

    /**
     * @return Class of the root object.
     */
    protected abstract Class<T> getRootObjectClass();

    // ============================================================================
    // TUID resolution
    // ============================================================================
    @Override
    protected EObject getIdentifiedEObjectWithinRootEObjectInternal(final EObject root, final String[] ids) {
        if (!getRootObjectClass().isAssignableFrom(root.getClass())) {
            LOGGER.error("TUID resolving is only possible with root object of type "
                    + getRootObjectClass().getSimpleName());
            return null;
        }

        return findById(root, ids);
    }

    /**
     * Finds the wanted EObject in a given root object.
     *
     * @param rootObject
     *            The root object from which the search shall be started.
     * @param ids
     *            An array of the TUID segments. The segments of the root object have to be removed
     *            before calling this method.
     * @return The found EObject or null if there is no matching EObject.
     */
    private EObject findById(final EObject rootObject, final String[] ids) {
        // finds EObjects using brute force approach
        EObject obj = rootObject;
        for (String[] runningIds = ids; obj != null && runningIds.length > 0; runningIds = removeFirstElement(runningIds)) {
            obj = findById(obj, runningIds[0]);
        }
        return obj;
    }

    /**
     * Finds a single EObject, which is contained by the given root object. The root object does NOT
     * have to be the root object of the whole model but the parent of the searched EObject.
     *
     * @param rootObject
     *            The object, which's containment have to checked.
     * @param individualId
     *            The identifier of the wanted EObject. This has to be exactly one segment of a
     *            TUID.
     * @return The found EObject or null if there is no matching EObject.
     */
    private EObject findById(final EObject rootObject, final String individualId) {
        for (EReference containment : rootObject.eClass().getEAllContainments()) {
            EObject match = findMatchingEObject(rootObject.eGet(containment), individualId);
            if (match != null) {
                return match;
            }
        }
        return null;
    }

    /**
     * Looks for the wanted EObject by checking the candidate object. There are two options:
     * <ol>
     * <li>The candidate is an EObject, so we compare it's ID.</li>
     * <li>The candidate is an EList, so we compare the IDs of all of its elements.</li>
     * </ol>
     *
     * @param candidate
     *            The candidate object (EObject or EList).
     * @param individualId
     *            The ID of the wanted EObject.
     * @return The matched EObject or null if there was no match.
     */
    @SuppressWarnings("unchecked")
    private EObject findMatchingEObject(final Object candidate, final String individualId) {
        if (candidate instanceof Iterable<?>) {
            for (EObject obj : (Iterable<EObject>) candidate) {
                if (matchesIndividualId(obj, individualId)) {
                    return obj;
                }
            }
        } else if (candidate instanceof EObject) {
            if (matchesIndividualId((EObject) candidate, individualId)) {
                return (EObject) candidate;
            }
        }

        return null;
    }

    /**
     * Compares the individual ID of the given object with the given individual ID.
     *
     * @param obj
     *            The object for the comparison.
     * @param individualId
     *            The individual ID for the comparison.
     * @return True if the object has the individual ID.
     */
    private boolean matchesIndividualId(final EObject obj, final String individualId) {
        try {
            return hasId(obj, individualId);
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    /**
     * Checks if the given EObject has the same individual ID as the one passed to this method.
     *
     * @param obj
     *            The object to check.
     * @param indidivualId
     *            The individual ID to check.
     * @return True if the object has the same individual ID.
     * @throws IllegalArgumentException
     *             If there is no TUID calculation mechanism for this particular type of EObject.
     */
    protected abstract boolean hasId(EObject obj, String indidivualId) throws IllegalArgumentException;

    // ============================================================================
    // TUID generation
    // ============================================================================
    @Override
    public String calculateTUIDFromEObject(final EObject eObject, final EObject virtualRootObject, final String prefix) {
        if (!isValidTUID(prefix) || prefix.endsWith(VitruviusConstants.getTUIDSegmentSeperator())) {
            throw new IllegalArgumentException(
                    "The given prefix is invalid (must contain URI and default segment and must NOT end with a separator.");
        }

        LinkedList<String> segments = new LinkedList<String>();
        EObject parent = eObject;
        for (; parent != null && parent != virtualRootObject; parent = parent.eContainer()) {
            String currentSegment = calculateIndividualTUIDDelegator(parent);
            if (0 < currentSegment.length()) {
                segments.push(currentSegment);
            }
        }
        segments.push(prefix);
        return StringUtils.join(segments, VitruviusConstants.getTUIDSegmentSeperator());
    }

    /**
     * Calculates the individual ID for the given object.
     *
     * @param obj
     *            The object for the ID caluclation.
     * @return The individual ID.
     * @throws IllegalArgumentException
     *             If there is no TUID calculation mechanism for this particular type of EObject.
     */
    protected abstract String calculateIndividualTUIDDelegator(EObject obj) throws IllegalArgumentException;

    // ============================================================================
    // Helper stuff
    // ============================================================================
    /**
     * Creates a new array with the first element removed.
     *
     * @param ids
     *            The array for removal.
     * @param <T>
     *            The type of the array.
     * @return The sliced array.
     */
    private static <T> T[] removeFirstElement(final T[] ids) {
        return removeFirstElements(ids, 1);
    }

    /**
     * Creates a new array with the first n elements removed.
     *
     * @param ids
     *            The array for removal.
     * @param numberOfIdsToRemove
     *            The number of elements to remove.
     * @param <T>
     *            The type of the array.
     * @return The sliced array.
     */
    private static <T> T[] removeFirstElements(final T[] ids, final int numberOfIdsToRemove) {
        return Arrays.copyOfRange(ids, numberOfIdsToRemove, ids.length);
    }

}
