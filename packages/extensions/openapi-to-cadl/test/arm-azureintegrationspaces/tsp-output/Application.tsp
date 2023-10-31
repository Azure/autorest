import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./Space.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.IntegrationSpaces;
@doc("An integration application under space.")
@parentResource(Space)
model Application is TrackedResource<ApplicationProperties> {
  @doc("The name of the Application")
  @pattern("[a-zA-Z0-9_.()-]{0,79}$")
  @path
  @key("applicationName")
  @segment("applications")
  name: string;
}

@armResourceOperations
interface Applications {
  @doc("Get a Application")
  get is ArmResourceRead<Application>;
  @doc("Create a Application")
  createOrUpdate is ArmResourceCreateOrReplaceSync<Application>;
  @doc("Update a Application")
  patch is ArmResourcePatchSync<Application, ApplicationProperties>;
  @doc("Delete a Application")
  delete is ArmResourceDeleteSync<Application>;
  @doc("List Application resources by Space")
  listBySpace is ArmResourceListByParent<
    Application,
    {
      ...BaseParameters<Application>;

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
    }
  >;
  @doc("The delete business process development artifact action.")
  deleteBusinessProcessDevelopmentArtifact is ArmResourceActionSync<
    Application,
    GetOrDeleteBusinessProcessDevelopmentArtifactRequest,
    {}
  >;
  @doc("The get business process development artifact action.")
  getBusinessProcessDevelopmentArtifact is ArmResourceActionSync<
    Application,
    GetOrDeleteBusinessProcessDevelopmentArtifactRequest,
    SaveOrGetBusinessProcessDevelopmentArtifactResponse
  >;
  @doc("The list business process development artifacts action.")
  listBusinessProcessDevelopmentArtifacts is ArmResourceActionSync<
    Application,
    {},
    ListBusinessProcessDevelopmentArtifactsResponse
  >;
  @doc("The save business process development artifact action.")
  saveBusinessProcessDevelopmentArtifact is ArmResourceActionSync<
    Application,
    SaveOrValidateBusinessProcessDevelopmentArtifactRequest,
    SaveOrGetBusinessProcessDevelopmentArtifactResponse
  >;
  @doc("The validate business process development artifact action.")
  validateBusinessProcessDevelopmentArtifact is ArmResourceActionSync<
    Application,
    SaveOrValidateBusinessProcessDevelopmentArtifactRequest,
    {}
  >;
}
