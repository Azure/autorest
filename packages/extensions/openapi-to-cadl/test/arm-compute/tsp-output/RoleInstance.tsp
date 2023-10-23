import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./CloudService.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Compute;
@doc("Describes the cloud service role instance.")
@parentResource(CloudService)
model RoleInstance is ProxyResource<RoleInstanceProperties> {
  @doc("Name of the role instance.")
  @path
  @key("roleInstanceName")
  @segment("roleInstances")
  name: string;
}

@armResourceOperations
interface RoleInstances {
  @doc("Gets a role instance from a cloud service.")
  get is ArmResourceRead<RoleInstance>;
  @doc("Deletes a role instance from a cloud service.")
  delete is ArmResourceDeleteAsync<RoleInstance>;
  @doc("""
Gets the list of all role instances in a cloud service. Use nextLink property
in the response to get the next page of role instances. Do this till nextLink
is null to fetch all the role instances.
""")
  list is ArmResourceListByParent<
    RoleInstance,
    {
      @doc("""
The expand expression to apply to the operation. 'UserData' is not supported
for cloud services.
""")
      @query("$expand")
      $expand?: InstanceViewTypes;
    }
  >;
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("""
The Reboot Role Instance asynchronous operation requests a reboot of a role
instance in the cloud service.
""")
  restart is ArmResourceActionAsync<RoleInstance, {}, {}>;
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("""
The Reimage Role Instance asynchronous operation reinstalls the operating
system on instances of web roles or worker roles.
""")
  reimage is ArmResourceActionAsync<RoleInstance, {}, {}>;
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("""
The Rebuild Role Instance asynchronous operation reinstalls the operating
system on instances of web roles or worker roles and initializes the storage
resources that are used by them. If you do not want to initialize storage
resources, you can use Reimage Role Instance.
""")
  rebuild is ArmResourceActionAsync<RoleInstance, {}, {}>;
  @doc("""
Retrieves information about the run-time state of a role instance in a cloud
service.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/cloudServices/{cloudServiceName}/roleInstances/{roleInstanceName}/instanceView")
  @get
  GetInstanceView is Azure.Core.Foundations.Operation<
    {
      @doc("Name of the role instance.")
      @path
      roleInstanceName: string;

      @doc("Name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("Name of the cloud service.")
      @path
      cloudServiceName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    RoleInstanceInstanceView
  >;

  @doc("Gets a remote desktop file for a role instance in a cloud service.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/cloudServices/{cloudServiceName}/roleInstances/{roleInstanceName}/remoteDesktopFile")
  @get
  GetRemoteDesktopFile is Azure.Core.Foundations.Operation<
    {
      @doc("Name of the role instance.")
      @path
      roleInstanceName: string;

      @doc("Name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("Name of the cloud service.")
      @path
      cloudServiceName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Accept header")
      @header
      accept: "application/x-rdp";
    },
    void
  >;
}
