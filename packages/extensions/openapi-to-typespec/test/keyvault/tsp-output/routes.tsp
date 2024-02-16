import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Azure.Keyvault;

/**
 * Creates a full backup using a user-provided SAS token to an Azure blob storage
 * container.
 */
@route("/backup")
@post
op fullBackup is Azure.Core.Foundations.Operation<
  SASTokenParameter,
  FullBackupOperation
>;

/**
 * Returns the status of full backup operation
 */
@route("/backup/{jobId}/pending")
@get
op fullBackupStatus is Azure.Core.Foundations.Operation<
  {
    /**
     * The id returned as part of the backup request
     */
    @path
    jobId: string;
  },
  FullBackupOperation
>;

/**
 * Restores all key materials using the SAS token pointing to a previously stored
 * Azure Blob storage backup folder
 */
@route("/restore")
@put
op fullRestoreOperation is Azure.Core.Foundations.Operation<
  RestoreOperationParameters,
  RestoreOperation
>;

/**
 * Returns the status of restore operation
 */
@route("/restore/{jobId}/pending")
@get
op restoreStatus is Azure.Core.Foundations.Operation<
  {
    /**
     * The Job Id returned part of the restore operation
     */
    @path
    jobId: string;
  },
  RestoreOperation
>;

/**
 * Restores all key versions of a given key using user supplied SAS token pointing
 * to a previously stored Azure Blob storage backup folder
 */
@route("/keys/{keyName}/restore")
@put
op selectiveKeyRestoreOperation is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the key to be restored from the user supplied backup
     */
    @path
    keyName: string;

    /**
     * The Azure blob SAS token pointing to a folder where the previous successful
     * full backup was stored
     */
    @body
    restoreBlobDetails?: SelectiveKeyRestoreOperationParameters;
  },
  SelectiveKeyRestoreOperation
>;

/**
 * The GetCertificates operation returns the set of certificates resources in the
 * specified key vault. This operation requires the certificates/list permission.
 */
@summary("List certificates in a specified key vault")
@route("/certificates")
@get
op getCertificates is Azure.Core.Foundations.Operation<
  {
    /**
     * Maximum number of results to return in a page. If not specified the service
     * will return up to 25 results.
     */
    @maxValue(25)
    @minValue(1)
    @query("maxresults")
    maxresults?: int32;

    /**
     * Specifies whether to include certificates which are not completely provisioned.
     */
    @query("includePending")
    includePending?: boolean;
  },
  CertificateListResult
>;

/**
 * Deletes all versions of a certificate object along with its associated policy.
 * Delete certificate cannot be used to remove individual versions of a
 * certificate object. This operation requires the certificates/delete permission.
 */
@summary("Deletes a certificate from a specified key vault.")
@route("/certificates/{certificate-name}")
@delete
op deleteCertificate is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the certificate.
     */
    @path
    `certificate-name`: string;
  },
  DeletedCertificateBundle
>;

/**
 * Sets the certificate contacts for the specified key vault. This operation
 * requires the certificates/managecontacts permission.
 */
@summary("Sets the certificate contacts for the specified key vault.")
@route("/certificates/contacts")
@put
op setCertificateContacts is Azure.Core.Foundations.Operation<
  Contacts,
  Contacts
>;

/**
 * The GetCertificateContacts operation returns the set of certificate contact
 * resources in the specified key vault. This operation requires the
 * certificates/managecontacts permission.
 */
@summary("Lists the certificate contacts for a specified key vault.")
@route("/certificates/contacts")
@get
op getCertificateContacts is Azure.Core.Foundations.Operation<{}, Contacts>;

/**
 * Deletes the certificate contacts for a specified key vault certificate. This
 * operation requires the certificates/managecontacts permission.
 */
@summary("Deletes the certificate contacts for a specified key vault.")
@route("/certificates/contacts")
@delete
op deleteCertificateContacts is Azure.Core.Foundations.Operation<{}, Contacts>;

/**
 * The GetCertificateIssuers operation returns the set of certificate issuer
 * resources in the specified key vault. This operation requires the
 * certificates/manageissuers/getissuers permission.
 */
@summary("List certificate issuers for a specified key vault.")
@route("/certificates/issuers")
@get
op getCertificateIssuers is Azure.Core.Foundations.Operation<
  {
    /**
     * Maximum number of results to return in a page. If not specified the service
     * will return up to 25 results.
     */
    @maxValue(25)
    @minValue(1)
    @query("maxresults")
    maxresults?: int32;
  },
  CertificateIssuerListResult
>;

/**
 * The SetCertificateIssuer operation adds or updates the specified certificate
 * issuer. This operation requires the certificates/setissuers permission.
 */
@summary("Sets the specified certificate issuer.")
@route("/certificates/issuers/{issuer-name}")
@put
op setCertificateIssuer is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the issuer. The value you provide may be copied globally for the
     * purpose of running the service. The value provided should not include
     * personally identifiable or sensitive information.
     */
    @path
    `issuer-name`: string;

    /**
     * Certificate issuer set parameter.
     */
    @body
    parameter: CertificateIssuerSetParameters;
  },
  IssuerBundle
>;

/**
 * The UpdateCertificateIssuer operation performs an update on the specified
 * certificate issuer entity. This operation requires the certificates/setissuers
 * permission.
 */
@summary("Updates the specified certificate issuer.")
@route("/certificates/issuers/{issuer-name}")
@patch
op updateCertificateIssuer is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the issuer.
     */
    @path
    `issuer-name`: string;

    /**
     * Certificate issuer update parameter.
     */
    @body
    parameter: CertificateIssuerUpdateParameters;
  },
  IssuerBundle
>;

/**
 * The GetCertificateIssuer operation returns the specified certificate issuer
 * resources in the specified key vault. This operation requires the
 * certificates/manageissuers/getissuers permission.
 */
@summary("Lists the specified certificate issuer.")
@route("/certificates/issuers/{issuer-name}")
@get
op getCertificateIssuer is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the issuer.
     */
    @path
    `issuer-name`: string;
  },
  IssuerBundle
>;

/**
 * The DeleteCertificateIssuer operation permanently removes the specified
 * certificate issuer from the vault. This operation requires the
 * certificates/manageissuers/deleteissuers permission.
 */
@summary("Deletes the specified certificate issuer.")
@route("/certificates/issuers/{issuer-name}")
@delete
op deleteCertificateIssuer is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the issuer.
     */
    @path
    `issuer-name`: string;
  },
  IssuerBundle
>;

/**
 * If this is the first version, the certificate resource is created. This
 * operation requires the certificates/create permission.
 */
