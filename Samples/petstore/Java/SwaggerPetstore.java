/**
 */

package petstore;

import com.microsoft.rest.RestException;
import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceFuture;
import com.microsoft.rest.ServiceResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import petstore.models.Order;
import petstore.models.Pet;
import petstore.models.User;
import rx.Observable;
import com.microsoft.rest.RestClient;

/**
 * The interface for SwaggerPetstore class.
 */
public interface SwaggerPetstore {
    /**
     * Gets the REST client.
     *
     * @return the {@link RestClient} object.
    */
    RestClient restClient();

    /**
     * The default base URL.
     */
    String DEFAULT_BASE_URL = "http://petstore.swagger.io/v2";

    /**
     * Fake endpoint to test byte array in body parameter for adding a new pet to the store.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void addPetUsingByteArray();

    /**
     * Fake endpoint to test byte array in body parameter for adding a new pet to the store.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> addPetUsingByteArrayAsync(final ServiceCallback<Void> serviceCallback);

    /**
     * Fake endpoint to test byte array in body parameter for adding a new pet to the store.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> addPetUsingByteArrayAsync();

    /**
     * Fake endpoint to test byte array in body parameter for adding a new pet to the store.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> addPetUsingByteArrayWithServiceResponseAsync();
    /**
     * Fake endpoint to test byte array in body parameter for adding a new pet to the store.
     *
     * @param body Pet object in the form of byte array
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void addPetUsingByteArray(String body);

    /**
     * Fake endpoint to test byte array in body parameter for adding a new pet to the store.
     *
     * @param body Pet object in the form of byte array
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> addPetUsingByteArrayAsync(String body, final ServiceCallback<Void> serviceCallback);

    /**
     * Fake endpoint to test byte array in body parameter for adding a new pet to the store.
     *
     * @param body Pet object in the form of byte array
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> addPetUsingByteArrayAsync(String body);

    /**
     * Fake endpoint to test byte array in body parameter for adding a new pet to the store.
     *
     * @param body Pet object in the form of byte array
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> addPetUsingByteArrayWithServiceResponseAsync(String body);

    /**
     * Add a new pet to the store.
     * Adds a new pet to the store. You may receive an HTTP invalid input if your pet is invalid.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void addPet();

    /**
     * Add a new pet to the store.
     * Adds a new pet to the store. You may receive an HTTP invalid input if your pet is invalid.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> addPetAsync(final ServiceCallback<Void> serviceCallback);

    /**
     * Add a new pet to the store.
     * Adds a new pet to the store. You may receive an HTTP invalid input if your pet is invalid.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> addPetAsync();

    /**
     * Add a new pet to the store.
     * Adds a new pet to the store. You may receive an HTTP invalid input if your pet is invalid.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> addPetWithServiceResponseAsync();
    /**
     * Add a new pet to the store.
     * Adds a new pet to the store. You may receive an HTTP invalid input if your pet is invalid.
     *
     * @param body Pet object that needs to be added to the store
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void addPet(Pet body);

    /**
     * Add a new pet to the store.
     * Adds a new pet to the store. You may receive an HTTP invalid input if your pet is invalid.
     *
     * @param body Pet object that needs to be added to the store
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> addPetAsync(Pet body, final ServiceCallback<Void> serviceCallback);

    /**
     * Add a new pet to the store.
     * Adds a new pet to the store. You may receive an HTTP invalid input if your pet is invalid.
     *
     * @param body Pet object that needs to be added to the store
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> addPetAsync(Pet body);

    /**
     * Add a new pet to the store.
     * Adds a new pet to the store. You may receive an HTTP invalid input if your pet is invalid.
     *
     * @param body Pet object that needs to be added to the store
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> addPetWithServiceResponseAsync(Pet body);

    /**
     * Update an existing pet.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void updatePet();

    /**
     * Update an existing pet.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> updatePetAsync(final ServiceCallback<Void> serviceCallback);

    /**
     * Update an existing pet.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> updatePetAsync();

    /**
     * Update an existing pet.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> updatePetWithServiceResponseAsync();
    /**
     * Update an existing pet.
     *
     * @param body Pet object that needs to be added to the store
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void updatePet(Pet body);

    /**
     * Update an existing pet.
     *
     * @param body Pet object that needs to be added to the store
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> updatePetAsync(Pet body, final ServiceCallback<Void> serviceCallback);

    /**
     * Update an existing pet.
     *
     * @param body Pet object that needs to be added to the store
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> updatePetAsync(Pet body);

    /**
     * Update an existing pet.
     *
     * @param body Pet object that needs to be added to the store
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> updatePetWithServiceResponseAsync(Pet body);

    /**
     * Finds Pets by status.
     * Multiple status values can be provided with comma seperated strings.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     * @return the List&lt;Pet&gt; object if successful.
     */
    List<Pet> findPetsByStatus();

