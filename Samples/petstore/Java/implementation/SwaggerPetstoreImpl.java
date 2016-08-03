/**
 */

package petstore.implementation;

import petstore.SwaggerPetstore;
import com.microsoft.rest.ServiceClient;
import okhttp3.OkHttpClient;
import retrofit2.Retrofit;
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
        super(baseUrl);
        initialize();
    }

    /**
     * Initializes an instance of SwaggerPetstore client.
     *
     * @param clientBuilder the builder for building an OkHttp client, bundled with user configurations
     * @param restBuilder the builder for building an Retrofit client, bundled with user configurations
     */
    public SwaggerPetstoreImpl(OkHttpClient.Builder clientBuilder, Retrofit.Builder restBuilder) {
        this("http://petstore.swagger.io/v2", clientBuilder, restBuilder);
        initialize();
    }

    /**
     * Initializes an instance of SwaggerPetstore client.
     *
     * @param baseUrl the base URL of the host
     * @param clientBuilder the builder for building an OkHttp client, bundled with user configurations
     * @param restBuilder the builder for building an Retrofit client, bundled with user configurations
     */
    public SwaggerPetstoreImpl(String baseUrl, OkHttpClient.Builder clientBuilder, Retrofit.Builder restBuilder) {
        super(baseUrl, clientBuilder, restBuilder);
        initialize();
    }

    private void initialize() {
        initializeService();
    }

    private void initializeService() {
        service = retrofit().create(SwaggerPetstoreService.class);
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
     * @return the {@link Call} object
     */
    public ServiceCall<Void> addPetUsingByteArrayAsync(final ServiceCallback<Void> serviceCallback) {
        final String body = null;
        Call<ResponseBody> call = service.addPetUsingByteArray(body);
        final ServiceCall<Void> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Void> clientResponse = addPetUsingByteArrayDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
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
     * @return the {@link Call} object
     */
    public ServiceCall<Void> addPetUsingByteArrayAsync(String body, final ServiceCallback<Void> serviceCallback) {
        Call<ResponseBody> call = service.addPetUsingByteArray(body);
        final ServiceCall<Void> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Void> clientResponse = addPetUsingByteArrayDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
                }
            }
        });
        return serviceCall;
    }

    private ServiceResponse<Void> addPetUsingByteArrayDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.mapperAdapter())
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
     * @return the {@link Call} object
     */
    public ServiceCall<Void> addPetAsync(final ServiceCallback<Void> serviceCallback) {
        final Pet body = null;
        Call<ResponseBody> call = service.addPet(body);
        final ServiceCall<Void> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Void> clientResponse = addPetDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
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
     * @return the {@link Call} object
     */
    public ServiceCall<Void> addPetAsync(Pet body, final ServiceCallback<Void> serviceCallback) {
        Validator.validate(body);
        Call<ResponseBody> call = service.addPet(body);
        final ServiceCall<Void> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Void> clientResponse = addPetDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
                }
            }
        });
        return serviceCall;
    }

    private ServiceResponse<Void> addPetDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.mapperAdapter())
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
     * @return the {@link Call} object
     */
    public ServiceCall<Void> updatePetAsync(final ServiceCallback<Void> serviceCallback) {
        final Pet body = null;
        Call<ResponseBody> call = service.updatePet(body);
        final ServiceCall<Void> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Void> clientResponse = updatePetDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
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
     * @return the {@link Call} object
     */
    public ServiceCall<Void> updatePetAsync(Pet body, final ServiceCallback<Void> serviceCallback) {
        Validator.validate(body);
        Call<ResponseBody> call = service.updatePet(body);
        final ServiceCall<Void> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Void> clientResponse = updatePetDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
                }
            }
        });
        return serviceCall;
    }

    private ServiceResponse<Void> updatePetDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.mapperAdapter())
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
        final List<String> status = null;
        String statusConverted = this.mapperAdapter().serializeList(status, CollectionFormat.CSV);
        Call<ResponseBody> call = service.findPetsByStatus(statusConverted);
        return findPetsByStatusDelegate(call.execute());
    }

    /**
     * Finds Pets by status.
     * Multiple status values can be provided with comma seperated strings.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public ServiceCall<List<Pet>> findPetsByStatusAsync(final ServiceCallback<List<Pet>> serviceCallback) {
        final List<String> status = null;
        String statusConverted = this.mapperAdapter().serializeList(status, CollectionFormat.CSV);
        Call<ResponseBody> call = service.findPetsByStatus(statusConverted);
        final ServiceCall<List<Pet>> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<List<Pet>>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<List<Pet>> clientResponse = findPetsByStatusDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
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
        String statusConverted = this.mapperAdapter().serializeList(status, CollectionFormat.CSV);
        Call<ResponseBody> call = service.findPetsByStatus(statusConverted);
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
    public ServiceCall<List<Pet>> findPetsByStatusAsync(List<String> status, final ServiceCallback<List<Pet>> serviceCallback) {
        Validator.validate(status);
        String statusConverted = this.mapperAdapter().serializeList(status, CollectionFormat.CSV);
        Call<ResponseBody> call = service.findPetsByStatus(statusConverted);
        final ServiceCall<List<Pet>> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<List<Pet>>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<List<Pet>> clientResponse = findPetsByStatusDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
                }
            }
        });
        return serviceCall;
    }

    private ServiceResponse<List<Pet>> findPetsByStatusDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<List<Pet>, ServiceException>(this.mapperAdapter())
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
        final List<String> tags = null;
        String tagsConverted = this.mapperAdapter().serializeList(tags, CollectionFormat.CSV);
        Call<ResponseBody> call = service.findPetsByTags(tagsConverted);
        return findPetsByTagsDelegate(call.execute());
    }

    /**
     * Finds Pets by tags.
     * Muliple tags can be provided with comma seperated strings. Use tag1, tag2, tag3 for testing.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public ServiceCall<List<Pet>> findPetsByTagsAsync(final ServiceCallback<List<Pet>> serviceCallback) {
        final List<String> tags = null;
        String tagsConverted = this.mapperAdapter().serializeList(tags, CollectionFormat.CSV);
        Call<ResponseBody> call = service.findPetsByTags(tagsConverted);
        final ServiceCall<List<Pet>> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<List<Pet>>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<List<Pet>> clientResponse = findPetsByTagsDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
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
        String tagsConverted = this.mapperAdapter().serializeList(tags, CollectionFormat.CSV);
        Call<ResponseBody> call = service.findPetsByTags(tagsConverted);
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
    public ServiceCall<List<Pet>> findPetsByTagsAsync(List<String> tags, final ServiceCallback<List<Pet>> serviceCallback) {
        Validator.validate(tags);
        String tagsConverted = this.mapperAdapter().serializeList(tags, CollectionFormat.CSV);
        Call<ResponseBody> call = service.findPetsByTags(tagsConverted);
        final ServiceCall<List<Pet>> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<List<Pet>>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<List<Pet>> clientResponse = findPetsByTagsDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
                }
            }
        });
        return serviceCall;
    }

    private ServiceResponse<List<Pet>> findPetsByTagsDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<List<Pet>, ServiceException>(this.mapperAdapter())
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
    public ServiceCall<String> findPetsWithByteArrayAsync(long petId, final ServiceCallback<String> serviceCallback) {
        Call<ResponseBody> call = service.findPetsWithByteArray(petId);
        final ServiceCall<String> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<String>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<String> clientResponse = findPetsWithByteArrayDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
                }
            }
        });
        return serviceCall;
    }

    private ServiceResponse<String> findPetsWithByteArrayDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<String, ServiceException>(this.mapperAdapter())
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
    public ServiceCall<Pet> getPetByIdAsync(long petId, final ServiceCallback<Pet> serviceCallback) {
        Call<ResponseBody> call = service.getPetById(petId);
        final ServiceCall<Pet> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Pet>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Pet> clientResponse = getPetByIdDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
                }
            }
        });
        return serviceCall;
    }

    private ServiceResponse<Pet> getPetByIdDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Pet, ServiceException>(this.mapperAdapter())
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
     * @return the {@link Call} object
     */
    public ServiceCall<Void> updatePetWithFormAsync(String petId, final ServiceCallback<Void> serviceCallback) {
        if (petId == null) {
            throw new IllegalArgumentException("Parameter petId is required and cannot be null.");
        }
        final String name = null;
        final String status = null;
        Call<ResponseBody> call = service.updatePetWithForm(petId, name, status);
        final ServiceCall<Void> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Void> clientResponse = updatePetWithFormDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
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
     * @return the {@link Call} object
     */
    public ServiceCall<Void> updatePetWithFormAsync(String petId, String name, String status, final ServiceCallback<Void> serviceCallback) {
        if (petId == null) {
            throw new IllegalArgumentException("Parameter petId is required and cannot be null.");
        }
        Call<ResponseBody> call = service.updatePetWithForm(petId, name, status);
        final ServiceCall<Void> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Void> clientResponse = updatePetWithFormDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
                }
            }
        });
        return serviceCall;
    }

    private ServiceResponse<Void> updatePetWithFormDelegate(Response<ResponseBody> response) throws ServiceException, IOException, IllegalArgumentException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.mapperAdapter())
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
     * @return the {@link Call} object
     */
    public ServiceCall<Void> deletePetAsync(long petId, final ServiceCallback<Void> serviceCallback) {
        final String apiKey = null;
        Call<ResponseBody> call = service.deletePet(petId, apiKey);
        final ServiceCall<Void> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Void> clientResponse = deletePetDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
                }
            }
        });
        return serviceCall;
    }

    /**
     * Deletes a pet.
     *
     * @param petId Pet id to delete
     * @param apiKey the String value
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
     * @param apiKey the String value
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public ServiceCall<Void> deletePetAsync(long petId, String apiKey, final ServiceCallback<Void> serviceCallback) {
        Call<ResponseBody> call = service.deletePet(petId, apiKey);
        final ServiceCall<Void> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Void> clientResponse = deletePetDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
                }
            }
        });
        return serviceCall;
    }

    private ServiceResponse<Void> deletePetDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.mapperAdapter())
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
        final byte[] file = new byte[0];
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
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public ServiceCall<Void> uploadFileAsync(long petId, final ServiceCallback<Void> serviceCallback) {
        final String additionalMetadata = null;
        final byte[] file = new byte[0];
        RequestBody fileConverted = RequestBody.create(MediaType.parse("multipart/form-data"), new byte[0]);
        if (file != null) {
            fileConverted = RequestBody.create(MediaType.parse("multipart/form-data"), file);
        }
        Call<ResponseBody> call = service.uploadFile(petId, additionalMetadata, fileConverted);
        final ServiceCall<Void> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Void> clientResponse = uploadFileDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
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
     * @return the {@link Call} object
     */
    public ServiceCall<Void> uploadFileAsync(long petId, String additionalMetadata, byte[] file, final ServiceCallback<Void> serviceCallback) {
        RequestBody fileConverted = RequestBody.create(MediaType.parse("multipart/form-data"), new byte[0]);
        if (file != null) {
            fileConverted = RequestBody.create(MediaType.parse("multipart/form-data"), file);
        }
        Call<ResponseBody> call = service.uploadFile(petId, additionalMetadata, fileConverted);
        final ServiceCall<Void> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Void> clientResponse = uploadFileDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
                }
            }
        });
        return serviceCall;
    }

    private ServiceResponse<Void> uploadFileDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.mapperAdapter())
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
    public ServiceCall<Map<String, Integer>> getInventoryAsync(final ServiceCallback<Map<String, Integer>> serviceCallback) {
        Call<ResponseBody> call = service.getInventory();
        final ServiceCall<Map<String, Integer>> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Map<String, Integer>>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Map<String, Integer>> clientResponse = getInventoryDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
                }
            }
        });
        return serviceCall;
    }

    private ServiceResponse<Map<String, Integer>> getInventoryDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Map<String, Integer>, ServiceException>(this.mapperAdapter())
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
     * @return the {@link Call} object
     */
    public ServiceCall<Order> placeOrderAsync(final ServiceCallback<Order> serviceCallback) {
        final Order body = null;
        Call<ResponseBody> call = service.placeOrder(body);
        final ServiceCall<Order> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Order>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Order> clientResponse = placeOrderDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
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
     * @return the {@link Call} object
     */
    public ServiceCall<Order> placeOrderAsync(Order body, final ServiceCallback<Order> serviceCallback) {
        Validator.validate(body);
        Call<ResponseBody> call = service.placeOrder(body);
        final ServiceCall<Order> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Order>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Order> clientResponse = placeOrderDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
                }
            }
        });
        return serviceCall;
    }

    private ServiceResponse<Order> placeOrderDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Order, ServiceException>(this.mapperAdapter())
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
    public ServiceCall<Order> getOrderByIdAsync(String orderId, final ServiceCallback<Order> serviceCallback) {
        if (orderId == null) {
            throw new IllegalArgumentException("Parameter orderId is required and cannot be null.");
        }
        Call<ResponseBody> call = service.getOrderById(orderId);
        final ServiceCall<Order> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Order>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Order> clientResponse = getOrderByIdDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
                }
            }
        });
        return serviceCall;
    }

    private ServiceResponse<Order> getOrderByIdDelegate(Response<ResponseBody> response) throws ServiceException, IOException, IllegalArgumentException {
        return new ServiceResponseBuilder<Order, ServiceException>(this.mapperAdapter())
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
    public ServiceCall<Void> deleteOrderAsync(String orderId, final ServiceCallback<Void> serviceCallback) {
        if (orderId == null) {
            throw new IllegalArgumentException("Parameter orderId is required and cannot be null.");
        }
        Call<ResponseBody> call = service.deleteOrder(orderId);
        final ServiceCall<Void> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Void> clientResponse = deleteOrderDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
                }
            }
        });
        return serviceCall;
    }

    private ServiceResponse<Void> deleteOrderDelegate(Response<ResponseBody> response) throws ServiceException, IOException, IllegalArgumentException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.mapperAdapter())
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
     * @return the {@link Call} object
     */
    public ServiceCall<Void> createUserAsync(final ServiceCallback<Void> serviceCallback) {
        final User body = null;
        Call<ResponseBody> call = service.createUser(body);
        final ServiceCall<Void> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Void> clientResponse = createUserDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
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
     * @return the {@link Call} object
     */
    public ServiceCall<Void> createUserAsync(User body, final ServiceCallback<Void> serviceCallback) {
        Validator.validate(body);
        Call<ResponseBody> call = service.createUser(body);
        final ServiceCall<Void> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Void> clientResponse = createUserDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
                }
            }
        });
        return serviceCall;
    }

    private ServiceResponse<Void> createUserDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.mapperAdapter())
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
     * @return the {@link Call} object
     */
    public ServiceCall<Void> createUsersWithArrayInputAsync(final ServiceCallback<Void> serviceCallback) {
        final List<User> body = null;
        Call<ResponseBody> call = service.createUsersWithArrayInput(body);
        final ServiceCall<Void> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Void> clientResponse = createUsersWithArrayInputDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
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
     * @return the {@link Call} object
     */
    public ServiceCall<Void> createUsersWithArrayInputAsync(List<User> body, final ServiceCallback<Void> serviceCallback) {
        Validator.validate(body);
        Call<ResponseBody> call = service.createUsersWithArrayInput(body);
        final ServiceCall<Void> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Void> clientResponse = createUsersWithArrayInputDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
                }
            }
        });
        return serviceCall;
    }

    private ServiceResponse<Void> createUsersWithArrayInputDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.mapperAdapter())
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
     * @return the {@link Call} object
     */
    public ServiceCall<Void> createUsersWithListInputAsync(final ServiceCallback<Void> serviceCallback) {
        final List<User> body = null;
        Call<ResponseBody> call = service.createUsersWithListInput(body);
        final ServiceCall<Void> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Void> clientResponse = createUsersWithListInputDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
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
     * @return the {@link Call} object
     */
    public ServiceCall<Void> createUsersWithListInputAsync(List<User> body, final ServiceCallback<Void> serviceCallback) {
        Validator.validate(body);
        Call<ResponseBody> call = service.createUsersWithListInput(body);
        final ServiceCall<Void> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Void> clientResponse = createUsersWithListInputDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
                }
            }
        });
        return serviceCall;
    }

    private ServiceResponse<Void> createUsersWithListInputDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.mapperAdapter())
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
     * @return the {@link Call} object
     */
    public ServiceCall<String> loginUserAsync(final ServiceCallback<String> serviceCallback) {
        final String username = null;
        final String password = null;
        Call<ResponseBody> call = service.loginUser(username, password);
        final ServiceCall<String> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<String>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<String> clientResponse = loginUserDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
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
     * @return the {@link Call} object
     */
    public ServiceCall<String> loginUserAsync(String username, String password, final ServiceCallback<String> serviceCallback) {
        Call<ResponseBody> call = service.loginUser(username, password);
        final ServiceCall<String> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<String>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<String> clientResponse = loginUserDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
                }
            }
        });
        return serviceCall;
    }

    private ServiceResponse<String> loginUserDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<String, ServiceException>(this.mapperAdapter())
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
    public ServiceCall<Void> logoutUserAsync(final ServiceCallback<Void> serviceCallback) {
        Call<ResponseBody> call = service.logoutUser();
        final ServiceCall<Void> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Void> clientResponse = logoutUserDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
                }
            }
        });
        return serviceCall;
    }

    private ServiceResponse<Void> logoutUserDelegate(Response<ResponseBody> response) throws ServiceException, IOException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.mapperAdapter())
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
    public ServiceCall<User> getUserByNameAsync(String username, final ServiceCallback<User> serviceCallback) {
        if (username == null) {
            throw new IllegalArgumentException("Parameter username is required and cannot be null.");
        }
        Call<ResponseBody> call = service.getUserByName(username);
        final ServiceCall<User> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<User>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<User> clientResponse = getUserByNameDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
                }
            }
        });
        return serviceCall;
    }

    private ServiceResponse<User> getUserByNameDelegate(Response<ResponseBody> response) throws ServiceException, IOException, IllegalArgumentException {
        return new ServiceResponseBuilder<User, ServiceException>(this.mapperAdapter())
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
     * @return the {@link Call} object
     */
    public ServiceCall<Void> updateUserAsync(String username, final ServiceCallback<Void> serviceCallback) {
        if (username == null) {
            throw new IllegalArgumentException("Parameter username is required and cannot be null.");
        }
        final User body = null;
        Call<ResponseBody> call = service.updateUser(username, body);
        final ServiceCall<Void> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Void> clientResponse = updateUserDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
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
     * @return the {@link Call} object
     */
    public ServiceCall<Void> updateUserAsync(String username, User body, final ServiceCallback<Void> serviceCallback) {
        if (username == null) {
            throw new IllegalArgumentException("Parameter username is required and cannot be null.");
        }
        Validator.validate(body);
        Call<ResponseBody> call = service.updateUser(username, body);
        final ServiceCall<Void> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Void> clientResponse = updateUserDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
                }
            }
        });
        return serviceCall;
    }

    private ServiceResponse<Void> updateUserDelegate(Response<ResponseBody> response) throws ServiceException, IOException, IllegalArgumentException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.mapperAdapter())
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
    public ServiceCall<Void> deleteUserAsync(String username, final ServiceCallback<Void> serviceCallback) {
        if (username == null) {
            throw new IllegalArgumentException("Parameter username is required and cannot be null.");
        }
        Call<ResponseBody> call = service.deleteUser(username);
        final ServiceCall<Void> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<Void> clientResponse = deleteUserDelegate(response);
                    if (serviceCallback != null) {
                        serviceCallback.success(clientResponse);
                    }
                    serviceCall.success(clientResponse);
                } catch (ServiceException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
                }
            }
        });
        return serviceCall;
    }

    private ServiceResponse<Void> deleteUserDelegate(Response<ResponseBody> response) throws ServiceException, IOException, IllegalArgumentException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.mapperAdapter())
                .register(404, new TypeToken<Void>() { }.getType())
                .register(400, new TypeToken<Void>() { }.getType())
                .build(response);
    }

}
