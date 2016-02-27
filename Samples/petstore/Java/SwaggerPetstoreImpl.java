/**
 */

package petstore;

import com.microsoft.rest.ServiceClient;
import com.microsoft.rest.AutoRestBaseUrl;
import okhttp3.OkHttpClient;
import retrofit2.Retrofit;
import okhttp3.logging.HttpLoggingInterceptor.Level;
import com.google.common.reflect.TypeToken;
import com.microsoft.rest.serializer.CollectionFormat;
import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceException;
import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.ServiceResponseBuilder;
import com.microsoft.rest.ServiceResponseCallback;
import com.microsoft.rest.Validator;
import java.io.InputStream;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import okhttp3.ResponseBody;
import petstore.models.Order;
import petstore.models.Pet;
import petstore.models.User;
import retrofit2.Call;
import retrofit2.Response;

/**
 * Initializes a new instance of the SwaggerPetstore class.
 */
public final class SwaggerPetstoreImpl extends ServiceClient implements SwaggerPetstore {
    /**
     * The Retrofit service to perform REST calls.
     */
    private SwaggerPetstoreService service;
    /**
     * The URL used as the base for all cloud service requests.
     */
    private final AutoRestBaseUrl baseUrl;

    /**
     * Gets the URL used as the base for all cloud service requests.
     *
     * @return The BaseUrl value.
     */
    public AutoRestBaseUrl getBaseUrl() {
        return this.baseUrl;
    }

    /**
     * Initializes an instance of SwaggerPetstore client.
     */
    public SwaggerPetstoreImpl() {
        this("http://petstore.swagger.io/v2");
    }

    /**
     * Initializes an instance of SwaggerPetstore client.
     *
     * @param baseUrl the base URL of the host
     */
    public SwaggerPetstoreImpl(String baseUrl) {
        super();
        this.baseUrl = new AutoRestBaseUrl(baseUrl);
        initialize();
    }

    /**
     * Initializes an instance of SwaggerPetstore client.
     *
     * @param baseUrl the base URL of the host
     * @param clientBuilder the builder for building up an {@link OkHttpClient}
     * @param retrofitBuilder the builder for building up a {@link Retrofit}
     */
    public SwaggerPetstoreImpl(String baseUrl, OkHttpClient.Builder clientBuilder, Retrofit.Builder retrofitBuilder) {
        super(clientBuilder, retrofitBuilder);
        this.baseUrl = new AutoRestBaseUrl(baseUrl);
        initialize();
    }

    @Override
    protected void initialize() {
        super.initialize();
        this.retrofitBuilder.baseUrl(baseUrl);
        initializeService();
    }

    private void initializeService() {
        service = this.retrofitBuilder.client(this.clientBuilder.build())
                .build()
                .create(SwaggerPetstoreService.class);
    }

    /**
     * Sets the logging level for OkHttp client.
     *
     * @param logLevel the logging level enum
     */
    @Override
    public void setLogLevel(Level logLevel) {
        super.setLogLevel(logLevel);
        initializeService();
    }

