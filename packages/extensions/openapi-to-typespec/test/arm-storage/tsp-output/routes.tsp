// FIXME: Operations in this file are not detected as a resource operation, please confirm the conversion result manually

import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using TypeSpec.OpenAPI;

namespace Microsoft.Storage;

interface SkusOperations {
  /**
   * Lists the available SKUs supported by Microsoft.Storage for given subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Skus_List")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Storage/skus")
  @get
  list(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
  ): ArmResponse<StorageSkuListResult> | ErrorResponse;
}

interface StorageAccountsOperations {
  /**
   * Checks that the storage account name is valid and is not already in use.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("StorageAccounts_CheckNameAvailability")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Storage/checkNameAvailability")
  @post
  checkNameAvailability(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,

    /**
     * The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     */
    @body
    accountName: StorageAccountCheckNameAvailabilityParameters,
  ): ArmResponse<CheckNameAvailabilityResult> | ErrorResponse;
}

interface DeletedAccountsOperations {
  /**
   * Lists deleted accounts under the subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("DeletedAccounts_List")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Storage/deletedAccounts")
  @get
  list(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
  ): ArmResponse<DeletedAccountListResult> | ErrorResponse;
}

interface UsagesOperations {
  /**
   * Gets the current usage count and the limit for the resources of the location under the subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Usages_ListByLocation")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Storage/locations/{location}/usages")
  @get
  listByLocation(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...LocationResourceParameter,
  ): ArmResponse<UsageListResult> | ErrorResponse;
}
