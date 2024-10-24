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
/**
 * Describes the cloud service.
 */
model CloudService
  is Azure.ResourceManager.TrackedResource<CloudServiceProperties> {
  ...ResourceNameParameter<
    Resource = CloudService,
    KeyName = "cloudServiceName",
    SegmentName = "cloudServices",
    NamePattern = ""
  >;

  /**
   * Resource Id.
   */
  @visibility("read")
  id?: string;

  /**
   * Resource type.
   */
  @visibility("read")
  type?: string;

  /**
   * Resource location.
   */
  location: string;

  /**
   * Resource tags.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;

  /**
   * Metadata pertaining to creation and last modification of the resource.
   */
  @visibility("read")
  systemData?: SystemData;

  /**
   * List of logical availability zone of the resource. List should contain only 1 zone where cloud service should be provisioned. This field is optional.
   */
  zones?: string[];
}

@armResourceOperations
interface CloudServices {
  /**
   * Display information about a cloud service.
   */
  get is ArmResourceRead<CloudService>;

  /**
   * Create or update a cloud service. Please note some properties can be set only during cloud service creation.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<CloudService>;

  /**
   * Update a cloud service.
   */
  @parameterVisibility
  update is ArmCustomPatchAsync<CloudService, CloudServiceUpdate>;

  /**
   * Deletes a cloud service.
   */
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteAsync<CloudService>;

  /**
   * Gets a list of all cloud services under a resource group. Use nextLink property in the response to get the next page of Cloud Services. Do this till nextLink is null to fetch all the Cloud Services.
   */
  list is ArmResourceListByParent<CloudService>;

  /**
   * Gets a list of all cloud services in the subscription, regardless of the associated resource group. Use nextLink property in the response to get the next page of Cloud Services. Do this till nextLink is null to fetch all the Cloud Services.
   */
  listAll is ArmListBySubscription<CloudService>;

  /**
   * Gets the status of a cloud service.
   */
  @get
  getInstanceView is ArmResourceActionSync<
    CloudService,
    void,
    CloudServiceInstanceView
  >;

  /**
   * Starts the cloud service.
   */
  start is ArmResourceActionAsync<CloudService, void, void>;

  /**
   * Power off the cloud service. Note that resources are still attached and you are getting charged for the resources.
   */
  powerOff is ArmResourceActionAsync<CloudService, void, void>;

  /**
   * Restarts one or more role instances in a cloud service.
   */
  restart is ArmResourceActionAsync<CloudService, RoleInstances, void>;

  /**
   * Reimage asynchronous operation reinstalls the operating system on instances of web roles or worker roles.
   */
  reimage is ArmResourceActionAsync<CloudService, RoleInstances, void>;

  /**
   * Rebuild Role Instances reinstalls the operating system on instances of web roles or worker roles and initializes the storage resources that are used by them. If you do not want to initialize storage resources, you can use Reimage Role Instances.
   */
  rebuild is ArmResourceActionAsync<CloudService, RoleInstances, void>;

  /**
   * Deletes role instances in a cloud service.
   */
  deleteInstances is ArmResourceActionAsync<CloudService, RoleInstances, void>;

  /**
   * Updates the role instances in the specified update domain.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @put
  @operationId("CloudServicesUpdateDomain_WalkUpdateDomain")
  walkUpdateDomain is ArmResourceActionAsync<
    CloudService,
    UpdateDomain,
    void,
    Parameters = {
      /**
       * Specifies an integer value that identifies the update domain. Update domains are identified with a zero-based index: the first update domain has an ID of 0, the second has an ID of 1, and so on.
       */
      @path
      updateDomain: int32;
    }
  >;

  /**
   * Gets the specified update domain of a cloud service. Use nextLink property in the response to get the next page of update domains. Do this till nextLink is null to fetch all the update domains.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @operationId("CloudServicesUpdateDomain_GetUpdateDomain")
  getUpdateDomain is ArmResourceActionSync<
    CloudService,
    void,
    UpdateDomain,
    Parameters = {
      /**
       * Specifies an integer value that identifies the update domain. Update domains are identified with a zero-based index: the first update domain has an ID of 0, the second has an ID of 1, and so on.
       */
      @path
      updateDomain: int32;
    }
  >;

  /**
   * Gets a list of all update domains in a cloud service.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @operationId("CloudServicesUpdateDomain_ListUpdateDomains")
  listUpdateDomains is ArmResourceActionSync<
    CloudService,
    void,
    UpdateDomainListResult
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
