import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./GatewayContract.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * Gateway hostname configuration details.
 */
@parentResource(GatewayContract)
model GatewayHostnameConfigurationContract
  is ProxyResource<GatewayHostnameConfigurationContractProperties> {
  /**
   * Gateway hostname configuration identifier. Must be unique in the scope of parent Gateway entity.
   */
  @maxLength(80)
  @minLength(1)
  @path
  @key("hcId")
  @segment("hostnameConfigurations")
  name: string;
}

@armResourceOperations
interface GatewayHostnameConfigurationContracts {
  /**
   * Get details of a hostname configuration
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("GatewayHostnameConfiguration_Get")
  get is ArmResourceRead<GatewayHostnameConfigurationContract>;

  /**
   * Checks that hostname configuration entity specified by identifier exists for specified Gateway entity.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @head
  @operationId("GatewayHostnameConfiguration_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      GatewayHostnameConfigurationContract,
      BaseParameters<GatewayHostnameConfigurationContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates of updates hostname configuration for a Gateway.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("GatewayHostnameConfiguration_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    GatewayHostnameConfigurationContract,
    {
      ...BaseParameters<GatewayHostnameConfigurationContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("GatewayHostnameConfiguration_Delete")
  delete is ArmResourceDeleteSync<
    GatewayHostnameConfigurationContract,
    {
      ...BaseParameters<GatewayHostnameConfigurationContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("GatewayHostnameConfiguration_ListByService")
  listByService is ArmResourceListByParent<
    GatewayHostnameConfigurationContract,
    {
      ...BaseParameters<GatewayHostnameConfigurationContract>;

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

@@projectedName(GatewayHostnameConfigurationContracts.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(GatewayHostnameConfigurationContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(GatewayHostnameConfigurationContracts.createOrUpdate::parameters.resource,
  ""
);
