/**
 */

package petstore;

import com.microsoft.rest.ServiceCall;
import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceException;
import com.microsoft.rest.ServiceResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import petstore.models.Order;
import petstore.models.Pet;
import petstore.models.User;

/**
 * The interface for SwaggerPetstore class.
 */
public interface SwaggerPetstore {
    /**
     * The default base URL.
     */
    String DEFAULT_BASE_URL = "http://petstore.swagger.io/v2";

    /**
     * Fake endpoint to test byte array in body parameter for adding a new pet to the store.
     *
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    ServiceResponse<Void> addPetUsingByteArray() throws ServiceException, IOException;

    /**
     * Fake endpoint to test byte array in body parameter for adding a new pet to the store.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> addPetUsingByteArrayAsync(final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException;
    /**
     * Fake endpoint to test byte array in body parameter for adding a new pet to the store.
     *
     * @param body Pet object in the form of byte array
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    ServiceResponse<Void> addPetUsingByteArray(String body) throws ServiceException, IOException;

    /**
     * Fake endpoint to test byte array in body parameter for adding a new pet to the store.
     *
     * @param body Pet object in the form of byte array
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> addPetUsingByteArrayAsync(String body, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException;

    /**
     * Add a new pet to the store.
     * Adds a new pet to the store. You may receive an HTTP invalid input if your pet is invalid.
     *
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    ServiceResponse<Void> addPet() throws ServiceException, IOException;

    /**
     * Add a new pet to the store.
     * Adds a new pet to the store. You may receive an HTTP invalid input if your pet is invalid.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> addPetAsync(final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException;
    /**
     * Add a new pet to the store.
     * Adds a new pet to the store. You may receive an HTTP invalid input if your pet is invalid.
     *
     * @param body Pet object that needs to be added to the store
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    ServiceResponse<Void> addPet(Pet body) throws ServiceException, IOException;

    /**
     * Add a new pet to the store.
     * Adds a new pet to the store. You may receive an HTTP invalid input if your pet is invalid.
     *
     * @param body Pet object that needs to be added to the store
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> addPetAsync(Pet body, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException;

    /**
     * Update an existing pet.
     *
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    ServiceResponse<Void> updatePet() throws ServiceException, IOException;

    /**
     * Update an existing pet.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> updatePetAsync(final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException;
    /**
     * Update an existing pet.
     *
     * @param body Pet object that needs to be added to the store
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    ServiceResponse<Void> updatePet(Pet body) throws ServiceException, IOException;

    /**
     * Update an existing pet.
     *
     * @param body Pet object that needs to be added to the store
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> updatePetAsync(Pet body, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException;

    /**
     * Finds Pets by status.
     * Multiple status values can be provided with comma seperated strings.
     *
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the List&lt;Pet&gt; object wrapped in {@link ServiceResponse} if successful.
     */
    ServiceResponse<List<Pet>> findPetsByStatus() throws ServiceException, IOException;

    /**
     * Finds Pets by status.
     * Multiple status values can be provided with comma seperated strings.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<List<Pet>> findPetsByStatusAsync(final ServiceCallback<List<Pet>> serviceCallback) throws IllegalArgumentException;
    /**
     * Finds Pets by status.
     * Multiple status values can be provided with comma seperated strings.
     *
     * @param status Status values that need to be considered for filter
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the List&lt;Pet&gt; object wrapped in {@link ServiceResponse} if successful.
     */
    ServiceResponse<List<Pet>> findPetsByStatus(List<String> status) throws ServiceException, IOException;

    /**
     * Finds Pets by status.
     * Multiple status values can be provided with comma seperated strings.
     *
     * @param status Status values that need to be considered for filter
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<List<Pet>> findPetsByStatusAsync(List<String> status, final ServiceCallback<List<Pet>> serviceCallback) throws IllegalArgumentException;

    /**
     * Finds Pets by tags.
     * Muliple tags can be provided with comma seperated strings. Use tag1, tag2, tag3 for testing.
     *
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the List&lt;Pet&gt; object wrapped in {@link ServiceResponse} if successful.
     */
    ServiceResponse<List<Pet>> findPetsByTags() throws ServiceException, IOException;

