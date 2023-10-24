import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./FileServiceProperty.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Storage;
@doc("Properties of the file share, including Id, resource name, resource type, Etag.")
@parentResource(FileServiceProperty)
model FileShare is ProxyResource<FileShareProperties> {
  @doc("""
The name of the file share within the specified storage account. File share
names must be between 3 and 63 characters in length and use numbers, lower-case
letters and dash (-) only. Every dash (-) character must be immediately
preceded and followed by a letter or number.
""")
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
  get is ArmResourceRead<FileShare>;
  @doc("""
Creates a new share under the specified account as described by request body.
The share resource includes metadata and properties for that share. It does not
include a list of the files contained by the share. 
""")
  create is ArmResourceCreateOrUpdateAsync<FileShare>;
  @doc("""
Updates share properties as specified in request body. Properties not mentioned
in the request will not be changed. Update fails if the specified share does
not already exist. 
""")
  update is ArmResourcePatchSync<FileShare, FileShareProperties>;
  @doc("Deletes specified share under its account.")
  delete is ArmResourceDeleteAsync<FileShare>;
  @doc("Lists all shares.")
  list is ArmResourceListByParent<
    FileShare,
    {
      @doc("Optional. Specified maximum number of shares that can be included in the list.")
      @query("$maxpagesize")
      $maxpagesize?: string;

      @doc("""
Optional. When specified, only share names starting with the filter will be
listed.
""")
      @query("$filter")
      $filter?: string;

      @doc("""
Optional, used to expand the properties within share's properties. Valid values
are: deleted, snapshots. Should be passed as a string with delimiter ','
""")
      @query("$expand")
      $expand?: string;
    }
  >;
  @doc("""
Restore a file share within a valid retention days if share soft delete is
enabled
""")
  restore is ArmResourceActionSync<FileShare, DeletedShare, {}>;
  @doc("""
The Lease Share operation establishes and manages a lock on a share for delete
operations. The lock duration can be 15 to 60 seconds, or can be infinite.
""")
  lease is ArmResourceActionSync<
    FileShare,
    {
      @doc("Optional. Specify the snapshot time to lease a snapshot.")
      @header
      `x-ms-snapshot`?: string;

      ...LeaseShareRequest;
    },
    LeaseShareResponse
  >;
}