    /**
     * Finds Pets by status.
     * Multiple status values can be provided with comma seperated strings.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<List<Pet>> findPetsByStatusAsync(final ServiceCallback<List<Pet>> serviceCallback);

    /**
     * Finds Pets by status.
     * Multiple status values can be provided with comma seperated strings.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the List&lt;Pet&gt; object
     */
    Observable<List<Pet>> findPetsByStatusAsync();

    /**
     * Finds Pets by status.
     * Multiple status values can be provided with comma seperated strings.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the List&lt;Pet&gt; object
     */
    Observable<ServiceResponse<List<Pet>>> findPetsByStatusWithServiceResponseAsync();
    /**
     * Finds Pets by status.
     * Multiple status values can be provided with comma seperated strings.
     *
     * @param status Status values that need to be considered for filter
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     * @return the List&lt;Pet&gt; object if successful.
     */
    List<Pet> findPetsByStatus(List<String> status);

    /**
     * Finds Pets by status.
     * Multiple status values can be provided with comma seperated strings.
     *
     * @param status Status values that need to be considered for filter
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<List<Pet>> findPetsByStatusAsync(List<String> status, final ServiceCallback<List<Pet>> serviceCallback);

    /**
     * Finds Pets by status.
     * Multiple status values can be provided with comma seperated strings.
     *
     * @param status Status values that need to be considered for filter
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the List&lt;Pet&gt; object
     */
    Observable<List<Pet>> findPetsByStatusAsync(List<String> status);

    /**
     * Finds Pets by status.
     * Multiple status values can be provided with comma seperated strings.
     *
     * @param status Status values that need to be considered for filter
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the List&lt;Pet&gt; object
     */
    Observable<ServiceResponse<List<Pet>>> findPetsByStatusWithServiceResponseAsync(List<String> status);

    /**
     * Finds Pets by tags.
     * Muliple tags can be provided with comma seperated strings. Use tag1, tag2, tag3 for testing.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     * @return the List&lt;Pet&gt; object if successful.
     */
    List<Pet> findPetsByTags();

    /**
     * Finds Pets by tags.
     * Muliple tags can be provided with comma seperated strings. Use tag1, tag2, tag3 for testing.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<List<Pet>> findPetsByTagsAsync(final ServiceCallback<List<Pet>> serviceCallback);

    /**
     * Finds Pets by tags.
     * Muliple tags can be provided with comma seperated strings. Use tag1, tag2, tag3 for testing.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the List&lt;Pet&gt; object
     */
    Observable<List<Pet>> findPetsByTagsAsync();

    /**
     * Finds Pets by tags.
     * Muliple tags can be provided with comma seperated strings. Use tag1, tag2, tag3 for testing.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the List&lt;Pet&gt; object
     */
    Observable<ServiceResponse<List<Pet>>> findPetsByTagsWithServiceResponseAsync();
    /**
     * Finds Pets by tags.
     * Muliple tags can be provided with comma seperated strings. Use tag1, tag2, tag3 for testing.
     *
     * @param tags Tags to filter by
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     * @return the List&lt;Pet&gt; object if successful.
     */
    List<Pet> findPetsByTags(List<String> tags);

