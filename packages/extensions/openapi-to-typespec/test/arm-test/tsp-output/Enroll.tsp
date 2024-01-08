import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./Employee.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.Test;
@doc("A Test resource")
@singleton("default")
@parentResource(Employee)
model Enroll is TrackedResource<EnrollProperties> {
  @key("enroll")
  @segment("enrolls")
  name: string;
}

@armResourceOperations
interface Enrolls {
  @doc("Get a Enroll.")
  get is ArmResourceRead<Enroll>;
}
