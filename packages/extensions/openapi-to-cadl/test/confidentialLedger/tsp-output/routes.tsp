import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Azure.Language.Authoring;

@summary("Gets the constitution used for governance.")
@doc("""
The constitution is a script that assesses and applies proposals from
consortium members.
""")
@route("/app/governance/constitution")
@get
op GetConstitution is Azure.Core.Foundations.Operation<{}, Constitution>;

@summary("Lists the consortium members.")
@doc("Consortium members can manage the Confidential Ledger.")
op ListConsortiumMembers is Azure.Core.ResourceList<ConsortiumMember>;

@summary("Gets quotes for all nodes of the Confidential Ledger.")
@doc("""
A quote is an SGX enclave measurement that can be used to verify the validity
of a node and its enclave.
""")
op GetEnclaveQuotes is Azure.Core.ResourceRead<ConfidentialLedgerEnclaves>;

@summary("Retrieves a list of collection ids present in the Confidential Ledger")
@doc("Collection ids are user-created collections of ledger entries")
op ListCollections is Azure.Core.ResourceList<Collection>;

@summary("Gets ledger entries from a collection corresponding to a range.")
@doc("""
A collection id may optionally be specified. Only entries in the specified (or
default) collection will be returned.
""")
@route("/app/transactions")
@get
op ListLedgerEntries is Azure.Core.Foundations.Operation<
  {
    @doc("The collection id.")
    @query
    collectionId: string;

    @doc("Specify the first transaction ID in a range.")
    @query
    fromTransactionId: string;

    @doc("Specify the last transaction ID in a range.")
    @query
    toTransactionId: string;
  },
  PagedLedgerEntries
>;

@summary("Writes a ledger entry.")
@doc("A collection id may optionally be specified.")
op CreateLedgerEntry is Azure.Core.ResourceCreateWithServiceProvidedName<
  LedgerWriteResult,
  {
    parameters: {
      @doc("The collection id.")
      @query
      collectionId: string;
    };
  }
>;

@summary("""
Gets the ledger entry at the specified transaction id. A collection id may
optionally be specified to indicate the collection from which to fetch the
value.
""")
@doc("""
To return older ledger entries, the relevant sections of the ledger must be
read from disk and validated. To prevent blocking within the enclave, the
response will indicate whether the entry is ready and part of the response, or
if the loading is still ongoing.
""")
@route("/app/transactions/{transactionId}")
@get
op GetLedgerEntry is Azure.Core.Foundations.Operation<
  {
    @doc("The collection id.")
    @query
    collectionId: string;

    @doc("Identifies a write transaction.")
    @path
    transactionId: string;
  },
  LedgerQueryResult
>;

@summary("Gets a receipt certifying ledger contents at a particular transaction id.")
@doc("Gets a receipt certifying ledger contents at a particular transaction id.")
op GetReceipt is Azure.Core.ResourceRead<TransactionReceipt>;

@summary("Gets the status of an entry identified by a transaction id.")
@doc("Gets the status of an entry identified by a transaction id.")
op GetTransactionStatus is Azure.Core.ResourceRead<TransactionStatus>;

@summary("Gets the current value available in the ledger.")
@doc("A collection id may optionally be specified.")
@route("/app/transactions/current")
@get
op GetCurrentLedgerEntry is Azure.Core.Foundations.Operation<
  {
    @doc("The collection id.")
    @query
    collectionId: string;
  },
  LedgerEntry
>;

@summary("Deletes a user from the Confidential Ledger.")
@doc("Deletes a user from the Confidential Ledger.")
@route("/app/users/{userId}")
@delete
op DeleteUser is Azure.Core.Foundations.Operation<
  {
    @doc("The user id, either an AAD object ID or certificate fingerprint.")
    @path
    userId: string;
  },
  void
>;

@summary("Gets a user.")
@doc("Gets a user.")
@route("/app/users/{userId}")
@get
op GetUser is Azure.Core.Foundations.Operation<
  {
    @doc("The user id, either an AAD object ID or certificate fingerprint.")
    @path
    userId: string;
  },
  LedgerUser
>;

@summary("Adds a user or updates a user's fields.")
@doc("A JSON merge patch is applied for existing users")
@route("/app/users/{userId}")
@patch
op CreateOrUpdateUser is Azure.Core.Foundations.Operation<
  {
    @doc("The user id, either an AAD object ID or certificate fingerprint.")
    @path
    userId: string;

    @doc("Details about a Confidential Ledger user.")
    @body
    userDetails: LedgerUser;
  },
  LedgerUser
>;