    /**
     * Finds Pets by tags.
     * Muliple tags can be provided with comma seperated strings. Use tag1, tag2, tag3 for testing.
     *
     * @param tags Tags to filter by
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<List<Pet>> findPetsByTagsAsync(List<String> tags, final ServiceCallback<List<Pet>> serviceCallback);

    /**
     * Finds Pets by tags.
     * Muliple tags can be provided with comma seperated strings. Use tag1, tag2, tag3 for testing.
     *
     * @param tags Tags to filter by
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the List&lt;Pet&gt; object
     */
    Observable<List<Pet>> findPetsByTagsAsync(List<String> tags);

    /**
     * Finds Pets by tags.
     * Muliple tags can be provided with comma seperated strings. Use tag1, tag2, tag3 for testing.
     *
     * @param tags Tags to filter by
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the List&lt;Pet&gt; object
     */
    Observable<ServiceResponse<List<Pet>>> findPetsByTagsWithServiceResponseAsync(List<String> tags);

    /**
     * Fake endpoint to test byte array return by 'Find pet by ID'.
     * Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will simulate API error conditions.
     *
     * @param petId ID of pet that needs to be fetched
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     * @return the String object if successful.
     */
    String findPetsWithByteArray(long petId);

    /**
     * Fake endpoint to test byte array return by 'Find pet by ID'.
     * Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will simulate API error conditions.
     *
     * @param petId ID of pet that needs to be fetched
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<String> findPetsWithByteArrayAsync(long petId, final ServiceCallback<String> serviceCallback);

    /**
     * Fake endpoint to test byte array return by 'Find pet by ID'.
     * Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will simulate API error conditions.
     *
     * @param petId ID of pet that needs to be fetched
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the String object
     */
    Observable<String> findPetsWithByteArrayAsync(long petId);

    /**
     * Fake endpoint to test byte array return by 'Find pet by ID'.
     * Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will simulate API error conditions.
     *
     * @param petId ID of pet that needs to be fetched
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the String object
     */
    Observable<ServiceResponse<String>> findPetsWithByteArrayWithServiceResponseAsync(long petId);

    /**
     * Find pet by ID.
     * Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will simulate API error conditions.
     *
     * @param petId ID of pet that needs to be fetched
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     * @return the Pet object if successful.
     */
    Pet getPetById(long petId);

    /**
     * Find pet by ID.
     * Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will simulate API error conditions.
     *
     * @param petId ID of pet that needs to be fetched
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Pet> getPetByIdAsync(long petId, final ServiceCallback<Pet> serviceCallback);

    /**
     * Find pet by ID.
     * Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will simulate API error conditions.
     *
     * @param petId ID of pet that needs to be fetched
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the Pet object
     */
    Observable<Pet> getPetByIdAsync(long petId);

    /**
     * Find pet by ID.
     * Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will simulate API error conditions.
     *
     * @param petId ID of pet that needs to be fetched
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the Pet object
     */
    Observable<ServiceResponse<Pet>> getPetByIdWithServiceResponseAsync(long petId);

