import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.GuestConfiguration;
/**
 * Guest configuration assignment is an association between a machine and guest configuration.
 */
model GuestConfigurationAssignment
  is Azure.ResourceManager.ProxyResource<GuestConfigurationAssignmentProperties> {
  ...ResourceNameParameter<
    Resource = GuestConfigurationAssignment,
    KeyName = "guestConfigurationAssignmentName",
    SegmentName = "guestConfigurationAssignments",
    NamePattern = ""
  >;
}

@armResourceOperations
interface GuestConfigurationAssignmentOps
  extends Azure.ResourceManager.Legacy.ExtensionOperations<
      {
        ...ApiVersionParameter,
        ...SubscriptionIdParameter,
        ...ResourceGroupParameter,

        /** the provider namespace */
        @path
        @segment("providers")
        @key
        providerNamespace: "Microsoft.Compute",

        /** The name of the virtual machine. */
        @path
        @segment("virtualMachines")
        @key
        @pattern("^[a-zA-Z0-9][-a-zA-Z0-9_.]*[a-zA-Z0-9]$")
        vmName: string,
      },
      {
        ...Extension.ExtensionProviderNamespace<GuestConfigurationAssignment>,
      },
      {
        ...Extension.ExtensionProviderNamespace<GuestConfigurationAssignment>,

        /** The guest configuration assignment name. */
        @path
        @segment("guestConfigurationAssignments")
        @key
        guestConfigurationAssignmentName: string,
      }
    > {}

@armResourceOperations
interface GuestConfigurationAssignments {
  /**
   * Get information about a guest configuration assignment
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GuestConfigurationAssignments_Get")
  get is GuestConfigurationAssignmentOps.Read<GuestConfigurationAssignment>;

  /**
   * Creates an association between a VM and guest configuration
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GuestConfigurationAssignments_CreateOrUpdate")
  createOrUpdate is GuestConfigurationAssignmentOps.CreateOrUpdateSync<GuestConfigurationAssignment>;

  /**
   * Delete a guest configuration assignment
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  @operationId("GuestConfigurationAssignments_Delete")
  delete is GuestConfigurationAssignmentOps.DeleteSync<
    GuestConfigurationAssignment,
    Response = ArmDeletedResponse
  >;

  /**
   * List all guest configuration assignments for a virtual machine.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GuestConfigurationAssignments_List")
  list is GuestConfigurationAssignmentOps.List<
    GuestConfigurationAssignment,
    Response = ArmResponse<GuestConfigurationAssignmentList>
  >;

  /**
   * List all guest configuration assignments for a subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GuestConfigurationAssignments_SubscriptionList")
  subscriptionList is GuestConfigurationAssignmentOps.ListBySubscription<
    GuestConfigurationAssignment,
    Response = ArmResponse<GuestConfigurationAssignmentList> | NoContentResponse
  >;

  /**
   * List all reports for the guest configuration assignment, latest report first.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GuestConfigurationAssignmentReports_List")
  @get
  @action("reports")
  guestConfigurationAssignmentReportsList is GuestConfigurationAssignmentOps.ActionSync<
    GuestConfigurationAssignment,
    void,
    ArmResponse<GuestConfigurationAssignmentReportList>
  >;

  /**
   * Get a report for the guest configuration assignment, by reportId.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GuestConfigurationAssignmentReports_Get")
  @get
  @action("{reportId}")
  guestConfigurationAssignmentReportsGet is GuestConfigurationAssignmentOps.ActionSync<
    GuestConfigurationAssignment,
    void,
    ArmResponse<GuestConfigurationAssignmentReport>,
    Parameters = {
      /**
       * The GUID for the guest configuration assignment report.
       */
      @path
      reportId: string;
    }
  >;
}
@armResourceOperations
interface GuestConfigurationHCRPAssignmentOps
  extends Azure.ResourceManager.Legacy.ExtensionOperations<
      {
        ...ApiVersionParameter,
        ...SubscriptionIdParameter,
        ...ResourceGroupParameter,

        /** the provider namespace */
        @path
        @segment("providers")
        @key
        providerNamespace: "Microsoft.HybridCompute",

        /** The name of the ARC machine. */
        @path
        @segment("machines")
        @key
        machineName: string,
      },
      {
        ...Extension.ExtensionProviderNamespace<GuestConfigurationAssignment>,
      },
      {
        ...Extension.ExtensionProviderNamespace<GuestConfigurationAssignment>,

        /** The guest configuration assignment name. */
        @path
        @segment("guestConfigurationAssignments")
        @key
        guestConfigurationAssignmentName: string,
      }
    > {}

