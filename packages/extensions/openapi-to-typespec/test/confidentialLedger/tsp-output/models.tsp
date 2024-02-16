import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;

namespace Azure.Language.Authoring;

/**
 * State of a ledger query.
 */
enum ConfidentialLedgerQueryState {
  Loading,
  Ready,
}

/**
 * Represents the state of the transaction.
 */
enum TransactionState {
  Committed,
  Pending,
}

/**
 * Represents an assignable role.
 */
enum ConfidentialLedgerUserRoleName {
  Administrator,
  Contributor,
  Reader,
}

/**
 * The governance script for the application.
 */
model Constitution {
  /**
   * SHA256 digest of the constitution script.
   */
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  digest: string;

  /**
   * Contents of the constitution.
   */
  script: string;
}

/**
 * An error response from Confidential Ledger.
 */
@error
model ConfidentialLedgerError {
  /**
   * An error response from Confidential Ledger.
   */
  @visibility("read")
  error?: ConfidentialLedgerErrorBody;
}

/**
 * An error response from Confidential Ledger.
 */
model ConfidentialLedgerErrorBody {
  /**
   * The error code.
   */
  @visibility("read")
  code?: string;

  /**
   * The error message.
   */
  @visibility("read")
  message?: string;
}

/**
 * List of members in the consortium.
 */
@pagedResult
model Consortium {
  @items
  members: ConsortiumMember[];

  /**
   * Path from which to retrieve the next page of results.
   */
  @nextLink
  nextLink?: string;
}

/**
 * Describes a member of the consortium.
 */
@resource("app/governance/members")
model ConsortiumMember {
  /**
   * PEM-encoded certificate associated with the member.
   */
  certificate: string;

  /**
   * Identifier assigned to the member.
   */
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  id: string;
}

/**
 * Information about the enclaves running the Confidential Ledger.
 */
@resource("app/enclaveQuotes")
model ConfidentialLedgerEnclaves {
  /**
   * Id of the Confidential Ledger node responding to the request.
   */
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  currentNodeId: string;

  /**
   * Dictionary of enclave quotes, indexed by node id.
   */
  enclaveQuotes: Record<EnclaveQuote>;
}

/**
 * Contains the enclave quote.
 */
model EnclaveQuote {
  /**
   * ID assigned to this node.
   */
  nodeId: string;

  /**
   * MRENCLAVE value of the code running in the enclave.
   */
  mrenclave?: string;

  /**
   * Version of the quote presented.
   */
  quoteVersion: string;

  /**
   * Raw SGX quote, parsable by tools like Open Enclave's oeverify.
   */
  raw: string;
}

/**
 * Paginated collections returned in response to a query.
 */
@pagedResult
model PagedCollections {
  @items
  collections: Collection[];

  /**
   * Path from which to retrieve the next page of results.
   */
  @nextLink
  nextLink?: string;
}

/**
 * Identifier for collections.
 */
@resource("app/collections")
model Collection {
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  collectionId: string;
}

/**
 * Paginated ledger entries returned in response to a query.
 */
@pagedResult
model PagedLedgerEntries {
  /**
   * State of a ledger query.
   */
  state: ConfidentialLedgerQueryState;

  /**
   * Path from which to retrieve the next page of results.
   */
  @nextLink
  nextLink?: string;

  /**
   * Array of ledger entries.
   */
  @items
  entries: LedgerEntry[];
}

/**
 * An entry in the ledger.
 */
model LedgerEntry {
  /**
   * Contents of the ledger entry.
   */
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  contents: string;

  @visibility("read")
  collectionId?: string;

  /**
   * A unique identifier for the state of the ledger. If returned as part of a
   * LedgerEntry, it indicates the state from which the entry was read.
   */
  @visibility("read")
  transactionId?: string;
}

/**
 * Returned as a result of a write to the Confidential Ledger, the transaction id
 * in the response indicates when the write will become durable.
 */
@resource("app/transactions")
model LedgerWriteResult {
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  collectionId: string;
}

/**
 * The result of querying for a ledger entry from an older transaction id. The
 * ledger entry is available in the response only if the returned state is Ready.
 */
model LedgerQueryResult {
  /**
   * State of a ledger query.
   */
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  state: ConfidentialLedgerQueryState;

  /**
   * The ledger entry found as a result of the query. This is only available if the
   * query is in Ready state.
   */
  entry?: LedgerEntry;
}

/**
 * A receipt certifying the transaction at the specified id.
 */
@resource("app/transactions/{transactionId}/receipt")
model TransactionReceipt {
  receipt?: ReceiptContents;

  /**
   * State of a ledger query.
   */
  state: ConfidentialLedgerQueryState;

  /**
   * A unique identifier for the state of the ledger. If returned as part of a
   * LedgerEntry, it indicates the state from which the entry was read.
   */
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  transactionId: string;
}

model ReceiptContents {
  cert?: string;
  leaf?: string;
  leafComponents?: ReceiptLeafComponents;
  nodeId: string;
  proof: ReceiptElement[];
  root?: string;
  serviceEndorsements?: string[];
  signature: string;
}

model ReceiptLeafComponents {
  claimsDigest?: string;
  commitEvidence?: string;
  writeSetDigest?: string;
}

model ReceiptElement {
  left?: string;
  right?: string;
}

/**
 * Response returned to a query for the transaction status
 */
@resource("app/transactions/{transactionId}/status")
model TransactionStatus {
  /**
   * Represents the state of the transaction.
   */
  state: TransactionState;

  /**
   * A unique identifier for the state of the ledger. If returned as part of a
   * LedgerEntry, it indicates the state from which the entry was read.
   */
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  transactionId: string;
}

/**
 * Details about a Confidential Ledger user.
 */
model LedgerUser {
  /**
   * Represents an assignable role.
   */
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  assignedRole: ConfidentialLedgerUserRoleName;

  /**
   * Identifier for the user. This must either be an AAD object id or a certificate
   * fingerprint.
   */
  @visibility("read")
  userId?: string;
}

/**
 * An item in the Merkle proof.
 */
model MerkleProofElement {
  left?: string;
  right?: string;
}

/**
 * Object for assigning a role to a user.
 */
model RoleAssignment {
  /**
   * Represents an assignable role.
   */
  roleName: ConfidentialLedgerUserRoleName;

  /**
   * Description of the role.
   */
  description?: string;
}