@summary("Creates a new certificate.")
@route("/certificates/{certificate-name}/create")
@post
op createCertificate is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the certificate. The value you provide may be copied globally for
     * the purpose of running the service. The value provided should not include
     * personally identifiable or sensitive information.
     */
    @pattern("^[0-9a-zA-Z-]+$")
    @path
    `certificate-name`: string;

    /**
     * The parameters to create a certificate.
     */
    @body
    parameters: CertificateCreateParameters;
  },
  CertificateOperation
>;

/**
 * Imports an existing valid certificate, containing a private key, into Azure Key
 * Vault. This operation requires the certificates/import permission. The
 * certificate to be imported can be in either PFX or PEM format. If the
 * certificate is in PEM format the PEM file must contain the key as well as x509
 * certificates. Key Vault will only accept a key in PKCS#8 format.
 */
@summary("Imports a certificate into a specified key vault.")
@route("/certificates/{certificate-name}/import")
@post
op importCertificate is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the certificate. The value you provide may be copied globally for
     * the purpose of running the service. The value provided should not include
     * personally identifiable or sensitive information.
     */
    @pattern("^[0-9a-zA-Z-]+$")
    @path
    `certificate-name`: string;

    /**
     * The parameters to import the certificate.
     */
    @body
    parameters: CertificateImportParameters;
  },
  CertificateBundle
>;

/**
 * The GetCertificateVersions operation returns the versions of a certificate in
 * the specified key vault. This operation requires the certificates/list
 * permission.
 */
@summary("List the versions of a certificate.")
@route("/certificates/{certificate-name}/versions")
@get
op getCertificateVersions is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the certificate.
     */
    @path
    `certificate-name`: string;

    /**
     * Maximum number of results to return in a page. If not specified the service
     * will return up to 25 results.
     */
    @maxValue(25)
    @minValue(1)
    @query("maxresults")
    maxresults?: int32;
  },
  CertificateListResult
>;

/**
 * The GetCertificatePolicy operation returns the specified certificate policy
 * resources in the specified key vault. This operation requires the
 * certificates/get permission.
 */
@summary("Lists the policy for a certificate.")
@route("/certificates/{certificate-name}/policy")
@get
op getCertificatePolicy is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the certificate in a given key vault.
     */
    @path
    `certificate-name`: string;
  },
  CertificatePolicy
>;

/**
 * Set specified members in the certificate policy. Leave others as null. This
 * operation requires the certificates/update permission.
 */
@summary("Updates the policy for a certificate.")
@route("/certificates/{certificate-name}/policy")
@patch
op updateCertificatePolicy is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the certificate in the given vault.
     */
    @path
    `certificate-name`: string;

    /**
     * The policy for the certificate.
     */
    @body
    certificatePolicy: CertificatePolicy;
  },
  CertificatePolicy
>;

/**
 * The UpdateCertificate operation applies the specified update on the given
 * certificate; the only elements updated are the certificate's attributes. This
 * operation requires the certificates/update permission.
 */
@summary("Updates the specified attributes associated with the given certificate.")
@route("/certificates/{certificate-name}/{certificate-version}")
@patch
op updateCertificate is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the certificate in the given key vault.
     */
    @path
    `certificate-name`: string;

    /**
     * The version of the certificate.
     */
    @path
    `certificate-version`: string;

    /**
     * The parameters for certificate update.
     */
    @body
    parameters: CertificateUpdateParameters;
  },
  CertificateBundle
>;

/**
 * Gets information about a specific certificate. This operation requires the
 * certificates/get permission.
 */
@summary("Gets information about a certificate.")
@route("/certificates/{certificate-name}/{certificate-version}")
@get
op getCertificate is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the certificate in the given vault.
     */
    @path
    `certificate-name`: string;

    /**
     * The version of the certificate. This URI fragment is optional. If not
     * specified, the latest version of the certificate is returned.
     */
    @path
    `certificate-version`: string;
  },
  CertificateBundle
>;

/**
 * Updates a certificate creation operation that is already in progress. This
 * operation requires the certificates/update permission.
 */
@summary("Updates a certificate operation.")
@route("/certificates/{certificate-name}/pending")
@patch
op updateCertificateOperation is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the certificate.
     */
    @path
    `certificate-name`: string;

    /**
     * The certificate operation response.
     */
    @body
    certificateOperation: CertificateOperationUpdateParameter;
  },
  CertificateOperation
>;

/**
 * Gets the creation operation associated with a specified certificate. This
 * operation requires the certificates/get permission.
 */
@summary("Gets the creation operation of a certificate.")
@route("/certificates/{certificate-name}/pending")
@get
op getCertificateOperation is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the certificate.
     */
    @path
    `certificate-name`: string;
  },
  CertificateOperation
>;

/**
 * Deletes the creation operation for a specified certificate that is in the
 * process of being created. The certificate is no longer created. This operation
 * requires the certificates/update permission.
 */
@summary("Deletes the creation operation for a specific certificate.")
@route("/certificates/{certificate-name}/pending")
@delete
op deleteCertificateOperation is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the certificate.
     */
    @path
    `certificate-name`: string;
  },
  CertificateOperation
>;

/**
 * The MergeCertificate operation performs the merging of a certificate or
 * certificate chain with a key pair currently available in the service. This
 * operation requires the certificates/create permission.
 */
@summary("""
Merges a certificate or a certificate chain with a key pair existing on the
server.
""")
@route("/certificates/{certificate-name}/pending/merge")
@post
op mergeCertificate is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the certificate.
     */
    @path
    `certificate-name`: string;

    /**
     * The parameters to merge certificate.
     */
    @body
    parameters: CertificateMergeParameters;
  },
  CertificateBundle
>;

/**
 * Requests that a backup of the specified certificate be downloaded to the
 * client. All versions of the certificate will be downloaded. This operation
 * requires the certificates/backup permission.
 */
@summary("Backs up the specified certificate.")
@route("/certificates/{certificate-name}/backup")
@post
op backupCertificate is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the certificate.
     */
    @path
    `certificate-name`: string;
  },
  BackupCertificateResult
>;

/**
 * Restores a backed up certificate, and all its versions, to a vault. This
 * operation requires the certificates/restore permission.
 */
@summary("Restores a backed up certificate to a vault.")
@route("/certificates/restore")
@post
op restoreCertificate is Azure.Core.Foundations.Operation<
  CertificateRestoreParameters,
  CertificateBundle
>;

/**
 * The GetDeletedCertificates operation retrieves the certificates in the current
 * vault which are in a deleted state and ready for recovery or purging. This
 * operation includes deletion-specific information. This operation requires the
 * certificates/get/list permission. This operation can only be enabled on
 * soft-delete enabled vaults.
 */
@summary("""
Lists the deleted certificates in the specified vault currently available for
recovery.
""")
@route("/deletedcertificates")
@get
op getDeletedCertificates is Azure.Core.Foundations.Operation<
  {
    /**
     * Maximum number of results to return in a page. If not specified the service
     * will return up to 25 results.
     */
    @maxValue(25)
    @minValue(1)
    @query("maxresults")
    maxresults?: int32;

    /**
     * Specifies whether to include certificates which are not completely provisioned.
     */
    @query("includePending")
    includePending?: boolean;
  },
  DeletedCertificateListResult
