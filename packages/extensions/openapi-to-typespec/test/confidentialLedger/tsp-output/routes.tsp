import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Azure.Language.Authoring;

/**
 * The constitution is a script that assesses and applies proposals from
 * consortium members.
 */
@summary("Gets the constitution used for governance.")
@route("/app/governance/constitution")
@get
op getConstitution is Azure.Core.Foundations.Operation<{}, Constitution>;

/**
 * Consortium members can manage the Confidential Ledger.
 */
@summary("Lists the consortium members.")
op listConsortiumMembers is Azure.Core.ResourceList<ConsortiumMember>;

/**
 * A quote is an SGX enclave measurement that can be used to verify the validity
 * of a node and its enclave.
 */
@summary("Gets quotes for all nodes of the Confidential Ledger.")
op getEnclaveQuotes is Azure.Core.ResourceRead<ConfidentialLedgerEnclaves>;

/**
 * Collection ids are user-created collections of ledger entries
 */
@summary("Retrieves a list of collection ids present in the Confidential Ledger")
op listCollections is Azure.Core.ResourceList<Collection>;

/**
 * A collection id may optionally be specified. Only entries in the specified (or
 * default) collection will be returned.
 */
@summary("Gets ledger entries from a collection corresponding to a range.")
@route("/app/transactions")
@get
op listLedgerEntries is Azure.Core.Foundations.Operation<
  {
    /**
     * The collection id.
     */
    @query("collectionId")
    collectionId?: string;

    /**
     * Specify the first transaction ID in a range.
     */
    @query("fromTransactionId")
    fromTransactionId?: string;

    /**
     * Specify the last transaction ID in a range.
     */
    @query("toTransactionId")
    toTransactionId?: string;
  },
  PagedLedgerEntries
>;

/**
 * A collection id may optionally be specified.
 */
@summary("Writes a ledger entry.")
op createLedgerEntry is Azure.Core.ResourceCreateWithServiceProvidedName<
  LedgerWriteResult,
  {
    parameters: {
      /**
       * The collection id.
       */
      @query("collectionId")
      collectionId?: string;
    };
  }
>;

/**
 * To return older ledger entries, the relevant sections of the ledger must be
 * read from disk and validated. To prevent blocking within the enclave, the
 * response will indicate whether the entry is ready and part of the response, or
 * if the loading is still ongoing.
 */
@summary("""
Gets the ledger entry at the specified transaction id. A collection id may
optionally be specified to indicate the collection from which to fetch the
value.
""")
@route("/app/transactions/{transactionId}")
@get
op getLedgerEntry is Azure.Core.Foundations.Operation<
  {
    /**
     * The collection id.
     */
    @query("collectionId")
    collectionId?: string;

    /**
     * Identifies a write transaction.
     */
    @path
    transactionId: string;
  },
  LedgerQueryResult
>;

/**
 * Gets a receipt certifying ledger contents at a particular transaction id.
 */
@summary("Gets a receipt certifying ledger contents at a particular transaction id.")
op getReceipt is Azure.Core.ResourceRead<TransactionReceipt>;

/**
 * Gets the status of an entry identified by a transaction id.
 */
@summary("Gets the status of an entry identified by a transaction id.")
op getTransactionStatus is Azure.Core.ResourceRead<TransactionStatus>;

/**
 * A collection id may optionally be specified.
 */
@summary("Gets the current value available in the ledger.")
@route("/app/transactions/current")
@get
op getCurrentLedgerEntry is Azure.Core.Foundations.Operation<
  {
    /**
     * The collection id.
     */
    @query("collectionId")
    collectionId?: string;
  },
  LedgerEntry
>;

/**
 * Deletes a user from the Confidential Ledger.
 */
@summary("Deletes a user from the Confidential Ledger.")
@route("/app/users/{userId}")
@delete
op deleteUser is Azure.Core.Foundations.Operation<
  {
    /**
     * The user id, either an AAD object ID or certificate fingerprint.
     */
    @path
    userId: string;
  },
  void
>;

/**
 * Gets a user.
 */
@summary("Gets a user.")
@route("/app/users/{userId}")
@get
op getUser is Azure.Core.Foundations.Operation<
  {
    /**
     * The user id, either an AAD object ID or certificate fingerprint.
     */
    @path
    userId: string;
  },
  LedgerUser
>;

/**
 * A JSON merge patch is applied for existing users
 */
@summary("Adds a user or updates a user's fields.")
@route("/app/users/{userId}")
@patch
op createOrUpdateUser is Azure.Core.Foundations.Operation<
  {
    /**
     * The user id, either an AAD object ID or certificate fingerprint.
     */
    @path
    userId: string;

    /**
     * Details about a Confidential Ledger user.
     */
    @body
    userDetails: LedgerUser;
  },
  LedgerUser
>;