@armResourceOperations
interface GuestConfigurationHCRPAssignments {
  /**
   * Get information about a guest configuration assignment
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GuestConfigurationHCRPAssignments_Get")
  get is GuestConfigurationHCRPAssignmentOps.Read<GuestConfigurationAssignment>;

  /**
   * Creates an association between a ARC machine and guest configuration
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GuestConfigurationHCRPAssignments_CreateOrUpdate")
  createOrUpdate is GuestConfigurationHCRPAssignmentOps.CreateOrUpdateSync<GuestConfigurationAssignment>;

  /**
   * Delete a guest configuration assignment
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  @operationId("GuestConfigurationHCRPAssignments_Delete")
  delete is GuestConfigurationHCRPAssignmentOps.DeleteSync<
    GuestConfigurationAssignment,
    Response = ArmDeletedResponse
  >;

  /**
   * List all guest configuration assignments for an ARC machine.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GuestConfigurationHCRPAssignments_List")
  list is GuestConfigurationHCRPAssignmentOps.List<
    GuestConfigurationAssignment,
    Response = ArmResponse<GuestConfigurationAssignmentList>
  >;

  /**
   * List all reports for the guest configuration assignment, latest report first.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GuestConfigurationHCRPAssignmentReports_List")
  @get
  @action("reports")
  guestConfigurationHCRPAssignmentReportsList is GuestConfigurationHCRPAssignmentOps.ActionSync<
    GuestConfigurationAssignment,
    void,
    ArmResponse<GuestConfigurationAssignmentReportList>
  >;

  /**
   * Get a report for the guest configuration assignment, by reportId.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GuestConfigurationHCRPAssignmentReports_Get")
  @get
  @action("{reportId}")
  guestConfigurationHCRPAssignmentReportsGet is GuestConfigurationHCRPAssignmentOps.ActionSync<
    GuestConfigurationAssignment,
    void,
    ArmResponse<GuestConfigurationAssignmentReport>,
    Parameters = {
      /**
       * The GUID for the guest configuration assignment report.
       */
      @path
      reportId: string;
    }
  >;
}
@armResourceOperations
interface GuestConfigurationAssignmentsVMSSOps
  extends Azure.ResourceManager.Legacy.ExtensionOperations<
      {
        ...ApiVersionParameter,
        ...SubscriptionIdParameter,
        ...ResourceGroupParameter,

        /** the provider namespace */
        @path
        @segment("providers")
        @key
        providerNamespace: "Microsoft.Compute",

        /** The name of the virtual machine scale set. */
        @path
        @segment("virtualMachineScaleSets")
        @key
        vmssName: string,
      },
      {
        ...Extension.ExtensionProviderNamespace<GuestConfigurationAssignment>,
      },
      {
        ...Extension.ExtensionProviderNamespace<GuestConfigurationAssignment>,

        /** The guest configuration assignment name. */
        @path
        @segment("guestConfigurationAssignments")
        @key
        name: string,
      }
    > {}

@armResourceOperations
interface GuestConfigurationAssignmentsVMSS {
  /**
   * Get information about a guest configuration assignment for VMSS
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GuestConfigurationAssignmentsVMSS_Get")
  get is GuestConfigurationAssignmentsVMSSOps.Read<GuestConfigurationAssignment>;

  /**
   * Creates an association between a VMSS and guest configuration
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GuestConfigurationAssignmentsVMSS_CreateOrUpdate")
  createOrUpdate is GuestConfigurationAssignmentsVMSSOps.CreateOrUpdateSync<GuestConfigurationAssignment>;

  /**
   * Delete a guest configuration assignment for VMSS
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GuestConfigurationAssignmentsVMSS_Delete")
  delete is GuestConfigurationAssignmentsVMSSOps.DeleteSync<
    GuestConfigurationAssignment,
    Response = ArmResponse<GuestConfigurationAssignment> | ArmDeletedNoContentResponse
  >;

  /**
   * List all guest configuration assignments for VMSS.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GuestConfigurationAssignmentsVMSS_List")
  list is GuestConfigurationAssignmentsVMSSOps.List<
    GuestConfigurationAssignment,
    Response = ArmResponse<GuestConfigurationAssignmentList>
  >;

  /**
   * List all reports for the VMSS guest configuration assignment, latest report first.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GuestConfigurationAssignmentReportsVMSS_List")
  @get
  @action("reports")
  guestConfigurationAssignmentReportsVMSSList is GuestConfigurationAssignmentsVMSSOps.ActionSync<
    GuestConfigurationAssignment,
    void,
    ArmResponse<GuestConfigurationAssignmentReportList>
  >;

  /**
   * Get a report for the VMSS guest configuration assignment, by reportId.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GuestConfigurationAssignmentReportsVMSS_Get")
  @get
  @action("{id}")
  guestConfigurationAssignmentReportsVMSSGet is GuestConfigurationAssignmentsVMSSOps.ActionSync<
    GuestConfigurationAssignment,
    void,
    ArmResponse<GuestConfigurationAssignmentReport>,
    Parameters = {
      /**
       * The GUID for the guest configuration assignment report.
       */
      @path
      id: string;
    }
  >;
}
@armResourceOperations
interface GuestConfigurationConnectedVMwarevSphereAssignmentOps
  extends Azure.ResourceManager.Legacy.ExtensionOperations<
      {
        ...ApiVersionParameter,
        ...SubscriptionIdParameter,
        ...ResourceGroupParameter,

        /** the provider namespace */
        @path
        @segment("providers")
        @key
        providerNamespace: "Microsoft.ConnectedVMwarevSphere",

        /** The name of the virtual machine. */
        @path
        @segment("virtualmachines")
        @key
        @pattern("^[a-zA-Z0-9][-a-zA-Z0-9_.]*[a-zA-Z0-9]$")
        vmName: string,
      },
      {
        ...Extension.ExtensionProviderNamespace<GuestConfigurationAssignment>,
      },
      {
        ...Extension.ExtensionProviderNamespace<GuestConfigurationAssignment>,

        /** The guest configuration assignment name. */
        @path
        @segment("guestConfigurationAssignments")
        @key
        @pattern("^[^<>%&:\\\\?/#]*$")
        guestConfigurationAssignmentName: string,
      }
    > {}

