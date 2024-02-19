// FIXME: Operations in this file are not detected as a resource operation, please confirm the conversion result manually

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
  listByApplication(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * The number of result items to return.
     */
    @query("top")
    top?: int32,

    /**
     * The number of result items to skip.
     */
    @query("skip")
    skip?: int32,

    /**
     * The maximum number of result items per page.
     */
    @query("maxpagesize")
    maxpagesize?: int32,

    /**
     * Filter the result list using the given expression.
     */
    @query("filter")
    filter?: string,

    /**
     * Select the specified fields to be included in the response.
     */
    @query({
      name: "select",
      format: "multi",
    })
    select?: string[],

    /**
     * Expand the indicated resources into the response.
     */
    @query({
      name: "expand",
      format: "multi",
    })
    expand?: string[],

    /**
     * Expressions that specify the order of returned results.
     */
    @query({
      name: "orderby",
      format: "multi",
    })
    orderby?: string[],

    /**
     * The name of the space
     */
    @pattern("[a-zA-Z0-9_.()-]{0,79}$")
    @path
    spaceName: string,

    /**
     * The name of the Application
     */
    @pattern("[a-zA-Z0-9_.()-]{0,79}$")
    @path
    applicationName: string,
  ): ArmResponse<ApplicationResourceListResult> | ErrorResponse;

  /**
   * Get a ApplicationResource
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.IntegrationSpaces/spaces/{spaceName}/applications/{applicationName}/resources/{resourceName}")
  @get
  get(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the space
     */
    @pattern("[a-zA-Z0-9_.()-]{0,79}$")
    @path
    spaceName: string,

    /**
     * The name of the Application
     */
    @pattern("[a-zA-Z0-9_.()-]{0,79}$")
    @path
    applicationName: string,

    /**
     * The name of the application resource.
     */
    @pattern("[a-zA-Z0-9_.()-]{0,79}$")
    @path
    resourceName: string,
  ): ArmResponse<ApplicationResource> | ErrorResponse;

  /**
   * Create a ApplicationResource
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.IntegrationSpaces/spaces/{spaceName}/applications/{applicationName}/resources/{resourceName}")
  @put
  createOrUpdate(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the space
     */
    @pattern("[a-zA-Z0-9_.()-]{0,79}$")
    @path
    spaceName: string,

    /**
     * The name of the Application
     */
    @pattern("[a-zA-Z0-9_.()-]{0,79}$")
    @path
    applicationName: string,

    /**
     * The name of the application resource.
     */
    @pattern("[a-zA-Z0-9_.()-]{0,79}$")
    @path
    resourceName: string,

    /**
     * Resource create parameters.
     */
    @body
    resource: ApplicationResource,
  ): ArmResponse<ApplicationResource> | ErrorResponse;

  /**
   * Update a ApplicationResource
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.IntegrationSpaces/spaces/{spaceName}/applications/{applicationName}/resources/{resourceName}")
  @patch
  patch(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the space
     */
    @pattern("[a-zA-Z0-9_.()-]{0,79}$")
    @path
    spaceName: string,

    /**
     * The name of the Application
     */
    @pattern("[a-zA-Z0-9_.()-]{0,79}$")
    @path
    applicationName: string,

    /**
     * The name of the application resource.
     */
    @pattern("[a-zA-Z0-9_.()-]{0,79}$")
    @path
    resourceName: string,

    /**
     * The resource properties to be updated.
     */
    @body
    properties: ApplicationResourceUpdate,
  ): ArmResponse<ApplicationResource> | ErrorResponse;

  /**
   * Delete a ApplicationResource
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.IntegrationSpaces/spaces/{spaceName}/applications/{applicationName}/resources/{resourceName}")
  @delete
  delete(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the space
     */
    @pattern("[a-zA-Z0-9_.()-]{0,79}$")
    @path
    spaceName: string,

    /**
     * The name of the Application
     */
    @pattern("[a-zA-Z0-9_.()-]{0,79}$")
    @path
    applicationName: string,

    /**
     * The name of the application resource.
     */
    @pattern("[a-zA-Z0-9_.()-]{0,79}$")
    @path
    resourceName: string,
  ): ArmResponse<void> | ErrorResponse;
}
