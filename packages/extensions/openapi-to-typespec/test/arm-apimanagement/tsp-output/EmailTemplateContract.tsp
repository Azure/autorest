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
@doc("Email Template details.")
@parentResource(ApiManagementServiceResource)
model EmailTemplateContract is ProxyResource<EmailTemplateContractProperties> {
  @doc("Email Template Name Identifier.")
  @path
  @key("templateName")
  @segment("templates")
  name: TemplateName;
}

@armResourceOperations
interface EmailTemplateContracts {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the details of the email template specified by its identifier.")
  @operationId("EmailTemplate_Get")
  get is ArmResourceRead<EmailTemplateContract>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the entity state (Etag) version of the email template specified by its identifier.")
  @head
  @operationId("EmailTemplate_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      EmailTemplateContract,
      BaseParameters<EmailTemplateContract>
    >,
  ): OkResponse | ErrorResponse;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Updates an Email Template.")
  @operationId("EmailTemplate_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    EmailTemplateContract,
    {
      ...BaseParameters<EmailTemplateContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Updates API Management email template")
  @operationId("EmailTemplate_Update")
  update is ArmCustomPatchSync<
    EmailTemplateContract,
    EmailTemplateUpdateParameters,
    {
      ...BaseParameters<EmailTemplateContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Reset the Email Template to default template provided by the API Management service instance.")
  @operationId("EmailTemplate_Delete")
  delete is ArmResourceDeleteSync<
    EmailTemplateContract,
    {
      ...BaseParameters<EmailTemplateContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets all email templates")
  @operationId("EmailTemplate_ListByService")
  listByService is ArmResourceListByParent<
    EmailTemplateContract,
    {
      ...BaseParameters<EmailTemplateContract>;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
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
}
