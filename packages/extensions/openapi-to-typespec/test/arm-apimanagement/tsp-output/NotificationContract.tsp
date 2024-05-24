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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(ApiManagementServiceResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  NotificationContractProperties
)
model NotificationContract extends Foundations.ProxyResource {
  /**
   * Notification Name Identifier.
   */
  @path
  @key("notificationName")
  @segment("notifications")
  @visibility("read")
  name: NotificationName;

  /**
   * Notification entity contract properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: NotificationContractProperties;
}

@armResourceOperations
interface NotificationContracts {
  /**
   * Gets the details of the Notification specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Notification_Get")
  get is ArmResourceRead<NotificationContract>;

  /**
   * Create or Update API Management publisher notification.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Notification_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    NotificationContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<NotificationContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Notification_ListByService")
  listByService is ArmResourceListByParent<
    NotificationContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<NotificationContract>;

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
  // FIXME: NotificationRecipientUser_ListByNotification could not be converted to a resource operation
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("NotificationRecipientUser_ListByNotification")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientUsers")
  @get
  listByNotification(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the API Management service.
     */
    @maxLength(50)
    @minLength(1)
    @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
    @path
    serviceName: string,

    /**
     * Notification Name Identifier.
     */
    @path
    notificationName: NotificationName,

    ...SubscriptionIdParameter,
  ): ArmResponse<RecipientUserListResult> | ErrorResponse;

  /**
   * Gets the list of the Notification Recipient Emails subscribed to a notification.
   */
  // FIXME: NotificationRecipientEmail_ListByNotification could not be converted to a resource operation
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("NotificationRecipientEmail_ListByNotification")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientEmails")
  @get
  listByNotification(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the API Management service.
     */
    @maxLength(50)
    @minLength(1)
    @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
    @path
    serviceName: string,

    /**
     * Notification Name Identifier.
     */
    @path
    notificationName: NotificationName,

    ...SubscriptionIdParameter,
  ): ArmResponse<RecipientEmailListResult> | ErrorResponse;
}
