import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Microsoft.AzureSphere;

interface OperationsOperations {
  @doc("List the operations for the provider")
  @route("/providers/Microsoft.AzureSphere/operations")
  @get
  List is Azure.Core.Foundations.Operation<{}, OperationListResult>;
}

interface CatalogsOperations {
  @doc("List Catalog resources by subscription ID")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.AzureSphere/catalogs")
  @get
  ListBySubscription is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;
    },
    CatalogListResult
  >;

  @doc("List Catalog resources by resource group")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs")
  @get
  ListByResourceGroup is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;
    },
    CatalogListResult
  >;

  @doc("Get a Catalog")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;
    },
    Catalog
  >;

  @doc("Create a Catalog")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Resource create parameters.")
      @body
      resource: Catalog;
    },
    Catalog
  >;

  @doc("Update a Catalog")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}")
  @patch
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("The resource properties to be updated.")
      @body
      properties: CatalogUpdate;
    },
    Catalog
  >;

  @doc("Delete a Catalog")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;
    },
    void
  >;

  @doc("Counts devices in catalog.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/countDevices")
  @post
  CountDevices is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;
    },
    CountDeviceResponse
  >;

  @doc("Lists deployments for catalog.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/listDeployments")
  @post
  ListDeployments is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Filter the result list using the given expression")
      @query
      $filter: string;

      @doc("The number of result items to return.")
      @query
      $top: int32;

      @doc("The number of result items to skip.")
      @query
      $skip: int32;

      @doc("The maximum number of result items per page.")
      @query
      $maxpagesize: int32;
    },
    DeploymentListResult
  >;

  @doc("List the device groups for the catalog.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/listDeviceGroups")
  @post
  ListDeviceGroups is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Filter the result list using the given expression")
      @query
      $filter: string;

      @doc("The number of result items to return.")
      @query
      $top: int32;

      @doc("The number of result items to skip.")
      @query
      $skip: int32;

      @doc("The maximum number of result items per page.")
      @query
      $maxpagesize: int32;

      @doc("List device groups for catalog.")
      @body
      listDeviceGroupsRequest: ListDeviceGroupsRequest;
    },
    DeviceGroupListResult
  >;

  @doc("Lists device insights for catalog.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/listDeviceInsights")
  @post
  ListDeviceInsights is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Filter the result list using the given expression")
      @query
      $filter: string;

      @doc("The number of result items to return.")
      @query
      $top: int32;

      @doc("The number of result items to skip.")
      @query
      $skip: int32;

      @doc("The maximum number of result items per page.")
      @query
      $maxpagesize: int32;
    },
    PagedDeviceInsight
  >;

  @doc("Lists devices for catalog.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/listDevices")
  @post
  ListDevices is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Filter the result list using the given expression")
      @query
      $filter: string;

      @doc("The number of result items to return.")
      @query
      $top: int32;

      @doc("The number of result items to skip.")
      @query
      $skip: int32;

      @doc("The maximum number of result items per page.")
      @query
      $maxpagesize: int32;
    },
    DeviceListResult
  >;
}

interface CertificatesOperations {
  @doc("List Certificate resources by Catalog")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/certificates")
  @get
  ListByCatalog is Azure.Core.Foundations.Operation<
    {
      @doc("Filter the result list using the given expression")
      @query
      $filter: string;

      @doc("The number of result items to return.")
      @query
      $top: int32;

      @doc("The number of result items to skip.")
      @query
      $skip: int32;

      @doc("The maximum number of result items per page.")
      @query
      $maxpagesize: int32;

      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;
    },
    CertificateListResult
  >;

