/*
 */

import { ServiceClientOptions, RequestOptions, ServiceCallback } from 'ms-rest';
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
    constructor(baseUri: string, options: ServiceClientOptions);

            /**
         * @summary Fake endpoint to test byte array in body parameter for adding a
         * new pet to the store
         *
         * @param {object} [options] Optional Parameters.
         * 
         * @param {string} [options.body] Pet object in the form of byte array
         * 
         * @param {object} [options.customHeaders] Headers that will be added to the
         * request
         * 
         * @param {ServiceCallback} [callback] callback function; see ServiceCallback
         * doc in ms-rest index.d.ts for details
         */
        addPetUsingByteArray(options: { body? : string, customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;
        addPetUsingByteArray(callback: ServiceCallback<void>): void;

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
         * @param {ServiceCallback} [callback] callback function; see ServiceCallback
         * doc in ms-rest index.d.ts for details
         */
        addPet(options: { body? : models.Pet, customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;
        addPet(callback: ServiceCallback<void>): void;

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
         * @param {ServiceCallback} [callback] callback function; see ServiceCallback
         * doc in ms-rest index.d.ts for details
         */
        updatePet(options: { body? : models.Pet, customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;
        updatePet(callback: ServiceCallback<void>): void;

        /**
         * @summary Finds Pets by status
         *
         * Multiple status values can be provided with comma seperated strings
         *
         * @param {object} [options] Optional Parameters.
         * 
         * @param {array} [options.status] Status values that need to be considered
         * for filter
         * 
         * @param {object} [options.customHeaders] Headers that will be added to the
         * request
         * 
         * @param {ServiceCallback} [callback] callback function; see ServiceCallback
         * doc in ms-rest index.d.ts for details
         */
        findPetsByStatus(options: { status? : string[], customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<models.Pet[]>): void;
        findPetsByStatus(callback: ServiceCallback<models.Pet[]>): void;

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
         * @param {ServiceCallback} [callback] callback function; see ServiceCallback
         * doc in ms-rest index.d.ts for details
         */
        findPetsByTags(options: { tags? : string[], customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<models.Pet[]>): void;
        findPetsByTags(callback: ServiceCallback<models.Pet[]>): void;

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
         * @param {ServiceCallback} [callback] callback function; see ServiceCallback
         * doc in ms-rest index.d.ts for details
         */
        findPetsWithByteArray(petId: number, options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<string>): void;
        findPetsWithByteArray(petId: number, callback: ServiceCallback<string>): void;

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
         * @param {ServiceCallback} [callback] callback function; see ServiceCallback
         * doc in ms-rest index.d.ts for details
         */
        getPetById(petId: number, options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<models.Pet>): void;
        getPetById(petId: number, callback: ServiceCallback<models.Pet>): void;

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
         * @param {ServiceCallback} [callback] callback function; see ServiceCallback
         * doc in ms-rest index.d.ts for details
         */
        updatePetWithForm(petId: string, options: { name? : string, status? : string, customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;
        updatePetWithForm(petId: string, callback: ServiceCallback<void>): void;

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
         * @param {ServiceCallback} [callback] callback function; see ServiceCallback
         * doc in ms-rest index.d.ts for details
         */
        deletePet(petId: number, options: { apiKey? : string, customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;
        deletePet(petId: number, callback: ServiceCallback<void>): void;

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
         * @param {ServiceCallback} [callback] callback function; see ServiceCallback
         * doc in ms-rest index.d.ts for details
         */
        uploadFile(petId: number, options: { additionalMetadata? : string, file? : stream.Readable, customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;
        uploadFile(petId: number, callback: ServiceCallback<void>): void;

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
         * @param {ServiceCallback} [callback] callback function; see ServiceCallback
         * doc in ms-rest index.d.ts for details
         */
        getInventory(options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<{ [propertyName: string]: number }>): void;
        getInventory(callback: ServiceCallback<{ [propertyName: string]: number }>): void;

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
         * @param {string} [options.body.status] Order Status. Possible values
         * include: 'placed', 'approved', 'delivered'
         * 
         * @param {boolean} [options.body.complete]
         * 
         * @param {object} [options.customHeaders] Headers that will be added to the
         * request
         * 
         * @param {ServiceCallback} [callback] callback function; see ServiceCallback
         * doc in ms-rest index.d.ts for details
         */
        placeOrder(options: { body? : models.Order, customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<models.Order>): void;
        placeOrder(callback: ServiceCallback<models.Order>): void;

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
         * @param {ServiceCallback} [callback] callback function; see ServiceCallback
         * doc in ms-rest index.d.ts for details
         */
        getOrderById(orderId: string, options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<models.Order>): void;
        getOrderById(orderId: string, callback: ServiceCallback<models.Order>): void;

        /**
         * @summary Delete purchase order by ID
         *
         * For valid response try integer IDs with value < 1000. Anything above 1000
         * or nonintegers will generate API errors
         *
         * @param {string} orderId ID of the order that needs to be deleted
         * 
         * @param {object} [options] Optional Parameters.
         * 
         * @param {object} [options.customHeaders] Headers that will be added to the
         * request
         * 
         * @param {ServiceCallback} [callback] callback function; see ServiceCallback
         * doc in ms-rest index.d.ts for details
         */
        deleteOrder(orderId: string, options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;
        deleteOrder(orderId: string, callback: ServiceCallback<void>): void;

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
         * @param {ServiceCallback} [callback] callback function; see ServiceCallback
         * doc in ms-rest index.d.ts for details
         */
        createUser(options: { body? : models.User, customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;
        createUser(callback: ServiceCallback<void>): void;

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
         * @param {ServiceCallback} [callback] callback function; see ServiceCallback
         * doc in ms-rest index.d.ts for details
         */
        createUsersWithArrayInput(options: { body? : models.User[], customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;
        createUsersWithArrayInput(callback: ServiceCallback<void>): void;

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
         * @param {ServiceCallback} [callback] callback function; see ServiceCallback
         * doc in ms-rest index.d.ts for details
         */
        createUsersWithListInput(options: { body? : models.User[], customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;
        createUsersWithListInput(callback: ServiceCallback<void>): void;

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
         * @param {ServiceCallback} [callback] callback function; see ServiceCallback
         * doc in ms-rest index.d.ts for details
         */
        loginUser(options: { username? : string, password? : string, customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<string>): void;
        loginUser(callback: ServiceCallback<string>): void;

        /**
         * @summary Logs out current logged in user session
         *
         * @param {object} [options] Optional Parameters.
         * 
         * @param {object} [options.customHeaders] Headers that will be added to the
         * request
         * 
         * @param {ServiceCallback} [callback] callback function; see ServiceCallback
         * doc in ms-rest index.d.ts for details
         */
        logoutUser(options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;
        logoutUser(callback: ServiceCallback<void>): void;

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
         * @param {ServiceCallback} [callback] callback function; see ServiceCallback
         * doc in ms-rest index.d.ts for details
         */
        getUserByName(username: string, options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<models.User>): void;
        getUserByName(username: string, callback: ServiceCallback<models.User>): void;

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
         * @param {ServiceCallback} [callback] callback function; see ServiceCallback
         * doc in ms-rest index.d.ts for details
         */
        updateUser(username: string, options: { body? : models.User, customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;
        updateUser(username: string, callback: ServiceCallback<void>): void;

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
         * @param {ServiceCallback} [callback] callback function; see ServiceCallback
         * doc in ms-rest index.d.ts for details
         */
        deleteUser(username: string, options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;
        deleteUser(username: string, callback: ServiceCallback<void>): void;
}

export = SwaggerPetstore;
