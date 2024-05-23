import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./FileServiceProperties.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Storage;
/**
 * Properties of the file share, including Id, resource name, resource type, Etag.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(FileServiceProperties)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(FileShareProperties)
model FileShare extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = FileShare,
    KeyName = "shareName",
    SegmentName = "shares",
    NamePattern = ""
  >;

  /**
   * Properties of the file share.
   */
  @extension("x-ms-client-flatten", true)
  properties?: FileShareProperties;
}

@armResourceOperations
interface FileShares {
  /**
   * Gets properties of a specified share.
   */
  get is ArmResourceRead<
    FileShare,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<FileShare>;

      /**
       * Optional, used to expand the properties within share's properties. Valid values are: stats. Should be passed as a string with delimiter ','.
       */
      @query("$expand")
      $expand?: string;

      /**
       * Optional, used to retrieve properties of a snapshot.
       */
      @header
      `x-ms-snapshot`?: string;
    }
  >;

  /**
   * Creates a new share under the specified account as described by request body. The share resource includes metadata and properties for that share. It does not include a list of the files contained by the share.
   */
  create is ArmResourceCreateOrReplaceSync<
    FileShare,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<FileShare>;

      /**
       * Optional, used to expand the properties within share's properties. Valid values are: snapshots. Should be passed as a string with delimiter ','
       */
      @query("$expand")
      $expand?: string;
    }
  >;

  /**
   * Updates share properties as specified in request body. Properties not mentioned in the request will not be changed. Update fails if the specified share does not already exist.
   */
  @parameterVisibility
  update is ArmCustomPatchSync<FileShare, FileShare>;

  /**
   * Deletes specified share under its account.
   */
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteSync<
    FileShare,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<FileShare>;

      /**
       * Optional, used to delete a snapshot.
       */
      @header
      `x-ms-snapshot`?: string;

      /**
       * Optional. Valid values are: snapshots, leased-snapshots, none. The default value is snapshots. For 'snapshots', the file share is deleted including all of its file share snapshots. If the file share contains leased-snapshots, the deletion fails. For 'leased-snapshots', the file share is deleted included all of its file share snapshots (leased/unleased). For 'none', the file share is deleted if it has no share snapshots. If the file share contains any snapshots (leased or unleased), the deletion fails.
       */
      @query("$include")
      $include?: string;
    }
  >;

  /**
   * Lists all shares.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("FileShares_List")
  list is ArmResourceListByParent<
    FileShare,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<FileShare>;

      /**
       * Optional. Specified maximum number of shares that can be included in the list.
       */
      @query("$maxpagesize")
      $maxpagesize?: string;

      /**
       * Optional. When specified, only share names starting with the filter will be listed.
       */
      @query("$filter")
      $filter?: string;

      /**
       * Optional, used to expand the properties within share's properties. Valid values are: deleted, snapshots. Should be passed as a string with delimiter ','
       */
      @query("$expand")
      $expand?: string;
    }
  >;

  /**
   * Restore a file share within a valid retention days if share soft delete is enabled
   */
  restore is ArmResourceActionSync<FileShare, DeletedShare, void>;

  /**
   * The Lease Share operation establishes and manages a lock on a share for delete operations. The lock duration can be 15 to 60 seconds, or can be infinite.
   */
  lease is ArmResourceActionSync<
    FileShare,
    LeaseShareRequest,
    LeaseShareResponse,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<FileShare>;

      /**
       * Optional. Specify the snapshot time to lease a snapshot.
       */
      @header
      `x-ms-snapshot`?: string;
    }
  >;
}

@@maxLength(FileShare.name, 63);
@@minLength(FileShare.name, 3);
@@doc(FileShare.name,
  "The name of the file share within the specified storage account. File share names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number."
);
@@encodedName(FileShares.create::parameters.resource,
  "application/json",
  "fileShare"
);
@@extension(FileShares.create::parameters.resource,
  "x-ms-client-name",
  "fileShare"
);
@@doc(FileShares.create::parameters.resource,
  "Properties of the file share to create."
);
@@encodedName(FileShares.update::parameters.properties,
  "application/json",
  "fileShare"
);
@@extension(FileShares.update::parameters.properties,
  "x-ms-client-name",
  "fileShare"
);
@@doc(FileShares.update::parameters.properties,
  "Properties to update for the file share."
);
@@encodedName(FileShares.restore::parameters.body,
  "application/json",
  "deletedShare"
);
@@extension(FileShares.restore::parameters.body,
  "x-ms-client-name",
  "deletedShare"
);
@@doc(FileShares.restore::parameters.body, "");
@@encodedName(FileShares.lease::parameters.body,
  "application/json",
  "parameters"
);
@@extension(FileShares.lease::parameters.body,
  "x-ms-client-name",
  "parameters"
);
@@doc(FileShares.lease::parameters.body, "Lease Share request body.");
