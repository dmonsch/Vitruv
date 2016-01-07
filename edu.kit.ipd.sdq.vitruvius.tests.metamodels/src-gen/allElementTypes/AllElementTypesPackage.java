/**
 */
package allElementTypes;

import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EOperation;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EReference;

/**
 * <!-- begin-user-doc -->
 * The <b>Package</b> for the model.
 * It contains accessors for the meta objects to represent
 * <ul>
 *   <li>each class,</li>
 *   <li>each feature of each class,</li>
 *   <li>each operation of each class,</li>
 *   <li>each enum,</li>
 *   <li>and each data type</li>
 * </ul>
 * <!-- end-user-doc -->
 * @see allElementTypes.AllElementTypesFactory
 * @model kind="package"
 * @generated
 */
public interface AllElementTypesPackage extends EPackage {
	/**
	 * The package name.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	String eNAME = "allElementTypes";

	/**
	 * The package namespace URI.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	String eNS_URI = "http://edu.kit.ipd.sdq.vitruvius.tests.metamodels.allElementTypes";

	/**
	 * The package namespace name.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	String eNS_PREFIX = "allElementTypes";

	/**
	 * The singleton instance of the package.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	AllElementTypesPackage eINSTANCE = allElementTypes.impl.AllElementTypesPackageImpl.init();

	/**
	 * The meta object id for the '{@link allElementTypes.impl.RootImpl <em>Root</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see allElementTypes.impl.RootImpl
	 * @see allElementTypes.impl.AllElementTypesPackageImpl#getRoot()
	 * @generated
	 */
	int ROOT = 0;

	/**
	 * The feature id for the '<em><b>Single Valued EAttribute</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ROOT__SINGLE_VALUED_EATTRIBUTE = 0;

	/**
	 * The feature id for the '<em><b>Single Valued Non Containment EReference</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ROOT__SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE = 1;

	/**
	 * The feature id for the '<em><b>Single Valued Containment EReference</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ROOT__SINGLE_VALUED_CONTAINMENT_EREFERENCE = 2;

	/**
	 * The feature id for the '<em><b>Multi Valued EAttribute</b></em>' attribute list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ROOT__MULTI_VALUED_EATTRIBUTE = 3;

	/**
	 * The feature id for the '<em><b>Multi Valued Non Containment EReference</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ROOT__MULTI_VALUED_NON_CONTAINMENT_EREFERENCE = 4;

	/**
	 * The feature id for the '<em><b>Multi Valued Containment EReference</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ROOT__MULTI_VALUED_CONTAINMENT_EREFERENCE = 5;

	/**
	 * The feature id for the '<em><b>Non Root Object Container Helper</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ROOT__NON_ROOT_OBJECT_CONTAINER_HELPER = 6;

	/**
	 * The feature id for the '<em><b>Id</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ROOT__ID = 7;

	/**
	 * The number of structural features of the '<em>Root</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ROOT_FEATURE_COUNT = 8;

	/**
	 * The operation id for the '<em>Single Valued Operation</em>' operation.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ROOT___SINGLE_VALUED_OPERATION = 0;

	/**
	 * The operation id for the '<em>Multi Valued Operation</em>' operation.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ROOT___MULTI_VALUED_OPERATION = 1;

	/**
	 * The number of operations of the '<em>Root</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ROOT_OPERATION_COUNT = 2;

	/**
	 * The meta object id for the '{@link allElementTypes.impl.NonRootImpl <em>Non Root</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see allElementTypes.impl.NonRootImpl
	 * @see allElementTypes.impl.AllElementTypesPackageImpl#getNonRoot()
	 * @generated
	 */
	int NON_ROOT = 1;

