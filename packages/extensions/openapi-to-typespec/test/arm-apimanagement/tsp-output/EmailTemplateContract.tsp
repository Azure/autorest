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
 * Email Template details.
 */
@parentResource(ApiManagementServiceResource)
model EmailTemplateContract is ProxyResource<EmailTemplateContractProperties> {
  /**
   * Email Template Name Identifier.
   */
  @path
  @key("templateName")
  @segment("templates")
  @visibility("read")
  name: TemplateName;
}

@armResourceOperations
interface EmailTemplateContracts {
  /**
   * Gets the details of the email template specified by its identifier.
   */
  get is ArmResourceRead<EmailTemplateContract>;

  /**
   * Gets the entity state (Etag) version of the email template specified by its identifier.
   */
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      EmailTemplateContract,
      BaseParameters<EmailTemplateContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Updates an Email Template.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    EmailTemplateContract,
    {
      ...BaseParameters<EmailTemplateContract>;

      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Updates API Management email template
   */
  @parameterVisibility("read")
  update is ArmCustomPatchSync<
    EmailTemplateContract,
    EmailTemplateUpdateParameters,
    {
      ...BaseParameters<EmailTemplateContract>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Reset the Email Template to default template provided by the API Management service instance.
   */
  delete is ArmResourceDeleteSync<
    EmailTemplateContract,
    {
      ...BaseParameters<EmailTemplateContract>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Gets all email templates
   */
  listByService is ArmResourceListByParent<
    EmailTemplateContract,
    {
      ...BaseParameters<EmailTemplateContract>;

      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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

@@doc(EmailTemplateContracts.createOrUpdate::parameters.resource,
  "Email Template update parameters."
);
@@doc(EmailTemplateContracts.update::parameters.properties,
  "Update parameters."
);
