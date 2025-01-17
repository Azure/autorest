import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./OperationContract.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * Tag Contract details.
 */
@parentResource(OperationContract)
model TagContract
  is Azure.ResourceManager.ProxyResource<TagContractProperties> {
  ...ResourceNameParameter<
    Resource = TagContract,
    KeyName = "tagId",
    SegmentName = "tags",
    NamePattern = "^[^*#&+:<>?]+$"
  >;
}

@armResourceOperations
interface TagContractOps
  extends Azure.ResourceManager.Legacy.LegacyOperations<
      {
        ...ApiVersionParameter,
        ...SubscriptionIdParameter,
        ...ResourceGroupParameter,
        ...Azure.ResourceManager.Legacy.Provider,
        ...KeysOf<ResourceNameParameter<
          Resource = ApiManagementServiceResource,
          KeyName = "serviceName",
          SegmentName = "service",
          NamePattern = "^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$"
        >>,
        ...KeysOf<ResourceNameParameter<
          Resource = ApiContract,
          KeyName = "apiId",
          SegmentName = "apis",
          NamePattern = "^[^*#&+:<>?]+$"
        >>,
        ...KeysOf<ResourceNameParameter<
          Resource = OperationContract,
          KeyName = "operationId",
          SegmentName = "operations",
          NamePattern = ""
        >>,
      },
      KeysOf<ResourceNameParameter<
        Resource = TagContract,
        KeyName = "tagId",
        SegmentName = "tags",
        NamePattern = "^[^*#&+:<>?]+$"
      >>
    > {}

@armResourceOperations
interface TagContracts {
  /**
   * Get tag associated with the Operation.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_GetByOperation")
  getByOperation is TagContractOps.Read<TagContract>;

  /**
   * Gets the entity state version of the tag specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_GetEntityStateByOperation")
  getEntityStateByOperation is TagContractOps.CheckExistence<TagContract>;

  // FIXME: (ArmResourceCreateOrReplace): ArmResourceCreateOrReplaceAsync/ArmResourceCreateOrReplaceSync should have a body parameter.
  /**
   * Assign tag to the Operation.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_AssignToOperation")
  assignToOperation is TagContractOps.CreateOrUpdateSync<TagContract>;

  /**
   * Detach the tag from the Operation.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_DetachFromOperation")
  detachFromOperation is TagContractOps.DeleteSync<TagContract>;

  /**
   * Lists all Tags associated with the Operation.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_ListByOperation")
  listByOperation is TagContractOps.List<
    TagContract,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
       */
      @query("$filter")
      $filter?: string;

      /**
       * Number of records to return.
       */
      @minValue(1)
      @query("$top")
      $top?: int32;

      /**
       * Number of records to skip.
       */
      @query("$skip")
      $skip?: int32;
    }
  >;
}
@armResourceOperations
interface TagOps
  extends Azure.ResourceManager.Legacy.LegacyOperations<
      {
        ...ApiVersionParameter,
        ...SubscriptionIdParameter,
        ...ResourceGroupParameter,
        ...Azure.ResourceManager.Legacy.Provider,
        ...KeysOf<ResourceNameParameter<
          Resource = ApiManagementServiceResource,
          KeyName = "serviceName",
          SegmentName = "service",
          NamePattern = "^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$"
        >>,
        ...KeysOf<ResourceNameParameter<
          Resource = ApiContract,
          KeyName = "apiId",
          SegmentName = "apis",
          NamePattern = "^[^*#&+:<>?]+$"
        >>,
      },
      KeysOf<ResourceNameParameter<
        Resource = TagContract,
        KeyName = "tagId",
        SegmentName = "tags",
        NamePattern = "^[^*#&+:<>?]+$"
      >>
    > {}

@armResourceOperations
interface Tag {
  /**
   * Get tag associated with the API.
   */
  getByApi is TagOps.Read<TagContract>;

  /**
   * Gets the entity state version of the tag specified by its identifier.
   */
  getEntityStateByApi is TagOps.CheckExistence<TagContract>;

  // FIXME: (ArmResourceCreateOrReplace): ArmResourceCreateOrReplaceAsync/ArmResourceCreateOrReplaceSync should have a body parameter.
  /**
   * Assign tag to the Api.
   */
  assignToApi is TagOps.CreateOrUpdateSync<TagContract>;

  /**
   * Detach the tag from the Api.
   */
  detachFromApi is TagOps.DeleteSync<TagContract>;

  /**
   * Lists all Tags associated with the API.
   */
  listByApi is TagOps.List<
    TagContract,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
       */
      @query("$filter")
      $filter?: string;

      /**
       * Number of records to return.
       */
      @minValue(1)
      @query("$top")
      $top?: int32;

