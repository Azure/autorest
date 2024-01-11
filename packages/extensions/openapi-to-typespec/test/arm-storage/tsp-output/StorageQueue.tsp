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
  @doc("A queue name must be unique within a storage account and must be between 3 and 63 characters.The name must comprise of lowercase alphanumeric and dash(-) characters only, it should begin and end with an alphanumeric character and it cannot have two consecutive dash(-) characters.")
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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the queue with the specified queue name, under the specified account if it exists.")
  @operationId("Queue_Get")
  get is ArmResourceRead<StorageQueue>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates a new queue with the specified queue name, under the specified account.")
  @operationId("Queue_Create")
  create is ArmResourceCreateOrReplaceSync<StorageQueue>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates a new queue with the specified queue name, under the specified account.")
  @operationId("Queue_Update")
  update is ArmCustomPatchSync<StorageQueue, StorageQueue>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deletes the queue with the specified queue name, under the specified account if it exists.")
  @operationId("Queue_Delete")
  delete is ArmResourceDeleteSync<StorageQueue>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets a list of all the queues under the specified storage account")
  @operationId("Queue_List")
  list is ArmResourceListByParent<
    StorageQueue,
    {
      ...BaseParameters<StorageQueue>;

      @doc("Optional, a maximum number of queues that should be included in a list queue response")
      @query("$maxpagesize")
      $maxpagesize?: string;

      @doc("Optional, When specified, only the queues with a name starting with the given filter will be listed.")
      @query("$filter")
      $filter?: string;
    }
  >;
}