    /**
     * Fake endpoint to test byte array in body parameter for adding a new pet to the store.
     *
     * @param body Pet object in the form of byte array
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    public ServiceResponse<Void> addPetUsingByteArray(String body) throws ServiceException, IOException {
        Call<ResponseBody> call = service.addPetUsingByteArray(body);
        return addPetUsingByteArrayDelegate(call.execute());
    }

    /**
     * Fake endpoint to test byte array in body parameter for adding a new pet to the store.
     *
     * @param body Pet object in the form of byte array
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public Call<ResponseBody> addPetUsingByteArrayAsync(String body, final ServiceCallback<Void> serviceCallback) {
        Call<ResponseBody> call = service.addPetUsingByteArray(body);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    serviceCallback.success(addPetUsingByteArrayDelegate(response));
                } catch (ServiceException | IOException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<Void> addPetUsingByteArrayDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>()
                .register(405, new TypeToken<Void>() { }.getType())
                .build(response);
    }

    /**
     * Add a new pet to the store.
     *
     * @param body Pet object that needs to be added to the store
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    public ServiceResponse<Void> addPet(Pet body) throws ServiceException, IOException {
        Validator.validate(body);
        Call<ResponseBody> call = service.addPet(body);
        return addPetDelegate(call.execute());
    }

    /**
     * Add a new pet to the store.
     *
     * @param body Pet object that needs to be added to the store
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public Call<ResponseBody> addPetAsync(Pet body, final ServiceCallback<Void> serviceCallback) {
        Validator.validate(body, serviceCallback);
        Call<ResponseBody> call = service.addPet(body);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    serviceCallback.success(addPetDelegate(response));
                } catch (ServiceException | IOException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<Void> addPetDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>()
                .register(405, new TypeToken<Void>() { }.getType())
                .build(response);
    }

    /**
     * Update an existing pet.
     *
     * @param body Pet object that needs to be added to the store
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    public ServiceResponse<Void> updatePet(Pet body) throws ServiceException, IOException {
        Validator.validate(body);
        Call<ResponseBody> call = service.updatePet(body);
        return updatePetDelegate(call.execute());
    }

    /**
     * Update an existing pet.
     *
     * @param body Pet object that needs to be added to the store
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public Call<ResponseBody> updatePetAsync(Pet body, final ServiceCallback<Void> serviceCallback) {
        Validator.validate(body, serviceCallback);
        Call<ResponseBody> call = service.updatePet(body);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    serviceCallback.success(updatePetDelegate(response));
                } catch (ServiceException | IOException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<Void> updatePetDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>()
                .register(405, new TypeToken<Void>() { }.getType())
                .register(404, new TypeToken<Void>() { }.getType())
                .register(400, new TypeToken<Void>() { }.getType())
                .build(response);
    }

    /**
     * Finds Pets by status.
     * Multiple status values can be provided with comma seperated strings.
     *
     * @param status Status values that need to be considered for filter
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the List&lt;Pet&gt; object wrapped in {@link ServiceResponse} if successful.
     */
    public ServiceResponse<List<Pet>> findPetsByStatus(List<String> status) throws ServiceException, IOException {
        Validator.validate(status);
        Call<ResponseBody> call = service.findPetsByStatus(.getMapperAdapter().serializeList(status, CollectionFormat.CSV));
        return findPetsByStatusDelegate(call.execute());
    }

    /**
     * Finds Pets by status.
     * Multiple status values can be provided with comma seperated strings.
     *
     * @param status Status values that need to be considered for filter
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public Call<ResponseBody> findPetsByStatusAsync(List<String> status, final ServiceCallback<List<Pet>> serviceCallback) {
        Validator.validate(status, serviceCallback);
        Call<ResponseBody> call = service.findPetsByStatus(.getMapperAdapter().serializeList(status, CollectionFormat.CSV));
        call.enqueue(new ServiceResponseCallback<List<Pet>>(serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    serviceCallback.success(findPetsByStatusDelegate(response));
                } catch (ServiceException | IOException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<List<Pet>> findPetsByStatusDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<List<Pet>, ServiceException>()
                .register(200, new TypeToken<List<Pet>>() { }.getType())
                .register(400, new TypeToken<Void>() { }.getType())
                .build(response);
    }

    /**
     * Finds Pets by tags.
     * Muliple tags can be provided with comma seperated strings. Use tag1, tag2, tag3 for testing.
     *
     * @param tags Tags to filter by
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the List&lt;Pet&gt; object wrapped in {@link ServiceResponse} if successful.
     */
    public ServiceResponse<List<Pet>> findPetsByTags(List<String> tags) throws ServiceException, IOException {
        Validator.validate(tags);
        Call<ResponseBody> call = service.findPetsByTags(.getMapperAdapter().serializeList(tags, CollectionFormat.CSV));
        return findPetsByTagsDelegate(call.execute());
    }

