import * as msRest from 'ms-rest';

export interface AzureServiceClientOptions extends msRest.ServiceClientOptions {
  // TODO: Make this property have right type
  //  * @param {Array} [options.longRunningOperationRetryTimeout] - Retry timeout
  longRunningOperationRetryTimeout?: any;
}

export class AzureServiceClient extends msRest.ServiceClient {
  /**
  * @class
  * Initializes a new instance of the AzureServiceClient class.
  * @constructor
  * @param {ServiceClientCredentials} credentials - ApplicationTokenCredentials or 
  * UserTokenCredentials object used for authentication.  
  * 
  * @param {object} options - The parameter options used by ServiceClient
  * 
  * @param {string} [options.acceptLanguage] - Gets or sets the preferred language for the response. 
    * Default value is: 'en-US'.
    *  
    * @param {boolean} [options.generateClientRequestId] - When set to true a unique x-ms-client-request-id value 
    * is generated and included in each request. Default is true.
    * 
    * @param {number} [options.longRunningOperationRetryTimeout] - Gets or sets the retry timeout in seconds for 
    * Long Running Operations. Default value is 30.
  */
  constructor(credentials: msRest.ServiceClientCredentials, options: AzureServiceClientOptions)
}

export interface CloudError extends Error {
  code: string,
  message: string,
  target?: string,
  details?: Array<CloudError>
}

export class AzureEnvironment {
  /**
  * Initializes a new instance of the AzureEnvironment class.
  * @param {string} parameters.name - The Environment name
  * @param {string} parameters.portalUrl - The management portal URL
  * @param {string} parameters.managementEndpointUrl - The management service endpoint
  * @param {string} parameters.resourceManagerEndpointUrl - The resource management endpoint
  * @param {string} parameters.activeDirectoryEndpointUrl - The Active Directory login endpoint
  * @param {string} parameters.activeDirectoryResourceId - The resource ID to obtain AD tokens for (token audience)
  * @param {string} [parameters.publishingProfileUrl] - The publish settings file URL
  * @param {string} [parameters.sqlManagementEndpointUrl] - The sql server management endpoint for mobile commands
  * @param {string} [parameters.sqlServerHostnameSuffix] - The dns suffix for sql servers
  * @param {string} [parameters.galleryEndpointUrl] - The template gallery endpoint
  * @param {string} [parameters.activeDirectoryGraphResourceId] - The Active Directory resource ID
  * @param {string} [parameters.activeDirectoryGraphApiVersion] - The Active Directory api version
  * @param {string} [parameters.storageEndpointSuffix] - The endpoint suffix for storage accounts
  * @param {string} [parameters.keyVaultDnsSuffix] - The keyvault service dns suffix
  * @param {string} [parameters.azureDataLakeStoreFileSystemEndpointSuffix] - The data lake store filesystem service dns suffix
  * @param {string} [parameters.azureDataLakeAnalyticsCatalogAndJobEndpointSuffix] - The data lake analytics job and catalog service dns suffix
  * @param {bool} [parameters.validateAuthority] - Determines whether the authentication endpoint should 
  * be validated with Azure AD. Default value is true.
  */
  constructor(parameters: any);
  
  /**
   * The Environment name.
   */
  name: string;
  
  /**
   * The management portal URL.
   */
  portalUrl: string;
  
  /**
   * The management service endpoint.
   */
  managementEndpointUrl: string;

  /**
   * The resource management endpoint.
   */
  resourceManagerEndpointUrl: string;

  /**
   * The Active Directory login endpoint.
   */
  activeDirectoryEndpointUrl: string;

  /**
   * The resource ID to obtain AD tokens for (token audience).
   */
  activeDirectoryResourceId: string;
  
  /**
   * The publish settings file URL.
   */
  publishingProfileUrl: string;

  /**
   * The sql server management endpoint for mobile commands.
   */
  sqlManagementEndpointUrl: string;

  /**
   * The dns suffix for sql servers.
   */
  sqlServerHostnameSuffix: string;

  /**
   * The template gallery endpoint.
   */
  galleryEndpointUrl: string;

  /**
   * The Active Directory resource ID.
   */
  activeDirectoryGraphResourceId: string;
  
  /**
   * The Active Directory api version.
   */
  activeDirectoryGraphApiVersion: string;
  
  /**
   * The endpoint suffix for storage accounts.
   */
  storageEndpointSuffix: string;
  
  /**
   * The keyvault service dns suffix.
   */
  keyVaultDnsSuffix: string;
  
  /**
   * The data lake store filesystem service dns suffix.
   */
  azureDataLakeStoreFileSystemEndpointSuffix: string;

  /**
   * The data lake analytics job and catalog service dns suffix.
   */
  azureDataLakeAnalyticsCatalogAndJobEndpointSuffix: string;

  /**
   * Determines whether the authentication endpoint should be validated with Azure AD. Default value is true.
   */
  validateAuthority: boolean;
}


export interface AzureTokenCredentialsOptions {
  /**
   * The Azure environment to authenticate with.
   */
  environment?: AzureEnvironment;
  
  /**
   * The authorization scheme. Default value is 'Bearer'.
   */
  authorizationScheme?: string;

