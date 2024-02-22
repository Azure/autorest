import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;

namespace Azure.Keyvault;

/**
 * Reflects the deletion recovery level currently in effect for certificates in
 * the current vault. If it contains 'Purgeable', the certificate can be
 * permanently deleted by a privileged user; otherwise, only the system can purge
 * the certificate, at the end of the retention interval.
 */
enum DeletionRecoveryLevel {
  /**
   * Denotes a vault state in which deletion is an irreversible operation, without
   * the possibility for recovery. This level corresponds to no protection being
   * available against a Delete operation; the data is irretrievably lost upon
   * accepting a Delete operation at the entity level or higher (vault, resource
   * group, subscription etc.)
   */
  Purgeable,

  /**
   * Denotes a vault state in which deletion is recoverable, and which also permits
   * immediate and permanent deletion (i.e. purge). This level guarantees the
   * recoverability of the deleted entity during the retention interval (90 days),
   * unless a Purge operation is requested, or the subscription is cancelled. System
   * wil permanently delete it after 90 days, if not recovered
   */
  `Recoverable+Purgeable`,

  /**
   * Denotes a vault state in which deletion is recoverable without the possibility
   * for immediate and permanent deletion (i.e. purge). This level guarantees the
   * recoverability of the deleted entity during the retention interval(90 days) and
   * while the subscription is still available. System wil permanently delete it
   * after 90 days, if not recovered
   */
  Recoverable,

  /**
   * Denotes a vault and subscription state in which deletion is recoverable within
   * retention interval (90 days), immediate and permanent deletion (i.e. purge) is
   * not permitted, and in which the subscription itself  cannot be permanently
   * canceled. System wil permanently delete it after 90 days, if not recovered
   */
  `Recoverable+ProtectedSubscription`,

  /**
   * Denotes a vault state in which deletion is recoverable, and which also permits
   * immediate and permanent deletion (i.e. purge when 7<= SoftDeleteRetentionInDays
   * < 90). This level guarantees the recoverability of the deleted entity during
   * the retention interval, unless a Purge operation is requested, or the
   * subscription is cancelled.
   */
  `CustomizedRecoverable+Purgeable`,

  /**
   * Denotes a vault state in which deletion is recoverable without the possibility
   * for immediate and permanent deletion (i.e. purge when 7<=
   * SoftDeleteRetentionInDays < 90).This level guarantees the recoverability of the
   * deleted entity during the retention interval and while the subscription is
   * still available.
   */
  CustomizedRecoverable,

  /**
   * Denotes a vault and subscription state in which deletion is recoverable,
   * immediate and permanent deletion (i.e. purge) is not permitted, and in which
   * the subscription itself cannot be permanently canceled when 7<=
   * SoftDeleteRetentionInDays < 90. This level guarantees the recoverability of the
   * deleted entity during the retention interval, and also reflects the fact that
   * the subscription itself cannot be cancelled.
   */
  `CustomizedRecoverable+ProtectedSubscription`,
}

/**
 * JsonWebKey Key Type (kty), as defined in
 * https://tools.ietf.org/html/draft-ietf-jose-json-web-algorithms-40.
 */
enum JsonWebKeyType {
  /**
   * Elliptic Curve.
   */
  EC,

  /**
   * Elliptic Curve with a private key which is stored in the HSM.
   */
  `EC-HSM`,

  /**
   * RSA (https://tools.ietf.org/html/rfc3447)
   */
  RSA,

  /**
   * RSA with a private key which is stored in the HSM.
   */
  `RSA-HSM`,

  /**
   * Octet sequence (used to represent symmetric keys)
   */
  oct,

  /**
   * Octet sequence (used to represent symmetric keys) which is stored the HSM.
   */
  `oct-HSM`,

  /**
   * Octet key pair (https://tools.ietf.org/html/rfc8037)
   */
  OKP,

  /**
   * Octet key pair (https://tools.ietf.org/html/rfc8037) with a private key which
   * is stored in the HSM.
   */
  `OKP-HSM`,
}

/**
 * Elliptic curve name. For valid values, see JsonWebKeyCurveName.
 */
enum JsonWebKeyCurveName {
  /**
   * The NIST P-256 elliptic curve, AKA SECG curve SECP256R1.
   */
  `P-256`,

  /**
   * The NIST P-384 elliptic curve, AKA SECG curve SECP384R1.
   */
  `P-384`,

  /**
   * The NIST P-521 elliptic curve, AKA SECG curve SECP521R1.
   */
  `P-521`,

  /**
   * The SECG SECP256K1 elliptic curve.
   */
  `P-256K`,

  /**
   * The Ed25519 Edwards curve.
   */
  Ed25519,
}

enum KeyUsageType {
  digitalSignature,
  nonRepudiation,
  keyEncipherment,
  dataEncipherment,
  keyAgreement,
  keyCertSign,
  cRLSign,
  encipherOnly,
  decipherOnly,
}

/**
 * JSON web key operations. For more information, see JsonWebKeyOperation.
 */
enum JsonWebKeyOperation {
  encrypt,
  decrypt,
  sign,
  verify,
  wrapKey,
  unwrapKey,
  `import`,
  export,
}

/**
 * algorithm identifier
 */
enum JsonWebKeyEncryptionAlgorithm {
  `RSA-OAEP`,
  `RSA-OAEP-256`,
  RSA1_5,
  A128GCM,
  A192GCM,
  A256GCM,
  A128KW,
  A192KW,
  A256KW,
  A128CBC,
  A192CBC,
  A256CBC,
  A128CBCPAD,
  A192CBCPAD,
  A256CBCPAD,
}

/**
 * The signing/verification algorithm identifier. For more information on possible
 * algorithm types, see JsonWebKeySignatureAlgorithm.
 */
enum JsonWebKeySignatureAlgorithm {
  /**
   * RSASSA-PSS using SHA-256 and MGF1 with SHA-256, as described in
   * https://tools.ietf.org/html/rfc7518
   */
  PS256,

  /**
   * RSASSA-PSS using SHA-384 and MGF1 with SHA-384, as described in
   * https://tools.ietf.org/html/rfc7518
   */
  PS384,

  /**
   * RSASSA-PSS using SHA-512 and MGF1 with SHA-512, as described in
   * https://tools.ietf.org/html/rfc7518
   */
  PS512,

  /**
   * RSASSA-PKCS1-v1_5 using SHA-256, as described in
   * https://tools.ietf.org/html/rfc7518
   */
  RS256,

  /**
   * RSASSA-PKCS1-v1_5 using SHA-384, as described in
   * https://tools.ietf.org/html/rfc7518
   */
  RS384,

  /**
   * RSASSA-PKCS1-v1_5 using SHA-512, as described in
   * https://tools.ietf.org/html/rfc7518
   */
  RS512,

  /**
   * Reserved
   */
  RSNULL,

  /**
   * ECDSA using P-256 and SHA-256, as described in
   * https://tools.ietf.org/html/rfc7518.
   */
  ES256,

  /**
   * ECDSA using P-384 and SHA-384, as described in
   * https://tools.ietf.org/html/rfc7518
   */
  ES384,

  /**
   * ECDSA using P-521 and SHA-512, as described in
   * https://tools.ietf.org/html/rfc7518
   */
  ES512,

  /**
   * ECDSA using P-256K and SHA-256, as described in
   * https://tools.ietf.org/html/rfc7518
   */
  ES256K,

  /**
   * Edwards-Curve Digital Signature Algorithm, as described in
   * https://tools.ietf.org/html/rfc8032.
   */
  EdDSA,
}

/**
 * The encryption algorithm to use to protected the exported key material
 */
enum KeyEncryptionAlgorithm {
  CKM_RSA_AES_KEY_WRAP,
  RSA_AES_KEY_WRAP_256,
  RSA_AES_KEY_WRAP_384,
}

/**
 * The role definition type.
 */
enum RoleDefinitionType {
  `Microsoft.Authorization/roleDefinitions`,
}

/**
 * The role type.
 */
enum RoleType {
  /**
   * Built in role.
   */
  BuiltInRole: "AKVBuiltInRole",

  /**
   * Custom role.
   */
  CustomRole,
}

/**
 * Supported permissions for data actions.
 */
enum DataAction {
  /**
   * Read HSM key metadata.
   */
  ReadHsmKey: "Microsoft.KeyVault/managedHsm/keys/read/action",

  /**
   * Update an HSM key.
   */
  WriteHsmKey: "Microsoft.KeyVault/managedHsm/keys/write/action",

  /**
   * Read deleted HSM key.
   */
  ReadDeletedHsmKey: "Microsoft.KeyVault/managedHsm/keys/deletedKeys/read/action",