>;

/**
 * The GetDeletedCertificate operation retrieves the deleted certificate
 * information plus its attributes, such as retention interval, scheduled
 * permanent deletion and the current deletion recovery level. This operation
 * requires the certificates/get permission.
 */
@summary("Retrieves information about the specified deleted certificate.")
@route("/deletedcertificates/{certificate-name}")
@get
op getDeletedCertificate is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the certificate
     */
    @path
    `certificate-name`: string;
  },
  DeletedCertificateBundle
>;

/**
 * The PurgeDeletedCertificate operation performs an irreversible deletion of the
 * specified certificate, without possibility for recovery. The operation is not
 * available if the recovery level does not specify 'Purgeable'. This operation
 * requires the certificate/purge permission.
 */
@summary("Permanently deletes the specified deleted certificate.")
@route("/deletedcertificates/{certificate-name}")
@delete
op purgeDeletedCertificate is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the certificate
     */
    @path
    `certificate-name`: string;
  },
  void
>;

/**
 * The RecoverDeletedCertificate operation performs the reversal of the Delete
 * operation. The operation is applicable in vaults enabled for soft-delete, and
 * must be issued during the retention interval (available in the deleted
 * certificate's attributes). This operation requires the certificates/recover
 * permission.
 */
@summary("""
Recovers the deleted certificate back to its current version under
/certificates.
""")
@route("/deletedcertificates/{certificate-name}/recover")
@post
op recoverDeletedCertificate is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the deleted certificate
     */
    @path
    `certificate-name`: string;
  },
  CertificateBundle
>;

/**
 * The create key operation can be used to create any key type in Azure Key Vault.
 * If the named key already exists, Azure Key Vault creates a new version of the
 * key. It requires the keys/create permission.
 */
@summary("""
Creates a new key, stores it, then returns key parameters and attributes to the
client.
""")
@route("/keys/{key-name}/create")
@post
op createKey is Azure.Core.Foundations.Operation<
  {
    /**
     * The name for the new key. The system will generate the version name for the new
     * key. The value you provide may be copied globally for the purpose of running
     * the service. The value provided should not include personally identifiable or
     * sensitive information.
     */
    @pattern("^[0-9a-zA-Z-]+$")
    @path
    `key-name`: string;

    /**
     * The parameters to create a key.
     */
    @body
    parameters: KeyCreateParameters;
  },
  KeyBundle
>;

/**
 * The operation will rotate the key based on the key policy. It requires the
 * keys/rotate permission.
 */
@summary("""
Creates a new key version, stores it, then returns key parameters, attributes
and policy to the client.
""")
@route("/keys/{key-name}/rotate")
@post
op rotateKey is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of key to be rotated. The system will generate a new version in the
     * specified key.
     */
    @pattern("^[0-9a-zA-Z-]+$")
    @path
    `key-name`: string;
  },
  KeyBundle
>;

/**
 * The import key operation may be used to import any key type into an Azure Key
 * Vault. If the named key already exists, Azure Key Vault creates a new version
 * of the key. This operation requires the keys/import permission.
 */
@summary("""
Imports an externally created key, stores it, and returns key parameters and
attributes to the client.
""")
@route("/keys/{key-name}")
@put
op importKey is Azure.Core.Foundations.Operation<
  {
    /**
     * Name for the imported key. The value you provide may be copied globally for the
     * purpose of running the service. The value provided should not include
     * personally identifiable or sensitive information.
     */
    @pattern("^[0-9a-zA-Z-]+$")
    @path
    `key-name`: string;

    /**
     * The parameters to import a key.
     */
    @body
    parameters: KeyImportParameters;
  },
  KeyBundle
>;

/**
 * The delete key operation cannot be used to remove individual versions of a key.
 * This operation removes the cryptographic material associated with the key,
 * which means the key is not usable for Sign/Verify, Wrap/Unwrap or
 * Encrypt/Decrypt operations. This operation requires the keys/delete permission.
 */
@summary("Deletes a key of any type from storage in Azure Key Vault.")
@route("/keys/{key-name}")
@delete
op deleteKey is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the key to delete.
     */
    @path
    `key-name`: string;
  },
  DeletedKeyBundle
>;

/**
 * In order to perform this operation, the key must already exist in the Key
 * Vault. Note: The cryptographic material of a key itself cannot be changed. This
 * operation requires the keys/update permission.
 */
@summary("""
The update key operation changes specified attributes of a stored key and can
be applied to any key type and key version stored in Azure Key Vault.
""")
@route("/keys/{key-name}/{key-version}")
@patch
op updateKey is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of key to update.
     */
    @path
    `key-name`: string;

    /**
     * The version of the key to update.
     */
    @path
    `key-version`: string;

    /**
     * The parameters of the key to update.
     */
    @body
    parameters: KeyUpdateParameters;
  },
  KeyBundle
>;

/**
 * The get key operation is applicable to all key types. If the requested key is
 * symmetric, then no key material is released in the response. This operation
 * requires the keys/get permission.
 */
@summary("Gets the public part of a stored key.")
@route("/keys/{key-name}/{key-version}")
@get
op getKey is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the key to get.
     */
    @path
    `key-name`: string;

    /**
     * Adding the version parameter retrieves a specific version of a key. This URI
     * fragment is optional. If not specified, the latest version of the key is
     * returned.
     */
    @path
    `key-version`: string;
  },
  KeyBundle
>;

/**
 * The full key identifier, attributes, and tags are provided in the response.
 * This operation requires the keys/list permission.
 */
@summary("Retrieves a list of individual key versions with the same key name.")
@route("/keys/{key-name}/versions")
@get
op getKeyVersions is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the key.
     */
    @path
    `key-name`: string;

    /**
     * Maximum number of results to return in a page. If not specified the service
     * will return up to 25 results.
     */
    @maxValue(25)
    @minValue(1)
    @query("maxresults")
    maxresults?: int32;
  },
  KeyListResult
>;

/**
 * Retrieves a list of the keys in the Key Vault as JSON Web Key structures that
 * contain the public part of a stored key. The LIST operation is applicable to
 * all key types, however only the base key identifier, attributes, and tags are
 * provided in the response. Individual versions of a key are not listed in the
 * response. This operation requires the keys/list permission.
 */
@summary("List keys in the specified vault.")
@route("/keys")
@get
op getKeys is Azure.Core.Foundations.Operation<
  {
    /**
     * Maximum number of results to return in a page. If not specified the service
     * will return up to 25 results.
     */
    @maxValue(25)
    @minValue(1)
    @query("maxresults")
    maxresults?: int32;
  },
  KeyListResult
