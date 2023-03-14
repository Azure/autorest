import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Azure.Keyvault;

@doc("""
Creates a full backup using a user-provided SAS token to an Azure blob storage
container.
""")
@route("/backup")
@post
op FullBackup is Azure.Core.Foundations.Operation<
  {
    @doc("""
Azure blob shared access signature token pointing to a valid Azure blob
container where full backup needs to be stored. This token needs to be valid
for at least next 24 hours from the time of making this call
""")
    @body
    azureStorageBlobContainerUri: SASTokenParameter;
  },
  FullBackupOperation
>;

@doc("Returns the status of full backup operation")
@route("/backup/{jobId}/pending")
@get
op FullBackupStatus is Azure.Core.Foundations.Operation<
  {
    @doc("The id returned as part of the backup request")
    @path
    jobId: string;
  },
  FullBackupOperation
>;

@doc("""
Restores all key materials using the SAS token pointing to a previously stored
Azure Blob storage backup folder
""")
@route("/restore")
@put
op FullRestoreOperation is Azure.Core.Foundations.Operation<
  {
    @doc("""
The Azure blob SAS token pointing to a folder where the previous successful
full backup was stored
""")
    @body
    restoreBlobDetails: RestoreOperationParameters;
  },
  RestoreOperation
>;

@doc("Returns the status of restore operation")
@route("/restore/{jobId}/pending")
@get
op RestoreStatus is Azure.Core.Foundations.Operation<
  {
    @doc("The Job Id returned part of the restore operation")
    @path
    jobId: string;
  },
  RestoreOperation
>;

@doc("""
Restores all key versions of a given key using user supplied SAS token pointing
to a previously stored Azure Blob storage backup folder
""")
// FIXME: (name-collision-error) There is a potential collision with Operation, Parameter and Response names.
// Problematic names: [SelectiveKeyRestoreOperation]
@route("/keys/{keyName}/restore")
@put
op SelectiveKeyRestoreOperation is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the key to be restored from the user supplied backup")
    @path
    keyName: string;

    @doc("""
The Azure blob SAS token pointing to a folder where the previous successful
full backup was stored
""")
    @body
    restoreBlobDetails: SelectiveKeyRestoreOperationParameters;
  },
  SelectiveKeyRestoreOperation
>;

@summary("List certificates in a specified key vault")
@doc("""
The GetCertificates operation returns the set of certificates resources in the
specified key vault. This operation requires the certificates/list permission.
""")
@route("/certificates")
@get
op GetCertificates is Azure.Core.Foundations.Operation<
  {
    @doc("""
Maximum number of results to return in a page. If not specified the service
will return up to 25 results.
""")
    @query
    maxresults: int32;

    @doc("Specifies whether to include certificates which are not completely provisioned.")
    @query
    includePending: boolean;
  },
  CertificateListResult
>;

@summary("Deletes a certificate from a specified key vault.")
@doc("""
Deletes all versions of a certificate object along with its associated policy.
Delete certificate cannot be used to remove individual versions of a
certificate object. This operation requires the certificates/delete permission.
""")
@route("/certificates/{certificate-name}")
@delete
op DeleteCertificate is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the certificate.")
    @path
    `certificate-name`: string;
  },
  DeletedCertificateBundle
>;

@summary("Sets the certificate contacts for the specified key vault.")
@doc("""
Sets the certificate contacts for the specified key vault. This operation
requires the certificates/managecontacts permission.
""")
@route("/certificates/contacts")
@put
op SetCertificateContacts is Azure.Core.Foundations.Operation<
  {
    @doc("The contacts for the key vault certificate.")
    @body
    contacts: Contacts;
  },
  Contacts
>;

@summary("Lists the certificate contacts for a specified key vault.")
@doc("""
The GetCertificateContacts operation returns the set of certificate contact
resources in the specified key vault. This operation requires the
certificates/managecontacts permission.
""")
@route("/certificates/contacts")
@get
op GetCertificateContacts is Azure.Core.Foundations.Operation<{}, Contacts>;

@summary("Deletes the certificate contacts for a specified key vault.")
@doc("""
Deletes the certificate contacts for a specified key vault certificate. This
operation requires the certificates/managecontacts permission.
""")
@route("/certificates/contacts")
@delete
op DeleteCertificateContacts is Azure.Core.Foundations.Operation<{}, Contacts>;

@summary("List certificate issuers for a specified key vault.")
@doc("""
The GetCertificateIssuers operation returns the set of certificate issuer
resources in the specified key vault. This operation requires the
certificates/manageissuers/getissuers permission.
""")
@route("/certificates/issuers")
@get
op GetCertificateIssuers is Azure.Core.Foundations.Operation<
  {
    @doc("""
Maximum number of results to return in a page. If not specified the service
will return up to 25 results.
""")
    @query
    maxresults: int32;
  },
  CertificateIssuerListResult
>;

@summary("Sets the specified certificate issuer.")
@doc("""
The SetCertificateIssuer operation adds or updates the specified certificate
issuer. This operation requires the certificates/setissuers permission.
""")
@route("/certificates/issuers/{issuer-name}")
@put
op SetCertificateIssuer is Azure.Core.Foundations.Operation<
  {
    @doc("""
The name of the issuer. The value you provide may be copied globally for the
purpose of running the service. The value provided should not include
personally identifiable or sensitive information.
""")
    @path
    `issuer-name`: string;

    @doc("Certificate issuer set parameter.")
    @body
    parameter: CertificateIssuerSetParameters;
  },
  IssuerBundle
>;

@summary("Updates the specified certificate issuer.")
@doc("""
The UpdateCertificateIssuer operation performs an update on the specified
certificate issuer entity. This operation requires the certificates/setissuers
permission.
""")
@route("/certificates/issuers/{issuer-name}")
@patch
op UpdateCertificateIssuer is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the issuer.")
    @path
    `issuer-name`: string;

    @doc("Certificate issuer update parameter.")
    @body
    parameter: CertificateIssuerUpdateParameters;
  },
  IssuerBundle
>;

@summary("Lists the specified certificate issuer.")
@doc("""
The GetCertificateIssuer operation returns the specified certificate issuer
resources in the specified key vault. This operation requires the
certificates/manageissuers/getissuers permission.
""")
@route("/certificates/issuers/{issuer-name}")
@get
op GetCertificateIssuer is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the issuer.")
    @path
    `issuer-name`: string;
  },
  IssuerBundle
>;

