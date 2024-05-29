import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./QueueServiceProperties.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Storage;

#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(QueueServiceProperties)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(QueueProperties)
model StorageQueue extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = StorageQueue,
    KeyName = "queueName",
    SegmentName = "queues",
    NamePattern = "^[a-z0-9]([a-z0-9]|(-(?!-))){1,61}[a-z0-9]$"
  >;

  /**
   * Queue resource properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: QueueProperties;
}

@armResourceOperations
interface StorageQueues {
  /**
   * Gets the queue with the specified queue name, under the specified account if it exists.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Queue_Get")
  get is ArmResourceRead<StorageQueue>;

  /**
   * Creates a new queue with the specified queue name, under the specified account.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Queue_Create")
  create is ArmResourceCreateOrReplaceSync<StorageQueue>;

  /**
   * Creates a new queue with the specified queue name, under the specified account.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility
  @operationId("Queue_Update")
  update is ArmCustomPatchSync<StorageQueue, StorageQueue>;

  /**
   * Deletes the queue with the specified queue name, under the specified account if it exists.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("Queue_Delete")
  delete is ArmResourceDeleteSync<StorageQueue>;

  /**
   * Gets a list of all the queues under the specified storage account
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Queue_List")
  list is ArmResourceListByParent<
    StorageQueue,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<StorageQueue>;

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

@@maxLength(StorageQueue.name, 63);
@@minLength(StorageQueue.name, 3);
@@doc(StorageQueue.name,
  "A queue name must be unique within a storage account and must be between 3 and 63 characters.The name must comprise of lowercase alphanumeric and dash(-) characters only, it should begin and end with an alphanumeric character and it cannot have two consecutive dash(-) characters."
);
@@encodedName(StorageQueues.create::parameters.resource,
  "application/json",
  "queue"
);
@@extension(StorageQueues.create::parameters.resource,
  "x-ms-client-name",
  "queue"
);
@@doc(StorageQueues.create::parameters.resource,
  "Queue properties and metadata to be created with"
);
@@encodedName(StorageQueues.update::parameters.properties,
  "application/json",
  "queue"
);
@@extension(StorageQueues.update::parameters.properties,
  "x-ms-client-name",
  "queue"
);
@@doc(StorageQueues.update::parameters.properties,
  "Queue properties and metadata to be created with"
);