  /**
   * Recover deleted HSM key.
   */
  RecoverDeletedHsmKey: "Microsoft.KeyVault/managedHsm/keys/deletedKeys/recover/action",

  /**
   * Backup HSM keys.
   */
  BackupHsmKeys: "Microsoft.KeyVault/managedHsm/keys/backup/action",

  /**
   * Restore HSM keys.
   */
  RestoreHsmKeys: "Microsoft.KeyVault/managedHsm/keys/restore/action",

  /**
   * Delete role assignment.
   */
  DeleteRoleAssignment: "Microsoft.KeyVault/managedHsm/roleAssignments/delete/action",

  /**
   * Get role assignment.
   */
  GetRoleAssignment: "Microsoft.KeyVault/managedHsm/roleAssignments/read/action",

  /**
   * Create or update role assignment.
   */
  WriteRoleAssignment: "Microsoft.KeyVault/managedHsm/roleAssignments/write/action",

  /**
   * Get role definition.
   */
  ReadRoleDefinition: "Microsoft.KeyVault/managedHsm/roleDefinitions/read/action",

  /**
   * Create or update role definition.
   */
  WriteRoleDefinition: "Microsoft.KeyVault/managedHsm/roleDefinitions/write/action",

  /**
   * Delete role definition.
   */
  DeleteRoleDefinition: "Microsoft.KeyVault/managedHsm/roleDefinitions/delete/action",

  /**
   * Encrypt using an HSM key.
   */
  EncryptHsmKey: "Microsoft.KeyVault/managedHsm/keys/encrypt/action",

  /**
   * Decrypt using an HSM key.
   */
  DecryptHsmKey: "Microsoft.KeyVault/managedHsm/keys/decrypt/action",

  /**
   * Wrap using an HSM key.
   */
  WrapHsmKey: "Microsoft.KeyVault/managedHsm/keys/wrap/action",

  /**
   * Unwrap using an HSM key.
   */
  UnwrapHsmKey: "Microsoft.KeyVault/managedHsm/keys/unwrap/action",

  /**
   * Sign using an HSM key.
   */
  SignHsmKey: "Microsoft.KeyVault/managedHsm/keys/sign/action",

  /**
   * Verify using an HSM key.
   */
  VerifyHsmKey: "Microsoft.KeyVault/managedHsm/keys/verify/action",

  /**
   * Create an HSM key.
   */
  CreateHsmKey: "Microsoft.KeyVault/managedHsm/keys/create",

  /**
   * Delete an HSM key.
   */
  DeleteHsmKey: "Microsoft.KeyVault/managedHsm/keys/delete",

  /**
   * Export an HSM key.
   */
  ExportHsmKey: "Microsoft.KeyVault/managedHsm/keys/export/action",

  /**
   * Release an HSM key using Secure Key Release.
   */
  ReleaseKey: "Microsoft.KeyVault/managedHsm/keys/release/action",

  /**
   * Import an HSM key.
   */
  ImportHsmKey: "Microsoft.KeyVault/managedHsm/keys/import/action",

  /**
   * Purge a deleted HSM key.
   */
  PurgeDeletedHsmKey: "Microsoft.KeyVault/managedHsm/keys/deletedKeys/delete",

  /**
   * Download an HSM security domain.
   */
  DownloadHsmSecurityDomain: "Microsoft.KeyVault/managedHsm/securitydomain/download/action",

  /**
   * Check status of HSM security domain download.
   */
  DownloadHsmSecurityDomainStatus: "Microsoft.KeyVault/managedHsm/securitydomain/download/read",

  /**
   * Upload an HSM security domain.
   */
  UploadHsmSecurityDomain: "Microsoft.KeyVault/managedHsm/securitydomain/upload/action",

  /**
   * Check the status of the HSM security domain exchange file.
   */
  ReadHsmSecurityDomainStatus: "Microsoft.KeyVault/managedHsm/securitydomain/upload/read",

  /**
   * Download an HSM security domain transfer key.
   */
  ReadHsmSecurityDomainTransferKey: "Microsoft.KeyVault/managedHsm/securitydomain/transferkey/read",

  /**
   * Start an HSM backup.
   */
  StartHsmBackup: "Microsoft.KeyVault/managedHsm/backup/start/action",

  /**
   * Start an HSM restore.
   */
  StartHsmRestore: "Microsoft.KeyVault/managedHsm/restore/start/action",

  /**
   * Read an HSM backup status.
   */
  ReadHsmBackupStatus: "Microsoft.KeyVault/managedHsm/backup/status/action",

  /**
   * Read an HSM restore status.
   */
  ReadHsmRestoreStatus: "Microsoft.KeyVault/managedHsm/restore/status/action",

  /**
   * Generate random numbers.
   */
  RandomNumbersGenerate: "Microsoft.KeyVault/managedHsm/rng/action",
}

/**
 * The role scope.
 */
enum RoleScope {
  /**
   * Global scope
   */
  Global: "/",

  /**
   * Keys scope
   */
  Keys: "/keys",
}

/**
 * The type specifier of the value.
 */
enum SettingTypeEnum {
  boolean,
}

/**
 * The type of SAS token the SAS definition will create.
 */
enum SasTokenType {
  account,
  service,
}

/**
 * The type of the action.
 */
@fixed
enum ActionType {
  EmailContacts,
  AutoRenew,
  rotate,
  notify,
}

/**
 * operation status
 */
@fixed
enum OperationStatus {
  Success,
  InProgress,
  Failed,
}

model SASTokenParameter {
  /**
   * Azure Blob storage container Uri
   */
  storageResourceUri: string;

  /**
   * The SAS token pointing to an Azure Blob storage container
   */
  token: string;
}

/**
 * Full backup operation
 */
model FullBackupOperation {
  /**
   * Status of the backup operation.
   */
  status?: string;

  /**
   * The status details of backup operation.
   */
  statusDetails?: string;

  /**
   * Error encountered, if any, during the full backup operation.
   */
  error?: Error;

  /**
   * The start time of the backup operation in UTC
   */
  startTime?: plainTime;

  /**
   * The end time of the backup operation in UTC
   */
  endTime?: plainTime;

  /**
   * Identifier for the full backup operation.
   */
  jobId?: string;

  /**
   * The Azure blob storage container Uri which contains the full backup
   */
  azureStorageBlobContainerUri?: string;
}

/**
 * The key vault server error.
 */
model Error {
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

  /**
   * The key vault server error.
   */
  @visibility("read")
  @encodedName("application/json", "innererror")
  innerError?: Error;
}

/**
 * The key vault error exception.
 */
@error
model KeyVaultError {
  /**
   * The key vault server error.
   */
  @visibility("read")
  error?: Error;
}

model RestoreOperationParameters {
  sasTokenParameters: SASTokenParameter;

  /**
   * The Folder name of the blob where the previous successful full backup was stored
   */
  folderToRestore: string;
}

/**
 * Restore operation
 */
model RestoreOperation {
  /**
   * Status of the restore operation.
   */
  status?: string;

  /**
   * The status details of restore operation.
   */
  statusDetails?: string;

  /**
   * Error encountered, if any, during the restore operation.
   */
  error?: Error;

  /**
   * Identifier for the restore operation.
   */
  jobId?: string;

  /**
   * The start time of the restore operation
   */
  startTime?: plainTime;

  /**
   * The end time of the restore operation
   */
  endTime?: plainTime;
}

model SelectiveKeyRestoreOperationParameters {
  sasTokenParameters: SASTokenParameter;

  /**
   * The Folder name of the blob where the previous successful full backup was stored
   */
  folder: string;
}

/**
 * Selective Key Restore operation
 */
model SelectiveKeyRestoreOperation {
  /**
   * Status of the restore operation.
   */
  status?: string;

  /**
   * The status details of restore operation.
   */
  statusDetails?: string;

  /**
   * Error encountered, if any, during the selective key restore operation.
   */
  error?: Error;

  /**
   * Identifier for the selective key restore operation.
   */
  jobId?: string;

  /**
   * The start time of the restore operation
   */
  startTime?: plainTime;

  /**
   * The end time of the restore operation
   */
  endTime?: plainTime;
}

/**
 * The certificate list result.
 */
model CertificateListResult is Azure.Core.Page<CertificateItem>;

/**
 * The certificate item containing certificate metadata.
 */
model CertificateItem {
  /**
   * Certificate identifier.
   */
  id?: string;

  /**
   * The certificate management attributes.
   */
  attributes?: CertificateAttributes;

  /**
   * Application specific metadata in the form of key-value pairs.
   */
  tags?: Record<string>;

  /**
   * Thumbprint of the certificate.
   */
  @encodedName("application/json", "x5t")
  x509Thumbprint?: bytes;
}