>;

/**
 * The Key Backup operation exports a key from Azure Key Vault in a protected
 * form. Note that this operation does NOT return key material in a form that can
 * be used outside the Azure Key Vault system, the returned key material is either
 * protected to a Azure Key Vault HSM or to Azure Key Vault itself. The intent of
 * this operation is to allow a client to GENERATE a key in one Azure Key Vault
 * instance, BACKUP the key, and then RESTORE it into another Azure Key Vault
 * instance. The BACKUP operation may be used to export, in protected form, any
 * key type from Azure Key Vault. Individual versions of a key cannot be backed
 * up. BACKUP / RESTORE can be performed within geographical boundaries only;
 * meaning that a BACKUP from one geographical area cannot be restored to another
 * geographical area. For example, a backup from the US geographical area cannot
 * be restored in an EU geographical area. This operation requires the key/backup
 * permission.
 */
@summary("Requests that a backup of the specified key be downloaded to the client.")
@route("/keys/{key-name}/backup")
@post
op backupKey is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the key.
     */
    @path
    `key-name`: string;
  },
  BackupKeyResult
>;

/**
 * Imports a previously backed up key into Azure Key Vault, restoring the key, its
 * key identifier, attributes and access control policies. The RESTORE operation
 * may be used to import a previously backed up key. Individual versions of a key
 * cannot be restored. The key is restored in its entirety with the same key name
 * as it had when it was backed up. If the key name is not available in the target
 * Key Vault, the RESTORE operation will be rejected. While the key name is
 * retained during restore, the final key identifier will change if the key is
 * restored to a different vault. Restore will restore all versions and preserve
 * version identifiers. The RESTORE operation is subject to security constraints:
 * The target Key Vault must be owned by the same Microsoft Azure Subscription as
 * the source Key Vault The user must have RESTORE permission in the target Key
 * Vault. This operation requires the keys/restore permission.
 */
@summary("Restores a backed up key to a vault.")
@route("/keys/restore")
@post
op restoreKey is Azure.Core.Foundations.Operation<
  KeyRestoreParameters,
  KeyBundle
>;

/**
 * The ENCRYPT operation encrypts an arbitrary sequence of bytes using an
 * encryption key that is stored in Azure Key Vault. Note that the ENCRYPT
 * operation only supports a single block of data, the size of which is dependent
 * on the target key and the encryption algorithm to be used. The ENCRYPT
 * operation is only strictly necessary for symmetric keys stored in Azure Key
 * Vault since protection with an asymmetric key can be performed using public
 * portion of the key. This operation is supported for asymmetric keys as a
 * convenience for callers that have a key-reference but do not have access to the
 * public key material. This operation requires the keys/encrypt permission.
 */
@summary("""
Encrypts an arbitrary sequence of bytes using an encryption key that is stored
in a key vault.
""")
@route("/keys/{key-name}/{key-version}/encrypt")
@post
op encrypt is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the key.
     */
    @path
    `key-name`: string;

    /**
     * The version of the key.
     */
    @path
    `key-version`: string;

    /**
     * The parameters for the encryption operation.
     */
    @body
    parameters: KeyOperationsParameters;
  },
  KeyOperationResult
>;

/**
 * The DECRYPT operation decrypts a well-formed block of ciphertext using the
 * target encryption key and specified algorithm. This operation is the reverse of
 * the ENCRYPT operation; only a single block of data may be decrypted, the size
 * of this block is dependent on the target key and the algorithm to be used. The
 * DECRYPT operation applies to asymmetric and symmetric keys stored in Azure Key
 * Vault since it uses the private portion of the key. This operation requires the
 * keys/decrypt permission. Microsoft recommends not to use CBC algorithms for
 * decryption without first ensuring the integrity of the ciphertext using an
 * HMAC, for example. See
 * https://docs.microsoft.com/dotnet/standard/security/vulnerabilities-cbc-mode
 * for more information.
 */
@summary("Decrypts a single block of encrypted data.")
@route("/keys/{key-name}/{key-version}/decrypt")
@post
op decrypt is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the key.
     */
    @path
    `key-name`: string;

    /**
     * The version of the key.
     */
    @path
    `key-version`: string;

    /**
     * The parameters for the decryption operation.
     */
    @body
    parameters: KeyOperationsParameters;
  },
  KeyOperationResult
>;

/**
 * The SIGN operation is applicable to asymmetric and symmetric keys stored in
 * Azure Key Vault since this operation uses the private portion of the key. This
 * operation requires the keys/sign permission.
 */
@summary("Creates a signature from a digest using the specified key.")
@route("/keys/{key-name}/{key-version}/sign")
@post
op sign is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the key.
     */
    @path
    `key-name`: string;

    /**
     * The version of the key.
     */
    @path
    `key-version`: string;

    /**
     * The parameters for the signing operation.
     */
    @body
    parameters: KeySignParameters;
  },
  KeyOperationResult
>;

/**
 * The VERIFY operation is applicable to symmetric keys stored in Azure Key Vault.
 * VERIFY is not strictly necessary for asymmetric keys stored in Azure Key Vault
 * since signature verification can be performed using the public portion of the
 * key but this operation is supported as a convenience for callers that only have
 * a key-reference and not the public portion of the key. This operation requires
 * the keys/verify permission.
 */
@summary("Verifies a signature using a specified key.")
@route("/keys/{key-name}/{key-version}/verify")
@post
op verify is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the key.
     */
    @path
    `key-name`: string;

    /**
     * The version of the key.
     */
    @path
    `key-version`: string;

    /**
     * The parameters for verify operations.
     */
    @body
    parameters: KeyVerifyParameters;
  },
  KeyVerifyResult
>;

/**
 * The WRAP operation supports encryption of a symmetric key using a key
 * encryption key that has previously been stored in an Azure Key Vault. The WRAP
 * operation is only strictly necessary for symmetric keys stored in Azure Key
 * Vault since protection with an asymmetric key can be performed using the public
 * portion of the key. This operation is supported for asymmetric keys as a
 * convenience for callers that have a key-reference but do not have access to the
 * public key material. This operation requires the keys/wrapKey permission.
 */
@summary("Wraps a symmetric key using a specified key.")
@route("/keys/{key-name}/{key-version}/wrapkey")
@post
op wrapKey is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the key.
     */
    @path
    `key-name`: string;

    /**
     * The version of the key.
     */
    @path
    `key-version`: string;

    /**
     * The parameters for wrap operation.
     */
    @body
    parameters: KeyOperationsParameters;
  },
  KeyOperationResult
>;

/**
 * The UNWRAP operation supports decryption of a symmetric key using the target
 * key encryption key. This operation is the reverse of the WRAP operation. The
 * UNWRAP operation applies to asymmetric and symmetric keys stored in Azure Key
 * Vault since it uses the private portion of the key. This operation requires the
 * keys/unwrapKey permission.
 */
