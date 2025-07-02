import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";


using Azure.ClientGenerator.Core;
using Azure.Keyvault;



@@clientName(Error.`innererror`, "innerError")


@@clientName(CertificateItem.`x5t`, "x509Thumbprint")


@@clientName(Attributes.`nbf`, "notBefore")
@@clientName(Attributes.`exp`, "expires")


@@clientName(CertificateBundle.`x5t`, "x509Thumbprint")


@@clientName(CertificatePolicy.`key_props`, "keyProperties")
@@clientName(CertificatePolicy.`secret_props`, "secretProperties")
@@clientName(CertificatePolicy.`x509_props`, "x509CertificateProperties")
@@clientName(CertificatePolicy.`lifetime_actions`, "lifetimeActions")
@@clientName(CertificatePolicy.`issuer`, "issuerParameters")


@@clientName(KeyProperties.`kty`, "keyType")
@@clientName(KeyProperties.`key_size`, "keySize")
@@clientName(KeyProperties.`reuse_key`, "reuseKey")
@@clientName(KeyProperties.`crv`, "curve")


@@clientName(X509CertificateProperties.`sans`, "subjectAlternativeNames")
@@clientName(X509CertificateProperties.`key_usage`, "keyUsage")
@@clientName(X509CertificateProperties.`validity_months`, "validityInMonths")


@@clientName(SubjectAlternativeNames.`dns_names`, "dnsNames")


@@clientName(Trigger.`lifetime_percentage`, "lifetimePercentage")
@@clientName(Trigger.`days_before_expiry`, "daysBeforeExpiry")


@@clientName(Action.`action_type`, "actionType")


@@clientName(IssuerParameters.`cty`, "certificateType")
@@clientName(IssuerParameters.`cert_transparency`, "certificateTransparency")


@@clientName(Contacts.`contacts`, "contactList")


@@clientName(Contact.`email`, "emailAddress")


@@clientName(CertificateIssuerSetParameters.`org_details`, "organizationDetails")


@@clientName(IssuerCredentials.`account_id`, "accountId")
@@clientName(IssuerCredentials.`pwd`, "password")


@@clientName(OrganizationDetails.`admin_details`, "adminDetails")


@@clientName(AdministratorDetails.`first_name`, "firstName")
@@clientName(AdministratorDetails.`last_name`, "lastName")
@@clientName(AdministratorDetails.`email`, "emailAddress")


@@clientName(IssuerBundle.`org_details`, "organizationDetails")


@@clientName(CertificateIssuerUpdateParameters.`org_details`, "organizationDetails")


@@clientName(CertificateCreateParameters.`policy`, "certificatePolicy")
@@clientName(CertificateCreateParameters.`attributes`, "certificateAttributes")


@@clientName(CertificateOperation.`issuer`, "issuerParameters")
@@clientName(CertificateOperation.`cancellation_requested`, "cancellationRequested")
@@clientName(CertificateOperation.`status_details`, "statusDetails")
@@clientName(CertificateOperation.`request_id`, "requestId")


@@clientName(CertificateImportParameters.`value`, "base64EncodedCertificate")
@@clientName(CertificateImportParameters.`pwd`, "password")
@@clientName(CertificateImportParameters.`policy`, "certificatePolicy")
@@clientName(CertificateImportParameters.`attributes`, "certificateAttributes")


@@clientName(CertificateUpdateParameters.`policy`, "certificatePolicy")
@@clientName(CertificateUpdateParameters.`attributes`, "certificateAttributes")


@@clientName(CertificateOperationUpdateParameter.`cancellation_requested`, "cancellationRequested")


@@clientName(CertificateMergeParameters.`x5c`, "x509Certificates")
@@clientName(CertificateMergeParameters.`attributes`, "certificateAttributes")


@@clientName(CertificateRestoreParameters.`value`, "certificateBundleBackup")


@@clientName(KeyCreateParameters.`key_size`, "keySize")
@@clientName(KeyCreateParameters.`public_exponent`, "publicExponent")
@@clientName(KeyCreateParameters.`key_ops`, "keyOps")
@@clientName(KeyCreateParameters.`attributes`, "keyAttributes")
@@clientName(KeyCreateParameters.`crv`, "curve")
@@clientName(KeyCreateParameters.`release_policy`, "releasePolicy")


@@clientName(KeyReleasePolicy.`data`, "encodedPolicy")


@@clientName(KeyBundle.`release_policy`, "releasePolicy")