  @doc("Get a Certificate")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/certificates/{serialNumber}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("""
Serial number of the certificate. Use '.default' to get current active
certificate.
""")
      @path
      serialNumber: string;
    },
    Certificate
  >;

  @doc("Retrieves cert chain.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/certificates/{serialNumber}/retrieveCertChain")
  @post
  RetrieveCertChain is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("""
Serial number of the certificate. Use '.default' to get current active
certificate.
""")
      @path
      serialNumber: string;
    },
    CertificateChainResponse
  >;

  @doc("Gets the proof of possession nonce.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/certificates/{serialNumber}/retrieveProofOfPossessionNonce")
  @post
  RetrieveProofOfPossessionNonce is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("""
Serial number of the certificate. Use '.default' to get current active
certificate.
""")
      @path
      serialNumber: string;

      @doc("Proof of possession nonce request body ")
      @body
      proofOfPossessionNonceRequest: ProofOfPossessionNonceRequest;
    },
    ProofOfPossessionNonceResponse
  >;
}

interface ImagesOperations {
  @doc("List Image resources by Catalog")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/images")
  @get
  ListByCatalog is Azure.Core.Foundations.Operation<
    {
      @doc("Filter the result list using the given expression")
      @query
      $filter: string;

      @doc("The number of result items to return.")
      @query
      $top: int32;

      @doc("The number of result items to skip.")
      @query
      $skip: int32;

      @doc("The maximum number of result items per page.")
      @query
      $maxpagesize: int32;

      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;
    },
    ImageListResult
  >;

  @doc("Get a Image")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/images/{imageName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Image name. Use .default for image creation.")
      @path
      imageName: string;
    },
    Image
  >;

  @doc("Create a Image")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/images/{imageName}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Image name. Use .default for image creation.")
      @path
      imageName: string;

      @doc("Resource create parameters.")
      @body
      resource: Image;
    },
    Image
  >;

  @doc("Delete a Image")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/images/{imageName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Image name. Use .default for image creation.")
      @path
      imageName: string;
    },
    void
  >;
}

interface ProductsOperations {
  @doc("List Product resources by Catalog")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/products")
  @get
  ListByCatalog is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;
    },
    ProductListResult
  >;

  @doc("""
Get a Product. '.default' and '.unassigned' are system defined values and
cannot be used for product name.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/products/{productName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Name of product.")
      @path
      productName: string;
    },
    Product
  >;

  @doc("""
Create a Product. '.default' and '.unassigned' are system defined values and
cannot be used for product name.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/products/{productName}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Name of product.")
      @path
      productName: string;

      @doc("Resource create parameters.")
      @body
      resource: Product;
    },
    Product
  >;

  @doc("""
Update a Product. '.default' and '.unassigned' are system defined values and
cannot be used for product name.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/products/{productName}")
  @patch
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Name of product.")
      @path
      productName: string;

      @doc("The resource properties to be updated.")
      @body
      properties: ProductUpdate;
    },
    Product | void
  >;

  @doc("""
Delete a Product. '.default' and '.unassigned' are system defined values and
cannot be used for product name'
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/products/{productName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Name of product.")
      @path
      productName: string;
    },
    void
  >;

  @doc("""
Counts devices in product. '.default' and '.unassigned' are system defined
values and cannot be used for product name.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/products/{productName}/countDevices")
  @post
  CountDevices is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Name of product.")
      @path
      productName: string;
    },
    CountDeviceResponse
  >;

  @doc("""
Generates default device groups for the product. '.default' and '.unassigned'
are system defined values and cannot be used for product name.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/products/{productName}/generateDefaultDeviceGroups")
  @post
  GenerateDefaultDeviceGroups is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Name of product.")
      @path
      productName: string;
    },
    DeviceGroupListResult
  >;
}

