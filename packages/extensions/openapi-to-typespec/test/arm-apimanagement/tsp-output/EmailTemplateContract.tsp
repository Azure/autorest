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
 * Email Template details.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(ApiManagementServiceResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  EmailTemplateContractProperties
)
model EmailTemplateContract extends Foundations.ProxyResource {
  /**
   * Email Template Name Identifier.
   */
  @path
  @key("templateName")
  @segment("templates")
  @visibility("read")
  name: TemplateName;

  /**
   * Email Template entity contract properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: EmailTemplateContractProperties;
}

@armResourceOperations
interface EmailTemplateContracts {
  /**
   * Gets the details of the email template specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("EmailTemplate_Get")
  get is ArmResourceRead<EmailTemplateContract>;

  /**
   * Gets the entity state (Etag) version of the email template specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @head
  @operationId("EmailTemplate_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      EmailTemplateContract,
      BaseParameters<EmailTemplateContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Updates an Email Template.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("EmailTemplate_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    EmailTemplateContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<EmailTemplateContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility
  @operationId("EmailTemplate_Update")
  update is ArmCustomPatchSync<
    EmailTemplateContract,
    EmailTemplateUpdateParameters,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<EmailTemplateContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("EmailTemplate_Delete")
  delete is ArmResourceDeleteSync<
    EmailTemplateContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<EmailTemplateContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("EmailTemplate_ListByService")
  listByService is ArmResourceListByParent<
    EmailTemplateContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<EmailTemplateContract>;

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

@@encodedName(EmailTemplateContracts.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(EmailTemplateContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(EmailTemplateContracts.createOrUpdate::parameters.resource,
  "Email Template update parameters."
);
@@encodedName(EmailTemplateContracts.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(EmailTemplateContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(EmailTemplateContracts.update::parameters.properties,
  "Update parameters."
);