@@clientName(JsonWebKey.`key_ops`, "keyOps")
@@clientName(JsonWebKey.`dp`, "DP")
@@clientName(JsonWebKey.`dq`, "DQ")
@@clientName(JsonWebKey.`qi`, "QI")
@@clientName(JsonWebKey.`key_hsm`, "t")


@@clientName(KeyImportParameters.`Hsm`, "hsm")
@@clientName(KeyImportParameters.`attributes`, "keyAttributes")
@@clientName(KeyImportParameters.`release_policy`, "releasePolicy")


@@clientName(KeyUpdateParameters.`key_ops`, "keyOps")
@@clientName(KeyUpdateParameters.`attributes`, "keyAttributes")
@@clientName(KeyUpdateParameters.`release_policy`, "releasePolicy")


@@clientName(KeyRestoreParameters.`value`, "keyBundleBackup")


@@clientName(KeyOperationsParameters.`alg`, "algorithm")


@@clientName(KeyOperationResult.`value`, "result")
@@clientName(KeyOperationResult.`tag`, "authenticationTag")
@@clientName(KeyOperationResult.`aad`, "additionalAuthenticatedData")


@@clientName(KeySignParameters.`alg`, "algorithm")


@@clientName(KeyVerifyParameters.`alg`, "algorithm")
@@clientName(KeyVerifyParameters.`value`, "signature")


@@clientName(KeyReleaseParameters.`target`, "targetAttestationToken")


@@clientName(RoleDefinitionProperties.`type`, "roleType")


@@clientName(SecretSetParameters.`attributes`, "secretAttributes")


@@clientName(SecretUpdateParameters.`attributes`, "secretAttributes")


@@clientName(SecretRestoreParameters.`value`, "secretBundleBackup")


@@clientName(SecurityDomainOperationStatus.`status_details`, "statusDetails")


@@clientName(SecurityDomainJsonWebKey.`key_ops`, "keyOps")
@@clientName(SecurityDomainJsonWebKey.`x5c`, "x5C")
@@clientName(SecurityDomainJsonWebKey.`x5t`, "x5T")
@@clientName(SecurityDomainJsonWebKey.`x5t#S256`, "x5TS256")


@@clientName(TransferKey.`key_format`, "keyFormat")
@@clientName(TransferKey.`transfer_key`, "transferKey")


@@clientName(StorageRestoreParameters.`value`, "storageBundleBackup")


@@clientName(StorageAccountCreateParameters.`attributes`, "storageAccountAttributes")


@@clientName(StorageAccountUpdateParameters.`attributes`, "storageAccountAttributes")


@@clientName(SasDefinitionItem.`sid`, "secretId")


@@clientName(SasDefinitionBundle.`sid`, "secretId")


@@clientName(SasDefinitionCreateParameters.`attributes`, "sasDefinitionAttributes")


@@clientName(SasDefinitionUpdateParameters.`attributes`, "sasDefinitionAttributes")






@@clientName(.encrypt, "encrypt")
@@clientName(.decrypt, "decrypt")
@@clientName(.sign, "sign")
@@clientName(.verify, "verify")
@@clientName(.wrapKey, "wrapKey")
@@clientName(.unwrapKey, "unwrapKey")
@@clientName(.release, "release")


@@clientLocation(RoleDefinitionsOperationGroup.delete, "RoleDefinitions")
@@clientLocation(RoleDefinitionsOperationGroup.createOrUpdate, "RoleDefinitions")
@@clientLocation(RoleDefinitionsOperationGroup.get, "RoleDefinitions")
@@clientLocation(RoleDefinitionsOperationGroup.list, "RoleDefinitions")


@@clientLocation(RoleAssignmentsOperationGroup.delete, "RoleAssignments")
@@clientLocation(RoleAssignmentsOperationGroup.create, "RoleAssignments")
@@clientLocation(RoleAssignmentsOperationGroup.get, "RoleAssignments")
@@clientLocation(RoleAssignmentsOperationGroup.listForScope, "RoleAssignments")


@@clientLocation(HSMSecurityDomainOperationGroup.downloadPending, "HSMSecurityDomain")
@@clientLocation(HSMSecurityDomainOperationGroup.download, "HSMSecurityDomain")
@@clientLocation(HSMSecurityDomainOperationGroup.transferKey, "HSMSecurityDomain")
@@clientLocation(HSMSecurityDomainOperationGroup.upload, "HSMSecurityDomain")
@@clientLocation(HSMSecurityDomainOperationGroup.uploadPending, "HSMSecurityDomain")