    /**
     * Finds Pets by tags.
     * Muliple tags can be provided with comma seperated strings. Use tag1, tag2, tag3 for testing.
     *
     * @param tags Tags to filter by
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public Call<ResponseBody> findPetsByTagsAsync(List<String> tags, final ServiceCallback<List<Pet>> serviceCallback) {
        Validator.validate(tags, serviceCallback);
        Call<ResponseBody> call = service.findPetsByTags(.getMapperAdapter().serializeList(tags, CollectionFormat.CSV));
        call.enqueue(new ServiceResponseCallback<List<Pet>>(serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    serviceCallback.success(findPetsByTagsDelegate(response));
                } catch (ServiceException | IOException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<List<Pet>> findPetsByTagsDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<List<Pet>, ServiceException>()
                .register(200, new TypeToken<List<Pet>>() { }.getType())
                .register(400, new TypeToken<Void>() { }.getType())
                .build(response);
    }

    /**
     * Fake endpoint to test byte array return by 'Find pet by ID'.
     * Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will simulate API error conditions.
     *
     * @param petId ID of pet that needs to be fetched
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the String object wrapped in {@link ServiceResponse} if successful.
     */
    public ServiceResponse<String> findPetsWithByteArray(long petId) throws ServiceException, IOException {
        Call<ResponseBody> call = service.findPetsWithByteArray(petId);
        return findPetsWithByteArrayDelegate(call.execute());
    }

    /**
     * Fake endpoint to test byte array return by 'Find pet by ID'.
     * Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will simulate API error conditions.
     *
     * @param petId ID of pet that needs to be fetched
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public Call<ResponseBody> findPetsWithByteArrayAsync(long petId, final ServiceCallback<String> serviceCallback) {
        Call<ResponseBody> call = service.findPetsWithByteArray(petId);
        call.enqueue(new ServiceResponseCallback<String>(serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    serviceCallback.success(findPetsWithByteArrayDelegate(response));
                } catch (ServiceException | IOException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<String> findPetsWithByteArrayDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<String, ServiceException>()
                .register(404, new TypeToken<Void>() { }.getType())
                .register(200, new TypeToken<String>() { }.getType())
                .register(400, new TypeToken<Void>() { }.getType())
                .build(response);
    }

    /**
     * Find pet by ID.
     * Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will simulate API error conditions.
     *
     * @param petId ID of pet that needs to be fetched
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the Pet object wrapped in {@link ServiceResponse} if successful.
     */
    public ServiceResponse<Pet> getPetById(long petId) throws ServiceException, IOException {
        Call<ResponseBody> call = service.getPetById(petId);
        return getPetByIdDelegate(call.execute());
    }