    /**
     * Finds Pets by tags.
     * Muliple tags can be provided with comma seperated strings. Use tag1, tag2, tag3 for testing.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<List<Pet>> findPetsByTagsAsync(final ServiceCallback<List<Pet>> serviceCallback) throws IllegalArgumentException;
    /**
     * Finds Pets by tags.
     * Muliple tags can be provided with comma seperated strings. Use tag1, tag2, tag3 for testing.
     *
     * @param tags Tags to filter by
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the List&lt;Pet&gt; object wrapped in {@link ServiceResponse} if successful.
     */
    ServiceResponse<List<Pet>> findPetsByTags(List<String> tags) throws ServiceException, IOException;

    /**
     * Finds Pets by tags.
     * Muliple tags can be provided with comma seperated strings. Use tag1, tag2, tag3 for testing.
     *
     * @param tags Tags to filter by
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<List<Pet>> findPetsByTagsAsync(List<String> tags, final ServiceCallback<List<Pet>> serviceCallback) throws IllegalArgumentException;

    /**
     * Fake endpoint to test byte array return by 'Find pet by ID'.
     * Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will simulate API error conditions.
     *
     * @param petId ID of pet that needs to be fetched
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the String object wrapped in {@link ServiceResponse} if successful.
     */
    ServiceResponse<String> findPetsWithByteArray(long petId) throws ServiceException, IOException;

    /**
     * Fake endpoint to test byte array return by 'Find pet by ID'.
     * Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will simulate API error conditions.
     *
     * @param petId ID of pet that needs to be fetched
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<String> findPetsWithByteArrayAsync(long petId, final ServiceCallback<String> serviceCallback) throws IllegalArgumentException;

    /**
     * Find pet by ID.
     * Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will simulate API error conditions.
     *
     * @param petId ID of pet that needs to be fetched
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the Pet object wrapped in {@link ServiceResponse} if successful.
     */
    ServiceResponse<Pet> getPetById(long petId) throws ServiceException, IOException;

    /**
     * Find pet by ID.
     * Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will simulate API error conditions.
     *
     * @param petId ID of pet that needs to be fetched
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Pet> getPetByIdAsync(long petId, final ServiceCallback<Pet> serviceCallback) throws IllegalArgumentException;

    /**
     * Updates a pet in the store with form data.
     *
     * @param petId ID of pet that needs to be updated
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @throws IllegalArgumentException exception thrown from invalid parameters
     * @return the {@link ServiceResponse} object if successful.
     */
    ServiceResponse<Void> updatePetWithForm(String petId) throws ServiceException, IOException, IllegalArgumentException;

    /**
     * Updates a pet in the store with form data.
     *
     * @param petId ID of pet that needs to be updated
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> updatePetWithFormAsync(String petId, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException;
    /**
     * Updates a pet in the store with form data.
     *
     * @param petId ID of pet that needs to be updated
     * @param name Updated name of the pet
     * @param status Updated status of the pet
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @throws IllegalArgumentException exception thrown from invalid parameters
     * @return the {@link ServiceResponse} object if successful.
     */
    ServiceResponse<Void> updatePetWithForm(String petId, String name, String status) throws ServiceException, IOException, IllegalArgumentException;

    /**
     * Updates a pet in the store with form data.
     *
     * @param petId ID of pet that needs to be updated
     * @param name Updated name of the pet
     * @param status Updated status of the pet
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> updatePetWithFormAsync(String petId, String name, String status, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException;

    /**
     * Deletes a pet.
     *
     * @param petId Pet id to delete
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    ServiceResponse<Void> deletePet(long petId) throws ServiceException, IOException;

    /**
     * Deletes a pet.
     *
     * @param petId Pet id to delete
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> deletePetAsync(long petId, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException;
    /**
     * Deletes a pet.
     *
     * @param petId Pet id to delete
     * @param apiKey 
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    ServiceResponse<Void> deletePet(long petId, String apiKey) throws ServiceException, IOException;

    /**
     * Deletes a pet.
     *
     * @param petId Pet id to delete
     * @param apiKey 
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> deletePetAsync(long petId, String apiKey, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException;

    /**
     * uploads an image.
     *
     * @param petId ID of pet to update
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    ServiceResponse<Void> uploadFile(long petId) throws ServiceException, IOException;

    /**
     * uploads an image.
     *
     * @param petId ID of pet to update
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> uploadFileAsync(long petId, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException;
    /**
     * uploads an image.
     *
     * @param petId ID of pet to update
     * @param additionalMetadata Additional data to pass to server
     * @param file file to upload
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    ServiceResponse<Void> uploadFile(long petId, String additionalMetadata, byte[] file) throws ServiceException, IOException;

    /**
     * uploads an image.
     *
     * @param petId ID of pet to update
     * @param additionalMetadata Additional data to pass to server
     * @param file file to upload
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> uploadFileAsync(long petId, String additionalMetadata, byte[] file, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException;

    /**
     * Returns pet inventories by status.
     * Returns a map of status codes to quantities.
     *
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the Map&lt;String, Integer&gt; object wrapped in {@link ServiceResponse} if successful.
     */
    ServiceResponse<Map<String, Integer>> getInventory() throws ServiceException, IOException;