	/**
	 * The feature id for the '<em><b>Id</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int NON_ROOT__ID = 0;

	/**
	 * The number of structural features of the '<em>Non Root</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int NON_ROOT_FEATURE_COUNT = 1;

	/**
	 * The number of operations of the '<em>Non Root</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int NON_ROOT_OPERATION_COUNT = 0;

	/**
	 * The meta object id for the '{@link allElementTypes.impl.NonRootObjectContainerHelperImpl <em>Non Root Object Container Helper</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see allElementTypes.impl.NonRootObjectContainerHelperImpl
	 * @see allElementTypes.impl.AllElementTypesPackageImpl#getNonRootObjectContainerHelper()
	 * @generated
	 */
	int NON_ROOT_OBJECT_CONTAINER_HELPER = 2;

	/**
	 * The feature id for the '<em><b>Non Root Objects Containment</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int NON_ROOT_OBJECT_CONTAINER_HELPER__NON_ROOT_OBJECTS_CONTAINMENT = 0;

	/**
	 * The feature id for the '<em><b>Id</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int NON_ROOT_OBJECT_CONTAINER_HELPER__ID = 1;

	/**
	 * The number of structural features of the '<em>Non Root Object Container Helper</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int NON_ROOT_OBJECT_CONTAINER_HELPER_FEATURE_COUNT = 2;

	/**
	 * The number of operations of the '<em>Non Root Object Container Helper</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int NON_ROOT_OBJECT_CONTAINER_HELPER_OPERATION_COUNT = 0;


	/**
	 * Returns the meta object for class '{@link allElementTypes.Root <em>Root</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Root</em>'.
	 * @see allElementTypes.Root
	 * @generated
	 */
	EClass getRoot();

	/**
	 * Returns the meta object for the attribute '{@link allElementTypes.Root#getSingleValuedEAttribute <em>Single Valued EAttribute</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Single Valued EAttribute</em>'.
	 * @see allElementTypes.Root#getSingleValuedEAttribute()
	 * @see #getRoot()
	 * @generated
	 */
	EAttribute getRoot_SingleValuedEAttribute();

	/**
	 * Returns the meta object for the reference '{@link allElementTypes.Root#getSingleValuedNonContainmentEReference <em>Single Valued Non Containment EReference</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Single Valued Non Containment EReference</em>'.
	 * @see allElementTypes.Root#getSingleValuedNonContainmentEReference()
	 * @see #getRoot()
	 * @generated
	 */
	EReference getRoot_SingleValuedNonContainmentEReference();

	/**
	 * Returns the meta object for the containment reference '{@link allElementTypes.Root#getSingleValuedContainmentEReference <em>Single Valued Containment EReference</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Single Valued Containment EReference</em>'.
	 * @see allElementTypes.Root#getSingleValuedContainmentEReference()
	 * @see #getRoot()
	 * @generated
	 */
	EReference getRoot_SingleValuedContainmentEReference();

	/**
	 * Returns the meta object for the attribute list '{@link allElementTypes.Root#getMultiValuedEAttribute <em>Multi Valued EAttribute</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute list '<em>Multi Valued EAttribute</em>'.
	 * @see allElementTypes.Root#getMultiValuedEAttribute()
	 * @see #getRoot()
	 * @generated
	 */
	EAttribute getRoot_MultiValuedEAttribute();

	/**
	 * Returns the meta object for the reference list '{@link allElementTypes.Root#getMultiValuedNonContainmentEReference <em>Multi Valued Non Containment EReference</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference list '<em>Multi Valued Non Containment EReference</em>'.
	 * @see allElementTypes.Root#getMultiValuedNonContainmentEReference()
	 * @see #getRoot()
	 * @generated
	 */
	EReference getRoot_MultiValuedNonContainmentEReference();

	/**
	 * Returns the meta object for the containment reference list '{@link allElementTypes.Root#getMultiValuedContainmentEReference <em>Multi Valued Containment EReference</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Multi Valued Containment EReference</em>'.
	 * @see allElementTypes.Root#getMultiValuedContainmentEReference()
	 * @see #getRoot()
	 * @generated
	 */
	EReference getRoot_MultiValuedContainmentEReference();