@summary("Deletes the specified certificate issuer.")
@doc("""
The DeleteCertificateIssuer operation permanently removes the specified
certificate issuer from the vault. This operation requires the
certificates/manageissuers/deleteissuers permission.
""")
@route("/certificates/issuers/{issuer-name}")
@delete
op DeleteCertificateIssuer is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the issuer.")
    @path
    `issuer-name`: string;
  },
  IssuerBundle
>;

@summary("Creates a new certificate.")
@doc("""
If this is the first version, the certificate resource is created. This
operation requires the certificates/create permission.
""")
@route("/certificates/{certificate-name}/create")
@post
op CreateCertificate is Azure.Core.Foundations.Operation<
  {
    @doc("""
The name of the certificate. The value you provide may be copied globally for
the purpose of running the service. The value provided should not include
personally identifiable or sensitive information.
""")
    @path
    `certificate-name`: string;

    @doc("The parameters to create a certificate.")
    @body
    parameters: CertificateCreateParameters;
  },
  CertificateOperation
>;

@summary("Imports a certificate into a specified key vault.")
@doc("""
Imports an existing valid certificate, containing a private key, into Azure Key
Vault. This operation requires the certificates/import permission. The
certificate to be imported can be in either PFX or PEM format. If the
certificate is in PEM format the PEM file must contain the key as well as x509
certificates. Key Vault will only accept a key in PKCS#8 format.
""")
@route("/certificates/{certificate-name}/import")
@post
op ImportCertificate is Azure.Core.Foundations.Operation<
  {
    @doc("""
The name of the certificate. The value you provide may be copied globally for
the purpose of running the service. The value provided should not include
personally identifiable or sensitive information.
""")
    @path
    `certificate-name`: string;

    @doc("The parameters to import the certificate.")
    @body
    parameters: CertificateImportParameters;
  },
  CertificateBundle
>;

@summary("List the versions of a certificate.")
@doc("""
The GetCertificateVersions operation returns the versions of a certificate in
the specified key vault. This operation requires the certificates/list
permission.
""")
@route("/certificates/{certificate-name}/versions")
@get
op GetCertificateVersions is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the certificate.")
    @path
    `certificate-name`: string;

    @doc("""
Maximum number of results to return in a page. If not specified the service
will return up to 25 results.
""")
    @query
    maxresults: int32;
  },
  CertificateListResult
>;

@summary("Lists the policy for a certificate.")
@doc("""
The GetCertificatePolicy operation returns the specified certificate policy
resources in the specified key vault. This operation requires the
certificates/get permission.
""")
@route("/certificates/{certificate-name}/policy")
@get
op GetCertificatePolicy is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the certificate in a given key vault.")
    @path
    `certificate-name`: string;
  },
  CertificatePolicy
>;

@summary("Updates the policy for a certificate.")
@doc("""
Set specified members in the certificate policy. Leave others as null. This
operation requires the certificates/update permission.
""")
@route("/certificates/{certificate-name}/policy")
@patch
op UpdateCertificatePolicy is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the certificate in the given vault.")
    @path
    `certificate-name`: string;

    @doc("The policy for the certificate.")
    @body
    certificatePolicy: CertificatePolicy;
  },
  CertificatePolicy
>;

@summary("Updates the specified attributes associated with the given certificate.")
@doc("""
The UpdateCertificate operation applies the specified update on the given
certificate; the only elements updated are the certificate's attributes. This
operation requires the certificates/update permission.
""")
@route("/certificates/{certificate-name}/{certificate-version}")
@patch
op UpdateCertificate is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the certificate in the given key vault.")
    @path
    `certificate-name`: string;

    @doc("The version of the certificate.")
    @path
    `certificate-version`: string;

    @doc("The parameters for certificate update.")
    @body
    parameters: CertificateUpdateParameters;
  },
  CertificateBundle
>;

@summary("Gets information about a certificate.")
@doc("""
Gets information about a specific certificate. This operation requires the
certificates/get permission.
""")
@route("/certificates/{certificate-name}/{certificate-version}")
@get
op GetCertificate is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the certificate in the given vault.")
    @path
    `certificate-name`: string;

    @doc("""
The version of the certificate. This URI fragment is optional. If not
specified, the latest version of the certificate is returned.
""")
    @path
    `certificate-version`: string;
  },
  CertificateBundle
>;

@summary("Updates a certificate operation.")
@doc("""
Updates a certificate creation operation that is already in progress. This
operation requires the certificates/update permission.
""")
@route("/certificates/{certificate-name}/pending")
@patch
op UpdateCertificateOperation is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the certificate.")
    @path
    `certificate-name`: string;

    @doc("The certificate operation response.")
    @body
    certificateOperation: CertificateOperationUpdateParameter;
  },
  CertificateOperation
>;

@summary("Gets the creation operation of a certificate.")
@doc("""
Gets the creation operation associated with a specified certificate. This
operation requires the certificates/get permission.
""")
@route("/certificates/{certificate-name}/pending")
@get
op GetCertificateOperation is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the certificate.")
    @path
    `certificate-name`: string;
  },
  CertificateOperation
>;

@summary("Deletes the creation operation for a specific certificate.")
@doc("""
Deletes the creation operation for a specified certificate that is in the
process of being created. The certificate is no longer created. This operation
requires the certificates/update permission.
""")
@route("/certificates/{certificate-name}/pending")
@delete
op DeleteCertificateOperation is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the certificate.")
    @path
    `certificate-name`: string;
  },
  CertificateOperation
>;

@summary("""
Merges a certificate or a certificate chain with a key pair existing on the
server.
""")
@doc("""
The MergeCertificate operation performs the merging of a certificate or
certificate chain with a key pair currently available in the service. This
operation requires the certificates/create permission.
""")
@route("/certificates/{certificate-name}/pending/merge")
@post
op MergeCertificate is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the certificate.")
    @path
    `certificate-name`: string;

    @doc("The parameters to merge certificate.")
    @body
    parameters: CertificateMergeParameters;
  },
  CertificateBundle
>;

@summary("Backs up the specified certificate.")
@doc("""
Requests that a backup of the specified certificate be downloaded to the
client. All versions of the certificate will be downloaded. This operation
requires the certificates/backup permission.
""")
@route("/certificates/{certificate-name}/backup")
@post
op BackupCertificate is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the certificate.")
    @path
    `certificate-name`: string;
  },
  BackupCertificateResult
>;

