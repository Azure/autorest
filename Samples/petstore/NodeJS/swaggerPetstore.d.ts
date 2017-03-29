/*
 */

import { ServiceClientOptions, RequestOptions, ServiceCallback, HttpOperationResponse } from 'ms-rest';
import * as models from "./models";

declare class SwaggerPetstore {
  /**
   * @class
   * Initializes a new instance of the SwaggerPetstore class.
   * @constructor
   *
   * @param {string} [baseUri] - The base URI of the service.
   *
   * @param {object} [options] - The parameter options
   *
   * @param {Array} [options.filters] - Filters to be added to the request pipeline
   *
   * @param {object} [options.requestOptions] - Options for the underlying request object
   * {@link https://github.com/request/request#requestoptions-callback Options doc}
   *
   * @param {boolean} [options.noRetryPolicy] - If set to true, turn off default retry policy
   *
   */
  constructor(baseUri?: string, options?: ServiceClientOptions);


  /**
   * @summary Fake endpoint to test byte array in body parameter for adding a new
   * pet to the store
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {string} [options.body] Pet object in the form of byte array
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @returns {Promise} A promise is returned
   *
   * @resolve {HttpOperationResponse<null>} - The deserialized result object.
   *
   * @reject {Error|ServiceError} - The error object.
   */
  addPetUsingByteArrayWithHttpOperationResponse(options?: { body? : string, customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<void>>;

  /**
   * @summary Fake endpoint to test byte array in body parameter for adding a new
   * pet to the store
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {string} [options.body] Pet object in the form of byte array
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @param {ServiceCallback} [optionalCallback] - The optional callback.
   *
   * @returns {ServiceCallback|Promise} If a callback was passed as the last
   * parameter then it returns the callback else returns a Promise.
   *
   * {Promise} A promise is returned.
   *
   *                      @resolve {null} - The deserialized result object.
   *
   *                      @reject {Error|ServiceError} - The error object.
   *
   * {ServiceCallback} optionalCallback(err, result, request, response)
   *
   *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
   *
   *                      {null} [result]   - The deserialized result object if an error did not occur.
   *
   *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
   *
   *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
   */
  addPetUsingByteArray(options?: { body? : string, customHeaders? : { [headerName: string]: string; } }): Promise<void>;
  addPetUsingByteArray(callback: ServiceCallback<void>): void;
  addPetUsingByteArray(options: { body? : string, customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;


  /**
   * @summary Add a new pet to the store
   *
   * Adds a new pet to the store. You may receive an HTTP invalid input if your
   * pet is invalid.
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.body] Pet object that needs to be added to the
   * store
   *
   * @param {number} [options.body.id] The id of the pet. A more detailed
   * description of the id of the pet.
   *
   * @param {object} [options.body.category]
   *
   * @param {number} [options.body.category.id]
   *
   * @param {string} [options.body.category.name]
   *
   * @param {string} options.body.name
   *
   * @param {array} options.body.photoUrls
   *
   * @param {array} [options.body.tags]
   *
   * @param {string} [options.body.status] pet status in the store. Possible
   * values include: 'available', 'pending', 'sold'
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @returns {Promise} A promise is returned
   *
   * @resolve {HttpOperationResponse<null>} - The deserialized result object.
   *
   * @reject {Error|ServiceError} - The error object.
   */
  addPetWithHttpOperationResponse(options?: { body? : models.Pet, customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<void>>;

  /**
   * @summary Add a new pet to the store
   *
   * Adds a new pet to the store. You may receive an HTTP invalid input if your
   * pet is invalid.
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.body] Pet object that needs to be added to the
   * store
   *
   * @param {number} [options.body.id] The id of the pet. A more detailed
   * description of the id of the pet.
   *
   * @param {object} [options.body.category]
   *
   * @param {number} [options.body.category.id]
   *
   * @param {string} [options.body.category.name]
   *
   * @param {string} options.body.name
   *
   * @param {array} options.body.photoUrls
   *
   * @param {array} [options.body.tags]
   *
   * @param {string} [options.body.status] pet status in the store. Possible
   * values include: 'available', 'pending', 'sold'
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @param {ServiceCallback} [optionalCallback] - The optional callback.
   *
   * @returns {ServiceCallback|Promise} If a callback was passed as the last
   * parameter then it returns the callback else returns a Promise.
   *
   * {Promise} A promise is returned.
   *
   *                      @resolve {null} - The deserialized result object.
   *
   *                      @reject {Error|ServiceError} - The error object.
   *
   * {ServiceCallback} optionalCallback(err, result, request, response)
   *
   *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
   *
   *                      {null} [result]   - The deserialized result object if an error did not occur.
   *
   *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
   *
   *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
   */
  addPet(options?: { body? : models.Pet, customHeaders? : { [headerName: string]: string; } }): Promise<void>;
  addPet(callback: ServiceCallback<void>): void;
  addPet(options: { body? : models.Pet, customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;


  /**
   * @summary Update an existing pet
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.body] Pet object that needs to be added to the
   * store
   *
   * @param {number} [options.body.id] The id of the pet. A more detailed
   * description of the id of the pet.
   *
   * @param {object} [options.body.category]
   *
   * @param {number} [options.body.category.id]
   *
   * @param {string} [options.body.category.name]
   *
   * @param {string} options.body.name
   *
   * @param {array} options.body.photoUrls
   *
   * @param {array} [options.body.tags]
   *
   * @param {string} [options.body.status] pet status in the store. Possible
   * values include: 'available', 'pending', 'sold'
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @returns {Promise} A promise is returned
   *
   * @resolve {HttpOperationResponse<null>} - The deserialized result object.
   *
   * @reject {Error|ServiceError} - The error object.
   */
  updatePetWithHttpOperationResponse(options?: { body? : models.Pet, customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<void>>;

  /**
   * @summary Update an existing pet
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.body] Pet object that needs to be added to the
   * store
   *
   * @param {number} [options.body.id] The id of the pet. A more detailed
   * description of the id of the pet.
   *
   * @param {object} [options.body.category]
   *
   * @param {number} [options.body.category.id]
   *
   * @param {string} [options.body.category.name]
   *
   * @param {string} options.body.name
   *
   * @param {array} options.body.photoUrls
   *
   * @param {array} [options.body.tags]
   *
   * @param {string} [options.body.status] pet status in the store. Possible
   * values include: 'available', 'pending', 'sold'
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @param {ServiceCallback} [optionalCallback] - The optional callback.
   *
   * @returns {ServiceCallback|Promise} If a callback was passed as the last
   * parameter then it returns the callback else returns a Promise.
   *
   * {Promise} A promise is returned.
   *
   *                      @resolve {null} - The deserialized result object.
   *
   *                      @reject {Error|ServiceError} - The error object.
   *
   * {ServiceCallback} optionalCallback(err, result, request, response)
   *
   *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
   *
   *                      {null} [result]   - The deserialized result object if an error did not occur.
   *
   *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
   *
   *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
   */
  updatePet(options?: { body? : models.Pet, customHeaders? : { [headerName: string]: string; } }): Promise<void>;
  updatePet(callback: ServiceCallback<void>): void;
  updatePet(options: { body? : models.Pet, customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;


  /**
   * @summary Finds Pets by status
   *
   * Multiple status values can be provided with comma seperated strings
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {array} [options.status] Status values that need to be considered for
   * filter
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @returns {Promise} A promise is returned
   *
   * @resolve {HttpOperationResponse<Array>} - The deserialized result object.
   *
   * @reject {Error|ServiceError} - The error object.
   */
  findPetsByStatusWithHttpOperationResponse(options?: { status? : string[], customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<models.Pet[]>>;

  /**
   * @summary Finds Pets by status
   *
   * Multiple status values can be provided with comma seperated strings
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {array} [options.status] Status values that need to be considered for
   * filter
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @param {ServiceCallback} [optionalCallback] - The optional callback.
   *
   * @returns {ServiceCallback|Promise} If a callback was passed as the last
   * parameter then it returns the callback else returns a Promise.
   *
   * {Promise} A promise is returned.
   *
   *                      @resolve {Array} - The deserialized result object.
   *
   *                      @reject {Error|ServiceError} - The error object.
   *
   * {ServiceCallback} optionalCallback(err, result, request, response)
   *
   *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
   *
   *                      {Array} [result]   - The deserialized result object if an error did not occur.
   *
   *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
   *
   *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
   */
  findPetsByStatus(options?: { status? : string[], customHeaders? : { [headerName: string]: string; } }): Promise<models.Pet[]>;
  findPetsByStatus(callback: ServiceCallback<models.Pet[]>): void;
  findPetsByStatus(options: { status? : string[], customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<models.Pet[]>): void;


  /**
   * @summary Finds Pets by tags
   *
   * Muliple tags can be provided with comma seperated strings. Use tag1, tag2,
   * tag3 for testing.
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {array} [options.tags] Tags to filter by
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @returns {Promise} A promise is returned
   *
   * @resolve {HttpOperationResponse<Array>} - The deserialized result object.
   *
   * @reject {Error|ServiceError} - The error object.
   */
  findPetsByTagsWithHttpOperationResponse(options?: { tags? : string[], customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<models.Pet[]>>;

  /**
   * @summary Finds Pets by tags
   *
   * Muliple tags can be provided with comma seperated strings. Use tag1, tag2,
   * tag3 for testing.
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {array} [options.tags] Tags to filter by
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @param {ServiceCallback} [optionalCallback] - The optional callback.
   *
   * @returns {ServiceCallback|Promise} If a callback was passed as the last
   * parameter then it returns the callback else returns a Promise.
   *
   * {Promise} A promise is returned.
   *
   *                      @resolve {Array} - The deserialized result object.
   *
   *                      @reject {Error|ServiceError} - The error object.
   *
   * {ServiceCallback} optionalCallback(err, result, request, response)
   *
   *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
   *
   *                      {Array} [result]   - The deserialized result object if an error did not occur.
   *
   *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
   *
   *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
   */
  findPetsByTags(options?: { tags? : string[], customHeaders? : { [headerName: string]: string; } }): Promise<models.Pet[]>;
  findPetsByTags(callback: ServiceCallback<models.Pet[]>): void;
  findPetsByTags(options: { tags? : string[], customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<models.Pet[]>): void;


  /**
   * @summary Fake endpoint to test byte array return by 'Find pet by ID'
   *
   * Returns a pet when ID < 10.  ID > 10 or nonintegers will simulate API error
   * conditions
   *
   * @param {number} petId ID of pet that needs to be fetched
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @returns {Promise} A promise is returned
   *
   * @resolve {HttpOperationResponse<String>} - The deserialized result object.
   *
   * @reject {Error|ServiceError} - The error object.
   */
  findPetsWithByteArrayWithHttpOperationResponse(petId: number, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<string>>;

  /**
   * @summary Fake endpoint to test byte array return by 'Find pet by ID'
   *
   * Returns a pet when ID < 10.  ID > 10 or nonintegers will simulate API error
   * conditions
   *
   * @param {number} petId ID of pet that needs to be fetched
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @param {ServiceCallback} [optionalCallback] - The optional callback.
   *
   * @returns {ServiceCallback|Promise} If a callback was passed as the last
   * parameter then it returns the callback else returns a Promise.
   *
   * {Promise} A promise is returned.
   *
   *                      @resolve {String} - The deserialized result object.
   *
   *                      @reject {Error|ServiceError} - The error object.
   *
   * {ServiceCallback} optionalCallback(err, result, request, response)
   *
   *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
   *
   *                      {String} [result]   - The deserialized result object if an error did not occur.
   *
   *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
   *
   *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
   */
  findPetsWithByteArray(petId: number, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<string>;
  findPetsWithByteArray(petId: number, callback: ServiceCallback<string>): void;
  findPetsWithByteArray(petId: number, options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<string>): void;


  /**
   * @summary Find pet by ID
   *
   * Returns a pet when ID < 10.  ID > 10 or nonintegers will simulate API error
   * conditions
   *
   * @param {number} petId ID of pet that needs to be fetched
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @returns {Promise} A promise is returned
   *
   * @resolve {HttpOperationResponse<Pet>} - The deserialized result object.
   *
   * @reject {Error|ServiceError} - The error object.
   */
  getPetByIdWithHttpOperationResponse(petId: number, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<models.Pet>>;

  /**
   * @summary Find pet by ID
   *
   * Returns a pet when ID < 10.  ID > 10 or nonintegers will simulate API error
   * conditions
   *
   * @param {number} petId ID of pet that needs to be fetched
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @param {ServiceCallback} [optionalCallback] - The optional callback.
   *
   * @returns {ServiceCallback|Promise} If a callback was passed as the last
   * parameter then it returns the callback else returns a Promise.
   *
   * {Promise} A promise is returned.
   *
   *                      @resolve {Pet} - The deserialized result object.
   *
   *                      @reject {Error|ServiceError} - The error object.
   *
   * {ServiceCallback} optionalCallback(err, result, request, response)
   *
   *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
   *
   *                      {Pet} [result]   - The deserialized result object if an error did not occur.
   *                      See {@link Pet} for more information.
   *
   *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
   *
   *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
   */
  getPetById(petId: number, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<models.Pet>;
  getPetById(petId: number, callback: ServiceCallback<models.Pet>): void;
  getPetById(petId: number, options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<models.Pet>): void;


  /**
   * @summary Updates a pet in the store with form data
   *
   * @param {string} petId ID of pet that needs to be updated
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {string} [options.name] Updated name of the pet
   *
   * @param {string} [options.status] Updated status of the pet
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @returns {Promise} A promise is returned
   *
   * @resolve {HttpOperationResponse<null>} - The deserialized result object.
   *
   * @reject {Error|ServiceError} - The error object.
   */
  updatePetWithFormWithHttpOperationResponse(petId: string, options?: { name? : string, status? : string, customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<void>>;

  /**
   * @summary Updates a pet in the store with form data
   *
   * @param {string} petId ID of pet that needs to be updated
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {string} [options.name] Updated name of the pet
   *
   * @param {string} [options.status] Updated status of the pet
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @param {ServiceCallback} [optionalCallback] - The optional callback.
   *
   * @returns {ServiceCallback|Promise} If a callback was passed as the last
   * parameter then it returns the callback else returns a Promise.
   *
   * {Promise} A promise is returned.
   *
   *                      @resolve {null} - The deserialized result object.
   *
   *                      @reject {Error|ServiceError} - The error object.
   *
   * {ServiceCallback} optionalCallback(err, result, request, response)
   *
   *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
   *
   *                      {null} [result]   - The deserialized result object if an error did not occur.
   *
   *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
   *
   *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
   */
  updatePetWithForm(petId: string, options?: { name? : string, status? : string, customHeaders? : { [headerName: string]: string; } }): Promise<void>;
  updatePetWithForm(petId: string, callback: ServiceCallback<void>): void;
  updatePetWithForm(petId: string, options: { name? : string, status? : string, customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;


  /**
   * @summary Deletes a pet
   *
   * @param {number} petId Pet id to delete
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {string} [options.apiKey]
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @returns {Promise} A promise is returned
   *
   * @resolve {HttpOperationResponse<null>} - The deserialized result object.
   *
   * @reject {Error|ServiceError} - The error object.
   */
  deletePetWithHttpOperationResponse(petId: number, options?: { apiKey? : string, customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<void>>;

  /**
   * @summary Deletes a pet
   *
   * @param {number} petId Pet id to delete
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {string} [options.apiKey]
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @param {ServiceCallback} [optionalCallback] - The optional callback.
   *
   * @returns {ServiceCallback|Promise} If a callback was passed as the last
   * parameter then it returns the callback else returns a Promise.
   *
   * {Promise} A promise is returned.
   *
   *                      @resolve {null} - The deserialized result object.
   *
   *                      @reject {Error|ServiceError} - The error object.
   *
   * {ServiceCallback} optionalCallback(err, result, request, response)
   *
   *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
   *
   *                      {null} [result]   - The deserialized result object if an error did not occur.
   *
   *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
   *
   *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
   */
  deletePet(petId: number, options?: { apiKey? : string, customHeaders? : { [headerName: string]: string; } }): Promise<void>;
  deletePet(petId: number, callback: ServiceCallback<void>): void;
  deletePet(petId: number, options: { apiKey? : string, customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;


  /**
   * @summary uploads an image
   *
   * @param {number} petId ID of pet to update
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {string} [options.additionalMetadata] Additional data to pass to
   * server
   *
   * @param {object} [options.file] file to upload
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @returns {Promise} A promise is returned
   *
   * @resolve {HttpOperationResponse<null>} - The deserialized result object.
   *
   * @reject {Error|ServiceError} - The error object.
   */
  uploadFileWithHttpOperationResponse(petId: number, options?: { additionalMetadata? : string, file? : stream.Readable, customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<void>>;

  /**
   * @summary uploads an image
   *
   * @param {number} petId ID of pet to update
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {string} [options.additionalMetadata] Additional data to pass to
   * server
   *
   * @param {object} [options.file] file to upload
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @param {ServiceCallback} [optionalCallback] - The optional callback.
   *
   * @returns {ServiceCallback|Promise} If a callback was passed as the last
   * parameter then it returns the callback else returns a Promise.
   *
   * {Promise} A promise is returned.
   *
   *                      @resolve {null} - The deserialized result object.
   *
   *                      @reject {Error|ServiceError} - The error object.
   *
   * {ServiceCallback} optionalCallback(err, result, request, response)
   *
   *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
   *
   *                      {null} [result]   - The deserialized result object if an error did not occur.
   *
   *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
   *
   *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
   */
  uploadFile(petId: number, options?: { additionalMetadata? : string, file? : stream.Readable, customHeaders? : { [headerName: string]: string; } }): Promise<void>;
  uploadFile(petId: number, callback: ServiceCallback<void>): void;
  uploadFile(petId: number, options: { additionalMetadata? : string, file? : stream.Readable, customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;


  /**
   * @summary Returns pet inventories by status
   *
   * Returns a map of status codes to quantities
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @returns {Promise} A promise is returned
   *
   * @resolve {HttpOperationResponse<Object>} - The deserialized result object.
   *
   * @reject {Error|ServiceError} - The error object.
   */
  getInventoryWithHttpOperationResponse(options?: { customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<{ [propertyName: string]: number }>>;

  /**
   * @summary Returns pet inventories by status
   *
   * Returns a map of status codes to quantities
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @param {ServiceCallback} [optionalCallback] - The optional callback.
   *
   * @returns {ServiceCallback|Promise} If a callback was passed as the last
   * parameter then it returns the callback else returns a Promise.
   *
   * {Promise} A promise is returned.
   *
   *                      @resolve {Object} - The deserialized result object.
   *
   *                      @reject {Error|ServiceError} - The error object.
   *
   * {ServiceCallback} optionalCallback(err, result, request, response)
   *
   *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
   *
   *                      {Object} [result]   - The deserialized result object if an error did not occur.
   *
   *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
   *
   *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
   */
  getInventory(options?: { customHeaders? : { [headerName: string]: string; } }): Promise<{ [propertyName: string]: number }>;
  getInventory(callback: ServiceCallback<{ [propertyName: string]: number }>): void;
  getInventory(options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<{ [propertyName: string]: number }>): void;


  /**
   * @summary Place an order for a pet
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.body] order placed for purchasing the pet
   *
   * @param {number} [options.body.petId]
   *
   * @param {number} [options.body.quantity]
   *
   * @param {date} [options.body.shipDate]
   *
   * @param {string} [options.body.status] Order Status. Possible values include:
   * 'placed', 'approved', 'delivered'
   *
   * @param {boolean} [options.body.complete]
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @returns {Promise} A promise is returned
   *
   * @resolve {HttpOperationResponse<Order>} - The deserialized result object.
   *
   * @reject {Error|ServiceError} - The error object.
   */
  placeOrderWithHttpOperationResponse(options?: { body? : models.Order, customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<models.Order>>;

  /**
   * @summary Place an order for a pet
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.body] order placed for purchasing the pet
   *
   * @param {number} [options.body.petId]
   *
   * @param {number} [options.body.quantity]
   *
   * @param {date} [options.body.shipDate]
   *
   * @param {string} [options.body.status] Order Status. Possible values include:
   * 'placed', 'approved', 'delivered'
   *
   * @param {boolean} [options.body.complete]
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @param {ServiceCallback} [optionalCallback] - The optional callback.
   *
   * @returns {ServiceCallback|Promise} If a callback was passed as the last
   * parameter then it returns the callback else returns a Promise.
   *
   * {Promise} A promise is returned.
   *
   *                      @resolve {Order} - The deserialized result object.
   *
   *                      @reject {Error|ServiceError} - The error object.
   *
   * {ServiceCallback} optionalCallback(err, result, request, response)
   *
   *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
   *
   *                      {Order} [result]   - The deserialized result object if an error did not occur.
   *                      See {@link Order} for more information.
   *
   *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
   *
   *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
   */
  placeOrder(options?: { body? : models.Order, customHeaders? : { [headerName: string]: string; } }): Promise<models.Order>;
  placeOrder(callback: ServiceCallback<models.Order>): void;
  placeOrder(options: { body? : models.Order, customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<models.Order>): void;


  /**
   * @summary Find purchase order by ID
   *
   * For valid response try integer IDs with value <= 5 or > 10. Other values
   * will generated exceptions
   *
   * @param {string} orderId ID of pet that needs to be fetched
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @returns {Promise} A promise is returned
   *
   * @resolve {HttpOperationResponse<Order>} - The deserialized result object.
   *
   * @reject {Error|ServiceError} - The error object.
   */
  getOrderByIdWithHttpOperationResponse(orderId: string, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<models.Order>>;

  /**
   * @summary Find purchase order by ID
   *
   * For valid response try integer IDs with value <= 5 or > 10. Other values
   * will generated exceptions
   *
   * @param {string} orderId ID of pet that needs to be fetched
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @param {ServiceCallback} [optionalCallback] - The optional callback.
   *
   * @returns {ServiceCallback|Promise} If a callback was passed as the last
   * parameter then it returns the callback else returns a Promise.
   *
   * {Promise} A promise is returned.
   *
   *                      @resolve {Order} - The deserialized result object.
   *
   *                      @reject {Error|ServiceError} - The error object.
   *
   * {ServiceCallback} optionalCallback(err, result, request, response)
   *
   *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
   *
   *                      {Order} [result]   - The deserialized result object if an error did not occur.
   *                      See {@link Order} for more information.
   *
   *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
   *
   *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
   */
  getOrderById(orderId: string, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<models.Order>;
  getOrderById(orderId: string, callback: ServiceCallback<models.Order>): void;
  getOrderById(orderId: string, options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<models.Order>): void;


  /**
   * @summary Delete purchase order by ID
   *
   * For valid response try integer IDs with value < 1000. Anything above 1000 or
   * nonintegers will generate API errors
   *
   * @param {string} orderId ID of the order that needs to be deleted
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @returns {Promise} A promise is returned
   *
   * @resolve {HttpOperationResponse<null>} - The deserialized result object.
   *
   * @reject {Error|ServiceError} - The error object.
   */
  deleteOrderWithHttpOperationResponse(orderId: string, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<void>>;

  /**
   * @summary Delete purchase order by ID
   *
   * For valid response try integer IDs with value < 1000. Anything above 1000 or
   * nonintegers will generate API errors
   *
   * @param {string} orderId ID of the order that needs to be deleted
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @param {ServiceCallback} [optionalCallback] - The optional callback.
   *
   * @returns {ServiceCallback|Promise} If a callback was passed as the last
   * parameter then it returns the callback else returns a Promise.
   *
   * {Promise} A promise is returned.
   *
   *                      @resolve {null} - The deserialized result object.
   *
   *                      @reject {Error|ServiceError} - The error object.
   *
   * {ServiceCallback} optionalCallback(err, result, request, response)
   *
   *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
   *
   *                      {null} [result]   - The deserialized result object if an error did not occur.
   *
   *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
   *
   *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
   */
  deleteOrder(orderId: string, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<void>;
  deleteOrder(orderId: string, callback: ServiceCallback<void>): void;
  deleteOrder(orderId: string, options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;


  /**
   * @summary Create user
   *
   * This can only be done by the logged in user.
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.body] Created user object
   *
   * @param {number} [options.body.id]
   *
   * @param {string} [options.body.username]
   *
   * @param {string} [options.body.firstName]
   *
   * @param {string} [options.body.lastName]
   *
   * @param {string} [options.body.email]
   *
   * @param {string} [options.body.password]
   *
   * @param {string} [options.body.phone]
   *
   * @param {number} [options.body.userStatus] User Status
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @returns {Promise} A promise is returned
   *
   * @resolve {HttpOperationResponse<null>} - The deserialized result object.
   *
   * @reject {Error|ServiceError} - The error object.
   */
  createUserWithHttpOperationResponse(options?: { body? : models.User, customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<void>>;

  /**
   * @summary Create user
   *
   * This can only be done by the logged in user.
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.body] Created user object
   *
   * @param {number} [options.body.id]
   *
   * @param {string} [options.body.username]
   *
   * @param {string} [options.body.firstName]
   *
   * @param {string} [options.body.lastName]
   *
   * @param {string} [options.body.email]
   *
   * @param {string} [options.body.password]
   *
   * @param {string} [options.body.phone]
   *
   * @param {number} [options.body.userStatus] User Status
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @param {ServiceCallback} [optionalCallback] - The optional callback.
   *
   * @returns {ServiceCallback|Promise} If a callback was passed as the last
   * parameter then it returns the callback else returns a Promise.
   *
   * {Promise} A promise is returned.
   *
   *                      @resolve {null} - The deserialized result object.
   *
   *                      @reject {Error|ServiceError} - The error object.
   *
   * {ServiceCallback} optionalCallback(err, result, request, response)
   *
   *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
   *
   *                      {null} [result]   - The deserialized result object if an error did not occur.
   *
   *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
   *
   *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
   */
  createUser(options?: { body? : models.User, customHeaders? : { [headerName: string]: string; } }): Promise<void>;
  createUser(callback: ServiceCallback<void>): void;
  createUser(options: { body? : models.User, customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;


  /**
   * @summary Creates list of users with given input array
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {array} [options.body] List of user object
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @returns {Promise} A promise is returned
   *
   * @resolve {HttpOperationResponse<null>} - The deserialized result object.
   *
   * @reject {Error|ServiceError} - The error object.
   */
  createUsersWithArrayInputWithHttpOperationResponse(options?: { body? : models.User[], customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<void>>;

  /**
   * @summary Creates list of users with given input array
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {array} [options.body] List of user object
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @param {ServiceCallback} [optionalCallback] - The optional callback.
   *
   * @returns {ServiceCallback|Promise} If a callback was passed as the last
   * parameter then it returns the callback else returns a Promise.
   *
   * {Promise} A promise is returned.
   *
   *                      @resolve {null} - The deserialized result object.
   *
   *                      @reject {Error|ServiceError} - The error object.
   *
   * {ServiceCallback} optionalCallback(err, result, request, response)
   *
   *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
   *
   *                      {null} [result]   - The deserialized result object if an error did not occur.
   *
   *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
   *
   *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
   */
  createUsersWithArrayInput(options?: { body? : models.User[], customHeaders? : { [headerName: string]: string; } }): Promise<void>;
  createUsersWithArrayInput(callback: ServiceCallback<void>): void;
  createUsersWithArrayInput(options: { body? : models.User[], customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;


  /**
   * @summary Creates list of users with given input array
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {array} [options.body] List of user object
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @returns {Promise} A promise is returned
   *
   * @resolve {HttpOperationResponse<null>} - The deserialized result object.
   *
   * @reject {Error|ServiceError} - The error object.
   */
  createUsersWithListInputWithHttpOperationResponse(options?: { body? : models.User[], customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<void>>;

  /**
   * @summary Creates list of users with given input array
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {array} [options.body] List of user object
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @param {ServiceCallback} [optionalCallback] - The optional callback.
   *
   * @returns {ServiceCallback|Promise} If a callback was passed as the last
   * parameter then it returns the callback else returns a Promise.
   *
   * {Promise} A promise is returned.
   *
   *                      @resolve {null} - The deserialized result object.
   *
   *                      @reject {Error|ServiceError} - The error object.
   *
   * {ServiceCallback} optionalCallback(err, result, request, response)
   *
   *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
   *
   *                      {null} [result]   - The deserialized result object if an error did not occur.
   *
   *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
   *
   *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
   */
  createUsersWithListInput(options?: { body? : models.User[], customHeaders? : { [headerName: string]: string; } }): Promise<void>;
  createUsersWithListInput(callback: ServiceCallback<void>): void;
  createUsersWithListInput(options: { body? : models.User[], customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;


  /**
   * @summary Logs user into the system
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {string} [options.username] The user name for login
   *
   * @param {string} [options.password] The password for login in clear text
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @returns {Promise} A promise is returned
   *
   * @resolve {HttpOperationResponse<String>} - The deserialized result object.
   *
   * @reject {Error|ServiceError} - The error object.
   */
  loginUserWithHttpOperationResponse(options?: { username? : string, password? : string, customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<string>>;

  /**
   * @summary Logs user into the system
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {string} [options.username] The user name for login
   *
   * @param {string} [options.password] The password for login in clear text
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @param {ServiceCallback} [optionalCallback] - The optional callback.
   *
   * @returns {ServiceCallback|Promise} If a callback was passed as the last
   * parameter then it returns the callback else returns a Promise.
   *
   * {Promise} A promise is returned.
   *
   *                      @resolve {String} - The deserialized result object.
   *
   *                      @reject {Error|ServiceError} - The error object.
   *
   * {ServiceCallback} optionalCallback(err, result, request, response)
   *
   *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
   *
   *                      {String} [result]   - The deserialized result object if an error did not occur.
   *
   *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
   *
   *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
   */
  loginUser(options?: { username? : string, password? : string, customHeaders? : { [headerName: string]: string; } }): Promise<string>;
  loginUser(callback: ServiceCallback<string>): void;
  loginUser(options: { username? : string, password? : string, customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<string>): void;


  /**
   * @summary Logs out current logged in user session
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @returns {Promise} A promise is returned
   *
   * @resolve {HttpOperationResponse<null>} - The deserialized result object.
   *
   * @reject {Error|ServiceError} - The error object.
   */
  logoutUserWithHttpOperationResponse(options?: { customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<void>>;

  /**
   * @summary Logs out current logged in user session
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @param {ServiceCallback} [optionalCallback] - The optional callback.
   *
   * @returns {ServiceCallback|Promise} If a callback was passed as the last
   * parameter then it returns the callback else returns a Promise.
   *
   * {Promise} A promise is returned.
   *
   *                      @resolve {null} - The deserialized result object.
   *
   *                      @reject {Error|ServiceError} - The error object.
   *
   * {ServiceCallback} optionalCallback(err, result, request, response)
   *
   *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
   *
   *                      {null} [result]   - The deserialized result object if an error did not occur.
   *
   *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
   *
   *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
   */
  logoutUser(options?: { customHeaders? : { [headerName: string]: string; } }): Promise<void>;
  logoutUser(callback: ServiceCallback<void>): void;
  logoutUser(options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;


  /**
   * @summary Get user by user name
   *
   * @param {string} username The name that needs to be fetched. Use user1 for
   * testing.
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @returns {Promise} A promise is returned
   *
   * @resolve {HttpOperationResponse<User>} - The deserialized result object.
   *
   * @reject {Error|ServiceError} - The error object.
   */
  getUserByNameWithHttpOperationResponse(username: string, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<models.User>>;

  /**
   * @summary Get user by user name
   *
   * @param {string} username The name that needs to be fetched. Use user1 for
   * testing.
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @param {ServiceCallback} [optionalCallback] - The optional callback.
   *
   * @returns {ServiceCallback|Promise} If a callback was passed as the last
   * parameter then it returns the callback else returns a Promise.
   *
   * {Promise} A promise is returned.
   *
   *                      @resolve {User} - The deserialized result object.
   *
   *                      @reject {Error|ServiceError} - The error object.
   *
   * {ServiceCallback} optionalCallback(err, result, request, response)
   *
   *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
   *
   *                      {User} [result]   - The deserialized result object if an error did not occur.
   *                      See {@link User} for more information.
   *
   *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
   *
   *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
   */
  getUserByName(username: string, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<models.User>;
  getUserByName(username: string, callback: ServiceCallback<models.User>): void;
  getUserByName(username: string, options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<models.User>): void;


  /**
   * @summary Updated user
   *
   * This can only be done by the logged in user.
   *
   * @param {string} username name that need to be deleted
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.body] Updated user object
   *
   * @param {number} [options.body.id]
   *
   * @param {string} [options.body.username]
   *
   * @param {string} [options.body.firstName]
   *
   * @param {string} [options.body.lastName]
   *
   * @param {string} [options.body.email]
   *
   * @param {string} [options.body.password]
   *
   * @param {string} [options.body.phone]
   *
   * @param {number} [options.body.userStatus] User Status
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @returns {Promise} A promise is returned
   *
   * @resolve {HttpOperationResponse<null>} - The deserialized result object.
   *
   * @reject {Error|ServiceError} - The error object.
   */
  updateUserWithHttpOperationResponse(username: string, options?: { body? : models.User, customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<void>>;

  /**
   * @summary Updated user
   *
   * This can only be done by the logged in user.
   *
   * @param {string} username name that need to be deleted
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.body] Updated user object
   *
   * @param {number} [options.body.id]
   *
   * @param {string} [options.body.username]
   *
   * @param {string} [options.body.firstName]
   *
   * @param {string} [options.body.lastName]
   *
   * @param {string} [options.body.email]
   *
   * @param {string} [options.body.password]
   *
   * @param {string} [options.body.phone]
   *
   * @param {number} [options.body.userStatus] User Status
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @param {ServiceCallback} [optionalCallback] - The optional callback.
   *
   * @returns {ServiceCallback|Promise} If a callback was passed as the last
   * parameter then it returns the callback else returns a Promise.
   *
   * {Promise} A promise is returned.
   *
   *                      @resolve {null} - The deserialized result object.
   *
   *                      @reject {Error|ServiceError} - The error object.
   *
   * {ServiceCallback} optionalCallback(err, result, request, response)
   *
   *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
   *
   *                      {null} [result]   - The deserialized result object if an error did not occur.
   *
   *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
   *
   *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
   */
  updateUser(username: string, options?: { body? : models.User, customHeaders? : { [headerName: string]: string; } }): Promise<void>;
  updateUser(username: string, callback: ServiceCallback<void>): void;
  updateUser(username: string, options: { body? : models.User, customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;


  /**
   * @summary Delete user
   *
   * This can only be done by the logged in user.
   *
   * @param {string} username The name that needs to be deleted
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @returns {Promise} A promise is returned
   *
   * @resolve {HttpOperationResponse<null>} - The deserialized result object.
   *
   * @reject {Error|ServiceError} - The error object.
   */
  deleteUserWithHttpOperationResponse(username: string, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<void>>;

  /**
   * @summary Delete user
   *
   * This can only be done by the logged in user.
   *
   * @param {string} username The name that needs to be deleted
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @param {ServiceCallback} [optionalCallback] - The optional callback.
   *
   * @returns {ServiceCallback|Promise} If a callback was passed as the last
   * parameter then it returns the callback else returns a Promise.
   *
   * {Promise} A promise is returned.
   *
   *                      @resolve {null} - The deserialized result object.
   *
   *                      @reject {Error|ServiceError} - The error object.
   *
   * {ServiceCallback} optionalCallback(err, result, request, response)
   *
   *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
   *
   *                      {null} [result]   - The deserialized result object if an error did not occur.
   *
   *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
   *
   *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
   */
  deleteUser(username: string, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<void>;
  deleteUser(username: string, callback: ServiceCallback<void>): void;
  deleteUser(username: string, options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;
}

export = SwaggerPetstore;