    /**
     * Updates a pet in the store with form data.
     *
     * @param petId ID of pet that needs to be updated
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void updatePetWithForm(String petId);

    /**
     * Updates a pet in the store with form data.
     *
     * @param petId ID of pet that needs to be updated
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> updatePetWithFormAsync(String petId, final ServiceCallback<Void> serviceCallback);

    /**
     * Updates a pet in the store with form data.
     *
     * @param petId ID of pet that needs to be updated
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> updatePetWithFormAsync(String petId);

    /**
     * Updates a pet in the store with form data.
     *
     * @param petId ID of pet that needs to be updated
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> updatePetWithFormWithServiceResponseAsync(String petId);
    /**
     * Updates a pet in the store with form data.
     *
     * @param petId ID of pet that needs to be updated
     * @param name Updated name of the pet
     * @param status Updated status of the pet
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void updatePetWithForm(String petId, String name, String status);

    /**
     * Updates a pet in the store with form data.
     *
     * @param petId ID of pet that needs to be updated
     * @param name Updated name of the pet
     * @param status Updated status of the pet
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> updatePetWithFormAsync(String petId, String name, String status, final ServiceCallback<Void> serviceCallback);

    /**
     * Updates a pet in the store with form data.
     *
     * @param petId ID of pet that needs to be updated
     * @param name Updated name of the pet
     * @param status Updated status of the pet
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> updatePetWithFormAsync(String petId, String name, String status);

    /**
     * Updates a pet in the store with form data.
     *
     * @param petId ID of pet that needs to be updated
     * @param name Updated name of the pet
     * @param status Updated status of the pet
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> updatePetWithFormWithServiceResponseAsync(String petId, String name, String status);

    /**
     * Deletes a pet.
     *
     * @param petId Pet id to delete
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void deletePet(long petId);

    /**
     * Deletes a pet.
     *
     * @param petId Pet id to delete
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> deletePetAsync(long petId, final ServiceCallback<Void> serviceCallback);

    /**
     * Deletes a pet.
     *
     * @param petId Pet id to delete
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> deletePetAsync(long petId);

    /**
     * Deletes a pet.
     *
     * @param petId Pet id to delete
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> deletePetWithServiceResponseAsync(long petId);
    /**
     * Deletes a pet.
     *
     * @param petId Pet id to delete
     * @param apiKey the String value
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void deletePet(long petId, String apiKey);

    /**
     * Deletes a pet.
     *
     * @param petId Pet id to delete
     * @param apiKey the String value
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> deletePetAsync(long petId, String apiKey, final ServiceCallback<Void> serviceCallback);

    /**
     * Deletes a pet.
     *
     * @param petId Pet id to delete
     * @param apiKey the String value
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> deletePetAsync(long petId, String apiKey);

    /**
     * Deletes a pet.
     *
     * @param petId Pet id to delete
     * @param apiKey the String value
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> deletePetWithServiceResponseAsync(long petId, String apiKey);

    /**
     * uploads an image.
     *
     * @param petId ID of pet to update
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void uploadFile(long petId);

    /**
     * uploads an image.
     *
     * @param petId ID of pet to update
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> uploadFileAsync(long petId, final ServiceCallback<Void> serviceCallback);

    /**
     * uploads an image.
     *
     * @param petId ID of pet to update
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> uploadFileAsync(long petId);

    /**
     * uploads an image.
     *
     * @param petId ID of pet to update
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> uploadFileWithServiceResponseAsync(long petId);
    /**
     * uploads an image.
     *
     * @param petId ID of pet to update
     * @param additionalMetadata Additional data to pass to server
     * @param file file to upload
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void uploadFile(long petId, String additionalMetadata, byte[] file);

    /**
     * uploads an image.
     *
     * @param petId ID of pet to update
     * @param additionalMetadata Additional data to pass to server
     * @param file file to upload
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> uploadFileAsync(long petId, String additionalMetadata, byte[] file, final ServiceCallback<Void> serviceCallback);

    /**
     * uploads an image.
     *
     * @param petId ID of pet to update
     * @param additionalMetadata Additional data to pass to server
     * @param file file to upload
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> uploadFileAsync(long petId, String additionalMetadata, byte[] file);

    /**
     * uploads an image.
     *
     * @param petId ID of pet to update
     * @param additionalMetadata Additional data to pass to server
     * @param file file to upload
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> uploadFileWithServiceResponseAsync(long petId, String additionalMetadata, byte[] file);

    /**
     * Returns pet inventories by status.
     * Returns a map of status codes to quantities.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     * @return the Map&lt;String, Integer&gt; object if successful.
     */
    Map<String, Integer> getInventory();