      /**
       * Number of records to skip.
       */
      @query("$skip")
      $skip?: int32;
    }
  >;
}
@armResourceOperations
interface TagContractOperationGroupOps
  extends Azure.ResourceManager.Legacy.LegacyOperations<
      {
        ...ApiVersionParameter,
        ...SubscriptionIdParameter,
        ...ResourceGroupParameter,
        ...Azure.ResourceManager.Legacy.Provider,
        ...KeysOf<ResourceNameParameter<
          Resource = ApiManagementServiceResource,
          KeyName = "serviceName",
          SegmentName = "service",
          NamePattern = "^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$"
        >>,
        ...KeysOf<ResourceNameParameter<
          Resource = ProductContract,
          KeyName = "productId",
          SegmentName = "products",
          NamePattern = ""
        >>,
      },
      KeysOf<ResourceNameParameter<
        Resource = TagContract,
        KeyName = "tagId",
        SegmentName = "tags",
        NamePattern = "^[^*#&+:<>?]+$"
      >>
    > {}

@armResourceOperations
interface TagContractOperationGroup {
  /**
   * Get tag associated with the Product.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_GetByProduct")
  getByProduct is TagContractOperationGroupOps.Read<TagContract>;

  /**
   * Gets the entity state version of the tag specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_GetEntityStateByProduct")
  getEntityStateByProduct is TagContractOperationGroupOps.CheckExistence<TagContract>;

  // FIXME: (ArmResourceCreateOrReplace): ArmResourceCreateOrReplaceAsync/ArmResourceCreateOrReplaceSync should have a body parameter.
  /**
   * Assign tag to the Product.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_AssignToProduct")
  assignToProduct is TagContractOperationGroupOps.CreateOrUpdateSync<TagContract>;

  /**
   * Detach the tag from the Product.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_DetachFromProduct")
  detachFromProduct is TagContractOperationGroupOps.DeleteSync<TagContract>;

  /**
   * Lists all Tags associated with the Product.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_ListByProduct")
  listByProduct is TagContractOperationGroupOps.List<
    TagContract,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
       */
      @query("$filter")
      $filter?: string;

      /**
       * Number of records to return.
       */
      @minValue(1)
      @query("$top")
      $top?: int32;

      /**
       * Number of records to skip.
       */
      @query("$skip")
      $skip?: int32;
    }
  >;
}
@armResourceOperations
interface TagContractOperationGroupOps
  extends Azure.ResourceManager.Legacy.LegacyOperations<
      {
        ...ApiVersionParameter,
        ...SubscriptionIdParameter,
        ...ResourceGroupParameter,
        ...Azure.ResourceManager.Legacy.Provider,
        ...KeysOf<ResourceNameParameter<
          Resource = ApiManagementServiceResource,
          KeyName = "serviceName",
          SegmentName = "service",
          NamePattern = "^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$"
        >>,
      },
      KeysOf<ResourceNameParameter<
        Resource = TagContract,
        KeyName = "tagId",
        SegmentName = "tags",
        NamePattern = "^[^*#&+:<>?]+$"
      >>
    > {}

@armResourceOperations
interface TagContractOperationGroup {
  /**
   * Gets the details of the tag specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_Get")
  get is TagContractOperationGroupOps.Read<TagContract>;

  /**
   * Gets the entity state version of the tag specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_GetEntityState")
  getEntityState is TagContractOperationGroupOps.CheckExistence<TagContract>;

  /**
   * Creates a tag.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_CreateOrUpdate")
  createOrUpdate is TagContractOperationGroupOps.CreateOrUpdateSync<
    TagContract,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Updates the details of the tag specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @parameterVisibility
  @operationId("Tag_Update")
  update is TagContractOperationGroupOps.CustomPatchSync<
    TagContract,
    PatchModel = TagCreateUpdateParameters,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Deletes specific tag of the API Management service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_Delete")
  delete is TagContractOperationGroupOps.DeleteSync<
    TagContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists a collection of tags defined within a service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_ListByService")
  listByService is TagContractOperationGroupOps.List<
    TagContract,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
       */
      @query("$filter")
      $filter?: string;

      /**
       * Number of records to return.
       */
      @minValue(1)
      @query("$top")
      $top?: int32;

      /**
       * Number of records to skip.
       */
      @query("$skip")
      $skip?: int32;

      /**
       * Scope like 'apis', 'products' or 'apis/{apiId}
       */
      @query("scope")
      scope?: string;
    }
  >;
}

@@maxLength(TagContract.name, 80);
@@minLength(TagContract.name, 1);
@@doc(TagContract.name,
  "Tag identifier. Must be unique in the current API Management service instance."
);
@@doc(TagContract.properties, "Tag entity contract properties.");
@@doc(TagContractOperationGroup.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@doc(TagContractOperationGroup.update::parameters.properties,
  "Update parameters."
);