    /**
     * Returns pet inventories by status.
     * Returns a map of status codes to quantities.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Map<String, Integer>> getInventoryAsync(final ServiceCallback<Map<String, Integer>> serviceCallback) throws IllegalArgumentException;

    /**
     * Place an order for a pet.
     *
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the Order object wrapped in {@link ServiceResponse} if successful.
     */
    ServiceResponse<Order> placeOrder() throws ServiceException, IOException;

    /**
     * Place an order for a pet.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Order> placeOrderAsync(final ServiceCallback<Order> serviceCallback) throws IllegalArgumentException;
    /**
     * Place an order for a pet.
     *
     * @param body order placed for purchasing the pet
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the Order object wrapped in {@link ServiceResponse} if successful.
     */
    ServiceResponse<Order> placeOrder(Order body) throws ServiceException, IOException;

    /**
     * Place an order for a pet.
     *
     * @param body order placed for purchasing the pet
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Order> placeOrderAsync(Order body, final ServiceCallback<Order> serviceCallback) throws IllegalArgumentException;

    /**
     * Find purchase order by ID.
     * For valid response try integer IDs with value &lt;= 5 or &gt; 10. Other values will generated exceptions.
     *
     * @param orderId ID of pet that needs to be fetched
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @throws IllegalArgumentException exception thrown from invalid parameters
     * @return the Order object wrapped in {@link ServiceResponse} if successful.
     */
    ServiceResponse<Order> getOrderById(String orderId) throws ServiceException, IOException, IllegalArgumentException;

    /**
     * Find purchase order by ID.
     * For valid response try integer IDs with value &lt;= 5 or &gt; 10. Other values will generated exceptions.
     *
     * @param orderId ID of pet that needs to be fetched
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Order> getOrderByIdAsync(String orderId, final ServiceCallback<Order> serviceCallback) throws IllegalArgumentException;

    /**
     * Delete purchase order by ID.
     * For valid response try integer IDs with value &lt; 1000. Anything above 1000 or nonintegers will generate API errors.
     *
     * @param orderId ID of the order that needs to be deleted
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @throws IllegalArgumentException exception thrown from invalid parameters
     * @return the {@link ServiceResponse} object if successful.
     */
    ServiceResponse<Void> deleteOrder(String orderId) throws ServiceException, IOException, IllegalArgumentException;