    /**
     * Find pet by ID.
     * Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will simulate API error conditions.
     *
     * @param petId ID of pet that needs to be fetched
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public Call<ResponseBody> getPetByIdAsync(long petId, final ServiceCallback<Pet> serviceCallback) {
        Call<ResponseBody> call = service.getPetById(petId);
        call.enqueue(new ServiceResponseCallback<Pet>(serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    serviceCallback.success(getPetByIdDelegate(response));
                } catch (ServiceException | IOException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<Pet> getPetByIdDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Pet, ServiceException>()
                .register(404, new TypeToken<Void>() { }.getType())
                .register(200, new TypeToken<Pet>() { }.getType())
                .register(400, new TypeToken<Void>() { }.getType())
                .build(response);
    }

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
    public ServiceResponse<Void> updatePetWithForm(String petId, String name, String status) throws ServiceException, IOException, IllegalArgumentException {
        if (petId == null) {
            throw new IllegalArgumentException("Parameter petId is required and cannot be null.");
        }
        Call<ResponseBody> call = service.updatePetWithForm(petId, name, status);
        return updatePetWithFormDelegate(call.execute());
    }

    /**
     * Updates a pet in the store with form data.
     *
     * @param petId ID of pet that needs to be updated
     * @param name Updated name of the pet
     * @param status Updated status of the pet
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public Call<ResponseBody> updatePetWithFormAsync(String petId, String name, String status, final ServiceCallback<Void> serviceCallback) {
        if (petId == null) {
            serviceCallback.failure(new IllegalArgumentException("Parameter petId is required and cannot be null."));
            return null;
        }
        Call<ResponseBody> call = service.updatePetWithForm(petId, name, status);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    serviceCallback.success(updatePetWithFormDelegate(response));
                } catch (ServiceException | IOException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<Void> updatePetWithFormDelegate(Response<ResponseBody> response) throws ServiceException, IOException, IllegalArgumentException {
        return new ServiceResponseBuilder<Void, ServiceException>()
                .register(405, new TypeToken<Void>() { }.getType())
                .build(response);
    }

    /**
     * Deletes a pet.
     *
     * @param petId Pet id to delete
     * @param apiKey 
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    public ServiceResponse<Void> deletePet(long petId, String apiKey) throws ServiceException, IOException {
        Call<ResponseBody> call = service.deletePet(petId, apiKey);
        return deletePetDelegate(call.execute());
    }

    /**
     * Deletes a pet.
     *
     * @param petId Pet id to delete
     * @param apiKey 
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public Call<ResponseBody> deletePetAsync(long petId, String apiKey, final ServiceCallback<Void> serviceCallback) {
        Call<ResponseBody> call = service.deletePet(petId, apiKey);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    serviceCallback.success(deletePetDelegate(response));
                } catch (ServiceException | IOException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<Void> deletePetDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>()
                .register(400, new TypeToken<Void>() { }.getType())
                .build(response);
    }

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
    public ServiceResponse<Void> uploadFile(long petId, String additionalMetadata, InputStream file) throws ServiceException, IOException {
        Call<ResponseBody> call = service.uploadFile(petId, additionalMetadata, file);
        return uploadFileDelegate(call.execute());
    }

    /**
     * uploads an image.
     *
     * @param petId ID of pet to update
     * @param additionalMetadata Additional data to pass to server
     * @param file file to upload
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public Call<ResponseBody> uploadFileAsync(long petId, String additionalMetadata, InputStream file, final ServiceCallback<Void> serviceCallback) {
        Call<ResponseBody> call = service.uploadFile(petId, additionalMetadata, file);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    serviceCallback.success(uploadFileDelegate(response));
                } catch (ServiceException | IOException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<Void> uploadFileDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>()
                .build(response);
    }

    /**
     * Returns pet inventories by status.
     * Returns a map of status codes to quantities.
     *
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the Map&lt;String, Integer&gt; object wrapped in {@link ServiceResponse} if successful.
     */
    public ServiceResponse<Map<String, Integer>> getInventory() throws ServiceException, IOException {
        Call<ResponseBody> call = service.getInventory();
        return getInventoryDelegate(call.execute());
    }

    /**
     * Returns pet inventories by status.
     * Returns a map of status codes to quantities.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public Call<ResponseBody> getInventoryAsync(final ServiceCallback<Map<String, Integer>> serviceCallback) {
        Call<ResponseBody> call = service.getInventory();
        call.enqueue(new ServiceResponseCallback<Map<String, Integer>>(serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    serviceCallback.success(getInventoryDelegate(response));
                } catch (ServiceException | IOException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<Map<String, Integer>> getInventoryDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Map<String, Integer>, ServiceException>()
                .register(200, new TypeToken<Map<String, Integer>>() { }.getType())
                .build(response);
    }

    /**
     * Place an order for a pet.
     *
     * @param body order placed for purchasing the pet
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the Order object wrapped in {@link ServiceResponse} if successful.
     */
    public ServiceResponse<Order> placeOrder(Order body) throws ServiceException, IOException {
        Validator.validate(body);
        Call<ResponseBody> call = service.placeOrder(body);
        return placeOrderDelegate(call.execute());
    }