@summary("Restores a backed up certificate to a vault.")
@doc("""
Restores a backed up certificate, and all its versions, to a vault. This
operation requires the certificates/restore permission.
""")
@route("/certificates/restore")
@post
op RestoreCertificate is Azure.Core.Foundations.Operation<
  {
    @doc("The parameters to restore the certificate.")
    @body
    parameters: CertificateRestoreParameters;
  },
  CertificateBundle
>;

@summary("""
Lists the deleted certificates in the specified vault currently available for
recovery.
""")
@doc("""
The GetDeletedCertificates operation retrieves the certificates in the current
vault which are in a deleted state and ready for recovery or purging. This
operation includes deletion-specific information. This operation requires the
certificates/get/list permission. This operation can only be enabled on
soft-delete enabled vaults.
""")
@route("/deletedcertificates")
@get
op GetDeletedCertificates is Azure.Core.Foundations.Operation<
  {
    @doc("""
Maximum number of results to return in a page. If not specified the service
will return up to 25 results.
""")
    @query
    maxresults: int32;

    @doc("Specifies whether to include certificates which are not completely provisioned.")
    @query
    includePending: boolean;
  },
  DeletedCertificateListResult
>;

@summary("Retrieves information about the specified deleted certificate.")
@doc("""
The GetDeletedCertificate operation retrieves the deleted certificate
information plus its attributes, such as retention interval, scheduled
permanent deletion and the current deletion recovery level. This operation
requires the certificates/get permission.
""")
@route("/deletedcertificates/{certificate-name}")
@get
op GetDeletedCertificate is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the certificate")
    @path
    `certificate-name`: string;
  },
  DeletedCertificateBundle
>;

@summary("Permanently deletes the specified deleted certificate.")
@doc("""
The PurgeDeletedCertificate operation performs an irreversible deletion of the
specified certificate, without possibility for recovery. The operation is not
available if the recovery level does not specify 'Purgeable'. This operation
requires the certificate/purge permission.
""")
@route("/deletedcertificates/{certificate-name}")
@delete
op PurgeDeletedCertificate is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the certificate")
    @path
    `certificate-name`: string;
  },
  void
>;

@summary("""
Recovers the deleted certificate back to its current version under
/certificates.
""")
@doc("""
The RecoverDeletedCertificate operation performs the reversal of the Delete
operation. The operation is applicable in vaults enabled for soft-delete, and
must be issued during the retention interval (available in the deleted
certificate's attributes). This operation requires the certificates/recover
permission.
""")
@route("/deletedcertificates/{certificate-name}/recover")
@post
op RecoverDeletedCertificate is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the deleted certificate")
    @path
    `certificate-name`: string;
  },
  CertificateBundle
>;

@summary("""
Creates a new key, stores it, then returns key parameters and attributes to the
client.
""")
@doc("""
The create key operation can be used to create any key type in Azure Key Vault.
If the named key already exists, Azure Key Vault creates a new version of the
key. It requires the keys/create permission.
""")
@route("/keys/{key-name}/create")
@post
op CreateKey is Azure.Core.Foundations.Operation<
  {
    @doc("""
The name for the new key. The system will generate the version name for the new
key. The value you provide may be copied globally for the purpose of running
the service. The value provided should not include personally identifiable or
sensitive information.
""")
    @path
    `key-name`: string;

    @doc("The parameters to create a key.")
    @body
    parameters: KeyCreateParameters;
  },
  KeyBundle
>;

@summary("""
Creates a new key version, stores it, then returns key parameters, attributes
and policy to the client.
""")
@doc("""
The operation will rotate the key based on the key policy. It requires the
keys/rotate permission.
""")
@route("/keys/{key-name}/rotate")
@post
op RotateKey is Azure.Core.Foundations.Operation<
  {
    @doc("""
The name of key to be rotated. The system will generate a new version in the
specified key.
""")
    @path
    `key-name`: string;
  },
  KeyBundle
>;

@summary("""
Imports an externally created key, stores it, and returns key parameters and
attributes to the client.
""")
@doc("""
The import key operation may be used to import any key type into an Azure Key
Vault. If the named key already exists, Azure Key Vault creates a new version
of the key. This operation requires the keys/import permission.
""")
@route("/keys/{key-name}")
@put
op ImportKey is Azure.Core.Foundations.Operation<
  {
    @doc("""
Name for the imported key. The value you provide may be copied globally for the
purpose of running the service. The value provided should not include
personally identifiable or sensitive information.
""")
    @path
    `key-name`: string;

    @doc("The parameters to import a key.")
    @body
    parameters: KeyImportParameters;
  },
  KeyBundle
>;

@summary("Deletes a key of any type from storage in Azure Key Vault.")
@doc("""
The delete key operation cannot be used to remove individual versions of a key.
This operation removes the cryptographic material associated with the key,
which means the key is not usable for Sign/Verify, Wrap/Unwrap or
Encrypt/Decrypt operations. This operation requires the keys/delete permission.
""")
@route("/keys/{key-name}")
@delete
op DeleteKey is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the key to delete.")
    @path
    `key-name`: string;
  },
  DeletedKeyBundle
>;

@summary("""
The update key operation changes specified attributes of a stored key and can
be applied to any key type and key version stored in Azure Key Vault.
""")
@doc("""
In order to perform this operation, the key must already exist in the Key
Vault. Note: The cryptographic material of a key itself cannot be changed. This
operation requires the keys/update permission.
""")
@route("/keys/{key-name}/{key-version}")
@patch
op UpdateKey is Azure.Core.Foundations.Operation<
  {
    @doc("The name of key to update.")
    @path
    `key-name`: string;

    @doc("The version of the key to update.")
    @path
    `key-version`: string;

    @doc("The parameters of the key to update.")
    @body
    parameters: KeyUpdateParameters;
  },
  KeyBundle
>;

@summary("Gets the public part of a stored key.")
@doc("""
The get key operation is applicable to all key types. If the requested key is
symmetric, then no key material is released in the response. This operation
requires the keys/get permission.
""")
@route("/keys/{key-name}/{key-version}")
@get
op GetKey is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the key to get.")
    @path
    `key-name`: string;

    @doc("""
Adding the version parameter retrieves a specific version of a key. This URI
fragment is optional. If not specified, the latest version of the key is
returned.
""")
    @path
    `key-version`: string;
  },
  KeyBundle
>;

