import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;

namespace Azure.Language.Authoring;

enum ConfidentialLedgerQueryState {
  Loading,
  Ready,
}

enum TransactionState {
  Committed,
  Pending,
}

enum ConfidentialLedgerUserRoleName {
  Administrator,
  Contributor,
  Reader,
}

@doc("The governance script for the application.")
model Constitution {
  @doc("SHA256 digest of the constitution script.")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  digest: string;

  @doc("Contents of the constitution.")
  script: string;
}

@doc("An error response from Confidential Ledger.")
@error
model ConfidentialLedgerError {
  @doc("An error response from Confidential Ledger.")
  @visibility("read")
  error?: ConfidentialLedgerErrorBody;
}

@doc("An error response from Confidential Ledger.")
model ConfidentialLedgerErrorBody {
  @doc("The error code.")
  @visibility("read")
  code?: string;

  @doc("The error message.")
  @visibility("read")
  message?: string;
}

@doc("List of members in the consortium.")
@pagedResult
model Consortium {
  @items
  members: ConsortiumMember[];

  @doc("Path from which to retrieve the next page of results.")
  @nextLink
  nextLink?: string;
}

@doc("Describes a member of the consortium.")
@resource("app/governance/members")
model ConsortiumMember {
  @doc("PEM-encoded certificate associated with the member.")
  certificate: string;

  @doc("Identifier assigned to the member.")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  id: string;
}

@doc("Information about the enclaves running the Confidential Ledger.")
@resource("app/enclaveQuotes")
model ConfidentialLedgerEnclaves {
  @doc("Id of the Confidential Ledger node responding to the request.")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  currentNodeId: string;

  @doc("Dictionary of enclave quotes, indexed by node id.")
  enclaveQuotes: Record<EnclaveQuote>;
}

@doc("Contains the enclave quote.")
model EnclaveQuote {
  @doc("ID assigned to this node.")
  nodeId: string;

  @doc("MRENCLAVE value of the code running in the enclave.")
  mrenclave?: string;

  @doc("Version of the quote presented.")
  quoteVersion: string;

  @doc("Raw SGX quote, parsable by tools like Open Enclave's oeverify.")
  raw: string;
}

@doc("Paginated collections returned in response to a query.")
@pagedResult
model PagedCollections {
  @items
  collections: Collection[];

  @doc("Path from which to retrieve the next page of results.")
  @nextLink
  nextLink?: string;
}

@doc("Identifier for collections.")
@resource("app/collections")
model Collection {
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  collectionId: string;
}

@doc("Paginated ledger entries returned in response to a query.")
@pagedResult
model PagedLedgerEntries {
  @doc("State of a ledger query.")
  state: ConfidentialLedgerQueryState;

  @doc("Path from which to retrieve the next page of results.")
  @nextLink
  nextLink?: string;

  @doc("Array of ledger entries.")
  @items
  entries: LedgerEntry[];
}

@doc("An entry in the ledger.")
model LedgerEntry {
  @doc("Contents of the ledger entry.")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  contents: string;

  @visibility("read")
  collectionId?: string;

  @doc("""
A unique identifier for the state of the ledger. If returned as part of a
LedgerEntry, it indicates the state from which the entry was read.
""")
  @visibility("read")
  transactionId?: string;
}

@doc("""
Returned as a result of a write to the Confidential Ledger, the transaction id
in the response indicates when the write will become durable.
""")
@resource("app/transactions")
model LedgerWriteResult {
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  collectionId: string;
}

@doc("""
The result of querying for a ledger entry from an older transaction id. The
ledger entry is available in the response only if the returned state is Ready.
""")
model LedgerQueryResult {
  @doc("State of a ledger query.")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  state: ConfidentialLedgerQueryState;

  @doc("""
The ledger entry found as a result of the query. This is only available if the
query is in Ready state.
""")
  entry?: LedgerEntry;
}

@doc("A receipt certifying the transaction at the specified id.")
@resource("app/transactions/{transactionId}/receipt")
model TransactionReceipt {
  receipt?: ReceiptContents;

  @doc("State of a ledger query.")
  state: ConfidentialLedgerQueryState;

  @doc("""
A unique identifier for the state of the ledger. If returned as part of a
LedgerEntry, it indicates the state from which the entry was read.
""")
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

@doc("Response returned to a query for the transaction status")
@resource("app/transactions/{transactionId}/status")
model TransactionStatus {
  @doc("Represents the state of the transaction.")
  state: TransactionState;

  @doc("""
A unique identifier for the state of the ledger. If returned as part of a
LedgerEntry, it indicates the state from which the entry was read.
""")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  transactionId: string;
}

@doc("Details about a Confidential Ledger user.")
model LedgerUser {
  @doc("Represents an assignable role.")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  assignedRole: ConfidentialLedgerUserRoleName;

  @doc("""
Identifier for the user. This must either be an AAD object id or a certificate
fingerprint.
""")
  @visibility("read")
  userId?: string;
}

@doc("An item in the Merkle proof.")
model MerkleProofElement {
  left?: string;
  right?: string;
}

@doc("Object for assigning a role to a user.")
model RoleAssignment {
  @doc("Represents an assignable role.")
  roleName: ConfidentialLedgerUserRoleName;

  @doc("Description of the role.")
  description?: string;
}
