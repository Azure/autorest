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

  /**
   * Create or Update API Management publisher notification.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Notification_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    NotificationContract,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
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
    },
    Response = NotificationListResult
  >;

  /**
   * Gets the list of the Notification Recipient User subscribed to the notification.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @operationId("NotificationRecipientUser_ListByNotification")
  listByNotification is ArmResourceActionSync<
    NotificationContract,
    void,
    RecipientUserListResult
  >;

  /**
   * Determine if the Notification Recipient User is subscribed to the notification.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @head
  @operationId("NotificationRecipientUser_CheckEntityExists")
  checkEntityExists is ArmResourceActionNoContentSync<
    NotificationContract,
    void,
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
  @put
  @operationId("NotificationRecipientUser_CreateOrUpdate")
  notificationRecipientUserCreateOrUpdate is ArmResourceActionSync<
    NotificationContract,
    void,
    RecipientUserContract,
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
  @delete
  @operationId("NotificationRecipientUser_Delete")
  delete is ArmResourceActionSync<
    NotificationContract,
    void,
    void,
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
  @get
  @operationId("NotificationRecipientEmail_ListByNotification")
  notificationRecipientEmailListByNotification is ArmResourceActionSync<
    NotificationContract,
    void,
    RecipientEmailListResult
  >;

  /**
   * Determine if Notification Recipient Email subscribed to the notification.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @head
  @operationId("NotificationRecipientEmail_CheckEntityExists")
  notificationRecipientEmailCheckEntityExists is ArmResourceActionNoContentSync<
    NotificationContract,
    void,
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
  @put
  @operationId("NotificationRecipientEmail_CreateOrUpdate")
  notificationRecipientEmailCreateOrUpdate is ArmResourceActionSync<
    NotificationContract,
    void,
    RecipientEmailContract,
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
  @delete
  @operationId("NotificationRecipientEmail_Delete")
  notificationRecipientEmailDelete is ArmResourceActionSync<
    NotificationContract,
    void,
    void,
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