@summary("Retrieves a list of individual key versions with the same key name.")
@doc("""
The full key identifier, attributes, and tags are provided in the response.
This operation requires the keys/list permission.
""")
@route("/keys/{key-name}/versions")
@get
op GetKeyVersions is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the key.")
    @path
    `key-name`: string;

    @doc("""
Maximum number of results to return in a page. If not specified the service
will return up to 25 results.
""")
    @query
    maxresults: int32;
  },
  KeyListResult
>;

@summary("List keys in the specified vault.")
@doc("""
Retrieves a list of the keys in the Key Vault as JSON Web Key structures that
contain the public part of a stored key. The LIST operation is applicable to
all key types, however only the base key identifier, attributes, and tags are
provided in the response. Individual versions of a key are not listed in the
response. This operation requires the keys/list permission.
""")
@route("/keys")
@get
op GetKeys is Azure.Core.Foundations.Operation<
  {
    @doc("""
Maximum number of results to return in a page. If not specified the service
will return up to 25 results.
""")
    @query
    maxresults: int32;
  },
  KeyListResult
>;

@summary("Requests that a backup of the specified key be downloaded to the client.")
@doc("""
The Key Backup operation exports a key from Azure Key Vault in a protected
form. Note that this operation does NOT return key material in a form that can
be used outside the Azure Key Vault system, the returned key material is either
protected to a Azure Key Vault HSM or to Azure Key Vault itself. The intent of
this operation is to allow a client to GENERATE a key in one Azure Key Vault
instance, BACKUP the key, and then RESTORE it into another Azure Key Vault
instance. The BACKUP operation may be used to export, in protected form, any
key type from Azure Key Vault. Individual versions of a key cannot be backed
up. BACKUP / RESTORE can be performed within geographical boundaries only;
meaning that a BACKUP from one geographical area cannot be restored to another
geographical area. For example, a backup from the US geographical area cannot
be restored in an EU geographical area. This operation requires the key/backup
permission.
""")
@route("/keys/{key-name}/backup")
@post
op BackupKey is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the key.")
    @path
    `key-name`: string;
  },
  BackupKeyResult
>;

@summary("Restores a backed up key to a vault.")
@doc("""
Imports a previously backed up key into Azure Key Vault, restoring the key, its
key identifier, attributes and access control policies. The RESTORE operation
may be used to import a previously backed up key. Individual versions of a key
cannot be restored. The key is restored in its entirety with the same key name
as it had when it was backed up. If the key name is not available in the target
Key Vault, the RESTORE operation will be rejected. While the key name is
retained during restore, the final key identifier will change if the key is
restored to a different vault. Restore will restore all versions and preserve
version identifiers. The RESTORE operation is subject to security constraints:
The target Key Vault must be owned by the same Microsoft Azure Subscription as
the source Key Vault The user must have RESTORE permission in the target Key
Vault. This operation requires the keys/restore permission.
""")
@route("/keys/restore")
@post
op RestoreKey is Azure.Core.Foundations.Operation<
  {
    @doc("The parameters to restore the key.")
    @body
    parameters: KeyRestoreParameters;
  },
  KeyBundle
>;

@summary("""
Encrypts an arbitrary sequence of bytes using an encryption key that is stored
in a key vault.
""")
@doc("""
The ENCRYPT operation encrypts an arbitrary sequence of bytes using an
encryption key that is stored in Azure Key Vault. Note that the ENCRYPT
operation only supports a single block of data, the size of which is dependent
on the target key and the encryption algorithm to be used. The ENCRYPT
operation is only strictly necessary for symmetric keys stored in Azure Key
Vault since protection with an asymmetric key can be performed using public
portion of the key. This operation is supported for asymmetric keys as a
convenience for callers that have a key-reference but do not have access to the
public key material. This operation requires the keys/encrypt permission.
""")
@route("/keys/{key-name}/{key-version}/encrypt")
@post
op encrypt is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the key.")
    @path
    `key-name`: string;

    @doc("The version of the key.")
    @path
    `key-version`: string;

    @doc("The parameters for the encryption operation.")
    @body
    parameters: KeyOperationsParameters;
  },
  KeyOperationResult
>;

@summary("Decrypts a single block of encrypted data.")
@doc("""
The DECRYPT operation decrypts a well-formed block of ciphertext using the
target encryption key and specified algorithm. This operation is the reverse of
the ENCRYPT operation; only a single block of data may be decrypted, the size
of this block is dependent on the target key and the algorithm to be used. The
DECRYPT operation applies to asymmetric and symmetric keys stored in Azure Key
Vault since it uses the private portion of the key. This operation requires the
keys/decrypt permission. Microsoft recommends not to use CBC algorithms for
decryption without first ensuring the integrity of the ciphertext using an
HMAC, for example. See
https://docs.microsoft.com/dotnet/standard/security/vulnerabilities-cbc-mode
for more information.
""")
@route("/keys/{key-name}/{key-version}/decrypt")
@post
op decrypt is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the key.")
    @path
    `key-name`: string;

    @doc("The version of the key.")
    @path
    `key-version`: string;

    @doc("The parameters for the decryption operation.")
    @body
    parameters: KeyOperationsParameters;
  },
  KeyOperationResult
>;

@summary("Creates a signature from a digest using the specified key.")
@doc("""
The SIGN operation is applicable to asymmetric and symmetric keys stored in
Azure Key Vault since this operation uses the private portion of the key. This
operation requires the keys/sign permission.
""")
@route("/keys/{key-name}/{key-version}/sign")
@post
op sign is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the key.")
    @path
    `key-name`: string;

    @doc("The version of the key.")
    @path
    `key-version`: string;

    @doc("The parameters for the signing operation.")
    @body
    parameters: KeySignParameters;
  },
  KeyOperationResult
>;

@summary("Verifies a signature using a specified key.")
@doc("""
The VERIFY operation is applicable to symmetric keys stored in Azure Key Vault.
VERIFY is not strictly necessary for asymmetric keys stored in Azure Key Vault
since signature verification can be performed using the public portion of the
key but this operation is supported as a convenience for callers that only have
a key-reference and not the public portion of the key. This operation requires
the keys/verify permission.
""")
@route("/keys/{key-name}/{key-version}/verify")
@post
op verify is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the key.")
    @path
    `key-name`: string;

    @doc("The version of the key.")
    @path
    `key-version`: string;

    @doc("The parameters for verify operations.")
    @body
    parameters: KeyVerifyParameters;
  },
  KeyVerifyResult
>;

