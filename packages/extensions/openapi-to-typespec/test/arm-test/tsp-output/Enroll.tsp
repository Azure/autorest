import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Employee.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Test;
/**
 * A Test resource
 */
@singleton("default")
@parentResource(Employee)
model Enroll is TrackedResource<EnrollProperties> {
  @key("enroll")
  @segment("enrolls")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface Enrolls {
  /**
   * Get a Enroll.
   */
  get is ArmResourceRead<Enroll>;
}