	/**
	 * Returns the meta object for the containment reference '{@link allElementTypes.Root#getNonRootObjectContainerHelper <em>Non Root Object Container Helper</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Non Root Object Container Helper</em>'.
	 * @see allElementTypes.Root#getNonRootObjectContainerHelper()
	 * @see #getRoot()
	 * @generated
	 */
	EReference getRoot_NonRootObjectContainerHelper();

	/**
	 * Returns the meta object for the attribute '{@link allElementTypes.Root#getId <em>Id</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Id</em>'.
	 * @see allElementTypes.Root#getId()
	 * @see #getRoot()
	 * @generated
	 */
	EAttribute getRoot_Id();

	/**
	 * Returns the meta object for the '{@link allElementTypes.Root#singleValuedOperation() <em>Single Valued Operation</em>}' operation.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the '<em>Single Valued Operation</em>' operation.
	 * @see allElementTypes.Root#singleValuedOperation()
	 * @generated
	 */
	EOperation getRoot__SingleValuedOperation();

	/**
	 * Returns the meta object for the '{@link allElementTypes.Root#multiValuedOperation() <em>Multi Valued Operation</em>}' operation.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the '<em>Multi Valued Operation</em>' operation.
	 * @see allElementTypes.Root#multiValuedOperation()
	 * @generated
	 */
	EOperation getRoot__MultiValuedOperation();

	/**
	 * Returns the meta object for class '{@link allElementTypes.NonRoot <em>Non Root</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Non Root</em>'.
	 * @see allElementTypes.NonRoot
	 * @generated
	 */
	EClass getNonRoot();

	/**
	 * Returns the meta object for the attribute '{@link allElementTypes.NonRoot#getId <em>Id</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Id</em>'.
	 * @see allElementTypes.NonRoot#getId()
	 * @see #getNonRoot()
	 * @generated
	 */
	EAttribute getNonRoot_Id();

	/**
	 * Returns the meta object for class '{@link allElementTypes.NonRootObjectContainerHelper <em>Non Root Object Container Helper</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Non Root Object Container Helper</em>'.
	 * @see allElementTypes.NonRootObjectContainerHelper
	 * @generated
	 */
	EClass getNonRootObjectContainerHelper();

	/**
	 * Returns the meta object for the containment reference list '{@link allElementTypes.NonRootObjectContainerHelper#getNonRootObjectsContainment <em>Non Root Objects Containment</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Non Root Objects Containment</em>'.
	 * @see allElementTypes.NonRootObjectContainerHelper#getNonRootObjectsContainment()
	 * @see #getNonRootObjectContainerHelper()
	 * @generated
	 */
	EReference getNonRootObjectContainerHelper_NonRootObjectsContainment();

	/**
	 * Returns the meta object for the attribute '{@link allElementTypes.NonRootObjectContainerHelper#getId <em>Id</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Id</em>'.
	 * @see allElementTypes.NonRootObjectContainerHelper#getId()
	 * @see #getNonRootObjectContainerHelper()
	 * @generated
	 */
	EAttribute getNonRootObjectContainerHelper_Id();

	/**
	 * Returns the factory that creates the instances of the model.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the factory that creates the instances of the model.
	 * @generated
	 */
	AllElementTypesFactory getAllElementTypesFactory();

	/**
	 * <!-- begin-user-doc -->
	 * Defines literals for the meta objects that represent
	 * <ul>
	 *   <li>each class,</li>
	 *   <li>each feature of each class,</li>
	 *   <li>each operation of each class,</li>
	 *   <li>each enum,</li>
	 *   <li>and each data type</li>
	 * </ul>
	 * <!-- end-user-doc -->
	 * @generated
	 */
	interface Literals {
		/**
		 * The meta object literal for the '{@link allElementTypes.impl.RootImpl <em>Root</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see allElementTypes.impl.RootImpl
		 * @see allElementTypes.impl.AllElementTypesPackageImpl#getRoot()
		 * @generated
		 */
		EClass ROOT = eINSTANCE.getRoot();