/**
 * The certificate management attributes.
 */
model CertificateAttributes extends Attributes {
  /**
   * softDelete data retention days. Value should be >=7 and <=90 when softDelete
   * enabled, otherwise 0.
   */
  @visibility("read")
  recoverableDays?: int32;

  /**
   * Reflects the deletion recovery level currently in effect for certificates in
   * the current vault. If it contains 'Purgeable', the certificate can be
   * permanently deleted by a privileged user; otherwise, only the system can purge
   * the certificate, at the end of the retention interval.
   */
  @visibility("read")
  recoveryLevel?: DeletionRecoveryLevel;
}

/**
 * The object attributes managed by the KeyVault service.
 */
model Attributes {
  /**
   * Determines whether the object is enabled.
   */
  enabled?: boolean;

  /**
   * Not before date in UTC.
   */
  @encodedName("application/json", "nbf")
  notBefore?: plainTime;

  /**
   * Expiry date in UTC.
   */
  @encodedName("application/json", "exp")
  expires?: plainTime;

  /**
   * Creation time in UTC.
   */
  @visibility("read")
  created?: plainTime;

  /**
   * Last updated time in UTC.
   */
  @visibility("read")
  updated?: plainTime;
}

/**
 * A Deleted Certificate consisting of its previous id, attributes and its tags,
 * as well as information on when it will be purged.
 */
model DeletedCertificateBundle extends CertificateBundle {
  /**
   * The url of the recovery object, used to identify and recover the deleted
   * certificate.
   */
  recoveryId?: string;

  /**
   * The time when the certificate is scheduled to be purged, in UTC
   */
  @visibility("read")
  scheduledPurgeDate?: plainTime;

  /**
   * The time when the certificate was deleted, in UTC
   */
  @visibility("read")
  deletedDate?: plainTime;
}

/**
 * A certificate bundle consists of a certificate (X509) plus its attributes.
 */
model CertificateBundle {
  /**
   * The certificate id.
   */
  @visibility("read")
  id?: string;

  /**
   * The key id.
   */
  @visibility("read")
  kid?: string;

  /**
   * The secret id.
   */
  @visibility("read")
  sid?: string;

  /**
   * Thumbprint of the certificate.
   */
  @visibility("read")
  @encodedName("application/json", "x5t")
  x509Thumbprint?: bytes;

  /**
   * The management policy.
   */
  @visibility("read")
  policy?: CertificatePolicy;

  /**
   * CER contents of x509 certificate.
   */
  cer?: bytes;

  /**
   * The content type of the secret. eg. 'application/x-pem-file' or
   * 'application/x-pkcs12',
   */
  contentType?: string;

  /**
   * The certificate attributes.
   */
  attributes?: CertificateAttributes;

  /**
   * Application specific metadata in the form of key-value pairs
   */
  tags?: Record<string>;
}

/**
 * Management policy for a certificate.
 */
model CertificatePolicy {
  /**
   * The certificate id.
   */
  @visibility("read")
  id?: string;

  /**
   * Properties of the key backing a certificate.
   */
  @encodedName("application/json", "key_props")
  keyProperties?: KeyProperties;

  /**
   * Properties of the secret backing a certificate.
   */
  @encodedName("application/json", "secret_props")
  secretProperties?: SecretProperties;

  /**
   * Properties of the X509 component of a certificate.
   */
  @encodedName("application/json", "x509_props")
  x509CertificateProperties?: X509CertificateProperties;

  /**
   * Actions that will be performed by Key Vault over the lifetime of a certificate.
   */
  @encodedName("application/json", "lifetime_actions")
  lifetimeActions?: LifetimeAction[];

  /**
   * Parameters for the issuer of the X509 component of a certificate.
   */
  @encodedName("application/json", "issuer")
  issuerParameters?: IssuerParameters;

  /**
   * The certificate attributes.
   */
  attributes?: CertificateAttributes;
}

/**
 * Properties of the key pair backing a certificate.
 */
model KeyProperties {
  /**
   * Indicates if the private key can be exported. Release policy must be provided
   * when creating the first version of an exportable key.
   */
  exportable?: boolean;

  /**
   * The type of key pair to be used for the certificate.
   */
  @encodedName("application/json", "kty")
  keyType?: JsonWebKeyType;

  /**
   * The key size in bits. For example: 2048, 3072, or 4096 for RSA.
   */
  @encodedName("application/json", "key_size")
  keySize?: int32;

  /**
   * Indicates if the same key pair will be used on certificate renewal.
   */
  @encodedName("application/json", "reuse_key")
  reuseKey?: boolean;

  /**
   * Elliptic curve name. For valid values, see JsonWebKeyCurveName.
   */
  @encodedName("application/json", "crv")
  curve?: JsonWebKeyCurveName;
}

/**
 * Properties of the key backing a certificate.
 */
model SecretProperties {
  /**
   * The media type (MIME type).
   */
  contentType?: string;
}

/**
 * Properties of the X509 component of a certificate.
 */
model X509CertificateProperties {
  /**
   * The subject name. Should be a valid X509 distinguished Name.
   */
  subject?: string;

  /**
   * The enhanced key usage.
   */
  ekus?: string[];

  /**
   * The subject alternative names.
   */
  @encodedName("application/json", "sans")
  subjectAlternativeNames?: SubjectAlternativeNames;

  /**
   * Defines how the certificate's key may be used.
   */
  @encodedName("application/json", "key_usage")
  keyUsage?: KeyUsageType[];

  /**
   * The duration that the certificate is valid in months.
   */
  @encodedName("application/json", "validity_months")
  validityInMonths?: int32;
}

/**
 * The subject alternate names of a X509 object.
 */
model SubjectAlternativeNames {
  /**
   * Email addresses.
   */
  emails?: string[];

  /**
   * Domain names.
   */
  @encodedName("application/json", "dns_names")
  dnsNames?: string[];

  /**
   * User principal names.
   */
  upns?: string[];
}

/**
 * Action and its trigger that will be performed by Key Vault over the lifetime of
 * a certificate.
 */
model LifetimeAction {
  /**
   * The condition that will execute the action.
   */
  trigger?: Trigger;

  /**
   * The action that will be executed.
   */
  action?: Action;
}

/**
 * A condition to be satisfied for an action to be executed.
 */
model Trigger {
  /**
   * Percentage of lifetime at which to trigger. Value should be between 1 and 99.
   */
  @maxValue(99)
  @minValue(1)
  @encodedName("application/json", "lifetime_percentage")
  lifetimePercentage?: int32;

  /**
   * Days before expiry to attempt renewal. Value should be between 1 and
   * validity_in_months multiplied by 27. If validity_in_months is 36, then value
   * should be between 1 and 972 (36 * 27).
   */
  @encodedName("application/json", "days_before_expiry")
  daysBeforeExpiry?: int32;
}

/**
 * The action that will be executed.
 */
model Action {
  /**
   * The type of the action.
   */
  @encodedName("application/json", "action_type")
  actionType?: ActionType;
}

/**
 * Parameters for the issuer of the X509 component of a certificate.
 */
model IssuerParameters {
  /**
   * Name of the referenced issuer object or reserved names; for example, 'Self' or
   * 'Unknown'.
   */
  name?: string;

  /**
   * Certificate type as supported by the provider (optional); for example 'OV-SSL',
   * 'EV-SSL'
   */
  @encodedName("application/json", "cty")
  certificateType?: string;

  /**
   * Indicates if the certificates generated under this policy should be published
   * to certificate transparency logs.
   */
  @encodedName("application/json", "cert_transparency")
  certificateTransparency?: boolean;
}

/**
 * The contacts for the vault certificates.
 */
model Contacts {
  /**
   * Identifier for the contacts collection.
   */
  @visibility("read")
  id?: string;

  /**
   * The contact list for the vault certificates.
   */
  @encodedName("application/json", "contacts")
  contactList?: Contact[];
}

/**
 * The contact information for the vault certificates.
 */
model Contact {
  /**
   * Email address.
   */
  @encodedName("application/json", "email")
  emailAddress?: string;

  /**
   * Name.
   */
  name?: string;

  /**
   * Phone number.
   */
  phone?: string;
}

/**
 * The certificate issuer list result.
 */
model CertificateIssuerListResult is Azure.Core.Page<CertificateIssuerItem>;

/**
 * The certificate issuer item containing certificate issuer metadata.
 */
model CertificateIssuerItem {
  /**
   * Certificate Identifier.
   */
  id?: string;

  /**
   * The issuer provider.
   */
  provider?: string;
}

/**
 * The certificate issuer set parameters.
 */
