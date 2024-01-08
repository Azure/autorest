import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementServiceResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Notification details.")
@parentResource(ApiManagementServiceResource)
model NotificationContract is ProxyResource<NotificationContractProperties> {
  @doc("Notification Name Identifier.")
  @key("notificationName")
  @segment("notifications")
  name: NotificationName;
}

@armResourceOperations
@projectedName("client", "Notification")
interface NotificationContracts_Notification {
  @doc("Gets the details of the Notification specified by its identifier.")
  get is ArmResourceRead<NotificationContract>;
  @doc("Create or Update API Management publisher notification.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    NotificationContract,
    {
      ...BaseParameters<NotificationContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;
  @doc("Lists a collection of properties defined within a service instance.")
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
}

@armResourceOperations
@projectedName("client", "NotificationRecipientUser")
interface NotificationContracts_NotificationRecipientUser {
  @doc("Gets the list of the Notification Recipient User subscribed to the notification.")
  // FIXME: NotificationRecipientUser_ListByNotification could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientUsers")
  @get
  ListByNotification is Azure.Core.Foundations.Operation<
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
}

@armResourceOperations
@projectedName("client", "NotificationRecipientEmail")
interface NotificationContracts_NotificationRecipientEmail {
  @doc("Gets the list of the Notification Recipient Emails subscribed to a notification.")
  // FIXME: NotificationRecipientEmail_ListByNotification could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientEmails")
  @get
  ListByNotification is Azure.Core.Foundations.Operation<
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