@summary("Wraps a symmetric key using a specified key.")
@doc("""
The WRAP operation supports encryption of a symmetric key using a key
encryption key that has previously been stored in an Azure Key Vault. The WRAP
operation is only strictly necessary for symmetric keys stored in Azure Key
Vault since protection with an asymmetric key can be performed using the public
portion of the key. This operation is supported for asymmetric keys as a
convenience for callers that have a key-reference but do not have access to the
public key material. This operation requires the keys/wrapKey permission.
""")
@route("/keys/{key-name}/{key-version}/wrapkey")
@post
op wrapKey is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the key.")
    @path
    `key-name`: string;

    @doc("The version of the key.")
    @path
    `key-version`: string;

    @doc("The parameters for wrap operation.")
    @body
    parameters: KeyOperationsParameters;
  },
  KeyOperationResult
>;

@summary("""
Unwraps a symmetric key using the specified key that was initially used for
wrapping that key.
""")
@doc("""
The UNWRAP operation supports decryption of a symmetric key using the target
key encryption key. This operation is the reverse of the WRAP operation. The
UNWRAP operation applies to asymmetric and symmetric keys stored in Azure Key
Vault since it uses the private portion of the key. This operation requires the
keys/unwrapKey permission.
""")
@route("/keys/{key-name}/{key-version}/unwrapkey")
@post
op unwrapKey is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the key.")
    @path
    `key-name`: string;

    @doc("The version of the key.")
    @path
    `key-version`: string;

    @doc("The parameters for the key operation.")
    @body
    parameters: KeyOperationsParameters;
  },
  KeyOperationResult
>;

@summary("Releases a key.")
@doc("""
The release key operation is applicable to all key types. The target key must
be marked exportable. This operation requires the keys/release permission.
""")
@route("/keys/{key-name}/{key-version}/release")
@post
op release is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the key to get.")
    @path
    `key-name`: string;

    @doc("Adding the version parameter retrieves a specific version of a key.")
    @path
    `key-version`: string;

    @doc("The parameters for the key release operation.")
    @body
    parameters: KeyReleaseParameters;
  },
  KeyReleaseResult
>;

@summary("Lists the deleted keys in the specified vault.")
@doc("""
Retrieves a list of the keys in the Key Vault as JSON Web Key structures that
contain the public part of a deleted key. This operation includes
deletion-specific information. The Get Deleted Keys operation is applicable for
vaults enabled for soft-delete. While the operation can be invoked on any
vault, it will return an error if invoked on a non soft-delete enabled vault.
This operation requires the keys/list permission.
""")
@route("/deletedkeys")
@get
op GetDeletedKeys is Azure.Core.Foundations.Operation<
  {
    @doc("""
Maximum number of results to return in a page. If not specified the service
will return up to 25 results.
""")
    @query
    maxresults: int32;
  },
  DeletedKeyListResult
>;

@summary("Gets the public part of a deleted key.")
@doc("""
The Get Deleted Key operation is applicable for soft-delete enabled vaults.
While the operation can be invoked on any vault, it will return an error if
invoked on a non soft-delete enabled vault. This operation requires the
keys/get permission. 
""")
@route("/deletedkeys/{key-name}")
@get
op GetDeletedKey is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the key.")
    @path
    `key-name`: string;
  },
  DeletedKeyBundle
>;

@summary("Permanently deletes the specified key.")
@doc("""
The Purge Deleted Key operation is applicable for soft-delete enabled vaults.
While the operation can be invoked on any vault, it will return an error if
invoked on a non soft-delete enabled vault. This operation requires the
keys/purge permission.
""")
@route("/deletedkeys/{key-name}")
@delete
op PurgeDeletedKey is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the key")
    @path
    `key-name`: string;
  },
  void
>;

@summary("Recovers the deleted key to its latest version.")
@doc("""
The Recover Deleted Key operation is applicable for deleted keys in soft-delete
enabled vaults. It recovers the deleted key back to its latest version under
/keys. An attempt to recover an non-deleted key will return an error. Consider
this the inverse of the delete operation on soft-delete enabled vaults. This
operation requires the keys/recover permission.
""")
@route("/deletedkeys/{key-name}/recover")
@post
op RecoverDeletedKey is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the deleted key.")
    @path
    `key-name`: string;
  },
  KeyBundle
>;

@summary("Lists the policy for a key.")
@doc("""
The GetKeyRotationPolicy operation returns the specified key policy resources
in the specified key vault. This operation requires the keys/get permission.
""")
@route("/keys/{key-name}/rotationpolicy")
@get
op GetKeyRotationPolicy is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the key in a given key vault.")
    @path
    `key-name`: string;
  },
  KeyRotationPolicy
>;

@summary("Updates the rotation policy for a key.")
@doc("""
Set specified members in the key policy. Leave others as undefined. This
operation requires the keys/update permission.
""")
@route("/keys/{key-name}/rotationpolicy")
@put
op UpdateKeyRotationPolicy is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the key in the given vault.")
    @path
    `key-name`: string;

    @doc("The policy for the key.")
    @body
    keyRotationPolicy: KeyRotationPolicy;
  },
  KeyRotationPolicy
>;

@summary("Get the requested number of bytes containing random values.")
@doc("Get the requested number of bytes containing random values from a managed HSM.")
@route("/rng")
@post
op GetRandomBytes is Azure.Core.Foundations.Operation<
  {
    @doc("The request object to get random bytes.")
    @body
    parameters: GetRandomBytesRequest;
  },
  RandomBytes
>;

@summary("Sets a secret in a specified key vault.")
@doc("""
 The SET operation adds a secret to the Azure Key Vault. If the named secret
already exists, Azure Key Vault creates a new version of that secret. This
operation requires the secrets/set permission.
""")
@route("/secrets/{secret-name}")
@put
op SetSecret is Azure.Core.Foundations.Operation<
  {
    @doc("""
The name of the secret. The value you provide may be copied globally for the
purpose of running the service. The value provided should not include
personally identifiable or sensitive information.
""")
    @path
    `secret-name`: string;

    @doc("The parameters for setting the secret.")
    @body
    parameters: SecretSetParameters;
  },
  SecretBundle
>;

@summary("Deletes a secret from a specified key vault.")
@doc("""
The DELETE operation applies to any secret stored in Azure Key Vault. DELETE
cannot be applied to an individual version of a secret. This operation requires
the secrets/delete permission.
""")
@route("/secrets/{secret-name}")
@delete
op DeleteSecret is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the secret.")
    @path
    `secret-name`: string;
  },
  DeletedSecretBundle
>;