@summary("""
Unwraps a symmetric key using the specified key that was initially used for
wrapping that key.
""")
@route("/keys/{key-name}/{key-version}/unwrapkey")
@post
op unwrapKey is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the key.
     */
    @path
    `key-name`: string;

    /**
     * The version of the key.
     */
    @path
    `key-version`: string;

    /**
     * The parameters for the key operation.
     */
    @body
    parameters: KeyOperationsParameters;
  },
  KeyOperationResult
>;

/**
 * The release key operation is applicable to all key types. The target key must
 * be marked exportable. This operation requires the keys/release permission.
 */
@summary("Releases a key.")
@route("/keys/{key-name}/{key-version}/release")
@post
op release is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the key to get.
     */
    @path
    `key-name`: string;

    /**
     * Adding the version parameter retrieves a specific version of a key.
     */
    @path
    `key-version`: string;

    /**
     * The parameters for the key release operation.
     */
    @body
    parameters: KeyReleaseParameters;
  },
  KeyReleaseResult
>;

/**
 * Retrieves a list of the keys in the Key Vault as JSON Web Key structures that
 * contain the public part of a deleted key. This operation includes
 * deletion-specific information. The Get Deleted Keys operation is applicable for
 * vaults enabled for soft-delete. While the operation can be invoked on any
 * vault, it will return an error if invoked on a non soft-delete enabled vault.
 * This operation requires the keys/list permission.
 */
@summary("Lists the deleted keys in the specified vault.")
@route("/deletedkeys")
@get
op getDeletedKeys is Azure.Core.Foundations.Operation<
  {
    /**
     * Maximum number of results to return in a page. If not specified the service
     * will return up to 25 results.
     */
    @maxValue(25)
    @minValue(1)
    @query("maxresults")
    maxresults?: int32;
  },
  DeletedKeyListResult
>;

/**
 * The Get Deleted Key operation is applicable for soft-delete enabled vaults.
 * While the operation can be invoked on any vault, it will return an error if
 * invoked on a non soft-delete enabled vault. This operation requires the
 * keys/get permission.
 */
@summary("Gets the public part of a deleted key.")
@route("/deletedkeys/{key-name}")
@get
op getDeletedKey is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the key.
     */
    @path
    `key-name`: string;
  },
  DeletedKeyBundle
>;

/**
 * The Purge Deleted Key operation is applicable for soft-delete enabled vaults.
 * While the operation can be invoked on any vault, it will return an error if
 * invoked on a non soft-delete enabled vault. This operation requires the
 * keys/purge permission.
 */
@summary("Permanently deletes the specified key.")
@route("/deletedkeys/{key-name}")
@delete
op purgeDeletedKey is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the key
     */
    @path
    `key-name`: string;
  },
  void
>;

/**
 * The Recover Deleted Key operation is applicable for deleted keys in soft-delete
 * enabled vaults. It recovers the deleted key back to its latest version under
 * /keys. An attempt to recover an non-deleted key will return an error. Consider
 * this the inverse of the delete operation on soft-delete enabled vaults. This
 * operation requires the keys/recover permission.
 */
@summary("Recovers the deleted key to its latest version.")
@route("/deletedkeys/{key-name}/recover")
@post
op recoverDeletedKey is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the deleted key.
     */
    @path
    `key-name`: string;
  },
  KeyBundle
>;

/**
 * The GetKeyRotationPolicy operation returns the specified key policy resources
 * in the specified key vault. This operation requires the keys/get permission.
 */
@summary("Lists the policy for a key.")
@route("/keys/{key-name}/rotationpolicy")
@get
op getKeyRotationPolicy is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the key in a given key vault.
     */
    @path
    `key-name`: string;
  },
  KeyRotationPolicy
>;

/**
 * Set specified members in the key policy. Leave others as undefined. This
 * operation requires the keys/update permission.
 */
@summary("Updates the rotation policy for a key.")
@route("/keys/{key-name}/rotationpolicy")
@put
op updateKeyRotationPolicy is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the key in the given vault.
     */
    @path
    `key-name`: string;

    /**
     * The policy for the key.
     */
    @body
    keyRotationPolicy: KeyRotationPolicy;
  },
  KeyRotationPolicy
>;

/**
 * Get the requested number of bytes containing random values from a managed HSM.
 */
@summary("Get the requested number of bytes containing random values.")
@route("/rng")
@post
op getRandomBytes is Azure.Core.Foundations.Operation<
  GetRandomBytesRequest,
  RandomBytes
>;

/**
 *  The SET operation adds a secret to the Azure Key Vault. If the named secret
 * already exists, Azure Key Vault creates a new version of that secret. This
 * operation requires the secrets/set permission.
 */
@summary("Sets a secret in a specified key vault.")
@route("/secrets/{secret-name}")
@put
op setSecret is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the secret. The value you provide may be copied globally for the
     * purpose of running the service. The value provided should not include
     * personally identifiable or sensitive information.
     */
    @pattern("^[0-9a-zA-Z-]+$")
    @path
    `secret-name`: string;

    /**
     * The parameters for setting the secret.
     */
    @body
    parameters: SecretSetParameters;
  },
  SecretBundle
>;

/**
 * The DELETE operation applies to any secret stored in Azure Key Vault. DELETE
 * cannot be applied to an individual version of a secret. This operation requires
 * the secrets/delete permission.
 */
@summary("Deletes a secret from a specified key vault.")
@route("/secrets/{secret-name}")
@delete
op deleteSecret is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the secret.
     */
    @path
    `secret-name`: string;
  },
  DeletedSecretBundle
>;

/**
 * The UPDATE operation changes specified attributes of an existing stored secret.
 * Attributes that are not specified in the request are left unchanged. The value
 * of a secret itself cannot be changed. This operation requires the secrets/set
 * permission.
 */
@summary("Updates the attributes associated with a specified secret in a given key vault.")
@route("/secrets/{secret-name}/{secret-version}")
@patch
op updateSecret is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the secret.
     */
    @path
    `secret-name`: string;

    /**
     * The version of the secret.
     */
    @path
    `secret-version`: string;

    /**
     * The parameters for update secret operation.
     */
    @body
    parameters: SecretUpdateParameters;
  },
  SecretBundle
>;

/**
 * The GET operation is applicable to any secret stored in Azure Key Vault. This
 * operation requires the secrets/get permission.
 */
@summary("Get a specified secret from a given key vault.")
@route("/secrets/{secret-name}/{secret-version}")
@get
op getSecret is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the secret.
     */
    @path
    `secret-name`: string;

    /**
     * The version of the secret. This URI fragment is optional. If not specified, the
     * latest version of the secret is returned.
     */
    @path
    `secret-version`: string;
  },
  SecretBundle