    /**
     * Place an order for a pet.
     *
     * @param body order placed for purchasing the pet
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public Call<ResponseBody> placeOrderAsync(Order body, final ServiceCallback<Order> serviceCallback) {
        Validator.validate(body, serviceCallback);
        Call<ResponseBody> call = service.placeOrder(body);
        call.enqueue(new ServiceResponseCallback<Order>(serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    serviceCallback.success(placeOrderDelegate(response));
                } catch (ServiceException | IOException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<Order> placeOrderDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Order, ServiceException>()
                .register(200, new TypeToken<Order>() { }.getType())
                .register(400, new TypeToken<Void>() { }.getType())
                .build(response);
    }

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
    public ServiceResponse<Order> getOrderById(String orderId) throws ServiceException, IOException, IllegalArgumentException {
        if (orderId == null) {
            throw new IllegalArgumentException("Parameter orderId is required and cannot be null.");
        }
        Call<ResponseBody> call = service.getOrderById(orderId);
        return getOrderByIdDelegate(call.execute());
    }

    /**
     * Find purchase order by ID.
     * For valid response try integer IDs with value &lt;= 5 or &gt; 10. Other values will generated exceptions.
     *
     * @param orderId ID of pet that needs to be fetched
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public Call<ResponseBody> getOrderByIdAsync(String orderId, final ServiceCallback<Order> serviceCallback) {
        if (orderId == null) {
            serviceCallback.failure(new IllegalArgumentException("Parameter orderId is required and cannot be null."));
            return null;
        }
        Call<ResponseBody> call = service.getOrderById(orderId);
        call.enqueue(new ServiceResponseCallback<Order>(serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    serviceCallback.success(getOrderByIdDelegate(response));
                } catch (ServiceException | IOException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<Order> getOrderByIdDelegate(Response<ResponseBody> response) throws ServiceException, IOException, IllegalArgumentException {
        return new ServiceResponseBuilder<Order, ServiceException>()
                .register(404, new TypeToken<Void>() { }.getType())
                .register(200, new TypeToken<Order>() { }.getType())
                .register(400, new TypeToken<Void>() { }.getType())
                .build(response);
    }

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
    public ServiceResponse<Void> deleteOrder(String orderId) throws ServiceException, IOException, IllegalArgumentException {
        if (orderId == null) {
            throw new IllegalArgumentException("Parameter orderId is required and cannot be null.");
        }
        Call<ResponseBody> call = service.deleteOrder(orderId);
        return deleteOrderDelegate(call.execute());
    }

    /**
     * Delete purchase order by ID.
     * For valid response try integer IDs with value &lt; 1000. Anything above 1000 or nonintegers will generate API errors.
     *
     * @param orderId ID of the order that needs to be deleted
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public Call<ResponseBody> deleteOrderAsync(String orderId, final ServiceCallback<Void> serviceCallback) {
        if (orderId == null) {
            serviceCallback.failure(new IllegalArgumentException("Parameter orderId is required and cannot be null."));
            return null;
        }
        Call<ResponseBody> call = service.deleteOrder(orderId);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    serviceCallback.success(deleteOrderDelegate(response));
                } catch (ServiceException | IOException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<Void> deleteOrderDelegate(Response<ResponseBody> response) throws ServiceException, IOException, IllegalArgumentException {
        return new ServiceResponseBuilder<Void, ServiceException>()
                .register(404, new TypeToken<Void>() { }.getType())
                .register(400, new TypeToken<Void>() { }.getType())
                .build(response);
    }

    /**
     * Create user.
     * This can only be done by the logged in user.
     *
     * @param body Created user object
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    public ServiceResponse<Void> createUser(User body) throws ServiceException, IOException {
        Validator.validate(body);
        Call<ResponseBody> call = service.createUser(body);
        return createUserDelegate(call.execute());
    }

    /**
     * Create user.
     * This can only be done by the logged in user.
     *
     * @param body Created user object
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public Call<ResponseBody> createUserAsync(User body, final ServiceCallback<Void> serviceCallback) {
        Validator.validate(body, serviceCallback);
        Call<ResponseBody> call = service.createUser(body);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    serviceCallback.success(createUserDelegate(response));
                } catch (ServiceException | IOException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<Void> createUserDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>()
                .build(response);
    }

    /**
     * Creates list of users with given input array.
     *
     * @param body List of user object
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    public ServiceResponse<Void> createUsersWithArrayInput(List<User> body) throws ServiceException, IOException {
        Validator.validate(body);
        Call<ResponseBody> call = service.createUsersWithArrayInput(body);
        return createUsersWithArrayInputDelegate(call.execute());
    }

    /**
     * Creates list of users with given input array.
     *
     * @param body List of user object
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public Call<ResponseBody> createUsersWithArrayInputAsync(List<User> body, final ServiceCallback<Void> serviceCallback) {
        Validator.validate(body, serviceCallback);
        Call<ResponseBody> call = service.createUsersWithArrayInput(body);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    serviceCallback.success(createUsersWithArrayInputDelegate(response));
                } catch (ServiceException | IOException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<Void> createUsersWithArrayInputDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>()
                .build(response);
    }

    /**
     * Creates list of users with given input array.
     *
     * @param body List of user object
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    public ServiceResponse<Void> createUsersWithListInput(List<User> body) throws ServiceException, IOException {
        Validator.validate(body);
        Call<ResponseBody> call = service.createUsersWithListInput(body);
        return createUsersWithListInputDelegate(call.execute());
    }

    /**
     * Creates list of users with given input array.
     *
     * @param body List of user object
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public Call<ResponseBody> createUsersWithListInputAsync(List<User> body, final ServiceCallback<Void> serviceCallback) {
        Validator.validate(body, serviceCallback);
        Call<ResponseBody> call = service.createUsersWithListInput(body);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    serviceCallback.success(createUsersWithListInputDelegate(response));
                } catch (ServiceException | IOException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<Void> createUsersWithListInputDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>()
                .build(response);
    }

    /**
     * Logs user into the system.
     *
     * @param username The user name for login
     * @param password The password for login in clear text
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the String object wrapped in {@link ServiceResponse} if successful.
     */
    public ServiceResponse<String> loginUser(String username, String password) throws ServiceException, IOException {
        Call<ResponseBody> call = service.loginUser(username, password);
        return loginUserDelegate(call.execute());
    }

