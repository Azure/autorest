import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementServiceResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * Subscription details.
 */
@parentResource(ApiManagementServiceResource)
model SubscriptionContract
  is Azure.ResourceManager.ProxyResource<SubscriptionContractProperties> {
  ...ResourceNameParameter<
    Resource = SubscriptionContract,
    KeyName = "sid",
    SegmentName = "subscriptions",
    NamePattern = "^[^*#&+:<>?]+$"
  >;
}

@armResourceOperations
interface SubscriptionContractOps
  extends Azure.ResourceManager.Legacy.LegacyOperations<
      {
        ...ApiVersionParameter,
        ...SubscriptionIdParameter,
        ...ResourceGroupParameter,
        ...Azure.ResourceManager.Legacy.Provider,

        /** The name of the API Management service. */
        @path
        @segment("service")
        @key
        @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
        serviceName: string,
      },
      {
        /** Subscription entity Identifier. The entity represents the association between a user and a product in API Management. */
        @path
        @segment("subscriptions")
        @key
        @pattern("^[^*#&+:<>?]+$")
        sid: string,
      }
    > {}

@armResourceOperations
interface SubscriptionContracts {
  /**
   * Gets the specified Subscription entity.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Subscription_Get")
  get is SubscriptionContractOps.Read<SubscriptionContract>;

  /**
   * Gets the entity state (Etag) version of the apimanagement subscription specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Subscription_GetEntityTag")
  getEntityTag is SubscriptionContractOps.CheckExistence<SubscriptionContract>;

  /**
   * Creates or updates the subscription of specified user to the specified product.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Subscription_CreateOrUpdate")
  createOrUpdate is SubscriptionContractOps.CreateOrUpdateSync<
    SubscriptionContract,
    Parameters = {
      /**
       * Notify change in Subscription State.
       *  - If false, do not send any email notification for change of state of subscription
       *  - If true, send email notification of change of state of subscription
       */
      @query("notify")
      notify?: boolean;

      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;

      /**
       * Determines the type of application which send the create user request. Default is legacy publisher portal.
       */
      @query("appType")
      appType?: AppType;
    }
  >;

  /**
   * Updates the details of a subscription specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Subscription_Update")
  @patch(#{ implicitOptionality: false })
  update is SubscriptionContractOps.CustomPatchSync<
    SubscriptionContract,
    PatchModel = SubscriptionUpdateParameters,
    Parameters = {
      /**
       * Notify change in Subscription State.
       *  - If false, do not send any email notification for change of state of subscription
       *  - If true, send email notification of change of state of subscription
       */
      @query("notify")
      notify?: boolean;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;

      /**
       * Determines the type of application which send the create user request. Default is legacy publisher portal.
       */
      @query("appType")
      appType?: AppType;
    }
  >;

  /**
   * Deletes the specified subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Subscription_Delete")
  delete is SubscriptionContractOps.DeleteSync<
    SubscriptionContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists all subscriptions of the API Management service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Subscription_List")
  list is SubscriptionContractOps.List<
    SubscriptionContract,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| stateComment | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| ownerId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| scope | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| userId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| productId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| state | filter | eq |     |</br>| user | expand |     |     |</br>
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

  /**
   * Regenerates primary key of existing subscription of the API Management service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Subscription_RegeneratePrimaryKey")
  regeneratePrimaryKey is SubscriptionContractOps.ActionSync<
    SubscriptionContract,
    void,
    NoContentResponse
  >;

  /**
   * Regenerates secondary key of existing subscription of the API Management service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Subscription_RegenerateSecondaryKey")
  regenerateSecondaryKey is SubscriptionContractOps.ActionSync<
    SubscriptionContract,
    void,
    NoContentResponse
  >;

  /**
   * Gets the specified Subscription keys.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Subscription_ListSecrets")
  listSecrets is SubscriptionContractOps.ActionSync<
    SubscriptionContract,
    void,
    ArmResponse<SubscriptionKeysContract>
  >;
}
@armResourceOperations
interface UserSubscriptionOps
  extends Azure.ResourceManager.Legacy.LegacyOperations<
      {
        ...ApiVersionParameter,
        ...SubscriptionIdParameter,
        ...ResourceGroupParameter,
        ...Azure.ResourceManager.Legacy.Provider,

        /** The name of the API Management service. */
        @path
        @segment("service")
        @key
        @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
        serviceName: string,

        /** User identifier. Must be unique in the current API Management service instance. */
        @path
        @segment("users")
        @key
        userId: string,
      },
      {
        /** Subscription entity Identifier. The entity represents the association between a user and a product in API Management. */
        @path
        @segment("subscriptions")
        @key
        @pattern("^[^*#&+:<>?]+$")
        sid: string,
      }
    > {}

@armResourceOperations
interface UserSubscription {
  /**
   * Gets the specified Subscription entity associated with a particular user.
   */
  get is UserSubscriptionOps.Read<SubscriptionContract>;

  /**
   * Lists the collection of subscriptions of the specified user.
   */
  list is UserSubscriptionOps.List<
    SubscriptionContract,
    Parameters = {
      /**
       * | Field     |     Usage     |     Supported operators    | Supported functions               |</br>|-------------|------------------------|-----------------------------------|</br>|name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>|displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>|stateComment | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>|ownerId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>|scope | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>|userId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>|productId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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

@@maxLength(SubscriptionContract.name, 256);
@@doc(SubscriptionContract.name,
  "Subscription entity Identifier. The entity represents the association between a user and a product in API Management."
);
@@doc(SubscriptionContract.properties, "Subscription contract properties.");
@@doc(SubscriptionContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@doc(SubscriptionContracts.update::parameters.properties,
  "Update parameters."
);