>;

/**
 * The Get Secrets operation is applicable to the entire vault. However, only the
 * base secret identifier and its attributes are provided in the response.
 * Individual secret versions are not listed in the response. This operation
 * requires the secrets/list permission.
 */
@summary("List secrets in a specified key vault.")
@route("/secrets")
@get
op getSecrets is Azure.Core.Foundations.Operation<
  {
    /**
     * Maximum number of results to return in a page. If not specified, the service
     * will return up to 25 results.
     */
    @maxValue(25)
    @minValue(1)
    @query("maxresults")
    maxresults?: int32;
  },
  SecretListResult
>;

/**
 * The full secret identifier and attributes are provided in the response. No
 * values are returned for the secrets. This operations requires the secrets/list
 * permission.
 */
@summary("List all versions of the specified secret.")
@route("/secrets/{secret-name}/versions")
@get
op getSecretVersions is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the secret.
     */
    @path
    `secret-name`: string;

    /**
     * Maximum number of results to return in a page. If not specified, the service
     * will return up to 25 results.
     */
    @maxValue(25)
    @minValue(1)
    @query("maxresults")
    maxresults?: int32;
  },
  SecretListResult
>;

/**
 * The Get Deleted Secrets operation returns the secrets that have been deleted
 * for a vault enabled for soft-delete. This operation requires the secrets/list
 * permission.
 */
@summary("Lists deleted secrets for the specified vault.")
@route("/deletedsecrets")
@get
op getDeletedSecrets is Azure.Core.Foundations.Operation<
  {
    /**
     * Maximum number of results to return in a page. If not specified the service
     * will return up to 25 results.
     */
    @maxValue(25)
    @minValue(1)
    @query("maxresults")
    maxresults?: int32;
  },
  DeletedSecretListResult
>;

/**
 * The Get Deleted Secret operation returns the specified deleted secret along
 * with its attributes. This operation requires the secrets/get permission.
 */
@summary("Gets the specified deleted secret.")
@route("/deletedsecrets/{secret-name}")
@get
op getDeletedSecret is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the secret.
     */
    @path
    `secret-name`: string;
  },
  DeletedSecretBundle
>;

/**
 * The purge deleted secret operation removes the secret permanently, without the
 * possibility of recovery. This operation can only be enabled on a soft-delete
 * enabled vault. This operation requires the secrets/purge permission.
 */
@summary("Permanently deletes the specified secret.")
@route("/deletedsecrets/{secret-name}")
@delete
op purgeDeletedSecret is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the secret.
     */
    @path
    `secret-name`: string;
  },
  void
>;

/**
 * Recovers the deleted secret in the specified vault. This operation can only be
 * performed on a soft-delete enabled vault. This operation requires the
 * secrets/recover permission.
 */
@summary("Recovers the deleted secret to the latest version.")
@route("/deletedsecrets/{secret-name}/recover")
@post
op recoverDeletedSecret is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the deleted secret.
     */
    @path
    `secret-name`: string;
  },
  SecretBundle
>;

/**
 * Requests that a backup of the specified secret be downloaded to the client. All
 * versions of the secret will be downloaded. This operation requires the
 * secrets/backup permission.
 */
@summary("Backs up the specified secret.")
@route("/secrets/{secret-name}/backup")
@post
op backupSecret is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the secret.
     */
    @path
    `secret-name`: string;
  },
  BackupSecretResult
>;

/**
 * Restores a backed up secret, and all its versions, to a vault. This operation
 * requires the secrets/restore permission.
 */
@summary("Restores a backed up secret to a vault.")
@route("/secrets/restore")
@post
op restoreSecret is Azure.Core.Foundations.Operation<
  SecretRestoreParameters,
  SecretBundle
>;

/**
 * Description of the pool setting to be updated
 */
@summary("""
Updates key vault account setting, stores it, then returns the setting name and
value to the client.
""")
@route("/settings/{setting-name}")
@patch
op updateSettings is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the account setting. Must be a valid settings option.
     */
    @path
    `setting-name`: string;

    /**
     * The parameters to update an account setting.
     */
    @body
    parameters: UpdateSettingsRequest;
  },
  Setting
>;

/**
 * Retrieves the value of a specified, value account setting.
 */
@summary("Get specified account setting value.")
@route("/settings/{setting-name}")
@get
op getSettingValue is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the account setting. Must be a valid settings option.
     */
    @path
    `setting-name`: string;
  },
  Setting
>;

/**
 * Retrieves a list of all the available account settings that can be configured.
 */
@summary("List account settings.")
@route("/settings")
@get
op getSettings is Azure.Core.Foundations.Operation<{}, SettingsListResult>;

/**
 * List storage accounts managed by the specified key vault. This operation
 * requires the storage/list permission.
 */
@route("/storage")
@get
op getStorageAccounts is Azure.Core.Foundations.Operation<
  {
    /**
     * Maximum number of results to return in a page. If not specified the service
     * will return up to 25 results.
     */
    @maxValue(25)
    @minValue(1)
    @query("maxresults")
    maxresults?: int32;
  },
  StorageListResult
>;

/**
 * The Get Deleted Storage Accounts operation returns the storage accounts that
 * have been deleted for a vault enabled for soft-delete. This operation requires
 * the storage/list permission.
 */
@summary("Lists deleted storage accounts for the specified vault.")
@route("/deletedstorage")
@get
op getDeletedStorageAccounts is Azure.Core.Foundations.Operation<
  {
    /**
     * Maximum number of results to return in a page. If not specified the service
     * will return up to 25 results.
     */
    @maxValue(25)
    @minValue(1)
    @query("maxresults")
    maxresults?: int32;
  },
  DeletedStorageListResult
>;

/**
 * The Get Deleted Storage Account operation returns the specified deleted storage
 * account along with its attributes. This operation requires the storage/get
 * permission.
 */
@summary("Gets the specified deleted storage account.")
@route("/deletedstorage/{storage-account-name}")
@get
op getDeletedStorageAccount is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the storage account.
     */
    @pattern("^[0-9a-zA-Z]+$")
    @path
    `storage-account-name`: string;
  },
  DeletedStorageBundle
>;

/**
 * The purge deleted storage account operation removes the secret permanently,
 * without the possibility of recovery. This operation can only be performed on a
 * soft-delete enabled vault. This operation requires the storage/purge
 * permission.
 */
@summary("Permanently deletes the specified storage account.")
@route("/deletedstorage/{storage-account-name}")
@delete
op purgeDeletedStorageAccount is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the storage account.
     */
    @pattern("^[0-9a-zA-Z]+$")
    @path
    `storage-account-name`: string;
  },
  void
>;

/**
 * Recovers the deleted storage account in the specified vault. This operation can
 * only be performed on a soft-delete enabled vault. This operation requires the
 * storage/recover permission.
 */