    /**
     * Logs user into the system.
     *
     * @param username The user name for login
     * @param password The password for login in clear text
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public Call<ResponseBody> loginUserAsync(String username, String password, final ServiceCallback<String> serviceCallback) {
        Call<ResponseBody> call = service.loginUser(username, password);
        call.enqueue(new ServiceResponseCallback<String>(serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    serviceCallback.success(loginUserDelegate(response));
                } catch (ServiceException | IOException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<String> loginUserDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<String, ServiceException>()
                .register(200, new TypeToken<String>() { }.getType())
                .register(400, new TypeToken<Void>() { }.getType())
                .build(response);
    }

    /**
     * Logs out current logged in user session.
     *
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    public ServiceResponse<Void> logoutUser() throws ServiceException, IOException {
        Call<ResponseBody> call = service.logoutUser();
        return logoutUserDelegate(call.execute());
    }

    /**
     * Logs out current logged in user session.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public Call<ResponseBody> logoutUserAsync(final ServiceCallback<Void> serviceCallback) {
        Call<ResponseBody> call = service.logoutUser();
        call.enqueue(new ServiceResponseCallback<Void>(serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    serviceCallback.success(logoutUserDelegate(response));
                } catch (ServiceException | IOException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<Void> logoutUserDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>()
                .build(response);
    }

    /**
     * Get user by user name.
     *
     * @param username The name that needs to be fetched. Use user1 for testing. 
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @throws IllegalArgumentException exception thrown from invalid parameters
     * @return the User object wrapped in {@link ServiceResponse} if successful.
     */
    public ServiceResponse<User> getUserByName(String username) throws ServiceException, IOException, IllegalArgumentException {
        if (username == null) {
            throw new IllegalArgumentException("Parameter username is required and cannot be null.");
        }
        Call<ResponseBody> call = service.getUserByName(username);
        return getUserByNameDelegate(call.execute());
    }