    /**
     * Returns pet inventories by status.
     * Returns a map of status codes to quantities.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Map<String, Integer>> getInventoryAsync(final ServiceCallback<Map<String, Integer>> serviceCallback);

    /**
     * Returns pet inventories by status.
     * Returns a map of status codes to quantities.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the Map&lt;String, Integer&gt; object
     */
    Observable<Map<String, Integer>> getInventoryAsync();

    /**
     * Returns pet inventories by status.
     * Returns a map of status codes to quantities.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the Map&lt;String, Integer&gt; object
     */
    Observable<ServiceResponse<Map<String, Integer>>> getInventoryWithServiceResponseAsync();

    /**
     * Place an order for a pet.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     * @return the Order object if successful.
     */
    Order placeOrder();

    /**
     * Place an order for a pet.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Order> placeOrderAsync(final ServiceCallback<Order> serviceCallback);

    /**
     * Place an order for a pet.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the Order object
     */
    Observable<Order> placeOrderAsync();

    /**
     * Place an order for a pet.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the Order object
     */
    Observable<ServiceResponse<Order>> placeOrderWithServiceResponseAsync();
    /**
     * Place an order for a pet.
     *
     * @param body order placed for purchasing the pet
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     * @return the Order object if successful.
     */
    Order placeOrder(Order body);

    /**
     * Place an order for a pet.
     *
     * @param body order placed for purchasing the pet
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Order> placeOrderAsync(Order body, final ServiceCallback<Order> serviceCallback);

    /**
     * Place an order for a pet.
     *
     * @param body order placed for purchasing the pet
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the Order object
     */
    Observable<Order> placeOrderAsync(Order body);

    /**
     * Place an order for a pet.
     *
     * @param body order placed for purchasing the pet
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the Order object
     */
    Observable<ServiceResponse<Order>> placeOrderWithServiceResponseAsync(Order body);

    /**
     * Find purchase order by ID.
     * For valid response try integer IDs with value &lt;= 5 or &gt; 10. Other values will generated exceptions.
     *
     * @param orderId ID of pet that needs to be fetched
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     * @return the Order object if successful.
     */
    Order getOrderById(String orderId);

    /**
     * Find purchase order by ID.
     * For valid response try integer IDs with value &lt;= 5 or &gt; 10. Other values will generated exceptions.
     *
     * @param orderId ID of pet that needs to be fetched
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Order> getOrderByIdAsync(String orderId, final ServiceCallback<Order> serviceCallback);

    /**
     * Find purchase order by ID.
     * For valid response try integer IDs with value &lt;= 5 or &gt; 10. Other values will generated exceptions.
     *
     * @param orderId ID of pet that needs to be fetched
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the Order object
     */
    Observable<Order> getOrderByIdAsync(String orderId);

    /**
     * Find purchase order by ID.
     * For valid response try integer IDs with value &lt;= 5 or &gt; 10. Other values will generated exceptions.
     *
     * @param orderId ID of pet that needs to be fetched
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the Order object
     */
    Observable<ServiceResponse<Order>> getOrderByIdWithServiceResponseAsync(String orderId);

