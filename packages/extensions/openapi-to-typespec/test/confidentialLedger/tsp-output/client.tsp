import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Azure.Language.Authoring;

@@clientName(getConstitution, "GetConstitution");
@@clientName(listConsortiumMembers, "ListConsortiumMembers");
@@clientName(getEnclaveQuotes, "GetEnclaveQuotes");
@@clientName(listCollections, "ListCollections");
@@clientName(listLedgerEntries, "ListLedgerEntries");
@@clientName(createLedgerEntry, "CreateLedgerEntry");
@@clientName(getLedgerEntry, "GetLedgerEntry");
@@clientName(getReceipt, "GetReceipt");
@@clientName(getTransactionStatus, "GetTransactionStatus");
@@clientName(getCurrentLedgerEntry, "GetCurrentLedgerEntry");
@@clientName(deleteUser, "DeleteUser");
@@clientName(getUser, "GetUser");
@@clientName(createOrUpdateUser, "CreateOrUpdateUser");
