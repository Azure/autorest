import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Microsoft.IntegrationSpaces;

interface ApplicationResourcesOperations {
  @doc("List ApplicationResource resources by Application")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.IntegrationSpaces/spaces/{spaceName}/applications/{applicationName}/resources")
  @get
  ListByApplication is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @minLength(1)
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @maxLength(90)
      @minLength(1)
      @path
      resourceGroupName: string;

      @doc("The number of result items to return.")
      @query("top")
      top?: int32;

      @doc("The number of result items to skip.")
      @query("skip")
      skip?: int32;

      @doc("The maximum number of result items per page.")
      @query("maxpagesize")
      maxpagesize?: int32;

      @doc("Filter the result list using the given expression.")
      @query("filter")
      filter?: string;

      @doc("Select the specified fields to be included in the response.")
      @query({
        name: "select",
        format: "multi",
      })
      select?: string[];

      @doc("Expand the indicated resources into the response.")
      @query({
        name: "expand",
        format: "multi",
      })
      expand?: string[];

      @doc("Expressions that specify the order of returned results.")
      @query({
        name: "orderby",
        format: "multi",
      })
      orderby?: string[];

      @doc("The name of the space")
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      spaceName: string;

      @doc("The name of the Application")
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      applicationName: string;
    },
    ApplicationResourceListResult
  >;

  @doc("Get a ApplicationResource")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.IntegrationSpaces/spaces/{spaceName}/applications/{applicationName}/resources/{resourceName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @minLength(1)
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @maxLength(90)
      @minLength(1)
      @path
      resourceGroupName: string;

      @doc("The name of the space")
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      spaceName: string;

      @doc("The name of the Application")
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      applicationName: string;

      @doc("The name of the application resource.")
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      resourceName: string;
    },
    ApplicationResource
  >;

  @doc("Create a ApplicationResource")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.IntegrationSpaces/spaces/{spaceName}/applications/{applicationName}/resources/{resourceName}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @minLength(1)
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @maxLength(90)
      @minLength(1)
      @path
      resourceGroupName: string;

      @doc("The name of the space")
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      spaceName: string;

      @doc("The name of the Application")
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      applicationName: string;

      @doc("The name of the application resource.")
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      resourceName: string;

      @doc("Resource create parameters.")
      @body
      resource: ApplicationResource;
    },
    ApplicationResource
  >;

  @doc("Update a ApplicationResource")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.IntegrationSpaces/spaces/{spaceName}/applications/{applicationName}/resources/{resourceName}")
  @patch
  Patch is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @minLength(1)
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @maxLength(90)
      @minLength(1)
      @path
      resourceGroupName: string;

      @doc("The name of the space")
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      spaceName: string;

      @doc("The name of the Application")
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      applicationName: string;

      @doc("The name of the application resource.")
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      resourceName: string;

      @doc("The resource properties to be updated.")
      @body
      properties: ApplicationResourceUpdate;
    },
    ApplicationResource
  >;

  @doc("Delete a ApplicationResource")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.IntegrationSpaces/spaces/{spaceName}/applications/{applicationName}/resources/{resourceName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @minLength(1)
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @maxLength(90)
      @minLength(1)
      @path
      resourceGroupName: string;

      @doc("The name of the space")
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      spaceName: string;

      @doc("The name of the Application")
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      applicationName: string;

      @doc("The name of the application resource.")
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      resourceName: string;
    },
    void
  >;
}