		/**
		 * The meta object literal for the '<em><b>Single Valued EAttribute</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute ROOT__SINGLE_VALUED_EATTRIBUTE = eINSTANCE.getRoot_SingleValuedEAttribute();

		/**
		 * The meta object literal for the '<em><b>Single Valued Non Containment EReference</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ROOT__SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE = eINSTANCE.getRoot_SingleValuedNonContainmentEReference();

		/**
		 * The meta object literal for the '<em><b>Single Valued Containment EReference</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ROOT__SINGLE_VALUED_CONTAINMENT_EREFERENCE = eINSTANCE.getRoot_SingleValuedContainmentEReference();

		/**
		 * The meta object literal for the '<em><b>Multi Valued EAttribute</b></em>' attribute list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute ROOT__MULTI_VALUED_EATTRIBUTE = eINSTANCE.getRoot_MultiValuedEAttribute();

		/**
		 * The meta object literal for the '<em><b>Multi Valued Non Containment EReference</b></em>' reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ROOT__MULTI_VALUED_NON_CONTAINMENT_EREFERENCE = eINSTANCE.getRoot_MultiValuedNonContainmentEReference();

		/**
		 * The meta object literal for the '<em><b>Multi Valued Containment EReference</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ROOT__MULTI_VALUED_CONTAINMENT_EREFERENCE = eINSTANCE.getRoot_MultiValuedContainmentEReference();

		/**
		 * The meta object literal for the '<em><b>Non Root Object Container Helper</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ROOT__NON_ROOT_OBJECT_CONTAINER_HELPER = eINSTANCE.getRoot_NonRootObjectContainerHelper();

		/**
		 * The meta object literal for the '<em><b>Id</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute ROOT__ID = eINSTANCE.getRoot_Id();

		/**
		 * The meta object literal for the '<em><b>Single Valued Operation</b></em>' operation.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EOperation ROOT___SINGLE_VALUED_OPERATION = eINSTANCE.getRoot__SingleValuedOperation();

		/**
		 * The meta object literal for the '<em><b>Multi Valued Operation</b></em>' operation.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EOperation ROOT___MULTI_VALUED_OPERATION = eINSTANCE.getRoot__MultiValuedOperation();

		/**
		 * The meta object literal for the '{@link allElementTypes.impl.NonRootImpl <em>Non Root</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see allElementTypes.impl.NonRootImpl
		 * @see allElementTypes.impl.AllElementTypesPackageImpl#getNonRoot()
		 * @generated
		 */
		EClass NON_ROOT = eINSTANCE.getNonRoot();

		/**
		 * The meta object literal for the '<em><b>Id</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute NON_ROOT__ID = eINSTANCE.getNonRoot_Id();

		/**
		 * The meta object literal for the '{@link allElementTypes.impl.NonRootObjectContainerHelperImpl <em>Non Root Object Container Helper</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see allElementTypes.impl.NonRootObjectContainerHelperImpl
		 * @see allElementTypes.impl.AllElementTypesPackageImpl#getNonRootObjectContainerHelper()
		 * @generated
		 */
		EClass NON_ROOT_OBJECT_CONTAINER_HELPER = eINSTANCE.getNonRootObjectContainerHelper();

		/**
		 * The meta object literal for the '<em><b>Non Root Objects Containment</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference NON_ROOT_OBJECT_CONTAINER_HELPER__NON_ROOT_OBJECTS_CONTAINMENT = eINSTANCE.getNonRootObjectContainerHelper_NonRootObjectsContainment();

		/**
		 * The meta object literal for the '<em><b>Id</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute NON_ROOT_OBJECT_CONTAINER_HELPER__ID = eINSTANCE.getNonRootObjectContainerHelper_Id();

	}

} //AllElementTypesPackage
