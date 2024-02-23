import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./QueueServiceProperties.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Storage;

@parentResource(QueueServiceProperties)
model StorageQueue is ProxyResource<QueueProperties> {
  /**
   * A queue name must be unique within a storage account and must be between 3 and 63 characters.The name must comprise of lowercase alphanumeric and dash(-) characters only, it should begin and end with an alphanumeric character and it cannot have two consecutive dash(-) characters.
   */
  @maxLength(63)
  @minLength(3)
  @pattern("^[a-z0-9]([a-z0-9]|(-(?!-))){1,61}[a-z0-9]$")
  @path
  @key("queueName")
  @segment("queues")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface StorageQueues {
  /**
   * Gets the queue with the specified queue name, under the specified account if it exists.
   */
  get is ArmResourceRead<StorageQueue>;

  /**
   * Creates a new queue with the specified queue name, under the specified account.
   */
  create is ArmResourceCreateOrReplaceSync<StorageQueue>;

  /**
   * Creates a new queue with the specified queue name, under the specified account.
   */
  @parameterVisibility("read")
  update is ArmCustomPatchSync<StorageQueue, StorageQueue>;

  /**
   * Deletes the queue with the specified queue name, under the specified account if it exists.
   */
  delete is ArmResourceDeleteSync<StorageQueue>;

  /**
   * Gets a list of all the queues under the specified storage account
   */
  list is ArmResourceListByParent<
    StorageQueue,
    {
      ...BaseParameters<StorageQueue>;

      /**
       * Optional, a maximum number of queues that should be included in a list queue response
       */
      @query("$maxpagesize")
      $maxpagesize?: string;

      /**
       * Optional, When specified, only the queues with a name starting with the given filter will be listed.
       */
      @query("$filter")
      $filter?: string;
    }
  >;
}

@@doc(StorageQueues.create::parameters.resource,
  "Queue properties and metadata to be created with"
);
@@doc(StorageQueues.update::parameters.properties,
  "Queue properties and metadata to be created with"
);