interface DeviceGroupsOperations {
  @doc("""
List DeviceGroup resources by Product. '.default' and '.unassigned' are system
defined values and cannot be used for product name.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/products/{productName}/deviceGroups")
  @get
  ListByProduct is Azure.Core.Foundations.Operation<
    {
      @doc("Filter the result list using the given expression")
      @query
      $filter: string;

      @doc("The number of result items to return.")
      @query
      $top: int32;

      @doc("The number of result items to skip.")
      @query
      $skip: int32;

      @doc("The maximum number of result items per page.")
      @query
      $maxpagesize: int32;

      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Name of product.")
      @path
      productName: string;
    },
    DeviceGroupListResult
  >;

  @doc("""
Get a DeviceGroup. '.default' and '.unassigned' are system defined values and
cannot be used for product or device group name.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/products/{productName}/deviceGroups/{deviceGroupName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Name of product.")
      @path
      productName: string;

      @doc("Name of device group.")
      @path
      deviceGroupName: string;
    },
    DeviceGroup
  >;

  @doc("""
Create a DeviceGroup. '.default' and '.unassigned' are system defined values
and cannot be used for product or device group name.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/products/{productName}/deviceGroups/{deviceGroupName}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Name of product.")
      @path
      productName: string;

      @doc("Name of device group.")
      @path
      deviceGroupName: string;

      @doc("Resource create parameters.")
      @body
      resource: DeviceGroup;
    },
    DeviceGroup
  >;

  @doc("""
Update a DeviceGroup. '.default' and '.unassigned' are system defined values
and cannot be used for product or device group name.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/products/{productName}/deviceGroups/{deviceGroupName}")
  @patch
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Name of product.")
      @path
      productName: string;

      @doc("Name of device group.")
      @path
      deviceGroupName: string;

      @doc("The resource properties to be updated.")
      @body
      properties: DeviceGroupUpdate;
    },
    DeviceGroup | void
  >;

  @doc("""
Delete a DeviceGroup. '.default' and '.unassigned' are system defined values
and cannot be used for product or device group name.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/products/{productName}/deviceGroups/{deviceGroupName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Name of product.")
      @path
      productName: string;

      @doc("Name of device group.")
      @path
      deviceGroupName: string;
    },
    void
  >;

  @doc("""
Bulk claims the devices. Use '.unassigned' or '.default' for the device group
and product names when bulk claiming devices to a catalog only.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/products/{productName}/deviceGroups/{deviceGroupName}/claimDevices")
  @post
  ClaimDevices is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Name of product.")
      @path
      productName: string;

      @doc("Name of device group.")
      @path
      deviceGroupName: string;

      @doc("Bulk claim devices request body.")
      @body
      claimDevicesRequest: ClaimDevicesRequest;
    },
    void
  >;

  @doc("""
Counts devices in device group. '.default' and '.unassigned' are system defined
values and cannot be used for product or device group name.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/products/{productName}/deviceGroups/{deviceGroupName}/countDevices")
  @post
  CountDevices is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Name of product.")
      @path
      productName: string;

      @doc("Name of device group.")
      @path
      deviceGroupName: string;
    },
    CountDeviceResponse
  >;
}

interface DeploymentsOperations {
  @doc("""
List Deployment resources by DeviceGroup. '.default' and '.unassigned' are
system defined values and cannot be used for product or device group name.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/products/{productName}/deviceGroups/{deviceGroupName}/deployments")
  @get
  ListByDeviceGroup is Azure.Core.Foundations.Operation<
    {
      @doc("Filter the result list using the given expression")
      @query
      $filter: string;

      @doc("The number of result items to return.")
      @query
      $top: int32;

      @doc("The number of result items to skip.")
      @query
      $skip: int32;

      @doc("The maximum number of result items per page.")
      @query
      $maxpagesize: int32;

      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Name of product.")
      @path
      productName: string;

      @doc("Name of device group.")
      @path
      deviceGroupName: string;
    },
    DeploymentListResult
  >;

  @doc("""
Get a Deployment. '.default' and '.unassigned' are system defined values and
cannot be used for product or device group name.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/products/{productName}/deviceGroups/{deviceGroupName}/deployments/{deploymentName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Name of product.")
      @path
      productName: string;

      @doc("Name of device group.")
      @path
      deviceGroupName: string;

      @doc("""
Deployment name. Use .default for deployment creation and to get the current
deployment for the associated device group.
""")
      @path
      deploymentName: string;
    },
    Deployment
  >;

  @doc("""
Create a Deployment. '.default' and '.unassigned' are system defined values and
cannot be used for product or device group name.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/products/{productName}/deviceGroups/{deviceGroupName}/deployments/{deploymentName}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Name of product.")
      @path
      productName: string;

      @doc("Name of device group.")
      @path
      deviceGroupName: string;

      @doc("""
Deployment name. Use .default for deployment creation and to get the current
deployment for the associated device group.
""")
      @path
      deploymentName: string;

      @doc("Resource create parameters.")
      @body
      resource: Deployment;
    },
    Deployment
  >;

  @doc("""
Delete a Deployment. '.default' and '.unassigned' are system defined values and
cannot be used for product or device group name.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/products/{productName}/deviceGroups/{deviceGroupName}/deployments/{deploymentName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Name of product.")
      @path
      productName: string;

      @doc("Name of device group.")
      @path
      deviceGroupName: string;

      @doc("""
Deployment name. Use .default for deployment creation and to get the current
deployment for the associated device group.
""")
      @path
      deploymentName: string;
    },
    void
  >;
}

interface DevicesOperations {
  @doc("""
List Device resources by DeviceGroup. '.default' and '.unassigned' are system
defined values and cannot be used for product or device group name.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/products/{productName}/deviceGroups/{deviceGroupName}/devices")
  @get
  ListByDeviceGroup is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Name of product.")
      @path
      productName: string;

      @doc("Name of device group.")
      @path
      deviceGroupName: string;
    },
    DeviceListResult
  >;

  @doc("""
Get a Device. Use '.unassigned' or '.default' for the device group and product
names when a device does not belong to a device group and product.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/products/{productName}/deviceGroups/{deviceGroupName}/devices/{deviceName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Name of product.")
      @path
      productName: string;

      @doc("Name of device group.")
      @path
      deviceGroupName: string;

      @doc("Device name")
      @path
      deviceName: string;
    },
    Device
  >;

  @doc("""
Create a Device. Use '.unassigned' or '.default' for the device group and
product names to claim a device to the catalog only.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/products/{productName}/deviceGroups/{deviceGroupName}/devices/{deviceName}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Name of product.")
      @path
      productName: string;

      @doc("Name of device group.")
      @path
      deviceGroupName: string;

      @doc("Device name")
      @path
      deviceName: string;

      @doc("Resource create parameters.")
      @body
      resource: Device;
    },
    Device
  >;

  @doc("""
Update a Device. Use '.unassigned' or '.default' for the device group and
product names to move a device to the catalog level.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/products/{productName}/deviceGroups/{deviceGroupName}/devices/{deviceName}")
  @patch
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Name of product.")
      @path
      productName: string;

      @doc("Name of device group.")
      @path
      deviceGroupName: string;

      @doc("Device name")
      @path
      deviceName: string;

      @doc("The resource properties to be updated.")
      @body
      properties: DeviceUpdate;
    },
    Device | void
  >;

  @doc("Delete a Device")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/products/{productName}/deviceGroups/{deviceGroupName}/devices/{deviceName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Name of product.")
      @path
      productName: string;

      @doc("Name of device group.")
      @path
      deviceGroupName: string;

      @doc("Device name")
      @path
      deviceName: string;
    },
    void
  >;

  @doc("""
Generates the capability image for the device. Use '.unassigned' or '.default'
for the device group and product names to generate the image for a device that
does not belong to a specific device group and product.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureSphere/catalogs/{catalogName}/products/{productName}/deviceGroups/{deviceGroupName}/devices/{deviceName}/generateCapabilityImage")
  @post
  GenerateCapabilityImage is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @path
      resourceGroupName: string;

      @doc("Name of catalog")
      @path
      catalogName: string;

      @doc("Name of product.")
      @path
      productName: string;

      @doc("Name of device group.")
      @path
      deviceGroupName: string;

      @doc("Device name")
      @path
      deviceName: string;

      @doc("Generate capability image request body.")
      @body
      generateDeviceCapabilityRequest: GenerateCapabilityImageRequest;
    },
    SignedCapabilityImageResponse | void
  >;
}
