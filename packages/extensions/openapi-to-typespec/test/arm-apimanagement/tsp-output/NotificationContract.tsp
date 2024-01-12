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
@doc("Notification details.")
@parentResource(ApiManagementServiceResource)
model NotificationContract is ProxyResource<NotificationContractProperties> {
  @doc("Notification Name Identifier.")
  @path
  @key("notificationName")
  @segment("notifications")
  name: NotificationName;
}

@armResourceOperations
interface NotificationContracts {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the details of the Notification specified by its identifier.")
  @operationId("Notification_Get")
  get is ArmResourceRead<NotificationContract>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Create or Update API Management publisher notification.")
  @operationId("Notification_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    NotificationContract,
    {
      ...BaseParameters<NotificationContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists a collection of properties defined within a service instance.")
  @operationId("Notification_ListByService")
  listByService is ArmResourceListByParent<
    NotificationContract,
    {
      ...BaseParameters<NotificationContract>;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("NotificationRecipientUser_ListByNotification")
  @doc("Gets the list of the Notification Recipient User subscribed to the notification.")
  // FIXME: NotificationRecipientUser_ListByNotification could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientUsers")
  @get
  listByNotification is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Notification Name Identifier.")
      @path
      notificationName: NotificationName;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    RecipientUserListResult
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("NotificationRecipientEmail_ListByNotification")
  @doc("Gets the list of the Notification Recipient Emails subscribed to a notification.")
  // FIXME: NotificationRecipientEmail_ListByNotification could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientEmails")
  @get
  listByNotification is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Notification Name Identifier.")
      @path
      notificationName: NotificationName;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    RecipientEmailListResult
  >;
}