    /**
     * Delete purchase order by ID.
     * For valid response try integer IDs with value &lt; 1000. Anything above 1000 or nonintegers will generate API errors.
     *
     * @param orderId ID of the order that needs to be deleted
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void deleteOrder(String orderId);

    /**
     * Delete purchase order by ID.
     * For valid response try integer IDs with value &lt; 1000. Anything above 1000 or nonintegers will generate API errors.
     *
     * @param orderId ID of the order that needs to be deleted
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> deleteOrderAsync(String orderId, final ServiceCallback<Void> serviceCallback);

    /**
     * Delete purchase order by ID.
     * For valid response try integer IDs with value &lt; 1000. Anything above 1000 or nonintegers will generate API errors.
     *
     * @param orderId ID of the order that needs to be deleted
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> deleteOrderAsync(String orderId);

    /**
     * Delete purchase order by ID.
     * For valid response try integer IDs with value &lt; 1000. Anything above 1000 or nonintegers will generate API errors.
     *
     * @param orderId ID of the order that needs to be deleted
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> deleteOrderWithServiceResponseAsync(String orderId);

    /**
     * Create user.
     * This can only be done by the logged in user.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void createUser();

    /**
     * Create user.
     * This can only be done by the logged in user.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> createUserAsync(final ServiceCallback<Void> serviceCallback);

    /**
     * Create user.
     * This can only be done by the logged in user.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> createUserAsync();

    /**
     * Create user.
     * This can only be done by the logged in user.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> createUserWithServiceResponseAsync();
    /**
     * Create user.
     * This can only be done by the logged in user.
     *
     * @param body Created user object
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void createUser(User body);

    /**
     * Create user.
     * This can only be done by the logged in user.
     *
     * @param body Created user object
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> createUserAsync(User body, final ServiceCallback<Void> serviceCallback);

    /**
     * Create user.
     * This can only be done by the logged in user.
     *
     * @param body Created user object
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> createUserAsync(User body);

    /**
     * Create user.
     * This can only be done by the logged in user.
     *
     * @param body Created user object
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> createUserWithServiceResponseAsync(User body);

    /**
     * Creates list of users with given input array.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void createUsersWithArrayInput();

    /**
     * Creates list of users with given input array.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> createUsersWithArrayInputAsync(final ServiceCallback<Void> serviceCallback);

    /**
     * Creates list of users with given input array.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> createUsersWithArrayInputAsync();

    /**
     * Creates list of users with given input array.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> createUsersWithArrayInputWithServiceResponseAsync();
    /**
     * Creates list of users with given input array.
     *
     * @param body List of user object
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void createUsersWithArrayInput(List<User> body);

    /**
     * Creates list of users with given input array.
     *
     * @param body List of user object
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> createUsersWithArrayInputAsync(List<User> body, final ServiceCallback<Void> serviceCallback);

    /**
     * Creates list of users with given input array.
     *
     * @param body List of user object
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> createUsersWithArrayInputAsync(List<User> body);

    /**
     * Creates list of users with given input array.
     *
     * @param body List of user object
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> createUsersWithArrayInputWithServiceResponseAsync(List<User> body);

    /**
     * Creates list of users with given input array.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void createUsersWithListInput();

    /**
     * Creates list of users with given input array.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> createUsersWithListInputAsync(final ServiceCallback<Void> serviceCallback);

    /**
     * Creates list of users with given input array.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> createUsersWithListInputAsync();

    /**
     * Creates list of users with given input array.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> createUsersWithListInputWithServiceResponseAsync();
    /**
     * Creates list of users with given input array.
     *
     * @param body List of user object
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void createUsersWithListInput(List<User> body);

    /**
     * Creates list of users with given input array.
     *
     * @param body List of user object
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> createUsersWithListInputAsync(List<User> body, final ServiceCallback<Void> serviceCallback);

    /**
     * Creates list of users with given input array.
     *
     * @param body List of user object
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> createUsersWithListInputAsync(List<User> body);

    /**
     * Creates list of users with given input array.
     *
     * @param body List of user object
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> createUsersWithListInputWithServiceResponseAsync(List<User> body);

    /**
     * Logs user into the system.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     * @return the String object if successful.
     */
    String loginUser();

    /**
     * Logs user into the system.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<String> loginUserAsync(final ServiceCallback<String> serviceCallback);

    /**
     * Logs user into the system.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the String object
     */
    Observable<String> loginUserAsync();

    /**
     * Logs user into the system.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the String object
     */
    Observable<ServiceResponse<String>> loginUserWithServiceResponseAsync();
    /**
     * Logs user into the system.
     *
     * @param username The user name for login
     * @param password The password for login in clear text
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     * @return the String object if successful.
     */
    String loginUser(String username, String password);

