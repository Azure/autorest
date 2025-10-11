import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./CloudService.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/** Describes the cloud service role instance. */
@parentResource(CloudService)
model RoleInstance
  is Azure.ResourceManager.Legacy.TrackedResourceWithOptionalLocation<RoleInstanceProperties> {
  ...ResourceNameParameter<
    Resource = RoleInstance,
    KeyName = "roleInstanceName",
    SegmentName = "roleInstances",
    NamePattern = ""
  >;

  /** The role instance SKU. */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  sku?: InstanceSku;
}

@armResourceOperations
interface CloudServiceRoleInstances {
  /** Gets a role instance from a cloud service. */
  get is ArmResourceRead<
    RoleInstance,
    Parameters = {
      /** The expand expression to apply to the operation. 'UserData' is not supported for cloud services. */
      @query("$expand")
      $expand?: InstanceViewTypes;
    }
  >;

  /** Deletes a role instance from a cloud service. */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is ArmResourceDeleteWithoutOkAsync<
    RoleInstance,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /** Gets the list of all role instances in a cloud service. Use nextLink property in the response to get the next page of role instances. Do this till nextLink is null to fetch all the role instances. */
  list is ArmResourceListByParent<
    RoleInstance,
    Parameters = {
      /** The expand expression to apply to the operation. 'UserData' is not supported for cloud services. */
      @query("$expand")
      $expand?: InstanceViewTypes;
    }
  >;

  /** Retrieves information about the run-time state of a role instance in a cloud service. */
  @get
  @action("instanceView")
  getInstanceView is ArmResourceActionSync<
    RoleInstance,
    void,
    ArmResponse<RoleInstanceInstanceView>
  >;

  /** The Reboot Role Instance asynchronous operation requests a reboot of a role instance in the cloud service. */
  restart is ArmResourceActionAsync<RoleInstance, void, OkResponse>;

  /** The Reimage Role Instance asynchronous operation reinstalls the operating system on instances of web roles or worker roles. */
  reimage is ArmResourceActionAsync<RoleInstance, void, OkResponse>;

  /** The Rebuild Role Instance asynchronous operation reinstalls the operating system on instances of web roles or worker roles and initializes the storage resources that are used by them. If you do not want to initialize storage resources, you can use Reimage Role Instance. */
  rebuild is ArmResourceActionAsync<RoleInstance, void, OkResponse>;

  /** Gets a remote desktop file for a role instance in a cloud service. */
  @get
  @action("remoteDesktopFile")
  getRemoteDesktopFile is ArmResourceActionSync<RoleInstance, void, OkResponse>;
}

@@doc(RoleInstance.name, "Name of the role instance.");
@@doc(RoleInstance.properties, "Role instance properties.");
