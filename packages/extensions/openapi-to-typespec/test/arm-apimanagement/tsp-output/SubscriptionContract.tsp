import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementServiceResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * Subscription details.
 */
@parentResource(ApiManagementServiceResource)
model SubscriptionContract is ProxyResource<SubscriptionContractProperties> {
  /**
   * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
   */
  @path
  @key("subscriptionId")
  @segment("subscriptions")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface SubscriptionContracts {
  /**
   * Gets the specified Subscription entity.
   */
  get is ArmResourceRead<SubscriptionContract>;

  /**
   * Gets the entity state (Etag) version of the apimanagement subscription specified by its identifier.
   */
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      SubscriptionContract,
      BaseParameters<SubscriptionContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates or updates the subscription of specified user to the specified product.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    SubscriptionContract,
    {
      ...BaseParameters<SubscriptionContract>;

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
  @parameterVisibility("read")
  update is ArmCustomPatchSync<
    SubscriptionContract,
    SubscriptionUpdateParameters,
    {
      ...BaseParameters<SubscriptionContract>;

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
  delete is ArmResourceDeleteSync<
    SubscriptionContract,
    {
      ...BaseParameters<SubscriptionContract>;

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
  list is ArmResourceListByParent<
    SubscriptionContract,
    {
      ...BaseParameters<SubscriptionContract>;

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
  regeneratePrimaryKey is ArmResourceActionNoContentSync<
    SubscriptionContract,
    void
  >;

  /**
   * Regenerates secondary key of existing subscription of the API Management service instance.
   */
  regenerateSecondaryKey is ArmResourceActionNoContentSync<
    SubscriptionContract,
    void
  >;

  /**
   * Gets the specified Subscription keys.
   */
  listSecrets is ArmResourceActionSync<
    SubscriptionContract,
    void,
    SubscriptionKeysContract
  >;
}

@@doc(SubscriptionContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@doc(SubscriptionContracts.update::parameters.properties,
  "Update parameters."
);
