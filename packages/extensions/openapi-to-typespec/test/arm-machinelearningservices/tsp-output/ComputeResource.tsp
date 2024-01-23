import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";


using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;


namespace Azure.ResourceManager.MachineLearning;
// FIXME: ComputeResource has no properties property
/**
* Machine Learning compute object wrapped into ARM resource envelope.
*/
@parentResource(Workspace)
model ComputeResource is TrackedResource<{}> {
/**
* Name of the Azure Machine Learning compute.
*/
@path
@key("computeName")
@segment("computes")
"name": string;

...Azure.ResourceManager.ManagedServiceIdentity

...Azure.ResourceManager.ResourceSku
}



@armResourceOperations
interface ComputeResources {
/**
* Gets compute definition by its name. Any secrets (storage keys, service credentials, etc) are not returned - use 'keys' nested resource to get them.
*/
@operationId("Compute_Get")
#suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
get is ArmResourceRead<ComputeResource>

/**
* Creates or updates compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation. If your intent is to create a new compute, do a GET first to verify that it does not exist yet.
*/
@operationId("Compute_CreateOrUpdate")
#suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
createOrUpdate is ArmResourceCreateOrReplaceAsync<ComputeResource>

/**
* Updates properties of a compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation.
*/
@parameterVisibility("read")
@operationId("Compute_Update")
#suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
update is ArmCustomPatchAsync<ComputeResource,ClusterUpdateParameters>

/**
* Deletes specified Machine Learning compute.
*/
@operationId("Compute_Delete")
#suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
delete is ArmResourceDeleteAsync<ComputeResource,{
    ...BaseParameters<ComputeResource>;
    /**
* Delete the underlying compute if 'Delete', or detach the underlying compute from workspace if 'Detach'.
*/
@query("underlyingResourceAction")
"underlyingResourceAction": UnderlyingResourceAction
    }>

/**
* Gets computes in specified workspace.
*/
@operationId("Compute_List")
#suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
list is ArmResourceListByParent<ComputeResource,{
    ...BaseParameters<ComputeResource>;
    /**
* Continuation token for pagination.
*/
@query("$skip")
"$skip"?: string
    }>

/**
* Updates the custom services list. The list of custom services provided shall be overwritten
*/
@operationId("Compute_UpdateCustomServices")
#suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
updateCustomServices is ArmResourceActionSync<ComputeResource,paths·7cv641·subscriptions-subscriptionid-resourcegroups-resourcegroupname-providers-microsoft-machinelearningservices-workspaces-workspacename-computes-computename-customservices·post·requestbody·content·application-json·schema,void>

/**
* Get the details (e.g IP address, port etc) of all the compute nodes in the compute.
*/
@operationId("Compute_ListNodes")
#suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
listNodes is ArmResourceActionSync<ComputeResource,void,AmlComputeNodesInformation>

/**
* Gets secrets related to Machine Learning compute (storage keys, service credentials, etc).
*/
@operationId("Compute_ListKeys")
#suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
listKeys is ArmResourceActionSync<ComputeResource,void,ComputeSecrets>

/**
* Posts a start action to a compute instance
*/
@operationId("Compute_Start")
#suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
start is ArmResourceActionNoResponseContentAsync<ComputeResource,void>

/**
* Posts a stop action to a compute instance
*/
@operationId("Compute_Stop")
#suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
stop is ArmResourceActionNoResponseContentAsync<ComputeResource,void>

/**
* Posts a restart action to a compute instance
*/
@operationId("Compute_Restart")
#suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
restart is ArmResourceActionNoResponseContentAsync<ComputeResource,void>

/**
* Updates the idle shutdown setting of a compute instance.
*/
@operationId("Compute_UpdateIdleShutdownSetting")
#suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
updateIdleShutdownSetting is ArmResourceActionSync<ComputeResource,IdleShutdownSetting,void>

}



@@projectedName(ComputeResources.`createOrUpdate`::parameters.resource, "json", "parameters");
@@extension(ComputeResources.`createOrUpdate`::parameters.resource, "x-ms-client-name", "parameters");
@@doc(ComputeResources.`createOrUpdate`::parameters.resource, "Payload with Machine Learning compute definition.");
@@projectedName(ComputeResources.`update`::parameters.properties, "json", "parameters");
@@extension(ComputeResources.`update`::parameters.properties, "x-ms-client-name", "parameters");
@@doc(ComputeResources.`update`::parameters.properties, "Additional parameters for cluster update.");
@@projectedName(ComputeResources.`updateCustomServices`::parameters.body, "json", "customServices");
@@extension(ComputeResources.`updateCustomServices`::parameters.body, "x-ms-client-name", "customServices");
@@doc(ComputeResources.`updateCustomServices`::parameters.body, "New list of Custom Services.");
@@projectedName(ComputeResources.`updateIdleShutdownSetting`::parameters.body, "json", "parameters");
@@extension(ComputeResources.`updateIdleShutdownSetting`::parameters.body, "x-ms-client-name", "parameters");
@@doc(ComputeResources.`updateIdleShutdownSetting`::parameters.body, "The object for updating idle shutdown setting of specified ComputeInstance.");