import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/** Describes the cloud service. */
model CloudService
  is Azure.ResourceManager.TrackedResource<CloudServiceProperties> {
  ...ResourceNameParameter<
    Resource = CloudService,
    KeyName = "cloudServiceName",
    SegmentName = "cloudServices",
    NamePattern = ""
  >;
  ...Azure.ResourceManager.AvailabilityZonesProperty;
}

@armResourceOperations
interface CloudServices {
  /** Display information about a cloud service. */
  get is ArmResourceRead<CloudService>;

  /** Create or update a cloud service. Please note some properties can be set only during cloud service creation. */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    CloudService,
    LroHeaders = ArmLroLocationHeader<FinalResult = CloudService> &
      Azure.Core.Foundations.RetryAfterHeader
  >;

  /** Update a cloud service. */
  @patch(#{ implicitOptionality: false })
  update is Azure.ResourceManager.Legacy.CustomPatchAsync<
    CloudService,
    PatchModel = CloudServiceUpdate,
    Response = ArmResponse<CloudService>,
    OptionalRequestBody = true
  >;

  /** Deletes a cloud service. */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is ArmResourceDeleteWithoutOkAsync<
    CloudService,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /** Gets a list of all cloud services under a resource group. Use nextLink property in the response to get the next page of Cloud Services. Do this till nextLink is null to fetch all the Cloud Services. */
  list is ArmResourceListByParent<CloudService>;

  /** Gets a list of all cloud services in the subscription, regardless of the associated resource group. Use nextLink property in the response to get the next page of Cloud Services. Do this till nextLink is null to fetch all the Cloud Services. */
  listAll is ArmListBySubscription<CloudService>;

  /** Gets the status of a cloud service. */
  @get
  @action("instanceView")
  getInstanceView is ArmResourceActionSync<
    CloudService,
    void,
    ArmResponse<CloudServiceInstanceView>
  >;

  /** Starts the cloud service. */
  start is ArmResourceActionAsync<CloudService, void, OkResponse>;

  /** Power off the cloud service. Note that resources are still attached and you are getting charged for the resources. */
  @action("poweroff")
  powerOff is ArmResourceActionAsync<CloudService, void, OkResponse>;

  /** Restarts one or more role instances in a cloud service. */
  restart is ArmResourceActionAsync<
    CloudService,
    RoleInstances,
    OkResponse,
    OptionalRequestBody = true
  >;

  /** Reimage asynchronous operation reinstalls the operating system on instances of web roles or worker roles. */
  reimage is ArmResourceActionAsync<
    CloudService,
    RoleInstances,
    OkResponse,
    OptionalRequestBody = true
  >;

  /** Rebuild Role Instances reinstalls the operating system on instances of web roles or worker roles and initializes the storage resources that are used by them. If you do not want to initialize storage resources, you can use Reimage Role Instances. */
  rebuild is ArmResourceActionAsync<
    CloudService,
    RoleInstances,
    OkResponse,
    OptionalRequestBody = true
  >;

  /** Deletes role instances in a cloud service. */
  @action("delete")
  deleteInstances is ArmResourceActionAsync<
    CloudService,
    RoleInstances,
    OkResponse,
    OptionalRequestBody = true
  >;

  /** Updates the role instances in the specified update domain. */
  @put
  @action("{updateDomain}")
  walkUpdateDomain is ArmResourceActionAsync<
    CloudService,
    UpdateDomain,
    OkResponse,
    Parameters = {
      /** Specifies an integer value that identifies the update domain. Update domains are identified with a zero-based index: the first update domain has an ID of 0, the second has an ID of 1, and so on. */
      @path
      updateDomain: int32;
    },
    OptionalRequestBody = true
  >;

  /** Gets the specified update domain of a cloud service. Use nextLink property in the response to get the next page of update domains. Do this till nextLink is null to fetch all the update domains. */
  @get
  @action("{updateDomain}")
  getUpdateDomain is ArmResourceActionSync<
    CloudService,
    void,
    ArmResponse<UpdateDomain>,
    Parameters = {
      /** Specifies an integer value that identifies the update domain. Update domains are identified with a zero-based index: the first update domain has an ID of 0, the second has an ID of 1, and so on. */
      @path
      updateDomain: int32;
    }
  >;

  /** Gets a list of all update domains in a cloud service. */
  @list
  @get
  @action("updateDomains")
  listUpdateDomains is ArmResourceActionSync<
    CloudService,
    void,
    ArmResponse<UpdateDomainListResult>
  >;
}

@@doc(CloudService.name, "Name of the cloud service.");
@@doc(CloudService.properties, "Cloud service properties");
@@doc(CloudServices.createOrUpdate::parameters.resource,
  "The cloud service object."
);
@@doc(CloudServices.update::parameters.properties, "The cloud service object.");
@@doc(CloudServices.restart::parameters.body,
  "List of cloud service role instance names."
);
@@doc(CloudServices.reimage::parameters.body,
  "List of cloud service role instance names."
);
@@doc(CloudServices.rebuild::parameters.body,
  "List of cloud service role instance names."
);
@@doc(CloudServices.deleteInstances::parameters.body,
  "List of cloud service role instance names."
);
@@doc(CloudServices.walkUpdateDomain::parameters.body,
  "The update domain object."
);
