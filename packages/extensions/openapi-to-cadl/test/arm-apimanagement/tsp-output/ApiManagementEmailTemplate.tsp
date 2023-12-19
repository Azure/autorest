import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementService.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Email Template details.")
@parentResource(ApiManagementService)
model ApiManagementEmailTemplate
  is ProxyResource<EmailTemplateContractProperties> {
  @doc("Email Template Name Identifier.")
  @path
  @key("templateName")
  @segment("templates")
  name: TemplateName;
}

@armResourceOperations
interface ApiManagementEmailTemplates {
  @doc("Gets the details of the email template specified by its identifier.")
  get is ArmResourceRead<ApiManagementEmailTemplate>;
  @doc("Gets the entity state (Etag) version of the email template specified by its identifier.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      ApiManagementEmailTemplate,
      BaseParameters<ApiManagementEmailTemplate>
    >,
  ): OkResponse | ErrorResponse;
  @doc("Updates an Email Template.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ApiManagementEmailTemplate,
    {
      ...BaseParameters<ApiManagementEmailTemplate>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;
  @doc("Updates API Management email template")
  update is ArmResourcePatchSync<
    ApiManagementEmailTemplate,
    EmailTemplateContractProperties,
    {
      ...BaseParameters<ApiManagementEmailTemplate>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Reset the Email Template to default template provided by the API Management service instance.")
  delete is ArmResourceDeleteSync<
    ApiManagementEmailTemplate,
    {
      ...BaseParameters<ApiManagementEmailTemplate>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Gets all email templates")
  listByService is ArmResourceListByParent<
    ApiManagementEmailTemplate,
    {
      ...BaseParameters<ApiManagementEmailTemplate>;

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
