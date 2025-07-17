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
 * Notification details.
 */
@parentResource(ApiManagementServiceResource)
model NotificationContract
  is Azure.ResourceManager.ProxyResource<NotificationContractProperties> {
  ...ResourceNameParameter<
    Resource = NotificationContract,
    KeyName = "notificationName",
    SegmentName = "notifications",
    NamePattern = "",
    Type = NotificationName
  >;
}

@armResourceOperations
interface NotificationContracts {
  /**
   * Gets the details of the Notification specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Notification_Get")
  get is ArmResourceRead<NotificationContract>;

  // FIXME: (ArmResourceCreateOrReplace): ArmResourceCreateOrReplaceAsync/ArmResourceCreateOrReplaceSync should have a body parameter.
  /**
   * Create or Update API Management publisher notification.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  @operationId("Notification_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    NotificationContract,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    },
    Response = ArmResourceUpdatedResponse<NotificationContract>
  >;

  /**
   * Lists a collection of properties defined within a service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Notification_ListByService")
  listByService is ArmResourceListByParent<
    NotificationContract,
    Parameters = {
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

  /**
   * Gets the list of the Notification Recipient User subscribed to the notification.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("NotificationRecipientUser_ListByNotification")
  @get
  @action("recipientUsers")
  listByNotification is ArmResourceActionSync<
    NotificationContract,
    void,
    ArmResponse<ResourceListResult<RecipientUserContract>>
  >;

  /**
   * Determine if the Notification Recipient User is subscribed to the notification.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("NotificationRecipientUser_CheckEntityExists")
  @head
  @action("{userId}")
  checkEntityExists is ArmResourceActionSync<
    NotificationContract,
    void,
    NoContentResponse,
    Parameters = {
      /**
       * User identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @path
      userId: string;
    }
  >;

  /**
   * Adds the API Management User to the list of Recipients for the Notification.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("NotificationRecipientUser_CreateOrUpdate")
  @put
  @action("{userId}")
  notificationRecipientUserCreateOrUpdate is ArmResourceActionSync<
    NotificationContract,
    void,
    ArmResponse<RecipientUserContract> | ArmResourceCreatedSyncResponse<RecipientUserContract>,
    Parameters = {
      /**
       * User identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @path
      userId: string;
    }
  >;

  /**
   * Removes the API Management user from the list of Notification.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("NotificationRecipientUser_Delete")
  @delete
  @action("{userId}")
  delete is ArmResourceActionSync<
    NotificationContract,
    void,
    OkResponse | NoContentResponse,
    Parameters = {
      /**
       * User identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @path
      userId: string;
    }
  >;

  /**
   * Gets the list of the Notification Recipient Emails subscribed to a notification.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("NotificationRecipientEmail_ListByNotification")
  @get
  @action("recipientEmails")
  notificationRecipientEmailListByNotification is ArmResourceActionSync<
    NotificationContract,
    void,
    ArmResponse<ResourceListResult<RecipientEmailContract>>
  >;

  /**
   * Determine if Notification Recipient Email subscribed to the notification.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("NotificationRecipientEmail_CheckEntityExists")
  @head
  @action("{email}")
  notificationRecipientEmailCheckEntityExists is ArmResourceActionSync<
    NotificationContract,
    void,
    NoContentResponse,
    Parameters = {
      /**
       * Email identifier.
       */
      @path
      email: string;
    }
  >;

  /**
   * Adds the Email address to the list of Recipients for the Notification.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("NotificationRecipientEmail_CreateOrUpdate")
  @put
  @action("{email}")
  notificationRecipientEmailCreateOrUpdate is ArmResourceActionSync<
    NotificationContract,
    void,
    ArmResponse<RecipientEmailContract> | ArmResourceCreatedSyncResponse<RecipientEmailContract>,
    Parameters = {
      /**
       * Email identifier.
       */
      @path
      email: string;
    }
  >;

  /**
   * Removes the email from the list of Notification.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("NotificationRecipientEmail_Delete")
  @delete
  @action("{email}")
  notificationRecipientEmailDelete is ArmResourceActionSync<
    NotificationContract,
    void,
    OkResponse | NoContentResponse,
    Parameters = {
      /**
       * Email identifier.
       */
      @path
      email: string;
    }
  >;
}

@@doc(NotificationContract.name, "Notification Name Identifier.");
@@doc(NotificationContract.properties,
  "Notification entity contract properties."
);
