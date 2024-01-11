import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./FileServiceProperties.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Storage;
@doc("Properties of the file share, including Id, resource name, resource type, Etag.")
@parentResource(FileServiceProperties)
model FileShare is ProxyResource<FileShareProperties> {
  @doc("The name of the file share within the specified storage account. File share names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.")
  @maxLength(63)
  @minLength(3)
  @path
  @key("shareName")
  @segment("shares")
  name: string;
}

@armResourceOperations
interface FileShares {
  @doc("Gets properties of a specified share.")
  get is ArmResourceRead<
    FileShare,
    {
      ...BaseParameters<FileShare>;

      @doc("Optional, used to expand the properties within share's properties. Valid values are: stats. Should be passed as a string with delimiter ','.")
      @query("$expand")
      $expand?: string;

      @doc("Optional, used to retrieve properties of a snapshot.")
      @header
      `x-ms-snapshot`?: string;
    }
  >;

  @doc("Creates a new share under the specified account as described by request body. The share resource includes metadata and properties for that share. It does not include a list of the files contained by the share. ")
  create is ArmResourceCreateOrReplaceSync<
    FileShare,
    {
      ...BaseParameters<FileShare>;

      @doc("Optional, used to expand the properties within share's properties. Valid values are: snapshots. Should be passed as a string with delimiter ','")
      @query("$expand")
      $expand?: string;
    }
  >;

  @doc("Updates share properties as specified in request body. Properties not mentioned in the request will not be changed. Update fails if the specified share does not already exist. ")
  update is ArmCustomPatchSync<FileShare, FileShare>;

  @doc("Deletes specified share under its account.")
  delete is ArmResourceDeleteSync<
    FileShare,
    {
      ...BaseParameters<FileShare>;

      @doc("Optional, used to delete a snapshot.")
      @header
      `x-ms-snapshot`?: string;

      @doc("Optional. Valid values are: snapshots, leased-snapshots, none. The default value is snapshots. For 'snapshots', the file share is deleted including all of its file share snapshots. If the file share contains leased-snapshots, the deletion fails. For 'leased-snapshots', the file share is deleted included all of its file share snapshots (leased/unleased). For 'none', the file share is deleted if it has no share snapshots. If the file share contains any snapshots (leased or unleased), the deletion fails.")
      @query("$include")
      $include?: string;
    }
  >;

  @doc("Lists all shares.")
  list is ArmResourceListByParent<
    FileShare,
    {
      ...BaseParameters<FileShare>;

      @doc("Optional. Specified maximum number of shares that can be included in the list.")
      @query("$maxpagesize")
      $maxpagesize?: string;

      @doc("Optional. When specified, only share names starting with the filter will be listed.")
      @query("$filter")
      $filter?: string;

      @doc("Optional, used to expand the properties within share's properties. Valid values are: deleted, snapshots. Should be passed as a string with delimiter ','")
      @query("$expand")
      $expand?: string;
    }
  >;

  @doc("Restore a file share within a valid retention days if share soft delete is enabled")
  restore is ArmResourceActionSync<FileShare, DeletedShare, void>;

  @doc("The Lease Share operation establishes and manages a lock on a share for delete operations. The lock duration can be 15 to 60 seconds, or can be infinite.")
  lease is ArmResourceActionSync<
    FileShare,
    LeaseShareRequest,
    LeaseShareResponse,
    {
      ...BaseParameters<FileShare>;

      @doc("Optional. Specify the snapshot time to lease a snapshot.")
      @header
      `x-ms-snapshot`?: string;
    }
  >;
}
