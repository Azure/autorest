import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Compute;
@doc("Describes the cloud service.")
model CloudService is TrackedResource<CloudServiceProperties> {
  @doc("Name of the cloud service.")
  @path
  @key("cloudServiceName")
  @segment("cloudServices")
  name: string;
}

@armResourceOperations
interface CloudServices {
  @doc("Display information about a cloud service.")
  get is ArmResourceRead<CloudService>;
  @doc("""
Create or update a cloud service. Please note some properties can be set only
during cloud service creation.
""")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<CloudService>;
  @doc("Update a cloud service.")
  update is ArmTagsPatchAsync<CloudService>;
  @doc("Deletes a cloud service.")
  delete is ArmResourceDeleteAsync<CloudService>;
  @doc("""
Gets a list of all cloud services under a resource group. Use nextLink property
in the response to get the next page of Cloud Services. Do this till nextLink
is null to fetch all the Cloud Services.
""")
  list is ArmResourceListByParent<CloudService>;
  @doc("""
Gets a list of all cloud services in the subscription, regardless of the
associated resource group. Use nextLink property in the response to get the
next page of Cloud Services. Do this till nextLink is null to fetch all the
Cloud Services.
""")
  listAll is ArmListBySubscription<CloudService>;
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("Starts the cloud service.")
  start is ArmResourceActionAsync<CloudService, {}, {}>;
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("""
Power off the cloud service. Note that resources are still attached and you are
getting charged for the resources.
""")
  powerOff is ArmResourceActionAsync<CloudService, {}, {}>;
  @doc("Restarts one or more role instances in a cloud service.")
  restart is ArmResourceActionAsync<CloudService, RoleInstances, {}>;
  @doc("""
Reimage asynchronous operation reinstalls the operating system on instances of
web roles or worker roles.
""")
  reimage is ArmResourceActionAsync<CloudService, RoleInstances, {}>;
  @doc("""
Rebuild Role Instances reinstalls the operating system on instances of web
roles or worker roles and initializes the storage resources that are used by
them. If you do not want to initialize storage resources, you can use Reimage
Role Instances.
""")
  rebuild is ArmResourceActionAsync<CloudService, RoleInstances, {}>;
  @doc("Deletes role instances in a cloud service.")
  deleteInstances is ArmResourceActionAsync<CloudService, RoleInstances, {}>;
}
