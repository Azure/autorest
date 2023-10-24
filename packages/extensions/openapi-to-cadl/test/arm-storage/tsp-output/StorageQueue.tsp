import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./QueueServiceProperty.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Storage;

@parentResource(QueueServiceProperty)
model StorageQueue is ProxyResource<QueueProperties> {
  @doc("""
A queue name must be unique within a storage account and must be between 3 and
63 characters.The name must comprise of lowercase alphanumeric and dash(-)
characters only, it should begin and end with an alphanumeric character and it
cannot have two consecutive dash(-) characters.
""")
  @maxLength(63)
  @minLength(3)
  @pattern("^[a-z0-9]([a-z0-9]|(-(?!-))){1,61}[a-z0-9]$")
  @path
  @key("queueName")
  @segment("queues")
  name: string;
}

@armResourceOperations
interface StorageQueues {
  @doc("""
Gets the queue with the specified queue name, under the specified account if it
exists.
""")
  get is ArmResourceRead<StorageQueue>;
  @doc("Creates a new queue with the specified queue name, under the specified account.")
  create is ArmResourceCreateOrUpdateAsync<StorageQueue>;
  @doc("Creates a new queue with the specified queue name, under the specified account.")
  update is ArmResourcePatchSync<StorageQueue, QueueProperties>;
  @doc("""
Deletes the queue with the specified queue name, under the specified account if
it exists.
""")
  delete is ArmResourceDeleteWithoutOkAsync<StorageQueue>;
  @doc("Gets a list of all the queues under the specified storage account")
  list is ArmResourceListByParent<
    StorageQueue,
    {
      @doc("""
Optional, a maximum number of queues that should be included in a list queue
response
""")
      @query("$maxpagesize")
      $maxpagesize?: string;

      @doc("""
Optional, When specified, only the queues with a name starting with the given
filter will be listed.
""")
      @query("$filter")
      $filter?: string;
    }
  >;
}