model CertificateIssuerSetParameters {
  /**
   * The issuer provider.
   */
  provider: string;

  /**
   * The credentials to be used for the issuer.
   */
  credentials?: IssuerCredentials;

  /**
   * Details of the organization as provided to the issuer.
   */
  @encodedName("application/json", "org_details")
  organizationDetails?: OrganizationDetails;

  /**
   * Attributes of the issuer object.
   */
  attributes?: IssuerAttributes;
}

/**
 * The credentials to be used for the certificate issuer.
 */
model IssuerCredentials {
  /**
   * The user name/account name/account id.
   */
  @encodedName("application/json", "account_id")
  accountId?: string;

  /**
   * The password/secret/account key.
   */
  @encodedName("application/json", "pwd")
  password?: string;
}

/**
 * Details of the organization of the certificate issuer.
 */
model OrganizationDetails {
  /**
   * Id of the organization.
   */
  id?: string;

  /**
   * Details of the organization administrator.
   */
  @encodedName("application/json", "admin_details")
  adminDetails?: AdministratorDetails[];
}

/**
 * Details of the organization administrator of the certificate issuer.
 */
model AdministratorDetails {
  /**
   * First name.
   */
  @encodedName("application/json", "first_name")
  firstName?: string;

  /**
   * Last name.
   */
  @encodedName("application/json", "last_name")
  lastName?: string;

  /**
   * Email address.
   */
  @encodedName("application/json", "email")
  emailAddress?: string;

  /**
   * Phone number.
   */
  phone?: string;
}

/**
 * The attributes of an issuer managed by the Key Vault service.
 */
model IssuerAttributes {
  /**
   * Determines whether the issuer is enabled.
   */
  enabled?: boolean;

  /**
   * Creation time in UTC.
   */
  @visibility("read")
  created?: plainTime;

  /**
   * Last updated time in UTC.
   */
  @visibility("read")
  updated?: plainTime;
}

/**
 * The issuer for Key Vault certificate.
 */
model IssuerBundle {
  /**
   * Identifier for the issuer object.
   */
  @visibility("read")
  id?: string;

  /**
   * The issuer provider.
   */
  provider?: string;

  /**
   * The credentials to be used for the issuer.
   */
  credentials?: IssuerCredentials;

  /**
   * Details of the organization as provided to the issuer.
   */
  @encodedName("application/json", "org_details")
  organizationDetails?: OrganizationDetails;

  /**
   * Attributes of the issuer object.
   */
  attributes?: IssuerAttributes;
}

/**
 * The certificate issuer update parameters.
 */
model CertificateIssuerUpdateParameters {
  /**
   * The issuer provider.
   */
  provider?: string;

  /**
   * The credentials to be used for the issuer.
   */
  credentials?: IssuerCredentials;

  /**
   * Details of the organization as provided to the issuer.
   */
  @encodedName("application/json", "org_details")
  organizationDetails?: OrganizationDetails;

  /**
   * Attributes of the issuer object.
   */
  attributes?: IssuerAttributes;
}

/**
 * The certificate create parameters.
 */
model CertificateCreateParameters {
  /**
   * The management policy for the certificate.
   */
  @encodedName("application/json", "policy")
  certificatePolicy?: CertificatePolicy;

  /**
   * The attributes of the certificate (optional).
   */
  @encodedName("application/json", "attributes")
  certificateAttributes?: CertificateAttributes;

  /**
   * Application specific metadata in the form of key-value pairs.
   */
  tags?: Record<string>;
}

/**
 * A certificate operation is returned in case of asynchronous requests.
 */
model CertificateOperation {
  /**
   * The certificate id.
   */
  @visibility("read")
  id?: string;

  /**
   * Parameters for the issuer of the X509 component of a certificate.
   */
  @encodedName("application/json", "issuer")
  issuerParameters?: IssuerParameters;

  /**
   * The certificate signing request (CSR) that is being used in the certificate
   * operation.
   */
  csr?: bytes;

  /**
   * Indicates if cancellation was requested on the certificate operation.
   */
  @encodedName("application/json", "cancellation_requested")
  cancellationRequested?: boolean;

  /**
   * Status of the certificate operation.
   */
  status?: string;

  /**
   * The status details of the certificate operation.
   */
  @encodedName("application/json", "status_details")
  statusDetails?: string;

  /**
   * Error encountered, if any, during the certificate operation.
   */
  error?: Error;

  /**
   * Location which contains the result of the certificate operation.
   */
  target?: string;

  /**
   * Identifier for the certificate operation.
   */
  @encodedName("application/json", "request_id")
  requestId?: string;
}

/**
 * The certificate import parameters.
 */
model CertificateImportParameters {
  /**
   * Base64 encoded representation of the certificate object to import. This
   * certificate needs to contain the private key.
   */
  @encodedName("application/json", "value")
  base64EncodedCertificate: string;

  /**
   * If the private key in base64EncodedCertificate is encrypted, the password used
   * for encryption.
   */
  @encodedName("application/json", "pwd")
  password?: string;

  /**
   * The management policy for the certificate.
   */
  @encodedName("application/json", "policy")
  certificatePolicy?: CertificatePolicy;

  /**
   * The attributes of the certificate (optional).
   */
  @encodedName("application/json", "attributes")
  certificateAttributes?: CertificateAttributes;

  /**
   * Application specific metadata in the form of key-value pairs.
   */
  tags?: Record<string>;
}

/**
 * The certificate update parameters.
 */
model CertificateUpdateParameters {
  /**
   * The management policy for the certificate.
   */
  @encodedName("application/json", "policy")
  certificatePolicy?: CertificatePolicy;

  /**
   * The attributes of the certificate (optional).
   */
  @encodedName("application/json", "attributes")
  certificateAttributes?: CertificateAttributes;

  /**
   * Application specific metadata in the form of key-value pairs.
   */
  tags?: Record<string>;
}

/**
 * The certificate operation update parameters.
 */
model CertificateOperationUpdateParameter {
  /**
   * Indicates if cancellation was requested on the certificate operation.
   */
  @encodedName("application/json", "cancellation_requested")
  cancellationRequested: boolean;
}

/**
 * The certificate merge parameters
 */
model CertificateMergeParameters {
  /**
   * The certificate or the certificate chain to merge.
   */
  @encodedName("application/json", "x5c")
  x509Certificates: bytes[];

  /**
   * The attributes of the certificate (optional).
   */
  @encodedName("application/json", "attributes")
  certificateAttributes?: CertificateAttributes;

  /**
   * Application specific metadata in the form of key-value pairs.
   */
  tags?: Record<string>;
}

/**
 * The backup certificate result, containing the backup blob.
 */
model BackupCertificateResult {
  /**
   * The backup blob containing the backed up certificate.
   */
  @visibility("read")
  value?: bytes;
}

/**
 * The certificate restore parameters.
 */
model CertificateRestoreParameters {
  /**
   * The backup blob associated with a certificate bundle.
   */
  @encodedName("application/json", "value")
  certificateBundleBackup: bytes;
}

/**
 * A list of certificates that have been deleted in this vault.
 */
model DeletedCertificateListResult is Azure.Core.Page<DeletedCertificateItem>;

/**
 * The deleted certificate item containing metadata about the deleted certificate.
 */
model DeletedCertificateItem extends CertificateItem {
  /**
   * The url of the recovery object, used to identify and recover the deleted
   * certificate.
   */
  recoveryId?: string;

  /**
   * The time when the certificate is scheduled to be purged, in UTC
   */
  @visibility("read")
  scheduledPurgeDate?: plainTime;

  /**
   * The time when the certificate was deleted, in UTC
   */
  @visibility("read")
  deletedDate?: plainTime;
}

/**
 * The key create parameters.
 */
model KeyCreateParameters {
  /**
   * The type of key to create. For valid values, see JsonWebKeyType.
   */
  kty: JsonWebKeyType;

  /**
   * The key size in bits. For example: 2048, 3072, or 4096 for RSA.
   */
  @encodedName("application/json", "key_size")
  keySize?: int32;

  /**
   * The public exponent for a RSA key.
   */
  @encodedName("application/json", "public_exponent")
  publicExponent?: int32;

  @encodedName("application/json", "key_ops")
  keyOps?: JsonWebKeyOperation[];

  /**
   * The attributes of a key managed by the key vault service.
   */
  @encodedName("application/json", "attributes")
  keyAttributes?: KeyAttributes;

  /**
   * Application specific metadata in the form of key-value pairs.
   */
  tags?: Record<string>;

  /**
   * Elliptic curve name. For valid values, see JsonWebKeyCurveName.
   */
  @encodedName("application/json", "crv")
  curve?: JsonWebKeyCurveName;

  /**
   * The policy rules under which the key can be exported.
   */
  @encodedName("application/json", "release_policy")
  releasePolicy?: KeyReleasePolicy;
}

