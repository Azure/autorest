import * as msRest from 'ms-rest';

export interface AzureServiceClientOptions extends msRest.ServiceClientOptions {
	// TODO: Make this property have right type
	// 	* @param {Array} [options.longRunningOperationRetryTimeout] - Retry timeout
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

export class AzureEnvironment {
	/**
	* Initializes a new instance of the AzureEnvironment class.
	* @param {string} authenticationEndpoint - ActiveDirectory Endpoint for the Azure Environment.
	* @param {string} tokenAudience - Token audience for an endpoint.
	* @param {bool} [validateAuthority] - Determines whether the authentication endpoint should 
	* be validated with Azure AD. Default value is true.
	*/
	constructor(authenticationEndpoint: string, tokenAudience: string, validateAuthority: boolean);
	
	/**
	 * ActiveDirectory Endpoint for the Azure Environment
	 */
	authenticationEndpoint: string;
	
	/**
	 * Token audience for an endpoint.
	 */
	tokenAudience: string;
	
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

	// TODO: What type should this really have?   How is it used?
	/**
	 * The token cache. Default value is null.
	 */
	tokenCache?: any;
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
	* @param {string} clientRedirectUri The Uri where the user will be redirected after authenticating with AD.
	* @param {AzureTokenCredentialsOptions} options Object representing optional parameters.
	*/
	constructor(clientId: string, domain: string, username: string, password: string, clientRedirectUri: string, options?: AzureTokenCredentialsOptions);
}

// TODO: WHAT SHOULD WE EXPOSE HERE?
export class BaseResource {
}
