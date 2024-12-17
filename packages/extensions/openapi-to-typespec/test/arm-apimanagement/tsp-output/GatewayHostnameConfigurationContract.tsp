import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./GatewayContract.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * Gateway hostname configuration details.
 */
@parentResource(GatewayContract)
model GatewayHostnameConfigurationContract
  is Azure.ResourceManager.ProxyResource<GatewayHostnameConfigurationContractProperties> {
  ...ResourceNameParameter<
    Resource = GatewayHostnameConfigurationContract,
    KeyName = "hcId",
    SegmentName = "hostnameConfigurations",
    NamePattern = ""
  >;
}

@armResourceOperations
interface GatewayHostnameConfigurationContracts {
  /**
   * Get details of a hostname configuration
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GatewayHostnameConfiguration_Get")
  get is ArmResourceRead<GatewayHostnameConfigurationContract>;

  /**
   * Checks that hostname configuration entity specified by identifier exists for specified Gateway entity.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GatewayHostnameConfiguration_GetEntityTag")
  getEntityTag is ArmResourceCheckExistence<GatewayHostnameConfigurationContract>;

  /**
   * Creates of updates hostname configuration for a Gateway.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GatewayHostnameConfiguration_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    GatewayHostnameConfigurationContract,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Deletes the specified hostname configuration from the specified Gateway.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GatewayHostnameConfiguration_Delete")
  delete is ArmResourceDeleteSync<
    GatewayHostnameConfigurationContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists the collection of hostname configurations for the specified gateway.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GatewayHostnameConfiguration_ListByService")
  listByService is ArmResourceListByParent<
    GatewayHostnameConfigurationContract,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| hostname | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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

@@maxLength(GatewayHostnameConfigurationContract.name, 80);
@@minLength(GatewayHostnameConfigurationContract.name, 1);
@@doc(GatewayHostnameConfigurationContract.name,
  "Gateway hostname configuration identifier. Must be unique in the scope of parent Gateway entity."
);
@@doc(GatewayHostnameConfigurationContract.properties,
  "Gateway hostname configuration details."
);
@@doc(GatewayHostnameConfigurationContracts.createOrUpdate::parameters.resource,
  ""
);
