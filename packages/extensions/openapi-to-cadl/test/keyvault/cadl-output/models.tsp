import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Azure.Keyvault;

enum DeletionRecoveryLevel {
  @doc("""
Denotes a vault state in which deletion is an irreversible operation, without
the possibility for recovery. This level corresponds to no protection being
available against a Delete operation; the data is irretrievably lost upon
accepting a Delete operation at the entity level or higher (vault, resource
group, subscription etc.)
""")
  Purgeable,
  @doc("""
Denotes a vault state in which deletion is recoverable, and which also permits
immediate and permanent deletion (i.e. purge). This level guarantees the
recoverability of the deleted entity during the retention interval (90 days),
unless a Purge operation is requested, or the subscription is cancelled. System
wil permanently delete it after 90 days, if not recovered
""")
  `Recoverable+Purgeable`,
  @doc("""
Denotes a vault state in which deletion is recoverable without the possibility
for immediate and permanent deletion (i.e. purge). This level guarantees the
recoverability of the deleted entity during the retention interval(90 days) and
while the subscription is still available. System wil permanently delete it
after 90 days, if not recovered
""")
  Recoverable,
  @doc("""
Denotes a vault and subscription state in which deletion is recoverable within
retention interval (90 days), immediate and permanent deletion (i.e. purge) is
not permitted, and in which the subscription itself  cannot be permanently
canceled. System wil permanently delete it after 90 days, if not recovered
""")
  `Recoverable+ProtectedSubscription`,
  @doc("""
Denotes a vault state in which deletion is recoverable, and which also permits
immediate and permanent deletion (i.e. purge when 7<= SoftDeleteRetentionInDays
< 90). This level guarantees the recoverability of the deleted entity during
the retention interval, unless a Purge operation is requested, or the
subscription is cancelled.
""")
  `CustomizedRecoverable+Purgeable`,
  @doc("""
Denotes a vault state in which deletion is recoverable without the possibility
for immediate and permanent deletion (i.e. purge when 7<=
SoftDeleteRetentionInDays < 90).This level guarantees the recoverability of the
deleted entity during the retention interval and while the subscription is
still available.
""")
  CustomizedRecoverable,
  @doc("""
Denotes a vault and subscription state in which deletion is recoverable,
immediate and permanent deletion (i.e. purge) is not permitted, and in which
the subscription itself cannot be permanently canceled when 7<=
SoftDeleteRetentionInDays < 90. This level guarantees the recoverability of the
deleted entity during the retention interval, and also reflects the fact that
the subscription itself cannot be cancelled.
""")
  `CustomizedRecoverable+ProtectedSubscription`,
}

enum JsonWebKeyType {
  @doc("Elliptic Curve.") EC,
  @doc("Elliptic Curve with a private key which is stored in the HSM.")
  `EC-HSM`,
  @doc("RSA (https://tools.ietf.org/html/rfc3447)") RSA,
  @doc("RSA with a private key which is stored in the HSM.") `RSA-HSM`,
  @doc("Octet sequence (used to represent symmetric keys)") oct,
  @doc("Octet sequence (used to represent symmetric keys) which is stored the HSM.")
  `oct-HSM`,
  @doc("Octet key pair (https://tools.ietf.org/html/rfc8037)") OKP,
  @doc("""
Octet key pair (https://tools.ietf.org/html/rfc8037) with a private key which
is stored in the HSM.
""")
  `OKP-HSM`,
}