@summary("Updates the attributes associated with a specified secret in a given key vault.")
@doc("""
The UPDATE operation changes specified attributes of an existing stored secret.
Attributes that are not specified in the request are left unchanged. The value
of a secret itself cannot be changed. This operation requires the secrets/set
permission.
""")
@route("/secrets/{secret-name}/{secret-version}")
@patch
op UpdateSecret is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the secret.")
    @path
    `secret-name`: string;

    @doc("The version of the secret.")
    @path
    `secret-version`: string;

    @doc("The parameters for update secret operation.")
    @body
    parameters: SecretUpdateParameters;
  },
  SecretBundle
>;

@summary("Get a specified secret from a given key vault.")
@doc("""
The GET operation is applicable to any secret stored in Azure Key Vault. This
operation requires the secrets/get permission.
""")
@route("/secrets/{secret-name}/{secret-version}")
@get
op GetSecret is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the secret.")
    @path
    `secret-name`: string;

    @doc("""
The version of the secret. This URI fragment is optional. If not specified, the
latest version of the secret is returned.
""")
    @path
    `secret-version`: string;
  },
  SecretBundle
>;

@summary("List secrets in a specified key vault.")
@doc("""
The Get Secrets operation is applicable to the entire vault. However, only the
base secret identifier and its attributes are provided in the response.
Individual secret versions are not listed in the response. This operation
requires the secrets/list permission.
""")
@route("/secrets")
@get
op GetSecrets is Azure.Core.Foundations.Operation<
  {
    @doc("""
Maximum number of results to return in a page. If not specified, the service
will return up to 25 results.
""")
    @query
    maxresults: int32;
  },
  SecretListResult
>;

@summary("List all versions of the specified secret.")
@doc("""
The full secret identifier and attributes are provided in the response. No
values are returned for the secrets. This operations requires the secrets/list
permission.
""")
@route("/secrets/{secret-name}/versions")
@get
op GetSecretVersions is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the secret.")
    @path
    `secret-name`: string;

    @doc("""
Maximum number of results to return in a page. If not specified, the service
will return up to 25 results.
""")
    @query
    maxresults: int32;
  },
  SecretListResult
>;

@summary("Lists deleted secrets for the specified vault.")
@doc("""
The Get Deleted Secrets operation returns the secrets that have been deleted
for a vault enabled for soft-delete. This operation requires the secrets/list
permission.
""")
@route("/deletedsecrets")
@get
op GetDeletedSecrets is Azure.Core.Foundations.Operation<
  {
    @doc("""
Maximum number of results to return in a page. If not specified the service
will return up to 25 results.
""")
    @query
    maxresults: int32;
  },
  DeletedSecretListResult
>;

@summary("Gets the specified deleted secret.")
@doc("""
The Get Deleted Secret operation returns the specified deleted secret along
with its attributes. This operation requires the secrets/get permission.
""")
@route("/deletedsecrets/{secret-name}")
@get
op GetDeletedSecret is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the secret.")
    @path
    `secret-name`: string;
  },
  DeletedSecretBundle
>;

@summary("Permanently deletes the specified secret.")
@doc("""
The purge deleted secret operation removes the secret permanently, without the
possibility of recovery. This operation can only be enabled on a soft-delete
enabled vault. This operation requires the secrets/purge permission.
""")
@route("/deletedsecrets/{secret-name}")
@delete
op PurgeDeletedSecret is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the secret.")
    @path
    `secret-name`: string;
  },
  void
>;

@summary("Recovers the deleted secret to the latest version.")
@doc("""
Recovers the deleted secret in the specified vault. This operation can only be
performed on a soft-delete enabled vault. This operation requires the
secrets/recover permission.
""")
@route("/deletedsecrets/{secret-name}/recover")
@post
op RecoverDeletedSecret is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the deleted secret.")
    @path
    `secret-name`: string;
  },
  SecretBundle
>;

@summary("Backs up the specified secret.")
@doc("""
Requests that a backup of the specified secret be downloaded to the client. All
versions of the secret will be downloaded. This operation requires the
secrets/backup permission.
""")
@route("/secrets/{secret-name}/backup")
@post
op BackupSecret is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the secret.")
    @path
    `secret-name`: string;
  },
  BackupSecretResult
>;

@summary("Restores a backed up secret to a vault.")
@doc("""
Restores a backed up secret, and all its versions, to a vault. This operation
requires the secrets/restore permission.
""")
@route("/secrets/restore")
@post
op RestoreSecret is Azure.Core.Foundations.Operation<
  {
    @doc("The parameters to restore the secret.")
    @body
    parameters: SecretRestoreParameters;
  },
  SecretBundle
>;

@summary("""
Updates key vault account setting, stores it, then returns the setting name and
value to the client.
""")
@doc("Description of the pool setting to be updated")
@route("/settings/{setting-name}")
@patch
op UpdateSettings is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the account setting. Must be a valid settings option.")
    @path
    `setting-name`: string;

    @doc("The parameters to update an account setting.")
    @body
    parameters: UpdateSettingsRequest;
  },
  Setting
>;

@summary("Get specified account setting value.")
@doc("Retrieves the value of a specified, value account setting.")
@route("/settings/{setting-name}")
@get
op GetSettingValue is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the account setting. Must be a valid settings option.")
    @path
    `setting-name`: string;
  },
  Setting
>;

@summary("List account settings.")
@doc("Retrieves a list of all the available account settings that can be configured.")
@route("/settings")
@get
op GetSettings is Azure.Core.Foundations.Operation<{}, SettingsListResult>;

@doc("""
List storage accounts managed by the specified key vault. This operation
requires the storage/list permission.
""")
@route("/storage")
@get
op GetStorageAccounts is Azure.Core.Foundations.Operation<
  {
    @doc("""
Maximum number of results to return in a page. If not specified the service
will return up to 25 results.
""")
    @query
    maxresults: int32;
  },
  StorageListResult
>;

@summary("Lists deleted storage accounts for the specified vault.")
@doc("""
The Get Deleted Storage Accounts operation returns the storage accounts that
have been deleted for a vault enabled for soft-delete. This operation requires
the storage/list permission.
""")
@route("/deletedstorage")
@get
op GetDeletedStorageAccounts is Azure.Core.Foundations.Operation<
  {
    @doc("""
Maximum number of results to return in a page. If not specified the service
will return up to 25 results.
""")
    @query
    maxresults: int32;
  },
  DeletedStorageListResult
>;