@armResourceOperations
interface GuestConfigurationConnectedVMwarevSphereAssignments {
  /**
   * Get information about a guest configuration assignment
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GuestConfigurationConnectedVMwarevSphereAssignments_Get")
  get is GuestConfigurationConnectedVMwarevSphereAssignmentOps.Read<GuestConfigurationAssignment>;

  /**
   * Creates an association between a Connected VM Sphere machine and guest configuration
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GuestConfigurationConnectedVMwarevSphereAssignments_CreateOrUpdate")
  createOrUpdate is GuestConfigurationConnectedVMwarevSphereAssignmentOps.CreateOrUpdateSync<GuestConfigurationAssignment>;

  /**
   * Delete a guest configuration assignment
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GuestConfigurationConnectedVMwarevSphereAssignments_Delete")
  delete is GuestConfigurationConnectedVMwarevSphereAssignmentOps.DeleteSync<GuestConfigurationAssignment>;

  /**
   * List all guest configuration assignments for an ARC machine.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GuestConfigurationConnectedVMwarevSphereAssignments_List")
  list is GuestConfigurationConnectedVMwarevSphereAssignmentOps.List<
    GuestConfigurationAssignment,
    Response = ArmResponse<GuestConfigurationAssignmentList>
  >;

  /**
   * List all reports for the guest configuration assignment, latest report first.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GuestConfigurationConnectedVMwarevSphereAssignmentsReports_List")
  @get
  @action("reports")
  guestConfigurationConnectedVMwarevSphereAssignmentsReportsList is GuestConfigurationConnectedVMwarevSphereAssignmentOps.ActionSync<
    GuestConfigurationAssignment,
    void,
    ArmResponse<GuestConfigurationAssignmentReportList>
  >;

  /**
   * Get a report for the guest configuration assignment, by reportId.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GuestConfigurationConnectedVMwarevSphereAssignmentsReports_Get")
  @get
  @action("{reportId}")
  guestConfigurationConnectedVMwarevSphereAssignmentsReportsGet is GuestConfigurationConnectedVMwarevSphereAssignmentOps.ActionSync<
    GuestConfigurationAssignment,
    void,
    ArmResponse<GuestConfigurationAssignmentReport>,
    Parameters = {
      /**
       * The GUID for the guest configuration assignment report.
       */
      @path
      reportId: string;
    }
  >;
}

@@doc(GuestConfigurationAssignment.name,
  "The guest configuration assignment name."
);
@@doc(GuestConfigurationAssignment.properties,
  "Properties of the Guest configuration assignment."
);
@@doc(GuestConfigurationAssignments.createOrUpdate::parameters.resource,
  "Parameters supplied to the create or update guest configuration assignment."
);
@@doc(GuestConfigurationHCRPAssignments.createOrUpdate::parameters.resource,
  "Parameters supplied to the create or update guest configuration assignment."
);
@@doc(GuestConfigurationAssignmentsVMSS.createOrUpdate::parameters.resource,
  "Parameters supplied to the create or update guest configuration assignment."
);
@@doc(GuestConfigurationConnectedVMwarevSphereAssignments.createOrUpdate::parameters.resource,
  "Parameters supplied to the create or update guest configuration assignment."
);