enum JsonWebKeyCurveName {
  @doc("The NIST P-256 elliptic curve, AKA SECG curve SECP256R1.") `P-256`,
  @doc("The NIST P-384 elliptic curve, AKA SECG curve SECP384R1.") `P-384`,
  @doc("The NIST P-521 elliptic curve, AKA SECG curve SECP521R1.") `P-521`,
  @doc("The SECG SECP256K1 elliptic curve.") `P-256K`,
  @doc("The Ed25519 Edwards curve.") Ed25519,
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

enum JsonWebKeySignatureAlgorithm {
  @doc("""
RSASSA-PSS using SHA-256 and MGF1 with SHA-256, as described in
https://tools.ietf.org/html/rfc7518
""")
  PS256,
  @doc("""
RSASSA-PSS using SHA-384 and MGF1 with SHA-384, as described in
https://tools.ietf.org/html/rfc7518
""")
  PS384,
  @doc("""
RSASSA-PSS using SHA-512 and MGF1 with SHA-512, as described in
https://tools.ietf.org/html/rfc7518
""")
  PS512,
  @doc("""
RSASSA-PKCS1-v1_5 using SHA-256, as described in
https://tools.ietf.org/html/rfc7518
""")
  RS256,
  @doc("""
RSASSA-PKCS1-v1_5 using SHA-384, as described in
https://tools.ietf.org/html/rfc7518
""")
  RS384,
  @doc("""
RSASSA-PKCS1-v1_5 using SHA-512, as described in
https://tools.ietf.org/html/rfc7518
""")
  RS512,
  @doc("Reserved") RSNULL,
  @doc("""
ECDSA using P-256 and SHA-256, as described in
https://tools.ietf.org/html/rfc7518.
""")
  ES256,
  @doc("""
ECDSA using P-384 and SHA-384, as described in
https://tools.ietf.org/html/rfc7518
""")
  ES384,
  @doc("""
ECDSA using P-521 and SHA-512, as described in
https://tools.ietf.org/html/rfc7518
""")
  ES512,
  @doc("""
ECDSA using P-256K and SHA-256, as described in
https://tools.ietf.org/html/rfc7518
""")
  ES256K,
  @doc("""
Edwards-Curve Digital Signature Algorithm, as described in
https://tools.ietf.org/html/rfc8032.
""")
  EdDSA,
}

enum KeyEncryptionAlgorithm {
  CKM_RSA_AES_KEY_WRAP,
  RSA_AES_KEY_WRAP_256,
  RSA_AES_KEY_WRAP_384,
}

enum RoleDefinitionType {
  `Microsoft.Authorization/roleDefinitions`,
}

enum RoleType {
  @doc("Built in role.") BuiltInRole: "AKVBuiltInRole",
  @doc("Custom role.") CustomRole,
}

enum DataAction {
  @doc("Read HSM key metadata.")
  ReadHsmKey: "Microsoft.KeyVault/managedHsm/keys/read/action",
  @doc("Update an HSM key.")
  WriteHsmKey: "Microsoft.KeyVault/managedHsm/keys/write/action",
  @doc("Read deleted HSM key.")
  ReadDeletedHsmKey: "Microsoft.KeyVault/managedHsm/keys/deletedKeys/read/action",
  @doc("Recover deleted HSM key.")
  RecoverDeletedHsmKey: "Microsoft.KeyVault/managedHsm/keys/deletedKeys/recover/action",
  @doc("Backup HSM keys.")
  BackupHsmKeys: "Microsoft.KeyVault/managedHsm/keys/backup/action",
  @doc("Restore HSM keys.")
  RestoreHsmKeys: "Microsoft.KeyVault/managedHsm/keys/restore/action",
  @doc("Delete role assignment.")
  DeleteRoleAssignment: "Microsoft.KeyVault/managedHsm/roleAssignments/delete/action",
  @doc("Get role assignment.")
  GetRoleAssignment: "Microsoft.KeyVault/managedHsm/roleAssignments/read/action",
  @doc("Create or update role assignment.")
  WriteRoleAssignment: "Microsoft.KeyVault/managedHsm/roleAssignments/write/action",
  @doc("Get role definition.")
  ReadRoleDefinition: "Microsoft.KeyVault/managedHsm/roleDefinitions/read/action",
  @doc("Create or update role definition.")
  WriteRoleDefinition: "Microsoft.KeyVault/managedHsm/roleDefinitions/write/action",
  @doc("Delete role definition.")
  DeleteRoleDefinition: "Microsoft.KeyVault/managedHsm/roleDefinitions/delete/action",
  @doc("Encrypt using an HSM key.")
  EncryptHsmKey: "Microsoft.KeyVault/managedHsm/keys/encrypt/action",
  @doc("Decrypt using an HSM key.")
  DecryptHsmKey: "Microsoft.KeyVault/managedHsm/keys/decrypt/action",
  @doc("Wrap using an HSM key.")
  WrapHsmKey: "Microsoft.KeyVault/managedHsm/keys/wrap/action",
  @doc("Unwrap using an HSM key.")
  UnwrapHsmKey: "Microsoft.KeyVault/managedHsm/keys/unwrap/action",
  @doc("Sign using an HSM key.")
  SignHsmKey: "Microsoft.KeyVault/managedHsm/keys/sign/action",
  @doc("Verify using an HSM key.")
  VerifyHsmKey: "Microsoft.KeyVault/managedHsm/keys/verify/action",
  @doc("Create an HSM key.")
  CreateHsmKey: "Microsoft.KeyVault/managedHsm/keys/create",
  @doc("Delete an HSM key.")
  DeleteHsmKey: "Microsoft.KeyVault/managedHsm/keys/delete",
  @doc("Export an HSM key.")
  ExportHsmKey: "Microsoft.KeyVault/managedHsm/keys/export/action",
  @doc("Release an HSM key using Secure Key Release.")
  ReleaseKey: "Microsoft.KeyVault/managedHsm/keys/release/action",
  @doc("Import an HSM key.")
  ImportHsmKey: "Microsoft.KeyVault/managedHsm/keys/import/action",
  @doc("Purge a deleted HSM key.")
  PurgeDeletedHsmKey: "Microsoft.KeyVault/managedHsm/keys/deletedKeys/delete",
  @doc("Download an HSM security domain.")
  DownloadHsmSecurityDomain: "Microsoft.KeyVault/managedHsm/securitydomain/download/action",
  @doc("Check status of HSM security domain download.")
  DownloadHsmSecurityDomainStatus: "Microsoft.KeyVault/managedHsm/securitydomain/download/read",
  @doc("Upload an HSM security domain.")
  UploadHsmSecurityDomain: "Microsoft.KeyVault/managedHsm/securitydomain/upload/action",
  @doc("Check the status of the HSM security domain exchange file.")
  ReadHsmSecurityDomainStatus: "Microsoft.KeyVault/managedHsm/securitydomain/upload/read",
  @doc("Download an HSM security domain transfer key.")
  ReadHsmSecurityDomainTransferKey: "Microsoft.KeyVault/managedHsm/securitydomain/transferkey/read",
  @doc("Start an HSM backup.")
  StartHsmBackup: "Microsoft.KeyVault/managedHsm/backup/start/action",
  @doc("Start an HSM restore.")
  StartHsmRestore: "Microsoft.KeyVault/managedHsm/restore/start/action",
  @doc("Read an HSM backup status.")
  ReadHsmBackupStatus: "Microsoft.KeyVault/managedHsm/backup/status/action",
  @doc("Read an HSM restore status.")
  ReadHsmRestoreStatus: "Microsoft.KeyVault/managedHsm/restore/status/action",
  @doc("Generate random numbers.")
  RandomNumbersGenerate: "Microsoft.KeyVault/managedHsm/rng/action",
}

enum RoleScope {
  @doc("Global scope") Global: "/",
  @doc("Keys scope") Keys: "/keys",
}

enum SettingTypeEnum {
  boolean,
}

enum SasTokenType {
  account,
  service,
}
@Azure.Core.fixed
enum ActionType {
  EmailContacts,
  AutoRenew,
  rotate,
  notify,
}
@Azure.Core.fixed
enum OperationStatus {
  Success,
  InProgress,
  Failed,
}

model SASTokenParameter {
  @doc("Azure Blob storage container Uri")
  storageResourceUri: string;

  @doc("The SAS token pointing to an Azure Blob storage container")
  token: string;
}

@doc("Full backup operation")
model FullBackupOperation {
  @doc("Status of the backup operation.")
  status?: string;

  @doc("The status details of backup operation.")
  statusDetails?: string;

  @doc("Error encountered, if any, during the full backup operation.")
  error?: Error;

  @doc("The start time of the backup operation in UTC")
  startTime?: plainTime;

  @doc("The end time of the backup operation in UTC")
  endTime?: plainTime;

  @doc("Identifier for the full backup operation.")
  jobId?: string;

  @doc("The Azure blob storage container Uri which contains the full backup")
  azureStorageBlobContainerUri?: string;
}

@doc("The key vault server error.")
model Error {
  @doc("The error code.")
  @visibility("read")
  code?: string;

  @doc("The error message.")
  @visibility("read")
  message?: string;

  @doc("The key vault server error.")
  @visibility("read")
  @projectedName("json", "innererror")
  innerError?: Error;
}

@doc("The key vault error exception.")
@error
model KeyVaultError {
  @doc("The key vault server error.")
  @visibility("read")
  error?: Error;
}

model RestoreOperationParameters {
  sasTokenParameters: SASTokenParameter;

  @doc("The Folder name of the blob where the previous successful full backup was stored")
  folderToRestore: string;
}

@doc("Restore operation")
model RestoreOperation {
  @doc("Status of the restore operation.")
  status?: string;

  @doc("The status details of restore operation.")
  statusDetails?: string;

  @doc("Error encountered, if any, during the restore operation.")
  error?: Error;

  @doc("Identifier for the restore operation.")
  jobId?: string;

  @doc("The start time of the restore operation")
  startTime?: plainTime;

  @doc("The end time of the restore operation")
  endTime?: plainTime;
}

model SelectiveKeyRestoreOperationParameters {
  sasTokenParameters: SASTokenParameter;

  @doc("The Folder name of the blob where the previous successful full backup was stored")
  folder: string;
}

@doc("Selective Key Restore operation")
model SelectiveKeyRestoreOperation {
  @doc("Status of the restore operation.")
  status?: string;

  @doc("The status details of restore operation.")
  statusDetails?: string;

  @doc("Error encountered, if any, during the selective key restore operation.")
  error?: Error;

  @doc("Identifier for the selective key restore operation.")
  jobId?: string;

  @doc("The start time of the restore operation")
  startTime?: plainTime;

  @doc("The end time of the restore operation")
  endTime?: plainTime;
}

@doc("The certificate list result.")
model CertificateListResult is Azure.Core.Page<CertificateItem>;

@doc("The certificate item containing certificate metadata.")
model CertificateItem {
  @doc("Certificate identifier.")
  id?: string;

  @doc("The certificate management attributes.")
  attributes?: CertificateAttributes;

  @doc("Application specific metadata in the form of key-value pairs.")
  tags?: Record<string>;

  @doc("Thumbprint of the certificate.")
  @projectedName("json", "x5t")
  x509Thumbprint?: bytes;
}

@doc("The certificate management attributes.")
model CertificateAttributes {
  ...Attributes;

  @doc("""
softDelete data retention days. Value should be >=7 and <=90 when softDelete
enabled, otherwise 0.
""")
  @visibility("read")
  recoverableDays?: int32;

  @doc("""
Reflects the deletion recovery level currently in effect for certificates in
the current vault. If it contains 'Purgeable', the certificate can be
permanently deleted by a privileged user; otherwise, only the system can purge
the certificate, at the end of the retention interval.
""")
  @visibility("read")
  recoveryLevel?: DeletionRecoveryLevel;
}

@doc("The object attributes managed by the KeyVault service.")
model Attributes {
  @doc("Determines whether the object is enabled.")
  enabled?: boolean;

  @doc("Not before date in UTC.")
  @projectedName("json", "nbf")
  notBefore?: plainTime;

  @doc("Expiry date in UTC.")
  @projectedName("json", "exp")
  expires?: plainTime;

  @doc("Creation time in UTC.")
  @visibility("read")
  created?: plainTime;

  @doc("Last updated time in UTC.")
  @visibility("read")
  updated?: plainTime;
}

@doc("""
A Deleted Certificate consisting of its previous id, attributes and its tags,
as well as information on when it will be purged.
""")
model DeletedCertificateBundle {
  ...CertificateBundle;

  @doc("""
The url of the recovery object, used to identify and recover the deleted
certificate.
""")
  recoveryId?: string;

  @doc("The time when the certificate is scheduled to be purged, in UTC")
  @visibility("read")
  scheduledPurgeDate?: plainTime;

  @doc("The time when the certificate was deleted, in UTC")
  @visibility("read")
  deletedDate?: plainTime;
}

@doc("A certificate bundle consists of a certificate (X509) plus its attributes.")
model CertificateBundle {
  @doc("The certificate id.")
  @visibility("read")
  id?: string;

  @doc("The key id.")
  @visibility("read")
  kid?: string;

  @doc("The secret id.")
  @visibility("read")
  sid?: string;

  @doc("Thumbprint of the certificate.")
  @visibility("read")
  @projectedName("json", "x5t")
  x509Thumbprint?: bytes;

  @doc("The management policy.")
  @visibility("read")
  policy?: CertificatePolicy;

  @doc("CER contents of x509 certificate.")
  cer?: bytes;

  @doc("""
The content type of the secret. eg. 'application/x-pem-file' or
'application/x-pkcs12', 
""")
  contentType?: string;

  @doc("The certificate attributes.")
  attributes?: CertificateAttributes;

  @doc("Application specific metadata in the form of key-value pairs")
  tags?: Record<string>;
}

@doc("Management policy for a certificate.")
model CertificatePolicy {
  @doc("The certificate id.")
  @visibility("read")
  id?: string;

  @doc("Properties of the key backing a certificate.")
  @projectedName("json", "key_props")
  keyProperties?: KeyProperties;

  @doc("Properties of the secret backing a certificate.")
  @projectedName("json", "secret_props")
  secretProperties?: SecretProperties;

  @doc("Properties of the X509 component of a certificate.")
  @projectedName("json", "x509_props")
  x509CertificateProperties?: X509CertificateProperties;

  @doc("Actions that will be performed by Key Vault over the lifetime of a certificate.")
  @projectedName("json", "lifetime_actions")
  lifetimeActions?: LifetimeAction[];

  @doc("Parameters for the issuer of the X509 component of a certificate.")
  @projectedName("json", "issuer")
  issuerParameters?: IssuerParameters;

  @doc("The certificate attributes.")
  attributes?: CertificateAttributes;
}

@doc("Properties of the key pair backing a certificate.")
model KeyProperties {
  @doc("""
Indicates if the private key can be exported. Release policy must be provided
when creating the first version of an exportable key.
""")
  exportable?: boolean;

  @doc("The type of key pair to be used for the certificate.")
  @projectedName("json", "kty")
  keyType?: JsonWebKeyType;

  @doc("The key size in bits. For example: 2048, 3072, or 4096 for RSA.")
  @projectedName("json", "key_size")
  keySize?: int32;

  @doc("Indicates if the same key pair will be used on certificate renewal.")
  @projectedName("json", "reuse_key")
  reuseKey?: boolean;

  @doc("Elliptic curve name. For valid values, see JsonWebKeyCurveName.")
  @projectedName("json", "crv")
  curve?: JsonWebKeyCurveName;
}

@doc("Properties of the key backing a certificate.")
model SecretProperties {
  @doc("The media type (MIME type).")
  contentType?: string;
}

@doc("Properties of the X509 component of a certificate.")
model X509CertificateProperties {
  @doc("The subject name. Should be a valid X509 distinguished Name.")
  subject?: string;

  @doc("The enhanced key usage.")
  ekus?: string[];

  @doc("The subject alternative names.")
  @projectedName("json", "sans")
  subjectAlternativeNames?: SubjectAlternativeNames;

  @doc("Defines how the certificate's key may be used.")
  @projectedName("json", "key_usage")
  keyUsage?: KeyUsageType[];

  @doc("The duration that the certificate is valid in months.")
  @projectedName("json", "validity_months")
  validityInMonths?: int32;
}

@doc("The subject alternate names of a X509 object.")
model SubjectAlternativeNames {
  @doc("Email addresses.")
  emails?: string[];

  @doc("Domain names.")
  @projectedName("json", "dns_names")
  dnsNames?: string[];

  @doc("User principal names.")
  upns?: string[];
}

@doc("""
Action and its trigger that will be performed by Key Vault over the lifetime of
a certificate.
""")
model LifetimeAction {
  @doc("The condition that will execute the action.")
  trigger?: Trigger;

  @doc("The action that will be executed.")
  action?: Action;
}

@doc("A condition to be satisfied for an action to be executed.")
model Trigger {
  @doc("Percentage of lifetime at which to trigger. Value should be between 1 and 99.")
  @projectedName("json", "lifetime_percentage")
  lifetimePercentage?: int32;

  @doc("""
Days before expiry to attempt renewal. Value should be between 1 and
validity_in_months multiplied by 27. If validity_in_months is 36, then value
should be between 1 and 972 (36 * 27).
""")
  @projectedName("json", "days_before_expiry")
  daysBeforeExpiry?: int32;
}

@doc("The action that will be executed.")
model Action {
  @doc("The type of the action.")
  @projectedName("json", "action_type")
  actionType?: ActionType;
}

@doc("Parameters for the issuer of the X509 component of a certificate.")
model IssuerParameters {
  @doc("""
Name of the referenced issuer object or reserved names; for example, 'Self' or
'Unknown'.
""")
  name?: string;

  @doc("""
Certificate type as supported by the provider (optional); for example 'OV-SSL',
'EV-SSL'
""")
  @projectedName("json", "cty")
  certificateType?: string;

  @doc("""
Indicates if the certificates generated under this policy should be published
to certificate transparency logs.
""")
  @projectedName("json", "cert_transparency")
  certificateTransparency?: boolean;
}

@doc("The contacts for the vault certificates.")
model Contacts {
  @doc("Identifier for the contacts collection.")
  @visibility("read")
  id?: string;

  @doc("The contact list for the vault certificates.")
  @projectedName("json", "contacts")
  contactList?: Contact[];
}

@doc("The contact information for the vault certificates.")
model Contact {
  @doc("Email address.")
  @projectedName("json", "email")
  emailAddress?: string;

  @doc("Name.")
  name?: string;

  @doc("Phone number.")
  phone?: string;
}

@doc("The certificate issuer list result.")
model CertificateIssuerListResult is Azure.Core.Page<CertificateIssuerItem>;

@doc("The certificate issuer item containing certificate issuer metadata.")
model CertificateIssuerItem {
  @doc("Certificate Identifier.")
  id?: string;

  @doc("The issuer provider.")
  provider?: string;
}

@doc("The certificate issuer set parameters.")
model CertificateIssuerSetParameters {
  @doc("The issuer provider.")
  provider: string;

  @doc("The credentials to be used for the issuer.")
  credentials?: IssuerCredentials;

  @doc("Details of the organization as provided to the issuer.")
  @projectedName("json", "org_details")
  organizationDetails?: OrganizationDetails;

  @doc("Attributes of the issuer object.")
  attributes?: IssuerAttributes;
}

@doc("The credentials to be used for the certificate issuer.")
model IssuerCredentials {
  @doc("The user name/account name/account id.")
  @projectedName("json", "account_id")
  accountId?: string;

  @doc("The password/secret/account key.")
  @projectedName("json", "pwd")
  password?: string;
}

@doc("Details of the organization of the certificate issuer.")
model OrganizationDetails {
  @doc("Id of the organization.")
  id?: string;

  @doc("Details of the organization administrator.")
  @projectedName("json", "admin_details")
  adminDetails?: AdministratorDetails[];
}

@doc("Details of the organization administrator of the certificate issuer.")
model AdministratorDetails {
  @doc("First name.")
  @projectedName("json", "first_name")
  firstName?: string;

  @doc("Last name.")
  @projectedName("json", "last_name")
  lastName?: string;

  @doc("Email address.")
  @projectedName("json", "email")
  emailAddress?: string;

  @doc("Phone number.")
  phone?: string;
}

@doc("The attributes of an issuer managed by the Key Vault service.")
model IssuerAttributes {
  @doc("Determines whether the issuer is enabled.")
  enabled?: boolean;

  @doc("Creation time in UTC.")
  @visibility("read")
  created?: plainTime;

  @doc("Last updated time in UTC.")
  @visibility("read")
  updated?: plainTime;
}

@doc("The issuer for Key Vault certificate.")
model IssuerBundle {
  @doc("Identifier for the issuer object.")
  @visibility("read")
  id?: string;

  @doc("The issuer provider.")
  provider?: string;

  @doc("The credentials to be used for the issuer.")
  credentials?: IssuerCredentials;

  @doc("Details of the organization as provided to the issuer.")
  @projectedName("json", "org_details")
  organizationDetails?: OrganizationDetails;

  @doc("Attributes of the issuer object.")
  attributes?: IssuerAttributes;
}

@doc("The certificate issuer update parameters.")
model CertificateIssuerUpdateParameters {
  @doc("The issuer provider.")
  provider?: string;

  @doc("The credentials to be used for the issuer.")
  credentials?: IssuerCredentials;

  @doc("Details of the organization as provided to the issuer.")
  @projectedName("json", "org_details")
  organizationDetails?: OrganizationDetails;

  @doc("Attributes of the issuer object.")
  attributes?: IssuerAttributes;
}

@doc("The certificate create parameters.")
model CertificateCreateParameters {
  @doc("The management policy for the certificate.")
  @projectedName("json", "policy")
  certificatePolicy?: CertificatePolicy;

  @doc("The attributes of the certificate (optional).")
  @projectedName("json", "attributes")
  certificateAttributes?: CertificateAttributes;

  @doc("Application specific metadata in the form of key-value pairs.")
  tags?: Record<string>;
}

@doc("A certificate operation is returned in case of asynchronous requests.")
model CertificateOperation {
  @doc("The certificate id.")
  @visibility("read")
  id?: string;

  @doc("Parameters for the issuer of the X509 component of a certificate.")
  @projectedName("json", "issuer")
  issuerParameters?: IssuerParameters;

  @doc("""
The certificate signing request (CSR) that is being used in the certificate
operation.
""")
  csr?: bytes;

  @doc("Indicates if cancellation was requested on the certificate operation.")
  @projectedName("json", "cancellation_requested")
  cancellationRequested?: boolean;

  @doc("Status of the certificate operation.")
  status?: string;

  @doc("The status details of the certificate operation.")
  @projectedName("json", "status_details")
  statusDetails?: string;

  @doc("Error encountered, if any, during the certificate operation.")
  error?: Error;

  @doc("Location which contains the result of the certificate operation.")
  target?: string;

  @doc("Identifier for the certificate operation.")
  @projectedName("json", "request_id")
  requestId?: string;
}

@doc("The certificate import parameters.")
model CertificateImportParameters {
  @doc("""
Base64 encoded representation of the certificate object to import. This
certificate needs to contain the private key.
""")
  @projectedName("json", "value")
  base64EncodedCertificate: string;

  @doc("""
If the private key in base64EncodedCertificate is encrypted, the password used
for encryption.
""")
  @projectedName("json", "pwd")
  password?: string;

  @doc("The management policy for the certificate.")
  @projectedName("json", "policy")
  certificatePolicy?: CertificatePolicy;

  @doc("The attributes of the certificate (optional).")
  @projectedName("json", "attributes")
  certificateAttributes?: CertificateAttributes;

  @doc("Application specific metadata in the form of key-value pairs.")
  tags?: Record<string>;
}

@doc("The certificate update parameters.")
model CertificateUpdateParameters {
  @doc("The management policy for the certificate.")
  @projectedName("json", "policy")
  certificatePolicy?: CertificatePolicy;

  @doc("The attributes of the certificate (optional).")
  @projectedName("json", "attributes")
  certificateAttributes?: CertificateAttributes;

  @doc("Application specific metadata in the form of key-value pairs.")
  tags?: Record<string>;
}

@doc("The certificate operation update parameters.")
model CertificateOperationUpdateParameter {
  @doc("Indicates if cancellation was requested on the certificate operation.")
  @projectedName("json", "cancellation_requested")
  cancellationRequested: boolean;
}

@doc("The certificate merge parameters")
model CertificateMergeParameters {
  @doc("The certificate or the certificate chain to merge.")
  @projectedName("json", "x5c")
  x509Certificates: bytes[];

  @doc("The attributes of the certificate (optional).")
  @projectedName("json", "attributes")
  certificateAttributes?: CertificateAttributes;

  @doc("Application specific metadata in the form of key-value pairs.")
  tags?: Record<string>;
}

@doc("The backup certificate result, containing the backup blob.")
model BackupCertificateResult {
  @doc("The backup blob containing the backed up certificate.")
  @visibility("read")
  value?: bytes;
}

@doc("The certificate restore parameters.")
model CertificateRestoreParameters {
  @doc("The backup blob associated with a certificate bundle.")
  @projectedName("json", "value")
  certificateBundleBackup: bytes;
}

@doc("A list of certificates that have been deleted in this vault.")
model DeletedCertificateListResult is Azure.Core.Page<DeletedCertificateItem>;

@doc("The deleted certificate item containing metadata about the deleted certificate.")
model DeletedCertificateItem {
  ...CertificateItem;

  @doc("""
The url of the recovery object, used to identify and recover the deleted
certificate.
""")
  recoveryId?: string;

  @doc("The time when the certificate is scheduled to be purged, in UTC")
  @visibility("read")
  scheduledPurgeDate?: plainTime;

  @doc("The time when the certificate was deleted, in UTC")
  @visibility("read")
  deletedDate?: plainTime;
}

@doc("The key create parameters.")
model KeyCreateParameters {
  @doc("The type of key to create. For valid values, see JsonWebKeyType.")
  kty: JsonWebKeyType;

  @doc("The key size in bits. For example: 2048, 3072, or 4096 for RSA.")
  @projectedName("json", "key_size")
  keySize?: int32;

  @doc("The public exponent for a RSA key.")
  @projectedName("json", "public_exponent")
  publicExponent?: int32;

  @projectedName("json", "key_ops")
  keyOps?: JsonWebKeyOperation[];

  @doc("The attributes of a key managed by the key vault service.")
  @projectedName("json", "attributes")
  keyAttributes?: KeyAttributes;

  @doc("Application specific metadata in the form of key-value pairs.")
  tags?: Record<string>;

  @doc("Elliptic curve name. For valid values, see JsonWebKeyCurveName.")
  @projectedName("json", "crv")
  curve?: JsonWebKeyCurveName;

  @doc("The policy rules under which the key can be exported.")
  @projectedName("json", "release_policy")
  releasePolicy?: KeyReleasePolicy;
}

@doc("The attributes of a key managed by the key vault service.")
model KeyAttributes {
  ...Attributes;

  @doc("""
softDelete data retention days. Value should be >=7 and <=90 when softDelete
enabled, otherwise 0.
""")
  @visibility("read")
  recoverableDays?: int32;

  @doc("""
Reflects the deletion recovery level currently in effect for keys in the
current vault. If it contains 'Purgeable' the key can be permanently deleted by
a privileged user; otherwise, only the system can purge the key, at the end of
the retention interval.
""")
  @visibility("read")
  recoveryLevel?: DeletionRecoveryLevel;

  @doc("""
Indicates if the private key can be exported. Release policy must be provided
when creating the first version of an exportable key.
""")
  exportable?: boolean;
}

@doc("The policy rules under which the key can be exported.")
model KeyReleasePolicy {
  @doc("Content type and version of key release policy")
  contentType?: string;

  @doc("""
Defines the mutability state of the policy. Once marked immutable, this flag
cannot be reset and the policy cannot be changed under any circumstances.
""")
  immutable?: boolean;

  @doc("""
Blob encoding the policy rules under which the key can be released. Blob must
be base64 URL encoded.
""")
  @projectedName("json", "data")
  encodedPolicy?: bytes;
}

@doc("A KeyBundle consisting of a WebKey plus its attributes.")
model KeyBundle {
  @doc("The Json web key.")
  key?: JsonWebKey;

  @doc("The key management attributes.")
  attributes?: KeyAttributes;

  @doc("Application specific metadata in the form of key-value pairs.")
  tags?: Record<string>;

  @doc("""
True if the key's lifetime is managed by key vault. If this is a key backing a
certificate, then managed will be true.
""")
  @visibility("read")
  managed?: boolean;

  @doc("The policy rules under which the key can be exported.")
  @projectedName("json", "release_policy")
  releasePolicy?: KeyReleasePolicy;
}

@doc("As of http://tools.ietf.org/html/draft-ietf-jose-json-web-key-18")
model JsonWebKey {
  @doc("Key identifier.")
  kid?: string;

  @doc("""
JsonWebKey Key Type (kty), as defined in
https://tools.ietf.org/html/draft-ietf-jose-json-web-algorithms-40.
""")
  kty?: JsonWebKeyType;

  @projectedName("json", "key_ops")
  keyOps?: string[];

  @doc("RSA modulus.")
  n?: bytes;

  @doc("RSA public exponent.")
  e?: bytes;

  @doc("RSA private exponent, or the D component of an EC or OKP private key.")
  d?: bytes;

  @doc("RSA private key parameter.")
  @projectedName("json", "dp")
  DP?: bytes;

  @doc("RSA private key parameter.")
  @projectedName("json", "dq")
  DQ?: bytes;

  @doc("RSA private key parameter.")
  @projectedName("json", "qi")
  QI?: bytes;

  @doc("RSA secret prime.")
  p?: bytes;

  @doc("RSA secret prime, with p < q.")
  q?: bytes;

  @doc("Symmetric key.")
  k?: bytes;

  @doc("Protected Key, used with 'Bring Your Own Key'.")
  @projectedName("json", "key_hsm")
  t?: bytes;

  @doc("Elliptic curve name. For valid values, see JsonWebKeyCurveName.")
  crv?: JsonWebKeyCurveName;

  @doc("X component of an EC or OKP public key.")
  x?: bytes;

  @doc("Y component of an EC public key.")
  y?: bytes;
}

@doc("The key import parameters.")
model KeyImportParameters {
  @doc("Whether to import as a hardware key (HSM) or software key.")
  @projectedName("json", "Hsm")
  hsm?: boolean;

  @doc("The Json web key")
  key: JsonWebKey;

  @doc("The key management attributes.")
  @projectedName("json", "attributes")
  keyAttributes?: KeyAttributes;

  @doc("Application specific metadata in the form of key-value pairs.")
  tags?: Record<string>;

  @doc("The policy rules under which the key can be exported.")
  @projectedName("json", "release_policy")
  releasePolicy?: KeyReleasePolicy;
}

@doc("A DeletedKeyBundle consisting of a WebKey plus its Attributes and deletion info")
model DeletedKeyBundle {
  ...KeyBundle;

  @doc("The url of the recovery object, used to identify and recover the deleted key.")
  recoveryId?: string;

  @doc("The time when the key is scheduled to be purged, in UTC")
  @visibility("read")
  scheduledPurgeDate?: plainTime;

  @doc("The time when the key was deleted, in UTC")
  @visibility("read")
  deletedDate?: plainTime;
}

@doc("The key update parameters.")
model KeyUpdateParameters {
  @doc("""
Json web key operations. For more information on possible key operations, see
JsonWebKeyOperation.
""")
  @projectedName("json", "key_ops")
  keyOps?: JsonWebKeyOperation[];

  @doc("The attributes of a key managed by the key vault service.")
  @projectedName("json", "attributes")
  keyAttributes?: KeyAttributes;

  @doc("Application specific metadata in the form of key-value pairs.")
  tags?: Record<string>;

  @doc("The policy rules under which the key can be exported.")
  @projectedName("json", "release_policy")
  releasePolicy?: KeyReleasePolicy;
}

@doc("The key list result.")
model KeyListResult is Azure.Core.Page<KeyItem>;

@doc("The key item containing key metadata.")
model KeyItem {
  @doc("Key identifier.")
  kid?: string;

  @doc("The key management attributes.")
  attributes?: KeyAttributes;

  @doc("Application specific metadata in the form of key-value pairs.")
  tags?: Record<string>;

  @doc("""
True if the key's lifetime is managed by key vault. If this is a key backing a
certificate, then managed will be true.
""")
  @visibility("read")
  managed?: boolean;
}

@doc("The backup key result, containing the backup blob.")
model BackupKeyResult {
  @doc("The backup blob containing the backed up key.")
  @visibility("read")
  value?: bytes;
}

@doc("The key restore parameters.")
model KeyRestoreParameters {
  @doc("The backup blob associated with a key bundle.")
  @projectedName("json", "value")
  keyBundleBackup: bytes;
}

@doc("The key operations parameters.")
model KeyOperationsParameters {
  @doc("algorithm identifier")
  @projectedName("json", "alg")
  algorithm: JsonWebKeyEncryptionAlgorithm;
  value: bytes;

  @doc("""
Cryptographically random, non-repeating initialization vector for symmetric
algorithms.
""")
  iv?: bytes;

  @doc("""
Additional data to authenticate but not encrypt/decrypt when using
authenticated crypto algorithms.
""")
  aad?: bytes;

  @doc("""
The tag to authenticate when performing decryption with an authenticated
algorithm.
""")
  tag?: bytes;
}

@doc("The key operation result.")
model KeyOperationResult {
  @doc("Key identifier")
  @visibility("read")
  kid?: string;

  @visibility("read")
  @projectedName("json", "value")
  result?: bytes;

  @visibility("read")
  iv?: bytes;

  @visibility("read")
  @projectedName("json", "tag")
  authenticationTag?: bytes;

  @visibility("read")
  @projectedName("json", "aad")
  additionalAuthenticatedData?: bytes;
}

@doc("The key operations parameters.")
model KeySignParameters {
  @doc("""
The signing/verification algorithm identifier. For more information on possible
algorithm types, see JsonWebKeySignatureAlgorithm.
""")
  @projectedName("json", "alg")
  algorithm: JsonWebKeySignatureAlgorithm;
  value: bytes;
}

@doc("The key verify parameters.")
model KeyVerifyParameters {
  @doc("""
The signing/verification algorithm. For more information on possible algorithm
types, see JsonWebKeySignatureAlgorithm.
""")
  @projectedName("json", "alg")
  algorithm: JsonWebKeySignatureAlgorithm;

  @doc("The digest used for signing.")
  digest: bytes;

  @doc("The signature to be verified.")
  @projectedName("json", "value")
  signature: bytes;
}

@doc("The key verify result.")
model KeyVerifyResult {
  @doc("True if the signature is verified, otherwise false.")
  @visibility("read")
  value?: boolean;
}

@doc("The release key parameters.")
model KeyReleaseParameters {
  @doc("The attestation assertion for the target of the key release.")
  @projectedName("json", "target")
  targetAttestationToken: string;

  @doc("A client provided nonce for freshness.")
  nonce?: string;

  @doc("The encryption algorithm to use to protected the exported key material")
  enc?: KeyEncryptionAlgorithm;
}

@doc("The release result, containing the released key.")
model KeyReleaseResult {
  @doc("A signed object containing the released key.")
  @visibility("read")
  value?: string;
}

@doc("A list of keys that have been deleted in this vault.")
model DeletedKeyListResult is Azure.Core.Page<DeletedKeyItem>;

@doc("""
The deleted key item containing the deleted key metadata and information about
deletion.
""")
model DeletedKeyItem {
  ...KeyItem;

  @doc("The url of the recovery object, used to identify and recover the deleted key.")
  recoveryId?: string;

  @doc("The time when the key is scheduled to be purged, in UTC")
  @visibility("read")
  scheduledPurgeDate?: plainTime;

  @doc("The time when the key was deleted, in UTC")
  @visibility("read")
  deletedDate?: plainTime;
}

@doc("Management policy for a key.")
model KeyRotationPolicy {
  @doc("The key policy id.")
  @visibility("read")
  id?: string;

  @doc("""
Actions that will be performed by Key Vault over the lifetime of a key. For
preview, lifetimeActions can only have two items at maximum: one for rotate,
one for notify. Notification time would be default to 30 days before expiry and
it is not configurable.
""")
  lifetimeActions?: LifetimeActions[];

  @doc("The key rotation policy attributes.")
  attributes?: KeyRotationPolicyAttributes;
}

@doc("""
Action and its trigger that will be performed by Key Vault over the lifetime of
a key.
""")
model LifetimeActions {
  @doc("The condition that will execute the action.")
  trigger?: LifetimeActionsTrigger;

  @doc("The action that will be executed.")
  action?: LifetimeActionsType;
}

@doc("A condition to be satisfied for an action to be executed.")
model LifetimeActionsTrigger {
  @doc("""
Time after creation to attempt to rotate. It only applies to rotate. It will be
in ISO 8601 duration format. Example: 90 days : \"P90D\"  
""")
  timeAfterCreate?: string;

  @doc("""
Time before expiry to attempt to rotate or notify. It will be in ISO 8601
duration format. Example: 90 days : \"P90D\"
""")
  timeBeforeExpiry?: string;
}

@doc("The action that will be executed.")
model LifetimeActionsType {
  @doc("The type of the action.")
  type?: ActionType;
}

@doc("The key rotation policy attributes.")
model KeyRotationPolicyAttributes {
  @doc("""
The expiryTime will be applied on the new key version. It should be at least 28
days. It will be in ISO 8601 Format. Examples: 90 days: P90D, 3 months: P3M, 48
hours: PT48H, 1 year and 10 days: P1Y10D
""")
  expiryTime?: string;

  @doc("The key rotation policy created time in UTC.")
  @visibility("read")
  created?: plainTime;

  @doc("The key rotation policy's last updated time in UTC.")
  @visibility("read")
  updated?: plainTime;
}

@doc("The get random bytes request object.")
model GetRandomBytesRequest {
  @doc("The requested number of random bytes.")
  count: int32;
}

@doc("The get random bytes response object containing the bytes.")
model RandomBytes {
  @doc("The bytes encoded as a base64url string.")
  value: bytes;
}

@doc("Role definition.")
model RoleDefinition {
  @doc("The role definition ID.")
  @visibility("read")
  id?: string;

  @doc("The role definition name.")
  @visibility("read")
  name?: string;

  @doc("The role definition type.")
  @visibility("read")
  type?: RoleDefinitionType;

  @doc("Role definition properties.")
  properties?: RoleDefinitionProperties;
}

@doc("Role definition properties.")
model RoleDefinitionProperties {
  @doc("The role name.")
  roleName?: string;

  @doc("The role definition description.")
  description?: string;

  @doc("The role type.")
  @projectedName("json", "type")
  roleType?: RoleType;

  @doc("Role definition permissions.")
  permissions?: Permission[];

  @doc("Role definition assignable scopes.")
  assignableScopes?: RoleScope[];
}

@doc("Role definition permissions.")
model Permission {
  @doc("Action permissions that are granted.")
  actions?: string[];

  @doc("""
Action permissions that are excluded but not denied. They may be granted by
other role definitions assigned to a principal.
""")
  notActions?: string[];

  @doc("Data action permissions that are granted.")
  dataActions?: DataAction[];

  @doc("""
Data action permissions that are excluded but not denied. They may be granted
by other role definitions assigned to a principal.
""")
  notDataActions?: DataAction[];
}

@doc("Role definition create parameters.")
model RoleDefinitionCreateParameters {
  @doc("Role definition properties.")
  properties: RoleDefinitionProperties;
}

@doc("Role definition list operation result.")
model RoleDefinitionListResult is Azure.Core.Page<RoleDefinition>;

@doc("Role Assignments")
model RoleAssignment {
  @doc("The role assignment ID.")
  @visibility("read")
  id?: string;

  @doc("The role assignment name.")
  @visibility("read")
  name?: string;

  @doc("The role assignment type.")
  @visibility("read")
  type?: string;

  @doc("Role assignment properties.")
  properties?: RoleAssignmentPropertiesWithScope;
}

@doc("Role assignment properties with scope.")
model RoleAssignmentPropertiesWithScope {
  @doc("The role scope.")
  scope?: RoleScope;

  @doc("The role definition ID.")
  roleDefinitionId?: string;

  @doc("The principal ID.")
  principalId?: string;
}

@doc("Role assignment create parameters.")
model RoleAssignmentCreateParameters {
  @doc("Role assignment properties.")
  properties: RoleAssignmentProperties;
}

@doc("Role assignment properties.")
model RoleAssignmentProperties {
  @doc("The role definition ID used in the role assignment.")
  roleDefinitionId: string;

  @doc("""
The principal ID assigned to the role. This maps to the ID inside the Active
Directory. It can point to a user, service principal, or security group.
""")
  principalId: string;
}

@doc("Role assignment list operation result.")
model RoleAssignmentListResult is Azure.Core.Page<RoleAssignment>;

@doc("The secret set parameters.")
model SecretSetParameters {
  @doc("The value of the secret.")
  value: string;

  @doc("Application specific metadata in the form of key-value pairs.")
  tags?: Record<string>;

  @doc("Type of the secret value such as a password.")
  contentType?: string;

  @doc("The secret management attributes.")
  @projectedName("json", "attributes")
  secretAttributes?: SecretAttributes;
}

@doc("The secret management attributes.")
model SecretAttributes {
  ...Attributes;

  @doc("""
softDelete data retention days. Value should be >=7 and <=90 when softDelete
enabled, otherwise 0.
""")
  @visibility("read")
  recoverableDays?: int32;

  @doc("""
Reflects the deletion recovery level currently in effect for secrets in the
current vault. If it contains 'Purgeable', the secret can be permanently
deleted by a privileged user; otherwise, only the system can purge the secret,
at the end of the retention interval.
""")
  @visibility("read")
  recoveryLevel?: DeletionRecoveryLevel;
}

@doc("A secret consisting of a value, id and its attributes.")
model SecretBundle {
  @doc("The secret value.")
  value?: string;

  @doc("The secret id.")
  id?: string;

  @doc("The content type of the secret.")
  contentType?: string;

  @doc("The secret management attributes.")
  attributes?: SecretAttributes;

  @doc("Application specific metadata in the form of key-value pairs.")
  tags?: Record<string>;

  @doc("""
If this is a secret backing a KV certificate, then this field specifies the
corresponding key backing the KV certificate.
""")
  @visibility("read")
  kid?: string;

  @doc("""
True if the secret's lifetime is managed by key vault. If this is a secret
backing a certificate, then managed will be true.
""")
  @visibility("read")
  managed?: boolean;
}

@doc("""
A Deleted Secret consisting of its previous id, attributes and its tags, as
well as information on when it will be purged.
""")
model DeletedSecretBundle {
  ...SecretBundle;

  @doc("The url of the recovery object, used to identify and recover the deleted secret.")
  recoveryId?: string;

  @doc("The time when the secret is scheduled to be purged, in UTC")
  @visibility("read")
  scheduledPurgeDate?: plainTime;

  @doc("The time when the secret was deleted, in UTC")
  @visibility("read")
  deletedDate?: plainTime;
}

@doc("The secret update parameters.")
model SecretUpdateParameters {
  @doc("Type of the secret value such as a password.")
  contentType?: string;

  @doc("The secret management attributes.")
  @projectedName("json", "attributes")
  secretAttributes?: SecretAttributes;

  @doc("Application specific metadata in the form of key-value pairs.")
  tags?: Record<string>;
}

@doc("The secret list result.")
model SecretListResult is Azure.Core.Page<SecretItem>;

@doc("The secret item containing secret metadata.")
model SecretItem {
  @doc("Secret identifier.")
  id?: string;

  @doc("The secret management attributes.")
  attributes?: SecretAttributes;

  @doc("Application specific metadata in the form of key-value pairs.")
  tags?: Record<string>;

  @doc("Type of the secret value such as a password.")
  contentType?: string;

  @doc("""
True if the secret's lifetime is managed by key vault. If this is a key backing
a certificate, then managed will be true.
""")
  @visibility("read")
  managed?: boolean;
}

@doc("The deleted secret list result")
model DeletedSecretListResult is Azure.Core.Page<DeletedSecretItem>;

@doc("The deleted secret item containing metadata about the deleted secret.")
model DeletedSecretItem {
  ...SecretItem;

  @doc("The url of the recovery object, used to identify and recover the deleted secret.")
  recoveryId?: string;

  @doc("The time when the secret is scheduled to be purged, in UTC")
  @visibility("read")
  scheduledPurgeDate?: plainTime;

  @doc("The time when the secret was deleted, in UTC")
  @visibility("read")
  deletedDate?: plainTime;
}

@doc("The backup secret result, containing the backup blob.")
model BackupSecretResult {
  @doc("The backup blob containing the backed up secret.")
  @visibility("read")
  value?: bytes;
}

@doc("The secret restore parameters.")
model SecretRestoreParameters {
  @doc("The backup blob associated with a secret bundle.")
  @projectedName("json", "value")
  secretBundleBackup: bytes;
}

model SecurityDomainOperationStatus {
  @doc("operation status")
  status?: OperationStatus;

  @projectedName("json", "status_details")
  statusDetails?: string;
}

model CertificateInfoObject {
  @doc("Certificates needed from customer")
  certificates: SecurityDomainJsonWebKey[];

  @doc("""
Customer to specify the number of certificates (minimum 2 and maximum 10) to
restore Security Domain
""")
  required?: int32;
}

model SecurityDomainJsonWebKey {
  @doc("Key identifier.")
  kid: string;

  @doc("""
JsonWebKey Key Type (kty), as defined in
https://tools.ietf.org/html/draft-ietf-jose-json-web-algorithms-40. For
Security Domain this value must be RSA.
""")
  kty: string;

  @projectedName("json", "key_ops")
  keyOps: string[];

  @doc("RSA modulus.")
  n: string;

  @doc("RSA public exponent.")
  e: string;

  @doc("X509 certificate chain parameter")
  @projectedName("json", "x5c")
  x5C: string[];

  @doc("Public Key Use Parameter. This is optional and if present must be enc.")
  use?: string;

  @doc("X509 certificate SHA1 thumbprint. This is optional.")
  @projectedName("json", "x5t")
  x5T?: string;

  @doc("X509 certificate SHA256 thumbprint.")
  @projectedName("json", "x5t#S256")
  x5TS256: string;

  @doc("Algorithm intended for use with the key.")
  alg: string;
}

@doc("The Security Domain.")
model SecurityDomainObject {
  @doc("The Security Domain.")
  value: string;
}

model TransferKey {
  @doc("Specifies the format of the transfer key")
  @projectedName("json", "key_format")
  keyFormat?: string;

  @doc("Specifies the transfer key in JWK format")
  @projectedName("json", "transfer_key")
  transferKey: SecurityDomainJsonWebKey;
}

@doc("The update settings request object.")
model UpdateSettingsRequest {
  @doc("The value of the pool setting.")
  value: string;
}

model Setting {
  @doc("The account setting to be updated")
  name: string;

  @doc("The value of the pool setting.")
  value: string;

  @doc("The type specifier of the value.")
  type?: SettingTypeEnum;
}

@doc("The settings list result.")
model SettingsListResult {
  @doc("""
A response message containing a list of account settings with their associated
value.
""")
  @visibility("read")
  value?: Setting[];
}

@doc("The storage accounts list result.")
model StorageListResult is Azure.Core.Page<StorageAccountItem>;

@doc("The storage account item containing storage account metadata.")
model StorageAccountItem {
  @doc("Storage identifier.")
  @visibility("read")
  id?: string;

  @doc("Storage account resource Id.")
  @visibility("read")
  resourceId?: string;

  @doc("The storage account management attributes.")
  @visibility("read")
  attributes?: StorageAccountAttributes;

  @doc("Application specific metadata in the form of key-value pairs.")
  @visibility("read")
  tags?: Record<string>;
}

@doc("The storage account management attributes.")
model StorageAccountAttributes {
  @doc("the enabled state of the object.")
  enabled?: boolean;

  @doc("Creation time in UTC.")
  @visibility("read")
  created?: plainTime;

  @doc("Last updated time in UTC.")
  @visibility("read")
  updated?: plainTime;

  @doc("""
softDelete data retention days. Value should be >=7 and <=90 when softDelete
enabled, otherwise 0.
""")
  @visibility("read")
  recoverableDays?: int32;

  @doc("""
Reflects the deletion recovery level currently in effect for storage accounts
in the current vault. If it contains 'Purgeable' the storage account can be
permanently deleted by a privileged user; otherwise, only the system can purge
the storage account, at the end of the retention interval.
""")
  @visibility("read")
  recoveryLevel?: DeletionRecoveryLevel;
}

@doc("The deleted storage account list result")
model DeletedStorageListResult is Azure.Core.Page<DeletedStorageAccountItem>;

@doc("""
The deleted storage account item containing metadata about the deleted storage
account.
""")
model DeletedStorageAccountItem {
  ...StorageAccountItem;

  @doc("""
The url of the recovery object, used to identify and recover the deleted
storage account.
""")
  recoveryId?: string;

  @doc("The time when the storage account is scheduled to be purged, in UTC")
  @visibility("read")
  scheduledPurgeDate?: plainTime;

  @doc("The time when the storage account was deleted, in UTC")
  @visibility("read")
  deletedDate?: plainTime;
}

@doc("""
A deleted storage account bundle consisting of its previous id, attributes and
its tags, as well as information on when it will be purged.
""")
model DeletedStorageBundle {
  ...StorageBundle;

  @doc("""
The url of the recovery object, used to identify and recover the deleted
storage account.
""")
  recoveryId?: string;

  @doc("The time when the storage account is scheduled to be purged, in UTC")
  @visibility("read")
  scheduledPurgeDate?: plainTime;

  @doc("The time when the storage account was deleted, in UTC")
  @visibility("read")
  deletedDate?: plainTime;
}

@doc("""
A Storage account bundle consists of key vault storage account details plus its
attributes.
""")
model StorageBundle {
  @doc("The storage account id.")
  @visibility("read")
  id?: string;

  @doc("The storage account resource id.")
  @visibility("read")
  resourceId?: string;

  @doc("The current active storage account key name.")
  @visibility("read")
  activeKeyName?: string;

  @doc("whether keyvault should manage the storage account for the user.")
  @visibility("read")
  autoRegenerateKey?: boolean;

  @doc("The key regeneration time duration specified in ISO-8601 format.")
  @visibility("read")
  regenerationPeriod?: string;

  @doc("The storage account attributes.")
  @visibility("read")
  attributes?: StorageAccountAttributes;

  @doc("Application specific metadata in the form of key-value pairs")
  @visibility("read")
  tags?: Record<string>;
}

@doc("The backup storage result, containing the backup blob.")
model BackupStorageResult {
  @doc("The backup blob containing the backed up storage account.")
  @visibility("read")
  value?: bytes;
}

@doc("The secret restore parameters.")
model StorageRestoreParameters {
  @doc("The backup blob associated with a storage account.")
  @projectedName("json", "value")
  storageBundleBackup: bytes;
}

@doc("The storage account create parameters.")
model StorageAccountCreateParameters {
  @doc("Storage account resource id.")
  resourceId: string;

  @doc("Current active storage account key name.")
  activeKeyName: string;

  @doc("whether keyvault should manage the storage account for the user.")
  autoRegenerateKey: boolean;

  @doc("The key regeneration time duration specified in ISO-8601 format.")
  regenerationPeriod?: string;

  @doc("The attributes of the storage account.")
  @projectedName("json", "attributes")
  storageAccountAttributes?: StorageAccountAttributes;

  @doc("Application specific metadata in the form of key-value pairs.")
  tags?: Record<string>;
}

@doc("The storage account update parameters.")
model StorageAccountUpdateParameters {
  @doc("The current active storage account key name.")
  activeKeyName?: string;

  @doc("whether keyvault should manage the storage account for the user.")
  autoRegenerateKey?: boolean;

  @doc("The key regeneration time duration specified in ISO-8601 format.")
  regenerationPeriod?: string;

  @doc("The attributes of the storage account.")
  @projectedName("json", "attributes")
  storageAccountAttributes?: StorageAccountAttributes;

  @doc("Application specific metadata in the form of key-value pairs.")
  tags?: Record<string>;
}

@doc("The storage account key regenerate parameters.")
model StorageAccountRegenerteKeyParameters {
  @doc("The storage account key name.")
  keyName: string;
}

@doc("The storage account SAS definition list result.")
model SasDefinitionListResult is Azure.Core.Page<SasDefinitionItem>;

@doc("The SAS definition item containing storage SAS definition metadata.")
model SasDefinitionItem {
  @doc("The storage SAS identifier.")
  @visibility("read")
  id?: string;

  @doc("The storage account SAS definition secret id.")
  @visibility("read")
  @projectedName("json", "sid")
  secretId?: string;

  @doc("The SAS definition management attributes.")
  @visibility("read")
  attributes?: SasDefinitionAttributes;

  @doc("Application specific metadata in the form of key-value pairs.")
  @visibility("read")
  tags?: Record<string>;
}

@doc("The SAS definition management attributes.")
model SasDefinitionAttributes {
  @doc("the enabled state of the object.")
  enabled?: boolean;

  @doc("Creation time in UTC.")
  @visibility("read")
  created?: plainTime;

  @doc("Last updated time in UTC.")
  @visibility("read")
  updated?: plainTime;

  @doc("""
softDelete data retention days. Value should be >=7 and <=90 when softDelete
enabled, otherwise 0.
""")
  @visibility("read")
  recoverableDays?: int32;

  @doc("""
Reflects the deletion recovery level currently in effect for SAS definitions in
the current vault. If it contains 'Purgeable' the SAS definition can be
permanently deleted by a privileged user; otherwise, only the system can purge
the SAS definition, at the end of the retention interval.
""")
  @visibility("read")
  recoveryLevel?: DeletionRecoveryLevel;
}

@doc("The deleted SAS definition list result")
model DeletedSasDefinitionListResult
  is Azure.Core.Page<DeletedSasDefinitionItem>;

@doc("""
The deleted SAS definition item containing metadata about the deleted SAS
definition.
""")
model DeletedSasDefinitionItem {
  ...SasDefinitionItem;

  @doc("""
The url of the recovery object, used to identify and recover the deleted SAS
definition.
""")
  recoveryId?: string;

  @doc("The time when the SAS definition is scheduled to be purged, in UTC")
  @visibility("read")
  scheduledPurgeDate?: plainTime;

  @doc("The time when the SAS definition was deleted, in UTC")
  @visibility("read")
  deletedDate?: plainTime;
}

@doc("""
A deleted SAS definition bundle consisting of its previous id, attributes and
its tags, as well as information on when it will be purged.
""")
model DeletedSasDefinitionBundle {
  ...SasDefinitionBundle;

  @doc("""
The url of the recovery object, used to identify and recover the deleted SAS
definition.
""")
  recoveryId?: string;

  @doc("The time when the SAS definition is scheduled to be purged, in UTC")
  @visibility("read")
  scheduledPurgeDate?: plainTime;

  @doc("The time when the SAS definition was deleted, in UTC")
  @visibility("read")
  deletedDate?: plainTime;
}

@doc("""
A SAS definition bundle consists of key vault SAS definition details plus its
attributes.
""")
model SasDefinitionBundle {
  @doc("The SAS definition id.")
  @visibility("read")
  id?: string;

  @doc("Storage account SAS definition secret id.")
  @visibility("read")
  @projectedName("json", "sid")
  secretId?: string;

  @doc("""
The SAS definition token template signed with an arbitrary key.  Tokens created
according to the SAS definition will have the same properties as the template.
""")
  @visibility("read")
  templateUri?: string;

  @doc("The type of SAS token the SAS definition will create.")
  @visibility("read")
  sasType?: SasTokenType;

  @doc("The validity period of SAS tokens created according to the SAS definition.")
  @visibility("read")
  validityPeriod?: string;

  @doc("The SAS definition attributes.")
  @visibility("read")
  attributes?: SasDefinitionAttributes;

  @doc("Application specific metadata in the form of key-value pairs")
  @visibility("read")
  tags?: Record<string>;
}

@doc("The SAS definition create parameters.")
model SasDefinitionCreateParameters {
  @doc("""
The SAS definition token template signed with an arbitrary key.  Tokens created
according to the SAS definition will have the same properties as the template.
""")
  templateUri: string;

  @doc("The type of SAS token the SAS definition will create.")
  sasType: SasTokenType;

  @doc("The validity period of SAS tokens created according to the SAS definition.")
  validityPeriod: string;

  @doc("The attributes of the SAS definition.")
  @projectedName("json", "attributes")
  sasDefinitionAttributes?: SasDefinitionAttributes;

  @doc("Application specific metadata in the form of key-value pairs.")
  tags?: Record<string>;
}

@doc("The SAS definition update parameters.")
model SasDefinitionUpdateParameters {
  @doc("""
The SAS definition token template signed with an arbitrary key.  Tokens created
according to the SAS definition will have the same properties as the template.
""")
  templateUri?: string;

  @doc("The type of SAS token the SAS definition will create.")
  sasType?: SasTokenType;

  @doc("The validity period of SAS tokens created according to the SAS definition.")
  validityPeriod?: string;

  @doc("The attributes of the SAS definition.")
  @projectedName("json", "attributes")
  sasDefinitionAttributes?: SasDefinitionAttributes;

  @doc("Application specific metadata in the form of key-value pairs.")
  tags?: Record<string>;
}

@doc("The pending certificate signing request result.")
model PendingCertificateSigningRequestResult {
  @doc("The pending certificate signing request as Base64 encoded string.")
  @visibility("read")
  value?: string;
}

@doc("The export key parameters.")
model KeyExportParameters {
  @doc("""
The export key encryption Json web key. This key MUST be a RSA key that
supports encryption.
""")
  wrappingKey?: JsonWebKey;

  @doc("""
The export key encryption key identifier. This key MUST be a RSA key that
supports encryption.
""")
  wrappingKid?: string;

  @doc("The encryption algorithm to use to protected the exported key material")
  enc?: KeyEncryptionAlgorithm;
}

@doc("Role Assignments filter")
model RoleAssignmentFilter {
  @doc("Returns role assignment of the specific principal.")
  principalId?: string;
}

@doc("Role Definitions filter")
model RoleDefinitionFilter {
  @doc("Returns role definition with the specific name.")
  roleName?: string;
}