@summary("Gets the specified deleted storage account.")
@doc("""
The Get Deleted Storage Account operation returns the specified deleted storage
account along with its attributes. This operation requires the storage/get
permission.
""")
@route("/deletedstorage/{storage-account-name}")
@get
op GetDeletedStorageAccount is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the storage account.")
    @path
    `storage-account-name`: string;
  },
  DeletedStorageBundle
>;

@summary("Permanently deletes the specified storage account.")
@doc("""
The purge deleted storage account operation removes the secret permanently,
without the possibility of recovery. This operation can only be performed on a
soft-delete enabled vault. This operation requires the storage/purge
permission.
""")
@route("/deletedstorage/{storage-account-name}")
@delete
op PurgeDeletedStorageAccount is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the storage account.")
    @path
    `storage-account-name`: string;
  },
  void
>;

@summary("Recovers the deleted storage account.")
@doc("""
Recovers the deleted storage account in the specified vault. This operation can
only be performed on a soft-delete enabled vault. This operation requires the
storage/recover permission.
""")
@route("/deletedstorage/{storage-account-name}/recover")
@post
op RecoverDeletedStorageAccount is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the storage account.")
    @path
    `storage-account-name`: string;
  },
  StorageBundle
>;

@summary("Backs up the specified storage account.")
@doc("""
Requests that a backup of the specified storage account be downloaded to the
client. This operation requires the storage/backup permission.
""")
@route("/storage/{storage-account-name}/backup")
@post
op BackupStorageAccount is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the storage account.")
    @path
    `storage-account-name`: string;
  },
  BackupStorageResult
>;

@summary("Restores a backed up storage account to a vault.")
@doc("""
Restores a backed up storage account to a vault. This operation requires the
storage/restore permission.
""")
@route("/storage/restore")
@post
op RestoreStorageAccount is Azure.Core.Foundations.Operation<
  {
    @doc("The parameters to restore the storage account.")
    @body
    parameters: StorageRestoreParameters;
  },
  StorageBundle
>;

@doc("""
Deletes a storage account. This operation requires the storage/delete
permission.
""")
@route("/storage/{storage-account-name}")
@delete
op DeleteStorageAccount is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the storage account.")
    @path
    `storage-account-name`: string;
  },
  DeletedStorageBundle
>;

@doc("""
Gets information about a specified storage account. This operation requires the
storage/get permission.
""")
@route("/storage/{storage-account-name}")
@get
op GetStorageAccount is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the storage account.")
    @path
    `storage-account-name`: string;
  },
  StorageBundle
>;

@doc("""
Creates or updates a new storage account. This operation requires the
storage/set permission.
""")
@route("/storage/{storage-account-name}")
@put
op SetStorageAccount is Azure.Core.Foundations.Operation<
  {
    @doc("""
The name of the storage account. The value you provide may be copied globally
for the purpose of running the service. The value provided should not include
personally identifiable or sensitive information.
""")
    @path
    `storage-account-name`: string;

    @doc("The parameters to create a storage account.")
    @body
    parameters: StorageAccountCreateParameters;
  },
  StorageBundle
>;

@doc("""
Updates the specified attributes associated with the given storage account.
This operation requires the storage/set/update permission.
""")
@route("/storage/{storage-account-name}")
@patch
op UpdateStorageAccount is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the storage account.")
    @path
    `storage-account-name`: string;

    @doc("The parameters to update a storage account.")
    @body
    parameters: StorageAccountUpdateParameters;
  },
  StorageBundle
>;

@doc("""
Regenerates the specified key value for the given storage account. This
operation requires the storage/regeneratekey permission.
""")
@route("/storage/{storage-account-name}/regeneratekey")
@post
op RegenerateStorageAccountKey is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the storage account.")
    @path
    `storage-account-name`: string;

    @doc("The parameters to regenerate storage account key.")
    @body
    parameters: StorageAccountRegenerteKeyParameters;
  },
  StorageBundle
>;

@doc("""
List storage SAS definitions for the given storage account. This operation
requires the storage/listsas permission.
""")
@route("/storage/{storage-account-name}/sas")
@get
op GetSasDefinitions is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the storage account.")
    @path
    `storage-account-name`: string;

    @doc("""
Maximum number of results to return in a page. If not specified the service
will return up to 25 results.
""")
    @query
    maxresults: int32;
  },
  SasDefinitionListResult
>;

@summary("Lists deleted SAS definitions for the specified vault and storage account.")
@doc("""
The Get Deleted Sas Definitions operation returns the SAS definitions that have
been deleted for a vault enabled for soft-delete. This operation requires the
storage/listsas permission.
""")
@route("/deletedstorage/{storage-account-name}/sas")
@get
op GetDeletedSasDefinitions is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the storage account.")
    @path
    `storage-account-name`: string;

    @doc("""
Maximum number of results to return in a page. If not specified the service
will return up to 25 results.
""")
    @query
    maxresults: int32;
  },
  DeletedSasDefinitionListResult
>;

@summary("Gets the specified deleted sas definition.")
@doc("""
The Get Deleted SAS Definition operation returns the specified deleted SAS
definition along with its attributes. This operation requires the
storage/getsas permission.
""")
@route("/deletedstorage/{storage-account-name}/sas/{sas-definition-name}")
@get
op GetDeletedSasDefinition is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the storage account.")
    @path
    `storage-account-name`: string;

    @doc("The name of the SAS definition.")
    @path
    `sas-definition-name`: string;
  },
  DeletedSasDefinitionBundle
>;

@summary("Recovers the deleted SAS definition.")
@doc("""
Recovers the deleted SAS definition for the specified storage account. This
operation can only be performed on a soft-delete enabled vault. This operation
requires the storage/recover permission.
""")
@route("/deletedstorage/{storage-account-name}/sas/{sas-definition-name}/recover")
@post
op RecoverDeletedSasDefinition is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the storage account.")
    @path
    `storage-account-name`: string;

    @doc("The name of the SAS definition.")
    @path
    `sas-definition-name`: string;
  },
  SasDefinitionBundle
>;

@doc("""
Deletes a SAS definition from a specified storage account. This operation
requires the storage/deletesas permission.
""")
@route("/storage/{storage-account-name}/sas/{sas-definition-name}")
@delete
op DeleteSasDefinition is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the storage account.")
    @path
    `storage-account-name`: string;

    @doc("The name of the SAS definition.")
    @path
    `sas-definition-name`: string;
  },
  DeletedSasDefinitionBundle