  /**
   * The token cache. Default value is MemoryCache from adal.
   */
  tokenCache?: any;
  /**
   * The audience for which the token is requested. Valid value is 'graph'. If tokenAudience is provided
   * then domain should also be provided and its value should not be the default 'common' tenant.
   * It must be a string (preferrably in a guid format).
   */
  tokenAudience?: string;
}

export interface LoginWithUsernamePasswordOptions extends AzureTokenCredentialsOptions {
  /**
   * The domain or tenant id containing this application. Default value is 'common'.
   */
  domain?: string;

  /** 
   * The active directory application client id. 
   * See {@link https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/ Active Directory Quickstart for .Net} 
   * for an example.
   */
  clientId?: string
}

export interface DeviceTokenCredentialsOptions extends LoginWithUsernamePasswordOptions {
  /**
   * The user name for account in the form: 'user@example.com'. Default value is 'user@example.com'.
   */
  username?: string;
}

export interface InteractiveLoginOptions extends DeviceTokenCredentialsOptions {
  /**
   * The language code specifying how the message should be localized to. Default value 'en-us'.
   */
  language?: string; 
}

export class ApplicationTokenCredentials extends msRest.ServiceClientCredentials {
  /**
  * Creates a new ApplicationTokenCredentials object.
  * See {@link https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/ Active Directory Quickstart for .Net} 
  * for detailed instructions on creating an Azure Active Directory application.
  * @param {string} clientId The active directory application client id. 
  * @param {string} domain The domain or tenant id containing this application.
  * @param {string} secret The authentication secret for the application.
  * @param {AzureTokenCredentialsOptions} options Object representing optional parameters.
  */
  constructor(clientId: string, domain: string, secret: string, options?: AzureTokenCredentialsOptions);
}

export class UserTokenCredentials extends msRest.ServiceClientCredentials {
  /**
  * Creates a new UserTokenCredentials object.
  * See {@link https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/ Active Directory Quickstart for .Net} 
  * for an example.
  * @param {string} clientId The active directory application client id. 
  * @param {string} domain The domain or tenant id containing this application.
  * @param {string} username The user name for the Organization Id account.
  * @param {string} password The password for the Organization Id account.
  * @param {AzureTokenCredentialsOptions} options Object representing optional parameters.
  */
  constructor(clientId: string, domain: string, username: string, password: string, options?: AzureTokenCredentialsOptions);
}

export class DeviceTokenCredentials extends msRest.ServiceClientCredentials {
  /**
  * Creates a new DeviceTokenCredentials object.
  * @param {DeviceTokenCredentialsOptions} options Object representing optional parameters.
  */
  constructor(options?: DeviceTokenCredentialsOptions);
}

export class BaseResource {
}

/**
 * Provides a url and code that needs to be copy and pasted in a browser and authenticated over there. If successful, the user will get a 
 * DeviceTokenCredentials object
 *
 * @param {InteractiveLoginOptions} [options] The parameter options.
 *
 * @param {function} callback
 *
 * @returns {function} callback(err, credentials)
 *
 *                      {Error}  [err]                           - The Error object if an error occurred, null otherwise.
 *
 *                      {DeviceTokenCredentials} [credentials]   - The DeviceTokenCredentials object
 */
export function interactiveLogin(options: InteractiveLoginOptions, callback: { (err: Error, credentials: DeviceTokenCredentials): void }): void;

/**
 * Provides a UserTokenCredentials object. This method is applicable only for organizational ids that are not 2FA enabled.
 * Otherwise please use interactive login.
 *
 * @param {string} username The user name for the Organization Id account.
 *
 * @param {string} password The password for the Organization Id account.
 *
 * @param {LoginWithUsernamePasswordOptions} [options] The parameter options.
 *
 * @param {function} callback
 *
 * @returns {function} callback(err, credentials)
 *
 *                      {Error}  [err]                         - The Error object if an error occurred, null otherwise.
 *
 *                      {UserTokenCredentials} [credentials]   - The UserTokenCredentials object
 */
export function loginWithUsernamePassword(username: string, password: string, options: LoginWithUsernamePasswordOptions, callback: { (err: Error, credentials: UserTokenCredentials): void }): void;


/**
 * Provides an ApplicationTokenCredentials object.
 *
 * @param {string} clientId The active directory application client id also known as the SPN (ServicePrincipal Name). 
 * See {@link https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/ Active Directory Quickstart for .Net} 
 * for an example.
 *
 * @param {string} secret The application secret for the service principal.
 *
 * @param {string} domain The domain or tenant id containing this application.
 *
 * @param {AzureTokenCredentialsOptions} [options] The parameter options.
 *
 * @param {function} callback
 *
 * @returns {function} callback(err, credentials)
 *
 *                      {Error}  [err]                                - The Error object if an error occurred, null otherwise.
 *
 *                      {ApplicationTokenCredentials} [credentials]   - The ApplicationTokenCredentials object
 */
export function loginWithServicePrincipalSecret(clientId: string, secret: string, domain: string, options: AzureTokenCredentialsOptions, callback: { (err: Error, credentials: ApplicationTokenCredentials): void }): void;