    /**
     * Logs user into the system.
     *
     * @param username The user name for login
     * @param password The password for login in clear text
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<String> loginUserAsync(String username, String password, final ServiceCallback<String> serviceCallback);

    /**
     * Logs user into the system.
     *
     * @param username The user name for login
     * @param password The password for login in clear text
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the String object
     */
    Observable<String> loginUserAsync(String username, String password);

    /**
     * Logs user into the system.
     *
     * @param username The user name for login
     * @param password The password for login in clear text
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the String object
     */
    Observable<ServiceResponse<String>> loginUserWithServiceResponseAsync(String username, String password);

    /**
     * Logs out current logged in user session.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void logoutUser();

    /**
     * Logs out current logged in user session.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> logoutUserAsync(final ServiceCallback<Void> serviceCallback);

    /**
     * Logs out current logged in user session.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> logoutUserAsync();

    /**
     * Logs out current logged in user session.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> logoutUserWithServiceResponseAsync();

    /**
     * Get user by user name.
     *
     * @param username The name that needs to be fetched. Use user1 for testing.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     * @return the User object if successful.
     */
    User getUserByName(String username);

    /**
     * Get user by user name.
     *
     * @param username The name that needs to be fetched. Use user1 for testing.
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<User> getUserByNameAsync(String username, final ServiceCallback<User> serviceCallback);

    /**
     * Get user by user name.
     *
     * @param username The name that needs to be fetched. Use user1 for testing.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the User object
     */
    Observable<User> getUserByNameAsync(String username);

    /**
     * Get user by user name.
     *
     * @param username The name that needs to be fetched. Use user1 for testing.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the User object
     */
    Observable<ServiceResponse<User>> getUserByNameWithServiceResponseAsync(String username);

    /**
     * Updated user.
     * This can only be done by the logged in user.
     *
     * @param username name that need to be deleted
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void updateUser(String username);

    /**
     * Updated user.
     * This can only be done by the logged in user.
     *
     * @param username name that need to be deleted
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> updateUserAsync(String username, final ServiceCallback<Void> serviceCallback);

    /**
     * Updated user.
     * This can only be done by the logged in user.
     *
     * @param username name that need to be deleted
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> updateUserAsync(String username);

    /**
     * Updated user.
     * This can only be done by the logged in user.
     *
     * @param username name that need to be deleted
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> updateUserWithServiceResponseAsync(String username);
    /**
     * Updated user.
     * This can only be done by the logged in user.
     *
     * @param username name that need to be deleted
     * @param body Updated user object
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void updateUser(String username, User body);

    /**
     * Updated user.
     * This can only be done by the logged in user.
     *
     * @param username name that need to be deleted
     * @param body Updated user object
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> updateUserAsync(String username, User body, final ServiceCallback<Void> serviceCallback);

    /**
     * Updated user.
     * This can only be done by the logged in user.
     *
     * @param username name that need to be deleted
     * @param body Updated user object
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> updateUserAsync(String username, User body);

    /**
     * Updated user.
     * This can only be done by the logged in user.
     *
     * @param username name that need to be deleted
     * @param body Updated user object
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> updateUserWithServiceResponseAsync(String username, User body);

    /**
     * Delete user.
     * This can only be done by the logged in user.
     *
     * @param username The name that needs to be deleted
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void deleteUser(String username);

    /**
     * Delete user.
     * This can only be done by the logged in user.
     *
     * @param username The name that needs to be deleted
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> deleteUserAsync(String username, final ServiceCallback<Void> serviceCallback);

    /**
     * Delete user.
     * This can only be done by the logged in user.
     *
     * @param username The name that needs to be deleted
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> deleteUserAsync(String username);

    /**
     * Delete user.
     * This can only be done by the logged in user.
     *
     * @param username The name that needs to be deleted
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> deleteUserWithServiceResponseAsync(String username);

}
