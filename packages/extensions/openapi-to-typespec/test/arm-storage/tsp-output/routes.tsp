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

@armResourceOperations
interface SkusOperations {
  /**
   * Lists the available SKUs supported by Microsoft.Storage for given subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Skus_List")
  @get
  @action("skus")
  list is ArmProviderActionAsync<
    Response = StorageSkuListResult,
    Scope = SubscriptionActionScope,
    Parameters = {}
  >;
}

@armResourceOperations
interface StorageAccountsOperations {
  /**
   * Checks that the storage account name is valid and is not already in use.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("StorageAccounts_CheckNameAvailability")
  @post
  checkNameAvailability is ArmProviderActionAsync<
    Response = CheckNameAvailabilityResult,
    Scope = SubscriptionActionScope,
    Parameters = {},
    Request = StorageAccountCheckNameAvailabilityParameters
  >;
}

@armResourceOperations
interface DeletedAccountsOperations {
  /**
   * Lists deleted accounts under the subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("DeletedAccounts_List")
  @get
  @action("deletedAccounts")
  list is ArmProviderActionAsync<
    Response = DeletedAccountListResult,
    Scope = SubscriptionActionScope,
    Parameters = {}
  >;
}

@armResourceOperations
interface UsagesOperations {
  /**
   * Gets the current usage count and the limit for the resources of the location under the subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Usages_ListByLocation")
  @get
  @action("usages")
  listByLocation is ArmProviderActionAsync<
    Response = UsageListResult,
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter
  >;
}
