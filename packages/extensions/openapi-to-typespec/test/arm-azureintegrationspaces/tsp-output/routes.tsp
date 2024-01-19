import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Microsoft.IntegrationSpaces;

interface ApplicationResourcesOperations {
  /**
   * List ApplicationResource resources by Application
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.IntegrationSpaces/spaces/{spaceName}/applications/{applicationName}/resources")
  @get
  listByApplication is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the target subscription.
       */
      @minLength(1)
      @path
      subscriptionId: string;

      /**
       * The name of the resource group. The name is case insensitive.
       */
      @maxLength(90)
      @minLength(1)
      @path
      resourceGroupName: string;

      /**
       * The number of result items to return.
       */
      @query("top")
      top?: int32;

      /**
       * The number of result items to skip.
       */
      @query("skip")
      skip?: int32;

      /**
       * The maximum number of result items per page.
       */
      @query("maxpagesize")
      maxpagesize?: int32;

      /**
       * Filter the result list using the given expression.
       */
      @query("filter")
      filter?: string;

      /**
       * Select the specified fields to be included in the response.
       */
      @query({
        name: "select",
        format: "multi",
      })
      select?: string[];

      /**
       * Expand the indicated resources into the response.
       */
      @query({
        name: "expand",
        format: "multi",
      })
      expand?: string[];

      /**
       * Expressions that specify the order of returned results.
       */
      @query({
        name: "orderby",
        format: "multi",
      })
      orderby?: string[];

      /**
       * The name of the space
       */
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      spaceName: string;

      /**
       * The name of the Application
       */
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      applicationName: string;
    },
    ApplicationResourceListResult
  >;

  /**
   * Get a ApplicationResource
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.IntegrationSpaces/spaces/{spaceName}/applications/{applicationName}/resources/{resourceName}")
  @get
  get is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the target subscription.
       */
      @minLength(1)
      @path
      subscriptionId: string;

      /**
       * The name of the resource group. The name is case insensitive.
       */
      @maxLength(90)
      @minLength(1)
      @path
      resourceGroupName: string;

      /**
       * The name of the space
       */
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      spaceName: string;

      /**
       * The name of the Application
       */
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      applicationName: string;

      /**
       * The name of the application resource.
       */
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      resourceName: string;
    },
    ApplicationResource
  >;

  /**
   * Create a ApplicationResource
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.IntegrationSpaces/spaces/{spaceName}/applications/{applicationName}/resources/{resourceName}")
  @put
  createOrUpdate is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the target subscription.
       */
      @minLength(1)
      @path
      subscriptionId: string;

      /**
       * The name of the resource group. The name is case insensitive.
       */
      @maxLength(90)
      @minLength(1)
      @path
      resourceGroupName: string;

      /**
       * The name of the space
       */
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      spaceName: string;

      /**
       * The name of the Application
       */
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      applicationName: string;

      /**
       * The name of the application resource.
       */
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      resourceName: string;

      /**
       * Resource create parameters.
       */
      @body
      resource: ApplicationResource;
    },
    ApplicationResource
  >;

  /**
   * Update a ApplicationResource
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.IntegrationSpaces/spaces/{spaceName}/applications/{applicationName}/resources/{resourceName}")
  @patch
  patch is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the target subscription.
       */
      @minLength(1)
      @path
      subscriptionId: string;

      /**
       * The name of the resource group. The name is case insensitive.
       */
      @maxLength(90)
      @minLength(1)
      @path
      resourceGroupName: string;

      /**
       * The name of the space
       */
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      spaceName: string;

      /**
       * The name of the Application
       */
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      applicationName: string;

      /**
       * The name of the application resource.
       */
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      resourceName: string;

      /**
       * The resource properties to be updated.
       */
      @body
      properties: ApplicationResourceUpdate;
    },
    ApplicationResource
  >;

  /**
   * Delete a ApplicationResource
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.IntegrationSpaces/spaces/{spaceName}/applications/{applicationName}/resources/{resourceName}")
  @delete
  delete is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the target subscription.
       */
      @minLength(1)
      @path
      subscriptionId: string;

      /**
       * The name of the resource group. The name is case insensitive.
       */
      @maxLength(90)
      @minLength(1)
      @path
      resourceGroupName: string;

      /**
       * The name of the space
       */
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      spaceName: string;

      /**
       * The name of the Application
       */
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      applicationName: string;

      /**
       * The name of the application resource.
       */
      @pattern("[a-zA-Z0-9_.()-]{0,79}$")
      @path
      resourceName: string;
    },
    void
  >;
}
