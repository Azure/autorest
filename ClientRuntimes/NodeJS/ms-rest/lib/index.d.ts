/**
 * HTTP REST operation response, passed to the client callback. 
 * 
 * @property {object} request       - Raw HTTP request
 * @property {object} response      - Raw HTTP response   
 * @property {T} body               - The deserialized response model object   
 */
export interface HttpOperationResponse<T> {
	request: any
	response: any
	body: T
}

/**
 * REST request options
 *  
 * @property {Object.<string, string>} customHeaders - Any additional HTTP headers to be added to the request
 */
export interface RequestOptions {
	customHeaders?: { [headerName: string]: string; }	
}

/**
 * Service client options, used for all REST requests initiated by the service client.
 * 
 * @property {Array} [filters]                  - Filters to be added to the request pipeline
 * @property {RequestOptions} requestOptions    - Default RequestOptions to use for requests 
 * @property {boolean}  noRetryPolicy           - If set to true, turn off default retry policy
 */
export interface ServiceClientOptions {
	filters?: any[]
	requestOptions?: RequestOptions;
	noRetryPolicy?: boolean;
}