/**
 * The attributes of a key managed by the key vault service.
 */
model KeyAttributes extends Attributes {
  /**
   * softDelete data retention days. Value should be >=7 and <=90 when softDelete
   * enabled, otherwise 0.
   */
  @visibility("read")
  recoverableDays?: int32;

  /**
   * Reflects the deletion recovery level currently in effect for keys in the
   * current vault. If it contains 'Purgeable' the key can be permanently deleted by
   * a privileged user; otherwise, only the system can purge the key, at the end of
   * the retention interval.
   */
  @visibility("read")
  recoveryLevel?: DeletionRecoveryLevel;

  /**
   * Indicates if the private key can be exported. Release policy must be provided
   * when creating the first version of an exportable key.
   */
  exportable?: boolean;
}

/**
 * The policy rules under which the key can be exported.
 */
model KeyReleasePolicy {
  /**
   * Content type and version of key release policy
   */
  contentType?: string = "application/json; charset=utf-8";

  /**
   * Defines the mutability state of the policy. Once marked immutable, this flag
   * cannot be reset and the policy cannot be changed under any circumstances.
   */
  immutable?: boolean;

  /**
   * Blob encoding the policy rules under which the key can be released. Blob must
   * be base64 URL encoded.
   */
  @encodedName("application/json", "data")
  encodedPolicy?: bytes;
}

/**
 * A KeyBundle consisting of a WebKey plus its attributes.
 */
model KeyBundle {
  /**
   * The Json web key.
   */
  key?: JsonWebKey;

  /**
   * The key management attributes.
   */
  attributes?: KeyAttributes;

  /**
   * Application specific metadata in the form of key-value pairs.
   */
  tags?: Record<string>;

  /**
   * True if the key's lifetime is managed by key vault. If this is a key backing a
   * certificate, then managed will be true.
   */
  @visibility("read")
  managed?: boolean;

  /**
   * The policy rules under which the key can be exported.
   */
  @encodedName("application/json", "release_policy")
  releasePolicy?: KeyReleasePolicy;
}

/**
 * As of http://tools.ietf.org/html/draft-ietf-jose-json-web-key-18
 */
model JsonWebKey {
  /**
   * Key identifier.
   */
  kid?: string;

  /**
   * JsonWebKey Key Type (kty), as defined in
   * https://tools.ietf.org/html/draft-ietf-jose-json-web-algorithms-40.
   */
  kty?: JsonWebKeyType;

  @encodedName("application/json", "key_ops")
  keyOps?: string[];

  /**
   * RSA modulus.
   */
  n?: bytes;

  /**
   * RSA public exponent.
   */
  e?: bytes;

  /**
   * RSA private exponent, or the D component of an EC or OKP private key.
   */
  d?: bytes;

  /**
   * RSA private key parameter.
   */
  @encodedName("application/json", "dp")
  DP?: bytes;

  /**
   * RSA private key parameter.
   */
  @encodedName("application/json", "dq")
  DQ?: bytes;

  /**
   * RSA private key parameter.
   */
  @encodedName("application/json", "qi")
  QI?: bytes;

  /**
   * RSA secret prime.
   */
  p?: bytes;

  /**
   * RSA secret prime, with p < q.
   */
  q?: bytes;

  /**
   * Symmetric key.
   */
  k?: bytes;

  /**
   * Protected Key, used with 'Bring Your Own Key'.
   */
  @encodedName("application/json", "key_hsm")
  t?: bytes;

  /**
   * Elliptic curve name. For valid values, see JsonWebKeyCurveName.
   */
  crv?: JsonWebKeyCurveName;

  /**
   * X component of an EC or OKP public key.
   */
  x?: bytes;

  /**
   * Y component of an EC public key.
   */
  y?: bytes;
}

/**
 * The key import parameters.
 */
model KeyImportParameters {
  /**
   * Whether to import as a hardware key (HSM) or software key.
   */
  @encodedName("application/json", "Hsm")
  hsm?: boolean;

  /**
   * The Json web key
   */
  key: JsonWebKey;

  /**
   * The key management attributes.
   */
  @encodedName("application/json", "attributes")
  keyAttributes?: KeyAttributes;

  /**
   * Application specific metadata in the form of key-value pairs.
   */
  tags?: Record<string>;

  /**
   * The policy rules under which the key can be exported.
   */
  @encodedName("application/json", "release_policy")
  releasePolicy?: KeyReleasePolicy;
}

/**
 * A DeletedKeyBundle consisting of a WebKey plus its Attributes and deletion info
 */
model DeletedKeyBundle extends KeyBundle {
  /**
   * The url of the recovery object, used to identify and recover the deleted key.
   */
  recoveryId?: string;

  /**
   * The time when the key is scheduled to be purged, in UTC
   */
  @visibility("read")
  scheduledPurgeDate?: plainTime;

  /**
   * The time when the key was deleted, in UTC
   */
  @visibility("read")
  deletedDate?: plainTime;
}

/**
 * The key update parameters.
 */
model KeyUpdateParameters {
  /**
   * Json web key operations. For more information on possible key operations, see
   * JsonWebKeyOperation.
   */
  @encodedName("application/json", "key_ops")
  keyOps?: JsonWebKeyOperation[];

  /**
   * The attributes of a key managed by the key vault service.
   */
  @encodedName("application/json", "attributes")
  keyAttributes?: KeyAttributes;

  /**
   * Application specific metadata in the form of key-value pairs.
   */
  tags?: Record<string>;

  /**
   * The policy rules under which the key can be exported.
   */
  @encodedName("application/json", "release_policy")
  releasePolicy?: KeyReleasePolicy;
}

/**
 * The key list result.
 */
model KeyListResult is Azure.Core.Page<KeyItem>;

/**
 * The key item containing key metadata.
 */
model KeyItem {
  /**
   * Key identifier.
   */
  kid?: string;

  /**
   * The key management attributes.
   */
  attributes?: KeyAttributes;

  /**
   * Application specific metadata in the form of key-value pairs.
   */
  tags?: Record<string>;

  /**
   * True if the key's lifetime is managed by key vault. If this is a key backing a
   * certificate, then managed will be true.
   */
  @visibility("read")
  managed?: boolean;
}

/**
 * The backup key result, containing the backup blob.
 */
model BackupKeyResult {
  /**
   * The backup blob containing the backed up key.
   */
  @visibility("read")
  value?: bytes;
}

/**
 * The key restore parameters.
 */
model KeyRestoreParameters {
  /**
   * The backup blob associated with a key bundle.
   */
  @encodedName("application/json", "value")
  keyBundleBackup: bytes;
}

/**
 * The key operations parameters.
 */
model KeyOperationsParameters {
  /**
   * algorithm identifier
   */
  @encodedName("application/json", "alg")
  algorithm: JsonWebKeyEncryptionAlgorithm;

  value: bytes;

  /**
   * Cryptographically random, non-repeating initialization vector for symmetric
   * algorithms.
   */
  iv?: bytes;

  /**
   * Additional data to authenticate but not encrypt/decrypt when using
   * authenticated crypto algorithms.
   */
  aad?: bytes;

  /**
   * The tag to authenticate when performing decryption with an authenticated
   * algorithm.
   */
  tag?: bytes;
}

/**
 * The key operation result.
 */
model KeyOperationResult {
  /**
   * Key identifier
   */
  @visibility("read")
  kid?: string;

  @visibility("read")
  @encodedName("application/json", "value")
  result?: bytes;

  @visibility("read")
  iv?: bytes;

  @visibility("read")
  @encodedName("application/json", "tag")
  authenticationTag?: bytes;

  @visibility("read")
  @encodedName("application/json", "aad")
  additionalAuthenticatedData?: bytes;
}

/**
 * The key operations parameters.
 */
model KeySignParameters {
  /**
   * The signing/verification algorithm identifier. For more information on possible
   * algorithm types, see JsonWebKeySignatureAlgorithm.
   */
  @encodedName("application/json", "alg")
  algorithm: JsonWebKeySignatureAlgorithm;

  value: bytes;
}

/**
 * The key verify parameters.
 */
model KeyVerifyParameters {
  /**
   * The signing/verification algorithm. For more information on possible algorithm
   * types, see JsonWebKeySignatureAlgorithm.
   */
  @encodedName("application/json", "alg")
  algorithm: JsonWebKeySignatureAlgorithm;

  /**
   * The digest used for signing.
   */
  digest: bytes;

  /**
   * The signature to be verified.
   */
  @encodedName("application/json", "value")
  signature: bytes;
}

/**
 * The key verify result.
 */