@summary("Recovers the deleted storage account.")
@route("/deletedstorage/{storage-account-name}/recover")
@post
op recoverDeletedStorageAccount is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the storage account.
     */
    @pattern("^[0-9a-zA-Z]+$")
    @path
    `storage-account-name`: string;
  },
  StorageBundle
>;

/**
 * Requests that a backup of the specified storage account be downloaded to the
 * client. This operation requires the storage/backup permission.
 */
@summary("Backs up the specified storage account.")
@route("/storage/{storage-account-name}/backup")
@post
op backupStorageAccount is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the storage account.
     */
    @path
    `storage-account-name`: string;
  },
  BackupStorageResult
>;

/**
 * Restores a backed up storage account to a vault. This operation requires the
 * storage/restore permission.
 */
@summary("Restores a backed up storage account to a vault.")
@route("/storage/restore")
@post
op restoreStorageAccount is Azure.Core.Foundations.Operation<
  StorageRestoreParameters,
  StorageBundle
>;

/**
 * Deletes a storage account. This operation requires the storage/delete
 * permission.
 */
@route("/storage/{storage-account-name}")
@delete
op deleteStorageAccount is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the storage account.
     */
    @pattern("^[0-9a-zA-Z]+$")
    @path
    `storage-account-name`: string;
  },
  DeletedStorageBundle
>;

/**
 * Gets information about a specified storage account. This operation requires the
 * storage/get permission.
 */
@route("/storage/{storage-account-name}")
@get
op getStorageAccount is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the storage account.
     */
    @pattern("^[0-9a-zA-Z]+$")
    @path
    `storage-account-name`: string;
  },
  StorageBundle
>;

/**
 * Creates or updates a new storage account. This operation requires the
 * storage/set permission.
 */
@route("/storage/{storage-account-name}")
@put
op setStorageAccount is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the storage account. The value you provide may be copied globally
     * for the purpose of running the service. The value provided should not include
     * personally identifiable or sensitive information.
     */
    @pattern("^[0-9a-zA-Z]+$")
    @path
    `storage-account-name`: string;

    /**
     * The parameters to create a storage account.
     */
    @body
    parameters: StorageAccountCreateParameters;
  },
  StorageBundle
>;

/**
 * Updates the specified attributes associated with the given storage account.
 * This operation requires the storage/set/update permission.
 */
@route("/storage/{storage-account-name}")
@patch
op updateStorageAccount is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the storage account.
     */
    @pattern("^[0-9a-zA-Z]+$")
    @path
    `storage-account-name`: string;

    /**
     * The parameters to update a storage account.
     */
    @body
    parameters: StorageAccountUpdateParameters;
  },
  StorageBundle
>;

/**
 * Regenerates the specified key value for the given storage account. This
 * operation requires the storage/regeneratekey permission.
 */
@route("/storage/{storage-account-name}/regeneratekey")
@post
op regenerateStorageAccountKey is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the storage account.
     */
    @pattern("^[0-9a-zA-Z]+$")
    @path
    `storage-account-name`: string;

    /**
     * The parameters to regenerate storage account key.
     */
    @body
    parameters: StorageAccountRegenerteKeyParameters;
  },
  StorageBundle
>;

/**
 * List storage SAS definitions for the given storage account. This operation
 * requires the storage/listsas permission.
 */
@route("/storage/{storage-account-name}/sas")
@get
op getSasDefinitions is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the storage account.
     */
    @pattern("^[0-9a-zA-Z]+$")
    @path
    `storage-account-name`: string;

    /**
     * Maximum number of results to return in a page. If not specified the service
     * will return up to 25 results.
     */
    @maxValue(25)
    @minValue(1)
    @query("maxresults")
    maxresults?: int32;
  },
  SasDefinitionListResult
>;

/**
 * The Get Deleted Sas Definitions operation returns the SAS definitions that have
 * been deleted for a vault enabled for soft-delete. This operation requires the
 * storage/listsas permission.
 */
@summary("Lists deleted SAS definitions for the specified vault and storage account.")
@route("/deletedstorage/{storage-account-name}/sas")
@get
op getDeletedSasDefinitions is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the storage account.
     */
    @pattern("^[0-9a-zA-Z]+$")
    @path
    `storage-account-name`: string;

    /**
     * Maximum number of results to return in a page. If not specified the service
     * will return up to 25 results.
     */
    @maxValue(25)
    @minValue(1)
    @query("maxresults")
    maxresults?: int32;
  },
  DeletedSasDefinitionListResult
>;

/**
 * The Get Deleted SAS Definition operation returns the specified deleted SAS
 * definition along with its attributes. This operation requires the
 * storage/getsas permission.
 */
@summary("Gets the specified deleted sas definition.")
@route("/deletedstorage/{storage-account-name}/sas/{sas-definition-name}")
@get
op getDeletedSasDefinition is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the storage account.
     */
    @pattern("^[0-9a-zA-Z]+$")
    @path
    `storage-account-name`: string;

    /**
     * The name of the SAS definition.
     */
    @pattern("^[0-9a-zA-Z]+$")
    @path
    `sas-definition-name`: string;
  },
  DeletedSasDefinitionBundle
>;

/**
 * Recovers the deleted SAS definition for the specified storage account. This
 * operation can only be performed on a soft-delete enabled vault. This operation
 * requires the storage/recover permission.
 */
@summary("Recovers the deleted SAS definition.")
@route("/deletedstorage/{storage-account-name}/sas/{sas-definition-name}/recover")
@post
op recoverDeletedSasDefinition is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the storage account.
     */
    @pattern("^[0-9a-zA-Z]+$")
    @path
    `storage-account-name`: string;

    /**
     * The name of the SAS definition.
     */
    @pattern("^[0-9a-zA-Z]+$")
    @path
    `sas-definition-name`: string;
  },
  SasDefinitionBundle
>;

/**
 * Deletes a SAS definition from a specified storage account. This operation
 * requires the storage/deletesas permission.
 */
@route("/storage/{storage-account-name}/sas/{sas-definition-name}")
@delete
op deleteSasDefinition is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the storage account.
     */
    @pattern("^[0-9a-zA-Z]+$")
    @path
    `storage-account-name`: string;

    /**
     * The name of the SAS definition.
     */
    @pattern("^[0-9a-zA-Z]+$")
    @path
    `sas-definition-name`: string;
  },
  DeletedSasDefinitionBundle
>;

/**
 * Gets information about a SAS definition for the specified storage account. This
 * operation requires the storage/getsas permission.
 */
@route("/storage/{storage-account-name}/sas/{sas-definition-name}")
@get
op getSasDefinition is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the storage account.
     */
    @pattern("^[0-9a-zA-Z]+$")
    @path
    `storage-account-name`: string;

    /**
     * The name of the SAS definition.
     */
    @pattern("^[0-9a-zA-Z]+$")
    @path
    `sas-definition-name`: string;
  },
  SasDefinitionBundle
