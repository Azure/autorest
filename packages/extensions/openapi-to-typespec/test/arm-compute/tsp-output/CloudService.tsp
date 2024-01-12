import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
@doc("Describes the cloud service.")
model CloudService is TrackedResource<CloudServiceProperties> {
  @doc("Name of the cloud service.")
  @path
  @key("cloudServiceName")
  @segment("cloudServices")
  name: string;

  @doc("List of logical availability zone of the resource. List should contain only 1 zone where cloud service should be provisioned. This field is optional.")
  zones?: string[];
}

@armResourceOperations
interface CloudServices {
  @doc("Display information about a cloud service.")
  get is ArmResourceRead<CloudService>;

  @doc("Create or update a cloud service. Please note some properties can be set only during cloud service creation.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<CloudService>;

  @doc("Update a cloud service.")
  update is ArmCustomPatchAsync<CloudService, CloudServiceUpdate>;

  @doc("Deletes a cloud service.")
  delete is ArmResourceDeleteAsync<CloudService>;

  @doc("Gets a list of all cloud services under a resource group. Use nextLink property in the response to get the next page of Cloud Services. Do this till nextLink is null to fetch all the Cloud Services.")
  list is ArmResourceListByParent<CloudService>;

  @doc("Gets a list of all cloud services in the subscription, regardless of the associated resource group. Use nextLink property in the response to get the next page of Cloud Services. Do this till nextLink is null to fetch all the Cloud Services.")
  listAll is ArmListBySubscription<CloudService>;

  @doc("Starts the cloud service.")
  start is ArmResourceActionAsync<CloudService, void, void>;

  @doc("Power off the cloud service. Note that resources are still attached and you are getting charged for the resources.")
  powerOff is ArmResourceActionAsync<CloudService, void, void>;

  @doc("Restarts one or more role instances in a cloud service.")
  restart is ArmResourceActionAsync<CloudService, RoleInstances, void>;

  @doc("Reimage asynchronous operation reinstalls the operating system on instances of web roles or worker roles.")
  reimage is ArmResourceActionAsync<CloudService, RoleInstances, void>;

  @doc("Rebuild Role Instances reinstalls the operating system on instances of web roles or worker roles and initializes the storage resources that are used by them. If you do not want to initialize storage resources, you can use Reimage Role Instances.")
  rebuild is ArmResourceActionAsync<CloudService, RoleInstances, void>;

  @doc("Deletes role instances in a cloud service.")
  deleteInstances is ArmResourceActionAsync<CloudService, RoleInstances, void>;

  @doc("Gets the status of a cloud service.")
  // FIXME: CloudServices_GetInstanceView could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/cloudServices/{cloudServiceName}/instanceView")
  @get
  getInstanceView is Azure.Core.Foundations.Operation<
    {
      @doc("Name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("Name of the cloud service.")
      @path
      cloudServiceName: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    CloudServiceInstanceView
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("CloudServicesUpdateDomain_GetUpdateDomain")
  @doc("Gets the specified update domain of a cloud service. Use nextLink property in the response to get the next page of update domains. Do this till nextLink is null to fetch all the update domains.")
  // FIXME: CloudServicesUpdateDomain_GetUpdateDomain could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/cloudServices/{cloudServiceName}/updateDomains/{updateDomain}")
  @get
  getUpdateDomain is Azure.Core.Foundations.Operation<
    {
      @doc("Name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("Name of the cloud service.")
      @path
      cloudServiceName: string;

      @doc("Specifies an integer value that identifies the update domain. Update domains are identified with a zero-based index: the first update domain has an ID of 0, the second has an ID of 1, and so on.")
      @path
      updateDomain: int32;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    UpdateDomain
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("CloudServicesUpdateDomain_ListUpdateDomains")
  @doc("Gets a list of all update domains in a cloud service.")
  // FIXME: CloudServicesUpdateDomain_ListUpdateDomains could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/cloudServices/{cloudServiceName}/updateDomains")
  @get
  listUpdateDomains is Azure.Core.Foundations.Operation<
    {
      @doc("Name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("Name of the cloud service.")
      @path
      cloudServiceName: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    UpdateDomainListResult
  >;
}

@@projectedName(CloudServices.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(CloudServices.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(CloudServices.createOrUpdate::parameters.resource,
  "The cloud service object."
);
@@projectedName(CloudServices.update::parameters.properties,
  "json",
  "parameters"
);
@@extension(CloudServices.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(CloudServices.update::parameters.properties, "The cloud service object.");
@@projectedName(CloudServices.restart::parameters.body, "json", "parameters");
@@extension(CloudServices.restart::parameters.body,
  "x-ms-client-name",
  "parameters"
);
@@doc(CloudServices.restart::parameters.body,
  "List of cloud service role instance names."
);
@@projectedName(CloudServices.reimage::parameters.body, "json", "parameters");
@@extension(CloudServices.reimage::parameters.body,
  "x-ms-client-name",
  "parameters"
);
@@doc(CloudServices.reimage::parameters.body,
  "List of cloud service role instance names."
);
@@projectedName(CloudServices.rebuild::parameters.body, "json", "parameters");
@@extension(CloudServices.rebuild::parameters.body,
  "x-ms-client-name",
  "parameters"
);
@@doc(CloudServices.rebuild::parameters.body,
  "List of cloud service role instance names."
);
@@projectedName(CloudServices.deleteInstances::parameters.body,
  "json",
  "parameters"
);
@@extension(CloudServices.deleteInstances::parameters.body,
  "x-ms-client-name",
  "parameters"
);
@@doc(CloudServices.deleteInstances::parameters.body,
  "List of cloud service role instance names."
);
