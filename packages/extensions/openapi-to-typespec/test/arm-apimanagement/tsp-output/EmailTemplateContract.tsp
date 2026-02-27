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
/** Email Template details. */
@parentResource(ApiManagementServiceResource)
model EmailTemplateContract
  is Azure.ResourceManager.ProxyResource<EmailTemplateContractProperties> {
  ...ResourceNameParameter<
    Resource = EmailTemplateContract,
    KeyName = "templateName",
    SegmentName = "templates",
    NamePattern = "",
    Type = TemplateName
  >;
}

@armResourceOperations
interface EmailTemplateContracts {
  /** Gets the details of the email template specified by its identifier. */
  get is ArmResourceRead<EmailTemplateContract>;

  /** Gets the entity state (Etag) version of the email template specified by its identifier. */
  getEntityTag is ArmResourceCheckExistence<EmailTemplateContract>;

  /** Updates an Email Template. */
  createOrUpdate is Azure.ResourceManager.Legacy.CreateOrUpdateSync<
    EmailTemplateContract,
    Request = EmailTemplateUpdateParameters,
    Parameters = {
      /** ETag of the Entity. Not required when creating an entity, but required when updating an entity. */
      @header
      `If-Match`?: string;
    }
  >;

  /** Updates API Management email template */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<
    EmailTemplateContract,
    PatchModel = EmailTemplateUpdateParameters,
    Parameters = {
      /** ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update. */
      @header
      `If-Match`: string;
    }
  >;

  /** Reset the Email Template to default template provided by the API Management service instance. */
  delete is ArmResourceDeleteSync<
    EmailTemplateContract,
    Parameters = {
      /** ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update. */
      @header
      `If-Match`: string;
    }
  >;

  /** Gets all email templates */
  listByService is ArmResourceListByParent<
    EmailTemplateContract,
    Parameters = {
      /** |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br> */
      @query("$filter")
      $filter?: string;

      /** Number of records to return. */
      @minValue(1)
      @query("$top")
      $top?: int32;

      /** Number of records to skip. */
      @query("$skip")
      $skip?: int32;
    }
  >;
}

@@doc(EmailTemplateContract.name, "Email Template Name Identifier.");
@@doc(EmailTemplateContract.properties,
  "Email Template entity contract properties."
);
@@doc(EmailTemplateContracts.createOrUpdate::parameters.resource,
  "Email Template update parameters."
);
@@doc(EmailTemplateContracts.update::parameters.properties,
  "Update parameters."
);
