import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./Employee.tsp";
import "./Enroll.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager.Foundations;
using Azure.Core;
using Azure.ResourceManager;
using TypeSpec.Versioning;
@armProviderNamespace
@service({
  title: "Azure Test resource management API.",
  version: "2023-10-12",
})
@doc("For test.")
@useDependency(Azure.ResourceManager.Versions.v1_0_Preview_1)
@useDependency(Azure.Core.Versions.v1_0_Preview_1)
namespace Azure.ResourceManager.Test;