>;

@doc("""
Gets information about a SAS definition for the specified storage account. This
operation requires the storage/getsas permission.
""")
@route("/storage/{storage-account-name}/sas/{sas-definition-name}")
@get
op GetSasDefinition is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the storage account.")
    @path
    `storage-account-name`: string;

    @doc("The name of the SAS definition.")
    @path
    `sas-definition-name`: string;
  },
  SasDefinitionBundle
>;

@doc("""
Creates or updates a new SAS definition for the specified storage account. This
operation requires the storage/setsas permission.
""")
@route("/storage/{storage-account-name}/sas/{sas-definition-name}")
@put
op SetSasDefinition is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the storage account.")
    @path
    `storage-account-name`: string;

    @doc("""
The name of the SAS definition. The value you provide may be copied globally
for the purpose of running the service. The value provided should not include
personally identifiable or sensitive information.
""")
    @path
    `sas-definition-name`: string;

    @doc("The parameters to create a SAS definition.")
    @body
    parameters: SasDefinitionCreateParameters;
  },
  SasDefinitionBundle
>;

@doc("""
Updates the specified attributes associated with the given SAS definition. This
operation requires the storage/setsas permission.
""")
@route("/storage/{storage-account-name}/sas/{sas-definition-name}")
@patch
op UpdateSasDefinition is Azure.Core.Foundations.Operation<
  {
    @doc("The name of the storage account.")
    @path
    `storage-account-name`: string;

    @doc("The name of the SAS definition.")
    @path
    `sas-definition-name`: string;

    @doc("The parameters to update a SAS definition.")
    @body
    parameters: SasDefinitionUpdateParameters;
  },
  SasDefinitionBundle
>;

interface RoleDefinitionsOperations {
  @doc("Deletes a custom role definition.")
  @route("/{scope}/providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The scope of the role definition to delete. Managed HSM only supports '/'.")
      @path
      scope: string;

      @doc("The name (GUID) of the role definition to delete.")
      @path
      roleDefinitionName: string;
    },
    RoleDefinition
  >;

  @doc("Creates or updates a custom role definition.")
  @route("/{scope}/providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionName}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("""
The scope of the role definition to create or update. Managed HSM only supports
'/'.
""")
      @path
      scope: string;

      @doc("The name of the role definition to create or update. It can be any valid GUID.")
      @path
      roleDefinitionName: string;

      @doc("Parameters for the role definition.")
      @body
      parameters: RoleDefinitionCreateParameters;
    },
    RoleDefinition
  >;

  @doc("Get the specified role definition.")
  @route("/{scope}/providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The scope of the role definition to get. Managed HSM only supports '/'.")
      @path
      scope: string;

      @doc("The name of the role definition to get.")
      @path
      roleDefinitionName: string;
    },
    RoleDefinition
  >;

  @doc("Get all role definitions that are applicable at scope and above.")
  @route("/{scope}/providers/Microsoft.Authorization/roleDefinitions")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The scope of the role definition.")
      @path
      scope: string;

      @doc("""
The filter to apply on the operation. Use atScopeAndBelow filter to search
below the given scope as well.
""")
      @query
      $filter: string;
    },
    RoleDefinitionListResult
  >;
}

interface RoleAssignmentsOperations {
  @doc("Deletes a role assignment.")
  @route("/{scope}/providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The scope of the role assignment to delete.")
      @path
      scope: string;

      @doc("The name of the role assignment to delete.")
      @path
      roleAssignmentName: string;
    },
    RoleAssignment
  >;

  @doc("Creates a role assignment.")
  @route("/{scope}/providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}")
  @put
  Create is Azure.Core.Foundations.Operation<
    {
      @doc("The scope of the role assignment to create.")
      @path
      scope: string;

      @doc("The name of the role assignment to create. It can be any valid GUID.")
      @path
      roleAssignmentName: string;

      @doc("Parameters for the role assignment.")
      @body
      parameters: RoleAssignmentCreateParameters;
    },
    RoleAssignment
  >;

  @doc("Get the specified role assignment.")
  @route("/{scope}/providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The scope of the role assignment.")
      @path
      scope: string;

      @doc("The name of the role assignment to get.")
      @path
      roleAssignmentName: string;
    },
    RoleAssignment
  >;

  @doc("Gets role assignments for a scope.")
  @route("/{scope}/providers/Microsoft.Authorization/roleAssignments")
  @get
  ListForScope is Azure.Core.Foundations.Operation<
    {
      @doc("The scope of the role assignments.")
      @path
      scope: string;

      @doc("""
The filter to apply on the operation. Use $filter=atScope() to return all role
assignments at or above the scope. Use $filter=principalId eq {id} to return
all role assignments at, above or below the scope for the specified principal.
""")
      @query
      $filter: string;
    },
    RoleAssignmentListResult
  >;
}

interface HSMSecurityDomainOperations {
  @doc("Retrieves the Security Domain download operation status")
  @route("/securitydomain/download/pending")
  @get
  DownloadPending is Azure.Core.Foundations.Operation<
    {},
    SecurityDomainOperationStatus
  >;

  @doc("""
Retrieves the Security Domain from the managed HSM. Calling this endpoint can
be used to activate a provisioned managed HSM resource.
""")
  @route("/securitydomain/download")
  @post
  Download is Azure.Core.Foundations.Operation<
    {
      @doc("""
The Security Domain download operation requires customer to provide N
certificates (minimum 3 and maximum 10) containing a public key in JWK format.
""")
      @body
      CertificateInfoObject: CertificateInfoObject;
    },
    SecurityDomainObject
  >;

  @doc("Retrieve Security Domain transfer key")
  // FIXME: (name-collision-error) There is a potential collision with Operation, Parameter and Response names.
  // Problematic names: [TransferKey]
  @route("/securitydomain/upload")
  @get
  TransferKey is Azure.Core.Foundations.Operation<{}, TransferKey>;

  @doc("Restore the provided Security Domain.")
  @route("/securitydomain/upload")
  @post
  Upload is Azure.Core.Foundations.Operation<
    {
      @doc("The Security Domain to be restored.")
      @body
      security_domain: SecurityDomainObject;
    },
    SecurityDomainOperationStatus | void
  >;

  @doc("Get Security Domain upload operation status")
  @route("/securitydomain/upload/pending")
  @get
  UploadPending is Azure.Core.Foundations.Operation<
    {},
    SecurityDomainOperationStatus
  >;
}
