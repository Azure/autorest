import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ModelContainerResource.tsp";


using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;


namespace Azure.ResourceManager.MachineLearning;
/**
* Azure Resource Manager resource envelope.
*/
@parentResource(ModelContainerResource)
model ModelVersionResource is Azure.ResourceManager.ProxyResource<ModelVersion, false> {
...ResourceNameParameter<Resource = ModelVersionResource,KeyName = "version",SegmentName = "versions",NamePattern = "">
}



@armResourceOperations
interface ModelVersionResourceOps extends Azure.ResourceManager.Legacy.LegacyOperations<{...ApiVersionParameter;...SubscriptionIdParameter;...ResourceGroupParameter;...Azure.ResourceManager.Legacy.Provider;/** Name of Azure Machine Learning registry. This is case-insensitive */
@path @segment("registries") @key @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{2,32}$") registryName: string;/** Container name. This is case-sensitive. */
@path @segment("models") @key @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$") modelName: string}, {/** Version identifier. This is case-sensitive. */
@path @segment("versions") @key  version: string}> {}


@armResourceOperations
interface ModelVersionResources {
/**
* Get version.
*/
get is ModelVersionResourceOps.Read<ModelVersionResource
        >;


/**
* Create or update version.
*/
createOrUpdate is ModelVersionResourceOps.CreateOrUpdateAsync<ModelVersionResource
        >;


/**
* Delete version.
*/
#suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
delete is ModelVersionResourceOps.DeleteWithoutOkAsync<ModelVersionResource, Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
        >;


/**
* List versions.
*/
list is ModelVersionResourceOps.List<ModelVersionResource, Parameters = { /**
* Continuation token for pagination.
*/
@query("$skip")
"$skip"?: string,
/**
* Ordering of list.
*/
@query("$orderBy")
"$orderBy"?: string,
/**
* Maximum number of records to return.
*/
@query("$top")
"$top"?: int32,
/**
* Model description.
*/
@query("description")
"description"?: string,
/**
* Comma-separated list of tag names (and optionally values). Example: tag1,tag2=value2
*/
@query("tags")
"tags"?: string,
/**
* Comma-separated list of property names (and optionally values). Example: prop1,prop2=value2
*/
@query("properties")
"properties"?: string,
/**
* View type for including/excluding (for example) archived entities.
*/
@query("listViewType")
"listViewType"?: ListViewType }, Response = ArmResponse<ModelVersionResourceArmPaginatedResult>
        >;


/**
* Model Version Package operation.
*/
package is ModelVersionResourceOps.ActionAsync<ModelVersionResource, PackageRequest, ArmResponse<PackageResponse>>;


/**
* Generate a storage location and credential for the client to upload a model asset to.
*/
@action("startPendingUpload")
createOrGetStartPendingUpload is ModelVersionResourceOps.ActionSync<ModelVersionResource, PendingUploadRequestDto, ArmResponse<PendingUploadResponseDto>>;


}
@armResourceOperations
interface ModelVersionOps extends Azure.ResourceManager.Legacy.LegacyOperations<{...ApiVersionParameter;...SubscriptionIdParameter;...ResourceGroupParameter;...Azure.ResourceManager.Legacy.Provider;/** Name of Azure Machine Learning workspace. */
@path @segment("workspaces") @key @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$") workspaceName: string;/** Container name. This is case-sensitive. */
@path @segment("models") @key  name: string}, {/** Version identifier. This is case-sensitive. */
@path @segment("versions") @key  version: string}> {}


@armResourceOperations
interface ModelVersions {
/**
* Get version.
*/
get is ModelVersionOps.Read<ModelVersionResource
        >;


/**
* Create or update version.
*/
createOrUpdate is ModelVersionOps.CreateOrUpdateSync<ModelVersionResource
        >;


/**
* Delete version.
*/
delete is ModelVersionOps.DeleteSync<ModelVersionResource
        >;


/**
* List model versions.
*/
list is ModelVersionOps.List<ModelVersionResource, Parameters = { /**
* Continuation token for pagination.
*/
@query("$skip")
"$skip"?: string,
/**
* Ordering of list.
*/
@query("$orderBy")
"$orderBy"?: string,
/**
* Maximum number of records to return.
*/
@query("$top")
"$top"?: int32,
/**
* Model description.
*/
@query("description")
"description"?: string,
/**
* Number of initial results to skip.
*/
@query("offset")
"offset"?: int32,
/**
* Comma-separated list of tag names (and optionally values). Example: tag1,tag2=value2
*/
@query("tags")
"tags"?: string,
/**
* Comma-separated list of property names (and optionally values). Example: prop1,prop2=value2
*/
@query("properties")
"properties"?: string,
/**
* Name of the feed.
*/
@query("feed")
"feed"?: string,
/**
* View type for including/excluding (for example) archived entities.
*/
@query("listViewType")
"listViewType"?: ListViewType,
/**
* Model stage
*/
@query("stage")
"stage"?: string }, Response = ArmResponse<ModelVersionResourceArmPaginatedResult>
        >;


/**
* Model Version Package operation.
*/
package is ModelVersionOps.ActionAsync<ModelVersionResource, PackageRequest, ArmResponse<PackageResponse>>;


}


@@doc(ModelVersionResource.name, "Version identifier. This is case-sensitive.")
@@doc(ModelVersionResource.properties, "[Required] Additional attributes of the entity.")
@@doc(ModelVersionResources.`createOrUpdate`::parameters.resource, "Version entity to create or update.");
@@doc(ModelVersionResources.`package`::parameters.body, "Package operation request body.");
@@doc(ModelVersionResources.`createOrGetStartPendingUpload`::parameters.body, "Pending upload request object");
@@doc(ModelVersions.`createOrUpdate`::parameters.resource, "Version entity to create or update.");
@@doc(ModelVersions.`package`::parameters.body, "Package operation request body.");