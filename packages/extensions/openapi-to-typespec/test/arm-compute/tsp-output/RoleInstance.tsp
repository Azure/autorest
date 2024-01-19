import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./CloudService.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Describes the cloud service role instance.
 */
@parentResource(CloudService)
model RoleInstance is ProxyResource<RoleInstanceProperties> {
  /**
   * Name of the role instance.
   */
  @path
  @key("roleInstanceName")
  @segment("roleInstances")
  name: string;

  ...Azure.ResourceManager.ResourceSku;
}

@armResourceOperations
interface RoleInstances {
  /**
   * Gets a role instance from a cloud service.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("CloudServiceRoleInstances_Get")
  get is ArmResourceRead<
    RoleInstance,
    {
      ...BaseParameters<RoleInstance>;

      /**
       * The expand expression to apply to the operation. 'UserData' is not supported for cloud services.
       */
      @query("$expand")
      $expand?: InstanceViewTypes;
    }
  >;

  /**
   * Deletes a role instance from a cloud service.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("CloudServiceRoleInstances_Delete")
  delete is ArmResourceDeleteAsync<RoleInstance>;

  /**
   * Gets the list of all role instances in a cloud service. Use nextLink property in the response to get the next page of role instances. Do this till nextLink is null to fetch all the role instances.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("CloudServiceRoleInstances_List")
  list is ArmResourceListByParent<
    RoleInstance,
    {
      ...BaseParameters<RoleInstance>;

      /**
       * The expand expression to apply to the operation. 'UserData' is not supported for cloud services.
       */
      @query("$expand")
      $expand?: InstanceViewTypes;
    }
  >;

  /**
   * The Reboot Role Instance asynchronous operation requests a reboot of a role instance in the cloud service.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("CloudServiceRoleInstances_Restart")
  restart is ArmResourceActionAsync<RoleInstance, void, void>;

  /**
   * The Reimage Role Instance asynchronous operation reinstalls the operating system on instances of web roles or worker roles.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("CloudServiceRoleInstances_Reimage")
  reimage is ArmResourceActionAsync<RoleInstance, void, void>;

  /**
   * The Rebuild Role Instance asynchronous operation reinstalls the operating system on instances of web roles or worker roles and initializes the storage resources that are used by them. If you do not want to initialize storage resources, you can use Reimage Role Instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("CloudServiceRoleInstances_Rebuild")
  rebuild is ArmResourceActionAsync<RoleInstance, void, void>;

  /**
   * Retrieves information about the run-time state of a role instance in a cloud service.
   */
  // FIXME: CloudServiceRoleInstances_GetInstanceView could not be converted to a resource operation
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("CloudServiceRoleInstances_GetInstanceView")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/cloudServices/{cloudServiceName}/roleInstances/{roleInstanceName}/instanceView")
  @get
  getInstanceView is Azure.Core.Foundations.Operation<
    {
      /**
       * Name of the role instance.
       */
      @path
      roleInstanceName: string;

      /**
       * Name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * Name of the cloud service.
       */
      @path
      cloudServiceName: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    RoleInstanceInstanceView
  >;

  /**
   * Gets a remote desktop file for a role instance in a cloud service.
   */
  // FIXME: CloudServiceRoleInstances_GetRemoteDesktopFile could not be converted to a resource operation
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("CloudServiceRoleInstances_GetRemoteDesktopFile")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/cloudServices/{cloudServiceName}/roleInstances/{roleInstanceName}/remoteDesktopFile")
  @get
  getRemoteDesktopFile is Azure.Core.Foundations.Operation<
    {
      /**
       * Name of the role instance.
       */
      @path
      roleInstanceName: string;

      /**
       * Name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * Name of the cloud service.
       */
      @path
      cloudServiceName: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;

      /**
       * Accept header
       */
      @header
      accept: "application/x-rdp";
    },
    void
  >;
}