model KeyVerifyResult {
  /**
   * True if the signature is verified, otherwise false.
   */
  @visibility("read")
  value?: boolean;
}

/**
 * The release key parameters.
 */
model KeyReleaseParameters {
  /**
   * The attestation assertion for the target of the key release.
   */
  @minLength(1)
  @encodedName("application/json", "target")
  targetAttestationToken: string;

  /**
   * A client provided nonce for freshness.
   */
  nonce?: string;

  /**
   * The encryption algorithm to use to protected the exported key material
   */
  enc?: KeyEncryptionAlgorithm;
}

/**
 * The release result, containing the released key.
 */
model KeyReleaseResult {
  /**
   * A signed object containing the released key.
   */
  @visibility("read")
  value?: string;
}

/**
 * A list of keys that have been deleted in this vault.
 */
model DeletedKeyListResult is Azure.Core.Page<DeletedKeyItem>;

/**
 * The deleted key item containing the deleted key metadata and information about
 * deletion.
 */
model DeletedKeyItem extends KeyItem {
  /**
   * The url of the recovery object, used to identify and recover the deleted key.
   */
  recoveryId?: string;

  /**
   * The time when the key is scheduled to be purged, in UTC
   */
  @visibility("read")
  scheduledPurgeDate?: plainTime;

  /**
   * The time when the key was deleted, in UTC
   */
  @visibility("read")
  deletedDate?: plainTime;
}

/**
 * Management policy for a key.
 */
model KeyRotationPolicy {
  /**
   * The key policy id.
   */
  @visibility("read")
  id?: string;

  /**
   * Actions that will be performed by Key Vault over the lifetime of a key. For
   * preview, lifetimeActions can only have two items at maximum: one for rotate,
   * one for notify. Notification time would be default to 30 days before expiry and
   * it is not configurable.
   */
  lifetimeActions?: LifetimeActions[];

  /**
   * The key rotation policy attributes.
   */
  attributes?: KeyRotationPolicyAttributes;
}

/**
 * Action and its trigger that will be performed by Key Vault over the lifetime of
 * a key.
 */
model LifetimeActions {
  /**
   * The condition that will execute the action.
   */
  trigger?: LifetimeActionsTrigger;

  /**
   * The action that will be executed.
   */
  action?: LifetimeActionsType;
}

/**
 * A condition to be satisfied for an action to be executed.
 */
model LifetimeActionsTrigger {
  /**
   * Time after creation to attempt to rotate. It only applies to rotate. It will be
   * in ISO 8601 duration format. Example: 90 days : "P90D"
   */
  timeAfterCreate?: string;

  /**
   * Time before expiry to attempt to rotate or notify. It will be in ISO 8601
   * duration format. Example: 90 days : "P90D"
   */
  timeBeforeExpiry?: string;
}

/**
 * The action that will be executed.
 */
model LifetimeActionsType {
  /**
   * The type of the action.
   */
  type?: ActionType;
}

/**
 * The key rotation policy attributes.
 */
model KeyRotationPolicyAttributes {
  /**
   * The expiryTime will be applied on the new key version. It should be at least 28
   * days. It will be in ISO 8601 Format. Examples: 90 days: P90D, 3 months: P3M, 48
   * hours: PT48H, 1 year and 10 days: P1Y10D
   */
  expiryTime?: string;

  /**
   * The key rotation policy created time in UTC.
   */
  @visibility("read")
  created?: plainTime;

  /**
   * The key rotation policy's last updated time in UTC.
   */
  @visibility("read")
  updated?: plainTime;
}

/**
 * The get random bytes request object.
 */
model GetRandomBytesRequest {
  /**
   * The requested number of random bytes.
   */
  @maxValue(128)
  @minValue(1)
  count: int32;
}

/**
 * The get random bytes response object containing the bytes.
 */
model RandomBytes {
  /**
   * The bytes encoded as a base64url string.
   */
  value: bytes;
}

/**
 * Role definition.
 */
model RoleDefinition {
  /**
   * The role definition ID.
   */
  @visibility("read")
  id?: string;

  /**
   * The role definition name.
   */
  @visibility("read")
  name?: string;

  /**
   * The role definition type.
   */
  @visibility("read")
  type?: RoleDefinitionType;

  /**
   * Role definition properties.
   */
  properties?: RoleDefinitionProperties;
}

/**
 * Role definition properties.
 */
model RoleDefinitionProperties {
  /**
   * The role name.
   */
  roleName?: string;

  /**
   * The role definition description.
   */
  description?: string;

  /**
   * The role type.
   */
  @encodedName("application/json", "type")
  roleType?: RoleType;

  /**
   * Role definition permissions.
   */
  permissions?: Permission[];

  /**
   * Role definition assignable scopes.
   */
  assignableScopes?: RoleScope[];
}

/**
 * Role definition permissions.
 */
model Permission {
  /**
   * Action permissions that are granted.
   */
  actions?: string[];

  /**
   * Action permissions that are excluded but not denied. They may be granted by
   * other role definitions assigned to a principal.
   */
  notActions?: string[];

  /**
   * Data action permissions that are granted.
   */
  dataActions?: DataAction[];

  /**
   * Data action permissions that are excluded but not denied. They may be granted
   * by other role definitions assigned to a principal.
   */
  notDataActions?: DataAction[];
}

/**
 * Role definition create parameters.
 */
model RoleDefinitionCreateParameters {
  /**
   * Role definition properties.
   */
  properties: RoleDefinitionProperties;
}

/**
 * Role definition list operation result.
 */
model RoleDefinitionListResult is Azure.Core.Page<RoleDefinition>;

/**
 * Role Assignments
 */
model RoleAssignment {
  /**
   * The role assignment ID.
   */
  @visibility("read")
  id?: string;

  /**
   * The role assignment name.
   */
  @visibility("read")
  name?: string;

  /**
   * The role assignment type.
   */
  @visibility("read")
  type?: string;

  /**
   * Role assignment properties.
   */
  properties?: RoleAssignmentPropertiesWithScope;
}

/**
 * Role assignment properties with scope.
 */
model RoleAssignmentPropertiesWithScope {
  /**
   * The role scope.
   */
  scope?: RoleScope;

  /**
   * The role definition ID.
   */
  roleDefinitionId?: string;

  /**
   * The principal ID.
   */
  principalId?: string;
}

/**
 * Role assignment create parameters.
 */
model RoleAssignmentCreateParameters {
  /**
   * Role assignment properties.
   */
  properties: RoleAssignmentProperties;
}

/**
 * Role assignment properties.
 */
model RoleAssignmentProperties {
  /**
   * The role definition ID used in the role assignment.
   */
  roleDefinitionId: string;

  /**
   * The principal ID assigned to the role. This maps to the ID inside the Active
   * Directory. It can point to a user, service principal, or security group.
   */
  principalId: string;
}

/**
 * Role assignment list operation result.
 */
model RoleAssignmentListResult is Azure.Core.Page<RoleAssignment>;

/**
 * The secret set parameters.
 */
model SecretSetParameters {
  /**
   * The value of the secret.
   */
  value: string;

  /**
   * Application specific metadata in the form of key-value pairs.
   */
  tags?: Record<string>;

  /**
   * Type of the secret value such as a password.
   */
  contentType?: string;

  /**
   * The secret management attributes.
   */
  @encodedName("application/json", "attributes")
  secretAttributes?: SecretAttributes;
}

/**
 * The secret management attributes.
 */
model SecretAttributes extends Attributes {
  /**
   * softDelete data retention days. Value should be >=7 and <=90 when softDelete
   * enabled, otherwise 0.
   */
  @visibility("read")
  recoverableDays?: int32;

  /**
   * Reflects the deletion recovery level currently in effect for secrets in the
   * current vault. If it contains 'Purgeable', the secret can be permanently
   * deleted by a privileged user; otherwise, only the system can purge the secret,
   * at the end of the retention interval.
   */
  @visibility("read")
  recoveryLevel?: DeletionRecoveryLevel;
}

/**
 * A secret consisting of a value, id and its attributes.
 */
model SecretBundle {
  /**
   * The secret value.
   */
  value?: string;

  /**
   * The secret id.
   */
  id?: string;

  /**
   * The content type of the secret.
   */
  contentType?: string;

  /**
   * The secret management attributes.
   */
  attributes?: SecretAttributes;

  /**
   * Application specific metadata in the form of key-value pairs.
   */
  tags?: Record<string>;

  /**
   * If this is a secret backing a KV certificate, then this field specifies the
   * corresponding key backing the KV certificate.
   */
  @visibility("read")
  kid?: string;

  /**
   * True if the secret's lifetime is managed by key vault. If this is a secret
   * backing a certificate, then managed will be true.
   */
  @visibility("read")
  managed?: boolean;
}

