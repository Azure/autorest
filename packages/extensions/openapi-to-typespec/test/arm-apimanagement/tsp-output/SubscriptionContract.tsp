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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(ApiManagementServiceResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  SubscriptionContractProperties
)
model SubscriptionContract extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = SubscriptionContract,
    KeyName = "subscriptionId",
    SegmentName = "subscriptions",
    NamePattern = ""
  >;

  /**
   * Subscription contract properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: SubscriptionContractProperties;
}

@armResourceOperations
interface SubscriptionContracts {
  /**
   * Gets the specified Subscription entity.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Subscription_Get")
  get is ArmResourceRead<SubscriptionContract>;

  /**
   * Gets the entity state (Etag) version of the apimanagement subscription specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @head
  @operationId("Subscription_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      SubscriptionContract,
      BaseParameters<SubscriptionContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates or updates the subscription of specified user to the specified product.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Subscription_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    SubscriptionContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<SubscriptionContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility
  @operationId("Subscription_Update")
  update is ArmCustomPatchSync<
    SubscriptionContract,
    SubscriptionUpdateParameters,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<SubscriptionContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("Subscription_Delete")
  delete is ArmResourceDeleteSync<
    SubscriptionContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<SubscriptionContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Subscription_List")
  list is ArmResourceListByParent<
    SubscriptionContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<SubscriptionContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Subscription_RegeneratePrimaryKey")
  regeneratePrimaryKey is ArmResourceActionNoContentSync<
    SubscriptionContract,
    void
  >;

  /**
   * Regenerates secondary key of existing subscription of the API Management service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Subscription_RegenerateSecondaryKey")
  regenerateSecondaryKey is ArmResourceActionNoContentSync<
    SubscriptionContract,
    void
  >;

  /**
   * Gets the specified Subscription keys.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Subscription_ListSecrets")
  listSecrets is ArmResourceActionSync<
    SubscriptionContract,
    void,
    SubscriptionKeysContract
  >;
}

@@doc(SubscriptionContract.name,
  "Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call."
);
@@encodedName(SubscriptionContracts.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(SubscriptionContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(SubscriptionContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@encodedName(SubscriptionContracts.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(SubscriptionContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(SubscriptionContracts.update::parameters.properties,
  "Update parameters."
);
