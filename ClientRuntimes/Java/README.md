[![Build Status](https://travis-ci.org/Azure/autorest-clientruntime-for-java.svg?branch=javavnext)](https://travis-ci.org/Azure/autorest-clientruntime-for-java)

# AutoRest Client Runtimes for Java
The runtime libraries for AutoRest generated Java clients.

## Repository structure

### client-runtime
This is the generic runtime. You will need this for AutoRest generated library using Java code generator.

### azure-client-runtime
This is the runtime with Azure specific customizations. You will need this for AutoRest generated library using Azure.Java code generator.

### azure-client-authentication
This package provides access to Active Directory authentication on JDK using OrgId or application ID / secret combinations. Multi-factor-auth is currently not supported.

### azure-android-client-authentication
This package provides access to Active Directory authentication on Android. You can login with Microsoft accounts, OrgId, with or without multi-factor-auth.

## Build
To build this repository, you will need maven 2.0+ and gradle 1.6+.
Maven is used for [Java SDK](https://github.com/Azure/azure-sdk-for-java) when it's used as a submodule in there. Gradle is used for [AutoRest](https://github.com/Azure/autorest) when it's used as a submodule in there.