/**
 * A Deleted Secret consisting of its previous id, attributes and its tags, as
 * well as information on when it will be purged.
 */
model DeletedSecretBundle extends SecretBundle {
  /**
   * The url of the recovery object, used to identify and recover the deleted secret.
   */
  recoveryId?: string;

  /**
   * The time when the secret is scheduled to be purged, in UTC
   */
  @visibility("read")
  scheduledPurgeDate?: plainTime;

  /**
   * The time when the secret was deleted, in UTC
   */
  @visibility("read")
  deletedDate?: plainTime;
}

/**
 * The secret update parameters.
 */
model SecretUpdateParameters {
  /**
   * Type of the secret value such as a password.
   */
  contentType?: string;

  /**
   * The secret management attributes.
   */
  @encodedName("application/json", "attributes")
  secretAttributes?: SecretAttributes;

  /**
   * Application specific metadata in the form of key-value pairs.
   */
  tags?: Record<string>;
}

/**
 * The secret list result.
 */
model SecretListResult is Azure.Core.Page<SecretItem>;

/**
 * The secret item containing secret metadata.
 */
model SecretItem {
  /**
   * Secret identifier.
   */
  id?: string;

  /**
   * The secret management attributes.
   */
  attributes?: SecretAttributes;

  /**
   * Application specific metadata in the form of key-value pairs.
   */
  tags?: Record<string>;

  /**
   * Type of the secret value such as a password.
   */
  contentType?: string;

  /**
   * True if the secret's lifetime is managed by key vault. If this is a key backing
   * a certificate, then managed will be true.
   */
  @visibility("read")
  managed?: boolean;
}

/**
 * The deleted secret list result
 */
model DeletedSecretListResult is Azure.Core.Page<DeletedSecretItem>;

/**
 * The deleted secret item containing metadata about the deleted secret.
 */
model DeletedSecretItem extends SecretItem {
  /**
   * The url of the recovery object, used to identify and recover the deleted secret.
   */
  recoveryId?: string;

  /**
   * The time when the secret is scheduled to be purged, in UTC
   */
  @visibility("read")
  scheduledPurgeDate?: plainTime;

  /**
   * The time when the secret was deleted, in UTC
   */
  @visibility("read")
  deletedDate?: plainTime;
}

/**
 * The backup secret result, containing the backup blob.
 */
model BackupSecretResult {
  /**
   * The backup blob containing the backed up secret.
   */
  @visibility("read")
  value?: bytes;
}

/**
 * The secret restore parameters.
 */
model SecretRestoreParameters {
  /**
   * The backup blob associated with a secret bundle.
   */
  @encodedName("application/json", "value")
  secretBundleBackup: bytes;
}

model SecurityDomainOperationStatus {
  /**
   * operation status
   */
  status?: OperationStatus;

  @encodedName("application/json", "status_details")
  statusDetails?: string;
}

model CertificateInfoObject {
  /**
   * Certificates needed from customer
   */
  certificates: SecurityDomainJsonWebKey[];

  /**
   * Customer to specify the number of certificates (minimum 2 and maximum 10) to
   * restore Security Domain
   */
  @maxValue(10)
  @minValue(2)
  required?: int32 = 2;
}

model SecurityDomainJsonWebKey {
  /**
   * Key identifier.
   */
  kid: string;

  /**
   * JsonWebKey Key Type (kty), as defined in
   * https://tools.ietf.org/html/draft-ietf-jose-json-web-algorithms-40. For
   * Security Domain this value must be RSA.
   */
  kty: string;

  @encodedName("application/json", "key_ops")
  keyOps: string[];

  /**
   * RSA modulus.
   */
  n: string;

  /**
   * RSA public exponent.
   */
  e: string;

  /**
   * X509 certificate chain parameter
   */
  @encodedName("application/json", "x5c")
  x5C: string[];

  /**
   * Public Key Use Parameter. This is optional and if present must be enc.
   */
  use?: string;

  /**
   * X509 certificate SHA1 thumbprint. This is optional.
   */
  @encodedName("application/json", "x5t")
  x5T?: string;

  /**
   * X509 certificate SHA256 thumbprint.
   */
  @encodedName("application/json", "x5t#S256")
  x5TS256: string;

  /**
   * Algorithm intended for use with the key.
   */
  alg: string;
}

/**
 * The Security Domain.
 */
model SecurityDomainObject {
  /**
   * The Security Domain.
   */
  value: string;
}

model TransferKey {
  /**
   * Specifies the format of the transfer key
   */
  @encodedName("application/json", "key_format")
  keyFormat?: string = "jwk";

  /**
   * Specifies the transfer key in JWK format
   */
  @encodedName("application/json", "transfer_key")
  transferKey: SecurityDomainJsonWebKey;
}

/**
 * The update settings request object.
 */
model UpdateSettingsRequest {
  /**
   * The value of the pool setting.
   */
  value: string;
}

model Setting {
  /**
   * The account setting to be updated
   */
  name: string;

  /**
   * The value of the pool setting.
   */
  value: string;

  /**
   * The type specifier of the value.
   */
  type?: SettingTypeEnum;
}

/**
 * The settings list result.
 */
model SettingsListResult {
  /**
   * A response message containing a list of account settings with their associated
   * value.
   */
  @visibility("read")
  value?: Setting[];
}

/**
 * The storage accounts list result.
 */
model StorageListResult is Azure.Core.Page<StorageAccountItem>;

/**
 * The storage account item containing storage account metadata.
 */
model StorageAccountItem {
  /**
   * Storage identifier.
   */
  @visibility("read")
  id?: string;

  /**
   * Storage account resource Id.
   */
  @visibility("read")
  resourceId?: string;

  /**
   * The storage account management attributes.
   */
  @visibility("read")
  attributes?: StorageAccountAttributes;

  /**
   * Application specific metadata in the form of key-value pairs.
   */
  @visibility("read")
  tags?: Record<string>;
}

/**
 * The storage account management attributes.
 */
model StorageAccountAttributes {
  /**
   * the enabled state of the object.
   */
  enabled?: boolean;

  /**
   * Creation time in UTC.
   */
  @visibility("read")
  created?: plainTime;

  /**
   * Last updated time in UTC.
   */
  @visibility("read")
  updated?: plainTime;

  /**
   * softDelete data retention days. Value should be >=7 and <=90 when softDelete
   * enabled, otherwise 0.
   */
  @visibility("read")
  recoverableDays?: int32;

  /**
   * Reflects the deletion recovery level currently in effect for storage accounts
   * in the current vault. If it contains 'Purgeable' the storage account can be
   * permanently deleted by a privileged user; otherwise, only the system can purge
   * the storage account, at the end of the retention interval.
   */
  @visibility("read")
  recoveryLevel?: DeletionRecoveryLevel;
}

/**
 * The deleted storage account list result
 */
model DeletedStorageListResult is Azure.Core.Page<DeletedStorageAccountItem>;

/**
 * The deleted storage account item containing metadata about the deleted storage
 * account.
 */
model DeletedStorageAccountItem extends StorageAccountItem {
  /**
   * The url of the recovery object, used to identify and recover the deleted
   * storage account.
   */
  recoveryId?: string;

  /**
   * The time when the storage account is scheduled to be purged, in UTC
   */
  @visibility("read")
  scheduledPurgeDate?: plainTime;

  /**
   * The time when the storage account was deleted, in UTC
   */
  @visibility("read")
  deletedDate?: plainTime;
}

/**
 * A deleted storage account bundle consisting of its previous id, attributes and
 * its tags, as well as information on when it will be purged.
 */
model DeletedStorageBundle extends StorageBundle {
  /**
   * The url of the recovery object, used to identify and recover the deleted
   * storage account.
   */
  recoveryId?: string;

  /**
   * The time when the storage account is scheduled to be purged, in UTC
   */
  @visibility("read")
  scheduledPurgeDate?: plainTime;

  /**
   * The time when the storage account was deleted, in UTC
   */
  @visibility("read")
  deletedDate?: plainTime;
}

/**
 * A Storage account bundle consists of key vault storage account details plus its
 * attributes.
 */
model StorageBundle {
  /**
   * The storage account id.
   */
  @visibility("read")
  id?: string;

  /**
   * The storage account resource id.
   */
  @visibility("read")
  resourceId?: string;

  /**
   * The current active storage account key name.
   */
  @visibility("read")
  activeKeyName?: string;

  /**
   * whether keyvault should manage the storage account for the user.
   */
  @visibility("read")
  autoRegenerateKey?: boolean;

  /**
   * The key regeneration time duration specified in ISO-8601 format.
   */
  @visibility("read")
  regenerationPeriod?: string;

  /**
   * The storage account attributes.
   */
  @visibility("read")
  attributes?: StorageAccountAttributes;

  /**
   * Application specific metadata in the form of key-value pairs
   */
  @visibility("read")
  tags?: Record<string>;
}

