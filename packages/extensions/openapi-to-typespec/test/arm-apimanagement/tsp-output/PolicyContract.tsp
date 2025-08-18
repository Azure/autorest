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
 * Policy Contract details.
 */
@parentResource(OperationContract)
model PolicyContract
  is Azure.ResourceManager.ProxyResource<PolicyContractProperties> {
  ...ResourceNameParameter<
    Resource = PolicyContract,
    KeyName = "policyId",
    SegmentName = "policies",
    NamePattern = "",
    Type = PolicyIdName
  >;
}

alias PolicyContractOps = Azure.ResourceManager.Legacy.LegacyOperations<
  {
    ...ApiVersionParameter;
    ...SubscriptionIdParameter;
    ...ResourceGroupParameter;
    ...Azure.ResourceManager.Legacy.Provider;

    /** The name of the API Management service. */
    @path
    @segment("service")
    @key
    @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
    serviceName: string;

    /** API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number. */
    @path
    @segment("apis")
    @key
    @pattern("^[^*#&+:<>?]+$")
    apiId: string;

    /** Operation identifier within an API. Must be unique in the current API Management service instance. */
    @path
    @segment("operations")
    @key
    operationId: string;
  },
  {
    /** The identifier of the Policy. */
    @path
    @segment("policies")
    @key
    policyId: string;
  }
>;

@armResourceOperations
interface PolicyContracts {
  /**
   * Get the policy configuration at the API Operation level.
   */
  get is PolicyContractOps.Read<
    PolicyContract,
    Parameters = {
      /**
       * Policy Export Format.
       */
      @query("format")
      format?: PolicyExportFormat = PolicyExportFormat.xml;
    }
  >;

  /**
   * Gets the entity state (Etag) version of the API operation policy specified by its identifier.
   */
  getEntityTag is PolicyContractOps.CheckExistence<PolicyContract>;

  /**
   * Creates or updates policy configuration for the API Operation level.
   */
  createOrUpdate is PolicyContractOps.CreateOrUpdateSync<
    PolicyContract,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Deletes the policy configuration at the Api Operation.
   */
  delete is PolicyContractOps.DeleteSync<
    PolicyContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Get the list of policy configuration at the API Operation level.
   */
  listByOperation is PolicyContractOps.List<PolicyContract>;
}
alias ApiPolicyOps = Azure.ResourceManager.Legacy.LegacyOperations<
  {
    ...ApiVersionParameter;
    ...SubscriptionIdParameter;
    ...ResourceGroupParameter;
    ...Azure.ResourceManager.Legacy.Provider;

    /** The name of the API Management service. */
    @path
    @segment("service")
    @key
    @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
    serviceName: string;

    /** API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number. */
    @path
    @segment("apis")
    @key
    @pattern("^[^*#&+:<>?]+$")
    apiId: string;
  },
  {
    /** The identifier of the Policy. */
    @path
    @segment("policies")
    @key
    policyId: string;
  }
>;

@armResourceOperations
interface ApiPolicy {
  /**
   * Get the policy configuration at the API level.
   */
  get is ApiPolicyOps.Read<
    PolicyContract,
    Parameters = {
      /**
       * Policy Export Format.
       */
      @query("format")
      format?: PolicyExportFormat = PolicyExportFormat.xml;
    }
  >;

  /**
   * Gets the entity state (Etag) version of the API policy specified by its identifier.
   */
  getEntityTag is ApiPolicyOps.CheckExistence<PolicyContract>;

  /**
   * Creates or updates policy configuration for the API.
   */
  createOrUpdate is ApiPolicyOps.CreateOrUpdateSync<
    PolicyContract,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Deletes the policy configuration at the Api.
   */
  delete is ApiPolicyOps.DeleteSync<
    PolicyContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Get the policy configuration at the API level.
   */
  listByApi is ApiPolicyOps.List<PolicyContract>;
}
alias PolicyOps = Azure.ResourceManager.Legacy.LegacyOperations<
  {
    ...ApiVersionParameter;
    ...SubscriptionIdParameter;
    ...ResourceGroupParameter;
    ...Azure.ResourceManager.Legacy.Provider;

    /** The name of the API Management service. */
    @path
    @segment("service")
    @key
    @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
    serviceName: string;
  },
  {
    /** The identifier of the Policy. */
    @path
    @segment("policies")
    @key
    policyId: string;
  }
>;

@armResourceOperations
interface Policy {
  /**
   * Get the Global policy definition of the Api Management service.
   */
  get is PolicyOps.Read<
    PolicyContract,
    Parameters = {
      /**
       * Policy Export Format.
       */
      @query("format")
      format?: PolicyExportFormat = PolicyExportFormat.xml;
    }
  >;

  /**
   * Gets the entity state (Etag) version of the Global policy definition in the Api Management service.
   */
  getEntityTag is PolicyOps.CheckExistence<PolicyContract>;

  /**
   * Creates or updates the global policy configuration of the Api Management service.
   */
  createOrUpdate is PolicyOps.CreateOrUpdateSync<
    PolicyContract,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Deletes the global policy configuration of the Api Management Service.
   */
  delete is PolicyOps.DeleteSync<
    PolicyContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists all the Global Policy definitions of the Api Management service.
   */
  listByService is PolicyOps.List<PolicyContract>;
}
alias ProductPolicyOps = Azure.ResourceManager.Legacy.LegacyOperations<
  {
    ...ApiVersionParameter;
    ...SubscriptionIdParameter;
    ...ResourceGroupParameter;
    ...Azure.ResourceManager.Legacy.Provider;

    /** The name of the API Management service. */
    @path
    @segment("service")
    @key
    @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
    serviceName: string;

    /** Product identifier. Must be unique in the current API Management service instance. */
    @path
    @segment("products")
    @key
    productId: string;
  },
  {
    /** The identifier of the Policy. */
    @path
    @segment("policies")
    @key
    policyId: string;
  }
>;

@armResourceOperations
interface ProductPolicy {
  /**
   * Get the policy configuration at the Product level.
   */
  get is ProductPolicyOps.Read<
    PolicyContract,
    Parameters = {
      /**
       * Policy Export Format.
       */
      @query("format")
      format?: PolicyExportFormat = PolicyExportFormat.xml;
    }
  >;

  /**
   * Get the ETag of the policy configuration at the Product level.
   */
  getEntityTag is ProductPolicyOps.CheckExistence<PolicyContract>;

  /**
   * Creates or updates policy configuration for the Product.
   */
  createOrUpdate is ProductPolicyOps.CreateOrUpdateSync<
    PolicyContract,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Deletes the policy configuration at the Product.
   */
  delete is ProductPolicyOps.DeleteSync<
    PolicyContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Get the policy configuration at the Product level.
   */
  listByProduct is ProductPolicyOps.List<PolicyContract>;
}

@@doc(PolicyContract.name, "The identifier of the Policy.");
@@doc(PolicyContract.properties, "Properties of the Policy.");
@@doc(PolicyContracts.createOrUpdate::parameters.resource,
  "The policy contents to apply."
);
@@doc(ApiPolicy.createOrUpdate::parameters.resource,
  "The policy contents to apply."
);
@@doc(Policy.createOrUpdate::parameters.resource,
  "The policy contents to apply."
);
@@doc(ProductPolicy.createOrUpdate::parameters.resource,
  "The policy contents to apply."
);