    /**
     * Get user by user name.
     *
     * @param username The name that needs to be fetched. Use user1 for testing. 
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public Call<ResponseBody> getUserByNameAsync(String username, final ServiceCallback<User> serviceCallback) {
        if (username == null) {
            serviceCallback.failure(new IllegalArgumentException("Parameter username is required and cannot be null."));
            return null;
        }
        Call<ResponseBody> call = service.getUserByName(username);
        call.enqueue(new ServiceResponseCallback<User>(serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    serviceCallback.success(getUserByNameDelegate(response));
                } catch (ServiceException | IOException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<User> getUserByNameDelegate(Response<ResponseBody> response) throws ServiceException, IOException, IllegalArgumentException {
        return new ServiceResponseBuilder<User, ServiceException>()
                .register(404, new TypeToken<Void>() { }.getType())
                .register(200, new TypeToken<User>() { }.getType())
                .register(400, new TypeToken<Void>() { }.getType())
                .build(response);
    }

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
    public ServiceResponse<Void> updateUser(String username, User body) throws ServiceException, IOException, IllegalArgumentException {
        if (username == null) {
            throw new IllegalArgumentException("Parameter username is required and cannot be null.");
        }
        Validator.validate(body);
        Call<ResponseBody> call = service.updateUser(username, body);
        return updateUserDelegate(call.execute());
    }

    /**
     * Updated user.
     * This can only be done by the logged in user.
     *
     * @param username name that need to be deleted
     * @param body Updated user object
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public Call<ResponseBody> updateUserAsync(String username, User body, final ServiceCallback<Void> serviceCallback) {
        if (username == null) {
            serviceCallback.failure(new IllegalArgumentException("Parameter username is required and cannot be null."));
            return null;
        }
        Validator.validate(body, serviceCallback);
        Call<ResponseBody> call = service.updateUser(username, body);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    serviceCallback.success(updateUserDelegate(response));
                } catch (ServiceException | IOException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<Void> updateUserDelegate(Response<ResponseBody> response) throws ServiceException, IOException, IllegalArgumentException {
        return new ServiceResponseBuilder<Void, ServiceException>()
                .register(404, new TypeToken<Void>() { }.getType())
                .register(400, new TypeToken<Void>() { }.getType())
                .build(response);
    }

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
    public ServiceResponse<Void> deleteUser(String username) throws ServiceException, IOException, IllegalArgumentException {
        if (username == null) {
            throw new IllegalArgumentException("Parameter username is required and cannot be null.");
        }
        Call<ResponseBody> call = service.deleteUser(username);
        return deleteUserDelegate(call.execute());
    }

    /**
     * Delete user.
     * This can only be done by the logged in user.
     *
     * @param username The name that needs to be deleted
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public Call<ResponseBody> deleteUserAsync(String username, final ServiceCallback<Void> serviceCallback) {
        if (username == null) {
            serviceCallback.failure(new IllegalArgumentException("Parameter username is required and cannot be null."));
            return null;
        }
        Call<ResponseBody> call = service.deleteUser(username);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    serviceCallback.success(deleteUserDelegate(response));
                } catch (ServiceException | IOException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<Void> deleteUserDelegate(Response<ResponseBody> response) throws ServiceException, IOException, IllegalArgumentException {
        return new ServiceResponseBuilder<Void, ServiceException>()
                .register(404, new TypeToken<Void>() { }.getType())
                .register(400, new TypeToken<Void>() { }.getType())
                .build(response);
    }

}