/**
 * The backup storage result, containing the backup blob.
 */
model BackupStorageResult {
  /**
   * The backup blob containing the backed up storage account.
   */
  @visibility("read")
  value?: bytes;
}

/**
 * The secret restore parameters.
 */
model StorageRestoreParameters {
  /**
   * The backup blob associated with a storage account.
   */
  @encodedName("application/json", "value")
  storageBundleBackup: bytes;
}

/**
 * The storage account create parameters.
 */
model StorageAccountCreateParameters {
  /**
   * Storage account resource id.
   */
  resourceId: string;

  /**
   * Current active storage account key name.
   */
  activeKeyName: string;

  /**
   * whether keyvault should manage the storage account for the user.
   */
  autoRegenerateKey: boolean;

  /**
   * The key regeneration time duration specified in ISO-8601 format.
   */
  regenerationPeriod?: string;

  /**
   * The attributes of the storage account.
   */
  @encodedName("application/json", "attributes")
  storageAccountAttributes?: StorageAccountAttributes;

  /**
   * Application specific metadata in the form of key-value pairs.
   */
  tags?: Record<string>;
}

/**
 * The storage account update parameters.
 */
model StorageAccountUpdateParameters {
  /**
   * The current active storage account key name.
   */
  activeKeyName?: string;

  /**
   * whether keyvault should manage the storage account for the user.
   */
  autoRegenerateKey?: boolean;

  /**
   * The key regeneration time duration specified in ISO-8601 format.
   */
  regenerationPeriod?: string;

  /**
   * The attributes of the storage account.
   */
  @encodedName("application/json", "attributes")
  storageAccountAttributes?: StorageAccountAttributes;

  /**
   * Application specific metadata in the form of key-value pairs.
   */
  tags?: Record<string>;
}

/**
 * The storage account key regenerate parameters.
 */
model StorageAccountRegenerteKeyParameters {
  /**
   * The storage account key name.
   */
  keyName: string;
}

/**
 * The storage account SAS definition list result.
 */
model SasDefinitionListResult is Azure.Core.Page<SasDefinitionItem>;

/**
 * The SAS definition item containing storage SAS definition metadata.
 */
model SasDefinitionItem {
  /**
   * The storage SAS identifier.
   */
  @visibility("read")
  id?: string;

  /**
   * The storage account SAS definition secret id.
   */
  @visibility("read")
  @encodedName("application/json", "sid")
  secretId?: string;

  /**
   * The SAS definition management attributes.
   */
  @visibility("read")
  attributes?: SasDefinitionAttributes;

  /**
   * Application specific metadata in the form of key-value pairs.
   */
  @visibility("read")
  tags?: Record<string>;
}

/**
 * The SAS definition management attributes.
 */
model SasDefinitionAttributes {
  /**
   * the enabled state of the object.
   */
  enabled?: boolean;

  /**
   * Creation time in UTC.
   */
  @visibility("read")
  created?: plainTime;

  /**
   * Last updated time in UTC.
   */
  @visibility("read")
  updated?: plainTime;

  /**
   * softDelete data retention days. Value should be >=7 and <=90 when softDelete
   * enabled, otherwise 0.
   */
  @visibility("read")
  recoverableDays?: int32;

  /**
   * Reflects the deletion recovery level currently in effect for SAS definitions in
   * the current vault. If it contains 'Purgeable' the SAS definition can be
   * permanently deleted by a privileged user; otherwise, only the system can purge
   * the SAS definition, at the end of the retention interval.
   */
  @visibility("read")
  recoveryLevel?: DeletionRecoveryLevel;
}

/**
 * The deleted SAS definition list result
 */
model DeletedSasDefinitionListResult
  is Azure.Core.Page<DeletedSasDefinitionItem>;

/**
 * The deleted SAS definition item containing metadata about the deleted SAS
 * definition.
 */
model DeletedSasDefinitionItem extends SasDefinitionItem {
  /**
   * The url of the recovery object, used to identify and recover the deleted SAS
   * definition.
   */
  recoveryId?: string;

  /**
   * The time when the SAS definition is scheduled to be purged, in UTC
   */
  @visibility("read")
  scheduledPurgeDate?: plainTime;

  /**
   * The time when the SAS definition was deleted, in UTC
   */
  @visibility("read")
  deletedDate?: plainTime;
}

/**
 * A deleted SAS definition bundle consisting of its previous id, attributes and
 * its tags, as well as information on when it will be purged.
 */
model DeletedSasDefinitionBundle extends SasDefinitionBundle {
  /**
   * The url of the recovery object, used to identify and recover the deleted SAS
   * definition.
   */
  recoveryId?: string;

  /**
   * The time when the SAS definition is scheduled to be purged, in UTC
   */
  @visibility("read")
  scheduledPurgeDate?: plainTime;

  /**
   * The time when the SAS definition was deleted, in UTC
   */
  @visibility("read")
  deletedDate?: plainTime;
}

/**
 * A SAS definition bundle consists of key vault SAS definition details plus its
 * attributes.
 */
model SasDefinitionBundle {
  /**
   * The SAS definition id.
   */
  @visibility("read")
  id?: string;

  /**
   * Storage account SAS definition secret id.
   */
  @visibility("read")
  @encodedName("application/json", "sid")
  secretId?: string;

  /**
   * The SAS definition token template signed with an arbitrary key.  Tokens created
   * according to the SAS definition will have the same properties as the template.
   */
  @visibility("read")
  templateUri?: string;

  /**
   * The type of SAS token the SAS definition will create.
   */
  @visibility("read")
  sasType?: SasTokenType;

  /**
   * The validity period of SAS tokens created according to the SAS definition.
   */
  @visibility("read")
  validityPeriod?: string;

  /**
   * The SAS definition attributes.
   */
  @visibility("read")
  attributes?: SasDefinitionAttributes;

  /**
   * Application specific metadata in the form of key-value pairs
   */
  @visibility("read")
  tags?: Record<string>;
}

/**
 * The SAS definition create parameters.
 */
model SasDefinitionCreateParameters {
  /**
   * The SAS definition token template signed with an arbitrary key.  Tokens created
   * according to the SAS definition will have the same properties as the template.
   */
  templateUri: string;

  /**
   * The type of SAS token the SAS definition will create.
   */
  sasType: SasTokenType;

  /**
   * The validity period of SAS tokens created according to the SAS definition.
   */
  validityPeriod: string;

  /**
   * The attributes of the SAS definition.
   */
  @encodedName("application/json", "attributes")
  sasDefinitionAttributes?: SasDefinitionAttributes;

  /**
   * Application specific metadata in the form of key-value pairs.
   */
  tags?: Record<string>;
}

/**
 * The SAS definition update parameters.
 */
model SasDefinitionUpdateParameters {
  /**
   * The SAS definition token template signed with an arbitrary key.  Tokens created
   * according to the SAS definition will have the same properties as the template.
   */
  templateUri?: string;

  /**
   * The type of SAS token the SAS definition will create.
   */
  sasType?: SasTokenType;

  /**
   * The validity period of SAS tokens created according to the SAS definition.
   */
  validityPeriod?: string;

  /**
   * The attributes of the SAS definition.
   */
  @encodedName("application/json", "attributes")
  sasDefinitionAttributes?: SasDefinitionAttributes;

  /**
   * Application specific metadata in the form of key-value pairs.
   */
  tags?: Record<string>;
}

/**
 * The pending certificate signing request result.
 */
model PendingCertificateSigningRequestResult {
  /**
   * The pending certificate signing request as Base64 encoded string.
   */
  @visibility("read")
  value?: string;
}

/**
 * The export key parameters.
 */
model KeyExportParameters {
  /**
   * The export key encryption Json web key. This key MUST be a RSA key that
   * supports encryption.
   */
  wrappingKey?: JsonWebKey;

  /**
   * The export key encryption key identifier. This key MUST be a RSA key that
   * supports encryption.
   */
  wrappingKid?: string;

  /**
   * The encryption algorithm to use to protected the exported key material
   */
  enc?: KeyEncryptionAlgorithm;
}

/**
 * Role Assignments filter
 */
model RoleAssignmentFilter {
  /**
   * Returns role assignment of the specific principal.
   */
  principalId?: string;
}

/**
 * Role Definitions filter
 */
model RoleDefinitionFilter {
  /**
   * Returns role definition with the specific name.
   */
  roleName?: string;
}
