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
import com.microsoft.rest.ServiceCall;
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
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.Header;
import retrofit2.http.Headers;
import retrofit2.http.HTTP;
import retrofit2.http.Multipart;
import retrofit2.http.Part;
import retrofit2.http.Path;
import retrofit2.http.POST;
import retrofit2.http.PUT;
import retrofit2.http.Query;
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
     * The interface defining all the services for SwaggerPetstore to be
     * used by Retrofit to perform actually REST calls.
     */
    interface SwaggerPetstoreService {
        @Headers("Content-Type: application/json; charset=utf-8")
        @POST("pet")
        Call<ResponseBody> addPetUsingByteArray(@Body String body);

        @Headers("Content-Type: application/json; charset=utf-8")
        @POST("pet")
        Call<ResponseBody> addPet(@Body Pet body);

        @Headers("Content-Type: application/json; charset=utf-8")
        @PUT("pet")
        Call<ResponseBody> updatePet(@Body Pet body);

        @Headers("Content-Type: application/json; charset=utf-8")
        @GET("pet/findByStatus")
        Call<ResponseBody> findPetsByStatus(@Query("status") String status);

        @Headers("Content-Type: application/json; charset=utf-8")
        @GET("pet/findByTags")
        Call<ResponseBody> findPetsByTags(@Query("tags") String tags);

        @Headers("Content-Type: application/json; charset=utf-8")
        @GET("pet/{petId}")
        Call<ResponseBody> findPetsWithByteArray(@Path("petId") long petId);

        @Headers("Content-Type: application/json; charset=utf-8")
        @GET("pet/{petId}")
        Call<ResponseBody> getPetById(@Path("petId") long petId);

        @Multipart
        @POST("pet/{petId}")
        Call<ResponseBody> updatePetWithForm(@Path("petId") String petId, @Part("name") String name, @Part("status") String status);

        @Headers("Content-Type: application/json; charset=utf-8")
        @HTTP(path = "pet/{petId}", method = "DELETE", hasBody = true)
        Call<ResponseBody> deletePet(@Path("petId") long petId, @Header("api_key") String apiKey);

        @Multipart
        @POST("pet/{petId}/uploadImage")
        Call<ResponseBody> uploadFile(@Path("petId") long petId, @Part("additionalMetadata") String additionalMetadata, @Part("file") RequestBody file);

        @Headers("Content-Type: application/json; charset=utf-8")
        @GET("store/inventory")
        Call<ResponseBody> getInventory();

        @Headers("Content-Type: application/json; charset=utf-8")
        @POST("store/order")
        Call<ResponseBody> placeOrder(@Body Order body);

        @Headers("Content-Type: application/json; charset=utf-8")
        @GET("store/order/{orderId}")
        Call<ResponseBody> getOrderById(@Path("orderId") String orderId);

        @Headers("Content-Type: application/json; charset=utf-8")
        @HTTP(path = "store/order/{orderId}", method = "DELETE", hasBody = true)
        Call<ResponseBody> deleteOrder(@Path("orderId") String orderId);

        @Headers("Content-Type: application/json; charset=utf-8")
        @POST("user")
        Call<ResponseBody> createUser(@Body User body);

        @Headers("Content-Type: application/json; charset=utf-8")
        @POST("user/createWithArray")
        Call<ResponseBody> createUsersWithArrayInput(@Body List<User> body);

        @Headers("Content-Type: application/json; charset=utf-8")
        @POST("user/createWithList")
        Call<ResponseBody> createUsersWithListInput(@Body List<User> body);

        @Headers("Content-Type: application/json; charset=utf-8")
        @GET("user/login")
        Call<ResponseBody> loginUser(@Query("username") String username, @Query("password") String password);

        @Headers("Content-Type: application/json; charset=utf-8")
        @GET("user/logout")
        Call<ResponseBody> logoutUser();

        @Headers("Content-Type: application/json; charset=utf-8")
        @GET("user/{username}")
        Call<ResponseBody> getUserByName(@Path("username") String username);

        @Headers("Content-Type: application/json; charset=utf-8")
        @PUT("user/{username}")
        Call<ResponseBody> updateUser(@Path("username") String username, @Body User body);

        @Headers("Content-Type: application/json; charset=utf-8")
        @HTTP(path = "user/{username}", method = "DELETE", hasBody = true)
        Call<ResponseBody> deleteUser(@Path("username") String username);

    }

    /**
     * Fake endpoint to test byte array in body parameter for adding a new pet to the store.
     *
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    public ServiceResponse<Void> addPetUsingByteArray() throws ServiceException, IOException {
        final String body = null;
        Call<ResponseBody> call = service.addPetUsingByteArray(body);
        return addPetUsingByteArrayDelegate(call.execute());
    }

    /**
     * Fake endpoint to test byte array in body parameter for adding a new pet to the store.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall addPetUsingByteArrayAsync(final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        final String body = null;
        Call<ResponseBody> call = service.addPetUsingByteArray(body);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
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
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall addPetUsingByteArrayAsync(String body, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        Call<ResponseBody> call = service.addPetUsingByteArray(body);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
    }

    private ServiceResponse<Void> addPetUsingByteArrayDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.getMapperAdapter())
                .register(405, new TypeToken<Void>() { }.getType())
                .build(response);
    }

    /**
     * Add a new pet to the store.
     * Adds a new pet to the store. You may receive an HTTP invalid input if your pet is invalid.
     *
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    public ServiceResponse<Void> addPet() throws ServiceException, IOException {
        final Pet body = null;
        Call<ResponseBody> call = service.addPet(body);
        return addPetDelegate(call.execute());
    }

    /**
     * Add a new pet to the store.
     * Adds a new pet to the store. You may receive an HTTP invalid input if your pet is invalid.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall addPetAsync(final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        final Pet body = null;
        Call<ResponseBody> call = service.addPet(body);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
    }

    /**
     * Add a new pet to the store.
     * Adds a new pet to the store. You may receive an HTTP invalid input if your pet is invalid.
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
     * Adds a new pet to the store. You may receive an HTTP invalid input if your pet is invalid.
     *
     * @param body Pet object that needs to be added to the store
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall addPetAsync(Pet body, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        Validator.validate(body, serviceCallback);
        Call<ResponseBody> call = service.addPet(body);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
    }

    private ServiceResponse<Void> addPetDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.getMapperAdapter())
                .register(405, new TypeToken<Void>() { }.getType())
                .build(response);
    }

    /**
     * Update an existing pet.
     *
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    public ServiceResponse<Void> updatePet() throws ServiceException, IOException {
        final Pet body = null;
        Call<ResponseBody> call = service.updatePet(body);
        return updatePetDelegate(call.execute());
    }

    /**
     * Update an existing pet.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall updatePetAsync(final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        final Pet body = null;
        Call<ResponseBody> call = service.updatePet(body);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
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
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall updatePetAsync(Pet body, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        Validator.validate(body, serviceCallback);
        Call<ResponseBody> call = service.updatePet(body);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
    }

    private ServiceResponse<Void> updatePetDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.getMapperAdapter())
                .register(405, new TypeToken<Void>() { }.getType())
                .register(404, new TypeToken<Void>() { }.getType())
                .register(400, new TypeToken<Void>() { }.getType())
                .build(response);
    }

    /**
     * Finds Pets by status.
     * Multiple status values can be provided with comma seperated strings.
     *
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the List&lt;Pet&gt; object wrapped in {@link ServiceResponse} if successful.
     */
    public ServiceResponse<List<Pet>> findPetsByStatus() throws ServiceException, IOException {
        final String statusConverted = null;
        Call<ResponseBody> call = service.findPetsByStatus(statusConverted);
        return findPetsByStatusDelegate(call.execute());
    }

    /**
     * Finds Pets by status.
     * Multiple status values can be provided with comma seperated strings.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall findPetsByStatusAsync(final ServiceCallback<List<Pet>> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        final String statusConverted = null;
        Call<ResponseBody> call = service.findPetsByStatus(statusConverted);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
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
        String statusConverted = this.getMapperAdapter().serializeList(status, CollectionFormat.CSV);
        Call<ResponseBody> call = service.findPetsByStatus(statusConverted);
        return findPetsByStatusDelegate(call.execute());
    }

    /**
     * Finds Pets by status.
     * Multiple status values can be provided with comma seperated strings.
     *
     * @param status Status values that need to be considered for filter
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall findPetsByStatusAsync(List<String> status, final ServiceCallback<List<Pet>> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        Validator.validate(status, serviceCallback);
        String statusConverted = this.getMapperAdapter().serializeList(status, CollectionFormat.CSV);
        Call<ResponseBody> call = service.findPetsByStatus(statusConverted);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
    }

    private ServiceResponse<List<Pet>> findPetsByStatusDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<List<Pet>, ServiceException>(this.getMapperAdapter())
                .register(200, new TypeToken<List<Pet>>() { }.getType())
                .register(400, new TypeToken<Void>() { }.getType())
                .build(response);
    }

    /**
     * Finds Pets by tags.
     * Muliple tags can be provided with comma seperated strings. Use tag1, tag2, tag3 for testing.
     *
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the List&lt;Pet&gt; object wrapped in {@link ServiceResponse} if successful.
     */
    public ServiceResponse<List<Pet>> findPetsByTags() throws ServiceException, IOException {
        final String tagsConverted = null;
        Call<ResponseBody> call = service.findPetsByTags(tagsConverted);
        return findPetsByTagsDelegate(call.execute());
    }

    /**
     * Finds Pets by tags.
     * Muliple tags can be provided with comma seperated strings. Use tag1, tag2, tag3 for testing.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall findPetsByTagsAsync(final ServiceCallback<List<Pet>> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        final String tagsConverted = null;
        Call<ResponseBody> call = service.findPetsByTags(tagsConverted);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
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
        String tagsConverted = this.getMapperAdapter().serializeList(tags, CollectionFormat.CSV);
        Call<ResponseBody> call = service.findPetsByTags(tagsConverted);
        return findPetsByTagsDelegate(call.execute());
    }

    /**
     * Finds Pets by tags.
     * Muliple tags can be provided with comma seperated strings. Use tag1, tag2, tag3 for testing.
     *
     * @param tags Tags to filter by
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall findPetsByTagsAsync(List<String> tags, final ServiceCallback<List<Pet>> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        Validator.validate(tags, serviceCallback);
        String tagsConverted = this.getMapperAdapter().serializeList(tags, CollectionFormat.CSV);
        Call<ResponseBody> call = service.findPetsByTags(tagsConverted);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
    }

    private ServiceResponse<List<Pet>> findPetsByTagsDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<List<Pet>, ServiceException>(this.getMapperAdapter())
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
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall findPetsWithByteArrayAsync(long petId, final ServiceCallback<String> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        Call<ResponseBody> call = service.findPetsWithByteArray(petId);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
    }

    private ServiceResponse<String> findPetsWithByteArrayDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<String, ServiceException>(this.getMapperAdapter())
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
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall getPetByIdAsync(long petId, final ServiceCallback<Pet> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        Call<ResponseBody> call = service.getPetById(petId);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
    }

    private ServiceResponse<Pet> getPetByIdDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Pet, ServiceException>(this.getMapperAdapter())
                .register(404, new TypeToken<Void>() { }.getType())
                .register(200, new TypeToken<Pet>() { }.getType())
                .register(400, new TypeToken<Void>() { }.getType())
                .build(response);
    }

    /**
     * Updates a pet in the store with form data.
     *
     * @param petId ID of pet that needs to be updated
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @throws IllegalArgumentException exception thrown from invalid parameters
     * @return the {@link ServiceResponse} object if successful.
     */
    public ServiceResponse<Void> updatePetWithForm(String petId) throws ServiceException, IOException, IllegalArgumentException {
        if (petId == null) {
            throw new IllegalArgumentException("Parameter petId is required and cannot be null.");
        }
        final String name = null;
        final String status = null;
        Call<ResponseBody> call = service.updatePetWithForm(petId, name, status);
        return updatePetWithFormDelegate(call.execute());
    }

    /**
     * Updates a pet in the store with form data.
     *
     * @param petId ID of pet that needs to be updated
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall updatePetWithFormAsync(String petId, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        if (petId == null) {
            serviceCallback.failure(new IllegalArgumentException("Parameter petId is required and cannot be null."));
            return null;
        }
        final String name = null;
        final String status = null;
        Call<ResponseBody> call = service.updatePetWithForm(petId, name, status);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
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
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall updatePetWithFormAsync(String petId, String name, String status, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        if (petId == null) {
            serviceCallback.failure(new IllegalArgumentException("Parameter petId is required and cannot be null."));
            return null;
        }
        Call<ResponseBody> call = service.updatePetWithForm(petId, name, status);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
    }

    private ServiceResponse<Void> updatePetWithFormDelegate(Response<ResponseBody> response) throws ServiceException, IOException, IllegalArgumentException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.getMapperAdapter())
                .register(405, new TypeToken<Void>() { }.getType())
                .build(response);
    }

    /**
     * Deletes a pet.
     *
     * @param petId Pet id to delete
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    public ServiceResponse<Void> deletePet(long petId) throws ServiceException, IOException {
        final String apiKey = null;
        Call<ResponseBody> call = service.deletePet(petId, apiKey);
        return deletePetDelegate(call.execute());
    }

    /**
     * Deletes a pet.
     *
     * @param petId Pet id to delete
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall deletePetAsync(long petId, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        final String apiKey = null;
        Call<ResponseBody> call = service.deletePet(petId, apiKey);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
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
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall deletePetAsync(long petId, String apiKey, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        Call<ResponseBody> call = service.deletePet(petId, apiKey);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
    }

    private ServiceResponse<Void> deletePetDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.getMapperAdapter())
                .register(400, new TypeToken<Void>() { }.getType())
                .build(response);
    }

    /**
     * uploads an image.
     *
     * @param petId ID of pet to update
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    public ServiceResponse<Void> uploadFile(long petId) throws ServiceException, IOException {
        final String additionalMetadata = null;
        final RequestBody fileConverted = RequestBody.create(MediaType.parse("multipart/form-data"), new byte[0]);
        Call<ResponseBody> call = service.uploadFile(petId, additionalMetadata, fileConverted);
        return uploadFileDelegate(call.execute());
    }

    /**
     * uploads an image.
     *
     * @param petId ID of pet to update
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall uploadFileAsync(long petId, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        final String additionalMetadata = null;
        final RequestBody fileConverted = RequestBody.create(MediaType.parse("multipart/form-data"), new byte[0]);
        Call<ResponseBody> call = service.uploadFile(petId, additionalMetadata, fileConverted);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
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
    public ServiceResponse<Void> uploadFile(long petId, String additionalMetadata, byte[] file) throws ServiceException, IOException {
        RequestBody fileConverted = RequestBody.create(MediaType.parse("multipart/form-data"), new byte[0]);
        if (file != null) {
            fileConverted = RequestBody.create(MediaType.parse("multipart/form-data"), file);
        }
        Call<ResponseBody> call = service.uploadFile(petId, additionalMetadata, fileConverted);
        return uploadFileDelegate(call.execute());
    }

    /**
     * uploads an image.
     *
     * @param petId ID of pet to update
     * @param additionalMetadata Additional data to pass to server
     * @param file file to upload
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall uploadFileAsync(long petId, String additionalMetadata, byte[] file, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        RequestBody fileConverted = RequestBody.create(MediaType.parse("multipart/form-data"), new byte[0]);
        if (file != null) {
            fileConverted = RequestBody.create(MediaType.parse("multipart/form-data"), file);
        }
        Call<ResponseBody> call = service.uploadFile(petId, additionalMetadata, fileConverted);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
    }

    private ServiceResponse<Void> uploadFileDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.getMapperAdapter())
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
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall getInventoryAsync(final ServiceCallback<Map<String, Integer>> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        Call<ResponseBody> call = service.getInventory();
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
    }

    private ServiceResponse<Map<String, Integer>> getInventoryDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Map<String, Integer>, ServiceException>(this.getMapperAdapter())
                .register(200, new TypeToken<Map<String, Integer>>() { }.getType())
                .build(response);
    }

    /**
     * Place an order for a pet.
     *
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the Order object wrapped in {@link ServiceResponse} if successful.
     */
    public ServiceResponse<Order> placeOrder() throws ServiceException, IOException {
        final Order body = null;
        Call<ResponseBody> call = service.placeOrder(body);
        return placeOrderDelegate(call.execute());
    }

    /**
     * Place an order for a pet.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall placeOrderAsync(final ServiceCallback<Order> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        final Order body = null;
        Call<ResponseBody> call = service.placeOrder(body);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
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
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall placeOrderAsync(Order body, final ServiceCallback<Order> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        Validator.validate(body, serviceCallback);
        Call<ResponseBody> call = service.placeOrder(body);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
    }

    private ServiceResponse<Order> placeOrderDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Order, ServiceException>(this.getMapperAdapter())
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
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall getOrderByIdAsync(String orderId, final ServiceCallback<Order> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        if (orderId == null) {
            serviceCallback.failure(new IllegalArgumentException("Parameter orderId is required and cannot be null."));
            return null;
        }
        Call<ResponseBody> call = service.getOrderById(orderId);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
    }

    private ServiceResponse<Order> getOrderByIdDelegate(Response<ResponseBody> response) throws ServiceException, IOException, IllegalArgumentException {
        return new ServiceResponseBuilder<Order, ServiceException>(this.getMapperAdapter())
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
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall deleteOrderAsync(String orderId, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        if (orderId == null) {
            serviceCallback.failure(new IllegalArgumentException("Parameter orderId is required and cannot be null."));
            return null;
        }
        Call<ResponseBody> call = service.deleteOrder(orderId);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
    }

    private ServiceResponse<Void> deleteOrderDelegate(Response<ResponseBody> response) throws ServiceException, IOException, IllegalArgumentException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.getMapperAdapter())
                .register(404, new TypeToken<Void>() { }.getType())
                .register(400, new TypeToken<Void>() { }.getType())
                .build(response);
    }

    /**
     * Create user.
     * This can only be done by the logged in user.
     *
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    public ServiceResponse<Void> createUser() throws ServiceException, IOException {
        final User body = null;
        Call<ResponseBody> call = service.createUser(body);
        return createUserDelegate(call.execute());
    }

    /**
     * Create user.
     * This can only be done by the logged in user.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall createUserAsync(final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        final User body = null;
        Call<ResponseBody> call = service.createUser(body);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
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
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall createUserAsync(User body, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        Validator.validate(body, serviceCallback);
        Call<ResponseBody> call = service.createUser(body);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
    }

    private ServiceResponse<Void> createUserDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.getMapperAdapter())
                .build(response);
    }

    /**
     * Creates list of users with given input array.
     *
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    public ServiceResponse<Void> createUsersWithArrayInput() throws ServiceException, IOException {
        final List<User> body = null;
        Call<ResponseBody> call = service.createUsersWithArrayInput(body);
        return createUsersWithArrayInputDelegate(call.execute());
    }

    /**
     * Creates list of users with given input array.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall createUsersWithArrayInputAsync(final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        final List<User> body = null;
        Call<ResponseBody> call = service.createUsersWithArrayInput(body);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
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
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall createUsersWithArrayInputAsync(List<User> body, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        Validator.validate(body, serviceCallback);
        Call<ResponseBody> call = service.createUsersWithArrayInput(body);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
    }

    private ServiceResponse<Void> createUsersWithArrayInputDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.getMapperAdapter())
                .build(response);
    }

    /**
     * Creates list of users with given input array.
     *
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    public ServiceResponse<Void> createUsersWithListInput() throws ServiceException, IOException {
        final List<User> body = null;
        Call<ResponseBody> call = service.createUsersWithListInput(body);
        return createUsersWithListInputDelegate(call.execute());
    }

    /**
     * Creates list of users with given input array.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall createUsersWithListInputAsync(final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        final List<User> body = null;
        Call<ResponseBody> call = service.createUsersWithListInput(body);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
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
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall createUsersWithListInputAsync(List<User> body, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        Validator.validate(body, serviceCallback);
        Call<ResponseBody> call = service.createUsersWithListInput(body);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
    }

    private ServiceResponse<Void> createUsersWithListInputDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.getMapperAdapter())
                .build(response);
    }

    /**
     * Logs user into the system.
     *
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the String object wrapped in {@link ServiceResponse} if successful.
     */
    public ServiceResponse<String> loginUser() throws ServiceException, IOException {
        final String username = null;
        final String password = null;
        Call<ResponseBody> call = service.loginUser(username, password);
        return loginUserDelegate(call.execute());
    }

    /**
     * Logs user into the system.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall loginUserAsync(final ServiceCallback<String> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        final String username = null;
        final String password = null;
        Call<ResponseBody> call = service.loginUser(username, password);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
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
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall loginUserAsync(String username, String password, final ServiceCallback<String> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        Call<ResponseBody> call = service.loginUser(username, password);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
    }

    private ServiceResponse<String> loginUserDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<String, ServiceException>(this.getMapperAdapter())
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
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall logoutUserAsync(final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        Call<ResponseBody> call = service.logoutUser();
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
    }

    private ServiceResponse<Void> logoutUserDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.getMapperAdapter())
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
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall getUserByNameAsync(String username, final ServiceCallback<User> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        if (username == null) {
            serviceCallback.failure(new IllegalArgumentException("Parameter username is required and cannot be null."));
            return null;
        }
        Call<ResponseBody> call = service.getUserByName(username);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
    }

    private ServiceResponse<User> getUserByNameDelegate(Response<ResponseBody> response) throws ServiceException, IOException, IllegalArgumentException {
        return new ServiceResponseBuilder<User, ServiceException>(this.getMapperAdapter())
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
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @throws IllegalArgumentException exception thrown from invalid parameters
     * @return the {@link ServiceResponse} object if successful.
     */
    public ServiceResponse<Void> updateUser(String username) throws ServiceException, IOException, IllegalArgumentException {
        if (username == null) {
            throw new IllegalArgumentException("Parameter username is required and cannot be null.");
        }
        final User body = null;
        Call<ResponseBody> call = service.updateUser(username, body);
        return updateUserDelegate(call.execute());
    }

    /**
     * Updated user.
     * This can only be done by the logged in user.
     *
     * @param username name that need to be deleted
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall updateUserAsync(String username, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        if (username == null) {
            serviceCallback.failure(new IllegalArgumentException("Parameter username is required and cannot be null."));
            return null;
        }
        final User body = null;
        Call<ResponseBody> call = service.updateUser(username, body);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
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
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall updateUserAsync(String username, User body, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        if (username == null) {
            serviceCallback.failure(new IllegalArgumentException("Parameter username is required and cannot be null."));
            return null;
        }
        Validator.validate(body, serviceCallback);
        Call<ResponseBody> call = service.updateUser(username, body);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
    }

    private ServiceResponse<Void> updateUserDelegate(Response<ResponseBody> response) throws ServiceException, IOException, IllegalArgumentException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.getMapperAdapter())
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
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link Call} object
     */
    public ServiceCall deleteUserAsync(String username, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException {
        if (serviceCallback == null) {
            throw new IllegalArgumentException("ServiceCallback is required for async calls.");
        }
        if (username == null) {
            serviceCallback.failure(new IllegalArgumentException("Parameter username is required and cannot be null."));
            return null;
        }
        Call<ResponseBody> call = service.deleteUser(username);
        final ServiceCall serviceCall = new ServiceCall(call);
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
        return serviceCall;
    }

    private ServiceResponse<Void> deleteUserDelegate(Response<ResponseBody> response) throws ServiceException, IOException, IllegalArgumentException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.getMapperAdapter())
                .register(404, new TypeToken<Void>() { }.getType())
                .register(400, new TypeToken<Void>() { }.getType())
                .build(response);
    }

}