    /**
     * Delete purchase order by ID.
     * For valid response try integer IDs with value &lt; 1000. Anything above 1000 or nonintegers will generate API errors.
     *
     * @param orderId ID of the order that needs to be deleted
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> deleteOrderAsync(String orderId, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException;

    /**
     * Create user.
     * This can only be done by the logged in user.
     *
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    ServiceResponse<Void> createUser() throws ServiceException, IOException;

    /**
     * Create user.
     * This can only be done by the logged in user.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> createUserAsync(final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException;
    /**
     * Create user.
     * This can only be done by the logged in user.
     *
     * @param body Created user object
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    ServiceResponse<Void> createUser(User body) throws ServiceException, IOException;

    /**
     * Create user.
     * This can only be done by the logged in user.
     *
     * @param body Created user object
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> createUserAsync(User body, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException;

    /**
     * Creates list of users with given input array.
     *
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    ServiceResponse<Void> createUsersWithArrayInput() throws ServiceException, IOException;

    /**
     * Creates list of users with given input array.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> createUsersWithArrayInputAsync(final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException;
    /**
     * Creates list of users with given input array.
     *
     * @param body List of user object
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    ServiceResponse<Void> createUsersWithArrayInput(List<User> body) throws ServiceException, IOException;

    /**
     * Creates list of users with given input array.
     *
     * @param body List of user object
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> createUsersWithArrayInputAsync(List<User> body, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException;

    /**
     * Creates list of users with given input array.
     *
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    ServiceResponse<Void> createUsersWithListInput() throws ServiceException, IOException;

    /**
     * Creates list of users with given input array.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> createUsersWithListInputAsync(final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException;
    /**
     * Creates list of users with given input array.
     *
     * @param body List of user object
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    ServiceResponse<Void> createUsersWithListInput(List<User> body) throws ServiceException, IOException;

    /**
     * Creates list of users with given input array.
     *
     * @param body List of user object
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> createUsersWithListInputAsync(List<User> body, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException;

    /**
     * Logs user into the system.
     *
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the String object wrapped in {@link ServiceResponse} if successful.
     */
    ServiceResponse<String> loginUser() throws ServiceException, IOException;

    /**
     * Logs user into the system.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<String> loginUserAsync(final ServiceCallback<String> serviceCallback) throws IllegalArgumentException;
    /**
     * Logs user into the system.
     *
     * @param username The user name for login
     * @param password The password for login in clear text
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the String object wrapped in {@link ServiceResponse} if successful.
     */
    ServiceResponse<String> loginUser(String username, String password) throws ServiceException, IOException;

    /**
     * Logs user into the system.
     *
     * @param username The user name for login
     * @param password The password for login in clear text
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<String> loginUserAsync(String username, String password, final ServiceCallback<String> serviceCallback) throws IllegalArgumentException;

    /**
     * Logs out current logged in user session.
     *
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    ServiceResponse<Void> logoutUser() throws ServiceException, IOException;

    /**
     * Logs out current logged in user session.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> logoutUserAsync(final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException;

    /**
     * Get user by user name.
     *
     * @param username The name that needs to be fetched. Use user1 for testing. 
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @throws IllegalArgumentException exception thrown from invalid parameters
     * @return the User object wrapped in {@link ServiceResponse} if successful.
     */
    ServiceResponse<User> getUserByName(String username) throws ServiceException, IOException, IllegalArgumentException;

    /**
     * Get user by user name.
     *
     * @param username The name that needs to be fetched. Use user1 for testing. 
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<User> getUserByNameAsync(String username, final ServiceCallback<User> serviceCallback) throws IllegalArgumentException;

    /**
     * Updated user.
     * This can only be done by the logged in user.
     *
     * @param username name that need to be deleted
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @throws IllegalArgumentException exception thrown from invalid parameters
     * @return the {@link ServiceResponse} object if successful.
     */
    ServiceResponse<Void> updateUser(String username) throws ServiceException, IOException, IllegalArgumentException;

    /**
     * Updated user.
     * This can only be done by the logged in user.
     *
     * @param username name that need to be deleted
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> updateUserAsync(String username, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException;
    /**
     * Updated user.
     * This can only be done by the logged in user.
     *
     * @param username name that need to be deleted
     * @param body Updated user object
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @throws IllegalArgumentException exception thrown from invalid parameters
     * @return the {@link ServiceResponse} object if successful.
     */
    ServiceResponse<Void> updateUser(String username, User body) throws ServiceException, IOException, IllegalArgumentException;

    /**
     * Updated user.
     * This can only be done by the logged in user.
     *
     * @param username name that need to be deleted
     * @param body Updated user object
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> updateUserAsync(String username, User body, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException;

    /**
     * Delete user.
     * This can only be done by the logged in user.
     *
     * @param username The name that needs to be deleted
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @throws IllegalArgumentException exception thrown from invalid parameters
     * @return the {@link ServiceResponse} object if successful.
     */
    ServiceResponse<Void> deleteUser(String username) throws ServiceException, IOException, IllegalArgumentException;

    /**
     * Delete user.
     * This can only be done by the logged in user.
     *
     * @param username The name that needs to be deleted
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> deleteUserAsync(String username, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException;

}
