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
@doc("Subscription details.")
@parentResource(ApiManagementServiceResource)
model SubscriptionContract is ProxyResource<SubscriptionContractProperties> {
  @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
  @path
  @key("subscriptionId")
  @segment("subscriptions")
  name: string;
}

@armResourceOperations
interface SubscriptionContracts {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the specified Subscription entity.")
  @operationId("Subscription_Get")
  get is ArmResourceRead<SubscriptionContract>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the entity state (Etag) version of the apimanagement subscription specified by its identifier.")
  @head
  @operationId("Subscription_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      SubscriptionContract,
      BaseParameters<SubscriptionContract>
    >,
  ): OkResponse | ErrorResponse;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates or updates the subscription of specified user to the specified product.")
  @operationId("Subscription_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    SubscriptionContract,
    {
      ...BaseParameters<SubscriptionContract>;

      @doc("""
Notify change in Subscription State. 
 - If false, do not send any email notification for change of state of subscription 
 - If true, send email notification of change of state of subscription 
""")
      @query("notify")
      notify?: boolean;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;

      @doc("Determines the type of application which send the create user request. Default is legacy publisher portal.")
      @query("appType")
      appType?: AppType;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Updates the details of a subscription specified by its identifier.")
  @operationId("Subscription_Update")
  update is ArmCustomPatchSync<
    SubscriptionContract,
    SubscriptionUpdateParameters,
    {
      ...BaseParameters<SubscriptionContract>;

      @doc("""
Notify change in Subscription State. 
 - If false, do not send any email notification for change of state of subscription 
 - If true, send email notification of change of state of subscription 
""")
      @query("notify")
      notify?: boolean;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;

      @doc("Determines the type of application which send the create user request. Default is legacy publisher portal.")
      @query("appType")
      appType?: AppType;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deletes the specified subscription.")
  @operationId("Subscription_Delete")
  delete is ArmResourceDeleteSync<
    SubscriptionContract,
    {
      ...BaseParameters<SubscriptionContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists all subscriptions of the API Management service instance.")
  @operationId("Subscription_List")
  list is ArmResourceListByParent<
    SubscriptionContract,
    {
      ...BaseParameters<SubscriptionContract>;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| stateComment | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| ownerId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| scope | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| userId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| productId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| state | filter | eq |     |</br>| user | expand |     |     |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Regenerates primary key of existing subscription of the API Management service instance.")
  @operationId("Subscription_RegeneratePrimaryKey")
  regeneratePrimaryKey is ArmResourceActionNoContentSync<
    SubscriptionContract,
    void
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Regenerates secondary key of existing subscription of the API Management service instance.")
  @operationId("Subscription_RegenerateSecondaryKey")
  regenerateSecondaryKey is ArmResourceActionNoContentSync<
    SubscriptionContract,
    void
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the specified Subscription keys.")
  @operationId("Subscription_ListSecrets")
  listSecrets is ArmResourceActionSync<
    SubscriptionContract,
    void,
    SubscriptionKeysContract
  >;
}