>;

/**
 * Creates or updates a new SAS definition for the specified storage account. This
 * operation requires the storage/setsas permission.
 */
@route("/storage/{storage-account-name}/sas/{sas-definition-name}")
@put
op setSasDefinition is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the storage account.
     */
    @pattern("^[0-9a-zA-Z]+$")
    @path
    `storage-account-name`: string;

    /**
     * The name of the SAS definition. The value you provide may be copied globally
     * for the purpose of running the service. The value provided should not include
     * personally identifiable or sensitive information.
     */
    @pattern("^[0-9a-zA-Z]+$")
    @path
    `sas-definition-name`: string;

    /**
     * The parameters to create a SAS definition.
     */
    @body
    parameters: SasDefinitionCreateParameters;
  },
  SasDefinitionBundle
>;

/**
 * Updates the specified attributes associated with the given SAS definition. This
 * operation requires the storage/setsas permission.
 */
@route("/storage/{storage-account-name}/sas/{sas-definition-name}")
@patch
op updateSasDefinition is Azure.Core.Foundations.Operation<
  {
    /**
     * The name of the storage account.
     */
    @pattern("^[0-9a-zA-Z]+$")
    @path
    `storage-account-name`: string;

    /**
     * The name of the SAS definition.
     */
    @pattern("^[0-9a-zA-Z]+$")
    @path
    `sas-definition-name`: string;

    /**
     * The parameters to update a SAS definition.
     */
    @body
    parameters: SasDefinitionUpdateParameters;
  },
  SasDefinitionBundle
>;

interface RoleDefinitionsOperations {
  /**
   * Deletes a custom role definition.
   */
  @route("/{scope}/providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionName}")
  @delete
  delete is Azure.Core.Foundations.Operation<
    {
      /**
       * The scope of the role definition to delete. Managed HSM only supports '/'.
       */
      @path
      scope: string;

      /**
       * The name (GUID) of the role definition to delete.
       */
      @path
      roleDefinitionName: string;
    },
    RoleDefinition
  >;

  /**
   * Creates or updates a custom role definition.
   */
  @route("/{scope}/providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionName}")
  @put
  createOrUpdate is Azure.Core.Foundations.Operation<
    {
      /**
       * The scope of the role definition to create or update. Managed HSM only supports
       * '/'.
       */
      @path
      scope: string;

      /**
       * The name of the role definition to create or update. It can be any valid GUID.
       */
      @path
      roleDefinitionName: string;

      /**
       * Parameters for the role definition.
       */
      @body
      parameters: RoleDefinitionCreateParameters;
    },
    RoleDefinition
  >;

  /**
   * Get the specified role definition.
   */
  @route("/{scope}/providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionName}")
  @get
  get is Azure.Core.Foundations.Operation<
    {
      /**
       * The scope of the role definition to get. Managed HSM only supports '/'.
       */
      @path
      scope: string;

      /**
       * The name of the role definition to get.
       */
      @path
      roleDefinitionName: string;
    },
    RoleDefinition
  >;

  /**
   * Get all role definitions that are applicable at scope and above.
   */
  @route("/{scope}/providers/Microsoft.Authorization/roleDefinitions")
  @get
  list is Azure.Core.Foundations.Operation<
    {
      /**
       * The scope of the role definition.
       */
      @path
      scope: string;

      /**
       * The filter to apply on the operation. Use atScopeAndBelow filter to search
       * below the given scope as well.
       */
      @query("$filter")
      $filter?: string;
    },
    RoleDefinitionListResult
  >;
}

interface RoleAssignmentsOperations {
  /**
   * Deletes a role assignment.
   */
  @route("/{scope}/providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}")
  @delete
  delete is Azure.Core.Foundations.Operation<
    {
      /**
       * The scope of the role assignment to delete.
       */
      @path
      scope: string;

      /**
       * The name of the role assignment to delete.
       */
      @path
      roleAssignmentName: string;
    },
    RoleAssignment
  >;

  /**
   * Creates a role assignment.
   */
  @route("/{scope}/providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}")
  @put
  create is Azure.Core.Foundations.Operation<
    {
      /**
       * The scope of the role assignment to create.
       */
      @path
      scope: string;

      /**
       * The name of the role assignment to create. It can be any valid GUID.
       */
      @path
      roleAssignmentName: string;

      /**
       * Parameters for the role assignment.
       */
      @body
      parameters: RoleAssignmentCreateParameters;
    },
    RoleAssignment
  >;

  /**
   * Get the specified role assignment.
   */
  @route("/{scope}/providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}")
  @get
  get is Azure.Core.Foundations.Operation<
    {
      /**
       * The scope of the role assignment.
       */
      @path
      scope: string;

      /**
       * The name of the role assignment to get.
       */
      @path
      roleAssignmentName: string;
    },
    RoleAssignment
  >;

  /**
   * Gets role assignments for a scope.
   */
  @route("/{scope}/providers/Microsoft.Authorization/roleAssignments")
  @get
  listForScope is Azure.Core.Foundations.Operation<
    {
      /**
       * The scope of the role assignments.
       */
      @path
      scope: string;

      /**
       * The filter to apply on the operation. Use $filter=atScope() to return all role
       * assignments at or above the scope. Use $filter=principalId eq {id} to return
       * all role assignments at, above or below the scope for the specified principal.
       */
      @query("$filter")
      $filter?: string;
    },
    RoleAssignmentListResult
  >;
}

interface HSMSecurityDomainOperations {
  /**
   * Retrieves the Security Domain download operation status
   */
  @route("/securitydomain/download/pending")
  @get
  downloadPending is Azure.Core.Foundations.Operation<
    {},
    SecurityDomainOperationStatus
  >;

  /**
   * Retrieves the Security Domain from the managed HSM. Calling this endpoint can
   * be used to activate a provisioned managed HSM resource.
   */
  @route("/securitydomain/download")
  @post
  download is Azure.Core.Foundations.Operation<
    CertificateInfoObject,
    SecurityDomainObject
  >;

  /**
   * Retrieve Security Domain transfer key
   */
  @route("/securitydomain/upload")
  @get
  transferKey is Azure.Core.Foundations.Operation<{}, TransferKey>;

  /**
   * Restore the provided Security Domain.
   */
  @route("/securitydomain/upload")
  @post
  upload is Azure.Core.Foundations.Operation<
    SecurityDomainObject,
    SecurityDomainOperationStatus | void
  >;

  /**
   * Get Security Domain upload operation status
   */
  @route("/securitydomain/upload/pending")
  @get
  uploadPending is Azure.Core.Foundations.Operation<
    {},
    SecurityDomainOperationStatus
  >;
}
