// FIXME: Operations in this file are not detected as a resource operation, please confirm the conversion result manually

import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Microsoft.DataFactory;

interface FactoriesOperationGroup {
  /**
   * Updates a factory's repo information.
   */
  @autoRoute
  configureFactoryRepo is ArmProviderActionSync<
    Request = FactoryRepoUpdate,
    Response = Factory,
    Scope = SubscriptionActionScope,
    Parameters = {
      /**
       * The location identifier.
       */
      @path
      @segment("locations")
      locationId: string;
    }
  >;
}

interface ExposureControlOperationGroup {
  /**
   * Get exposure control feature for specific location.
   */
  @autoRoute
  getFeatureValue is ArmProviderActionSync<
    Request = ExposureControlRequest,
    Response = ExposureControlResponse,
    Scope = SubscriptionActionScope,
    Parameters = {
      /**
       * The location identifier.
       */
      @path
      @segment("locations")
      locationId: string;
    }
  >;
}
