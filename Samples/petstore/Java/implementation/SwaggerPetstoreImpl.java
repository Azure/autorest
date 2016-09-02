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
import com.microsoft.rest.Validator;
import java.io.InputStream;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import okhttp3.ResponseBody;
import petstore.models.Order;
import petstore.models.Pet;
import petstore.models.User;
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
import rx.functions.Func1;
import rx.Observable;

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
        Observable<Response<ResponseBody>> addPetUsingByteArray(@Body String body);

        @Headers("Content-Type: application/json; charset=utf-8")
        @POST("pet")
        Observable<Response<ResponseBody>> addPet(@Body Pet body);

        @Headers("Content-Type: application/json; charset=utf-8")
        @PUT("pet")
        Observable<Response<ResponseBody>> updatePet(@Body Pet body);

        @Headers("Content-Type: application/json; charset=utf-8")
        @GET("pet/findByStatus")
        Observable<Response<ResponseBody>> findPetsByStatus(@Query("status") String status);

        @Headers("Content-Type: application/json; charset=utf-8")
        @GET("pet/findByTags")
        Observable<Response<ResponseBody>> findPetsByTags(@Query("tags") String tags);

        @Headers("Content-Type: application/json; charset=utf-8")
        @GET("pet/{petId}")
        Observable<Response<ResponseBody>> findPetsWithByteArray(@Path("petId") long petId);

        @Headers("Content-Type: application/json; charset=utf-8")
        @GET("pet/{petId}")
        Observable<Response<ResponseBody>> getPetById(@Path("petId") long petId);

        @Multipart
        @POST("pet/{petId}")
        Observable<Response<ResponseBody>> updatePetWithForm(@Path("petId") String petId, @Part("name") String name, @Part("status") String status);

        @Headers("Content-Type: application/json; charset=utf-8")
        @HTTP(path = "pet/{petId}", method = "DELETE", hasBody = true)
        Observable<Response<ResponseBody>> deletePet(@Path("petId") long petId, @Header("api_key") String apiKey);

        @Multipart
        @POST("pet/{petId}/uploadImage")
        Observable<Response<ResponseBody>> uploadFile(@Path("petId") long petId, @Part("additionalMetadata") String additionalMetadata, @Part("file") RequestBody file);

        @Headers("Content-Type: application/json; charset=utf-8")
        @GET("store/inventory")
        Observable<Response<ResponseBody>> getInventory();

        @Headers("Content-Type: application/json; charset=utf-8")
        @POST("store/order")
        Observable<Response<ResponseBody>> placeOrder(@Body Order body);

        @Headers("Content-Type: application/json; charset=utf-8")
        @GET("store/order/{orderId}")
        Observable<Response<ResponseBody>> getOrderById(@Path("orderId") String orderId);

        @Headers("Content-Type: application/json; charset=utf-8")
        @HTTP(path = "store/order/{orderId}", method = "DELETE", hasBody = true)
        Observable<Response<ResponseBody>> deleteOrder(@Path("orderId") String orderId);

        @Headers("Content-Type: application/json; charset=utf-8")
        @POST("user")
        Observable<Response<ResponseBody>> createUser(@Body User body);

        @Headers("Content-Type: application/json; charset=utf-8")
        @POST("user/createWithArray")
        Observable<Response<ResponseBody>> createUsersWithArrayInput(@Body List<User> body);

        @Headers("Content-Type: application/json; charset=utf-8")
        @POST("user/createWithList")
        Observable<Response<ResponseBody>> createUsersWithListInput(@Body List<User> body);

        @Headers("Content-Type: application/json; charset=utf-8")
        @GET("user/login")
        Observable<Response<ResponseBody>> loginUser(@Query("username") String username, @Query("password") String password);

        @Headers("Content-Type: application/json; charset=utf-8")
        @GET("user/logout")
        Observable<Response<ResponseBody>> logoutUser();

        @Headers("Content-Type: application/json; charset=utf-8")
        @GET("user/{username}")
        Observable<Response<ResponseBody>> getUserByName(@Path("username") String username);

        @Headers("Content-Type: application/json; charset=utf-8")
        @PUT("user/{username}")
        Observable<Response<ResponseBody>> updateUser(@Path("username") String username, @Body User body);

        @Headers("Content-Type: application/json; charset=utf-8")
        @HTTP(path = "user/{username}", method = "DELETE", hasBody = true)
        Observable<Response<ResponseBody>> deleteUser(@Path("username") String username);

    }

    /**
     * Fake endpoint to test byte array in body parameter for adding a new pet to the store.
     *
     * @throws ServiceException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @return the {@link ServiceResponse} object if successful.
     */
    public ServiceResponse<Void> addPetUsingByteArray() throws ServiceException, IOException {
        return addPetUsingByteArrayAsync().toBlocking().single();
    }

    /**
     * Fake endpoint to test byte array in body parameter for adding a new pet to the store.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> addPetUsingByteArrayAsync(final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(addPetUsingByteArrayAsync(), serviceCallback);
    }

    /**
     * Fake endpoint to test byte array in body parameter for adding a new pet to the store.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> addPetUsingByteArrayAsync() {
        final String body = null;
        return service.addPetUsingByteArray(body)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = addPetUsingByteArrayDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return addPetUsingByteArrayAsync(body).toBlocking().single();
    }

    /**
     * Fake endpoint to test byte array in body parameter for adding a new pet to the store.
     *
     * @param body Pet object in the form of byte array
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> addPetUsingByteArrayAsync(String body, final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(addPetUsingByteArrayAsync(body), serviceCallback);
    }

    /**
     * Fake endpoint to test byte array in body parameter for adding a new pet to the store.
     *
     * @param body Pet object in the form of byte array
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> addPetUsingByteArrayAsync(String body) {
        return service.addPetUsingByteArray(body)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = addPetUsingByteArrayDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return addPetAsync().toBlocking().single();
    }

    /**
     * Add a new pet to the store.
     * Adds a new pet to the store. You may receive an HTTP invalid input if your pet is invalid.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> addPetAsync(final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(addPetAsync(), serviceCallback);
    }

    /**
     * Add a new pet to the store.
     * Adds a new pet to the store. You may receive an HTTP invalid input if your pet is invalid.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> addPetAsync() {
        final Pet body = null;
        return service.addPet(body)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = addPetDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return addPetAsync(body).toBlocking().single();
    }

    /**
     * Add a new pet to the store.
     * Adds a new pet to the store. You may receive an HTTP invalid input if your pet is invalid.
     *
     * @param body Pet object that needs to be added to the store
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> addPetAsync(Pet body, final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(addPetAsync(body), serviceCallback);
    }

    /**
     * Add a new pet to the store.
     * Adds a new pet to the store. You may receive an HTTP invalid input if your pet is invalid.
     *
     * @param body Pet object that needs to be added to the store
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> addPetAsync(Pet body) {
        Validator.validate(body);
        return service.addPet(body)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = addPetDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return updatePetAsync().toBlocking().single();
    }

    /**
     * Update an existing pet.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> updatePetAsync(final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(updatePetAsync(), serviceCallback);
    }

    /**
     * Update an existing pet.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> updatePetAsync() {
        final Pet body = null;
        return service.updatePet(body)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = updatePetDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return updatePetAsync(body).toBlocking().single();
    }

    /**
     * Update an existing pet.
     *
     * @param body Pet object that needs to be added to the store
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> updatePetAsync(Pet body, final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(updatePetAsync(body), serviceCallback);
    }

    /**
     * Update an existing pet.
     *
     * @param body Pet object that needs to be added to the store
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> updatePetAsync(Pet body) {
        Validator.validate(body);
        return service.updatePet(body)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = updatePetDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return findPetsByStatusAsync().toBlocking().single();
    }

    /**
     * Finds Pets by status.
     * Multiple status values can be provided with comma seperated strings.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<List<Pet>> findPetsByStatusAsync(final ServiceCallback<List<Pet>> serviceCallback) {
        return ServiceCall.create(findPetsByStatusAsync(), serviceCallback);
    }

    /**
     * Finds Pets by status.
     * Multiple status values can be provided with comma seperated strings.
     *
     * @return the observable to the List&lt;Pet&gt; object
     */
    public Observable<ServiceResponse<List<Pet>>> findPetsByStatusAsync() {
        final List<String> status = null;
        String statusConverted = this.mapperAdapter().serializeList(status, CollectionFormat.CSV);
        return service.findPetsByStatus(statusConverted)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<List<Pet>>>>() {
                @Override
                public Observable<ServiceResponse<List<Pet>>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<List<Pet>> clientResponse = findPetsByStatusDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return findPetsByStatusAsync(status).toBlocking().single();
    }

    /**
     * Finds Pets by status.
     * Multiple status values can be provided with comma seperated strings.
     *
     * @param status Status values that need to be considered for filter
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<List<Pet>> findPetsByStatusAsync(List<String> status, final ServiceCallback<List<Pet>> serviceCallback) {
        return ServiceCall.create(findPetsByStatusAsync(status), serviceCallback);
    }

    /**
     * Finds Pets by status.
     * Multiple status values can be provided with comma seperated strings.
     *
     * @param status Status values that need to be considered for filter
     * @return the observable to the List&lt;Pet&gt; object
     */
    public Observable<ServiceResponse<List<Pet>>> findPetsByStatusAsync(List<String> status) {
        Validator.validate(status);
        String statusConverted = this.mapperAdapter().serializeList(status, CollectionFormat.CSV);
        return service.findPetsByStatus(statusConverted)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<List<Pet>>>>() {
                @Override
                public Observable<ServiceResponse<List<Pet>>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<List<Pet>> clientResponse = findPetsByStatusDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return findPetsByTagsAsync().toBlocking().single();
    }

    /**
     * Finds Pets by tags.
     * Muliple tags can be provided with comma seperated strings. Use tag1, tag2, tag3 for testing.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<List<Pet>> findPetsByTagsAsync(final ServiceCallback<List<Pet>> serviceCallback) {
        return ServiceCall.create(findPetsByTagsAsync(), serviceCallback);
    }

    /**
     * Finds Pets by tags.
     * Muliple tags can be provided with comma seperated strings. Use tag1, tag2, tag3 for testing.
     *
     * @return the observable to the List&lt;Pet&gt; object
     */
    public Observable<ServiceResponse<List<Pet>>> findPetsByTagsAsync() {
        final List<String> tags = null;
        String tagsConverted = this.mapperAdapter().serializeList(tags, CollectionFormat.CSV);
        return service.findPetsByTags(tagsConverted)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<List<Pet>>>>() {
                @Override
                public Observable<ServiceResponse<List<Pet>>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<List<Pet>> clientResponse = findPetsByTagsDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return findPetsByTagsAsync(tags).toBlocking().single();
    }

    /**
     * Finds Pets by tags.
     * Muliple tags can be provided with comma seperated strings. Use tag1, tag2, tag3 for testing.
     *
     * @param tags Tags to filter by
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<List<Pet>> findPetsByTagsAsync(List<String> tags, final ServiceCallback<List<Pet>> serviceCallback) {
        return ServiceCall.create(findPetsByTagsAsync(tags), serviceCallback);
    }

    /**
     * Finds Pets by tags.
     * Muliple tags can be provided with comma seperated strings. Use tag1, tag2, tag3 for testing.
     *
     * @param tags Tags to filter by
     * @return the observable to the List&lt;Pet&gt; object
     */
    public Observable<ServiceResponse<List<Pet>>> findPetsByTagsAsync(List<String> tags) {
        Validator.validate(tags);
        String tagsConverted = this.mapperAdapter().serializeList(tags, CollectionFormat.CSV);
        return service.findPetsByTags(tagsConverted)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<List<Pet>>>>() {
                @Override
                public Observable<ServiceResponse<List<Pet>>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<List<Pet>> clientResponse = findPetsByTagsDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return findPetsWithByteArrayAsync(petId).toBlocking().single();
    }

    /**
     * Fake endpoint to test byte array return by 'Find pet by ID'.
     * Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will simulate API error conditions.
     *
     * @param petId ID of pet that needs to be fetched
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<String> findPetsWithByteArrayAsync(long petId, final ServiceCallback<String> serviceCallback) {
        return ServiceCall.create(findPetsWithByteArrayAsync(petId), serviceCallback);
    }

    /**
     * Fake endpoint to test byte array return by 'Find pet by ID'.
     * Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will simulate API error conditions.
     *
     * @param petId ID of pet that needs to be fetched
     * @return the observable to the String object
     */
    public Observable<ServiceResponse<String>> findPetsWithByteArrayAsync(long petId) {
        return service.findPetsWithByteArray(petId)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<String>>>() {
                @Override
                public Observable<ServiceResponse<String>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<String> clientResponse = findPetsWithByteArrayDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return getPetByIdAsync(petId).toBlocking().single();
    }

    /**
     * Find pet by ID.
     * Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will simulate API error conditions.
     *
     * @param petId ID of pet that needs to be fetched
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Pet> getPetByIdAsync(long petId, final ServiceCallback<Pet> serviceCallback) {
        return ServiceCall.create(getPetByIdAsync(petId), serviceCallback);
    }

    /**
     * Find pet by ID.
     * Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will simulate API error conditions.
     *
     * @param petId ID of pet that needs to be fetched
     * @return the observable to the Pet object
     */
    public Observable<ServiceResponse<Pet>> getPetByIdAsync(long petId) {
        return service.getPetById(petId)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Pet>>>() {
                @Override
                public Observable<ServiceResponse<Pet>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Pet> clientResponse = getPetByIdDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return updatePetWithFormAsync(petId).toBlocking().single();
    }

    /**
     * Updates a pet in the store with form data.
     *
     * @param petId ID of pet that needs to be updated
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> updatePetWithFormAsync(String petId, final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(updatePetWithFormAsync(petId), serviceCallback);
    }

    /**
     * Updates a pet in the store with form data.
     *
     * @param petId ID of pet that needs to be updated
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> updatePetWithFormAsync(String petId) {
        if (petId == null) {
            throw new IllegalArgumentException("Parameter petId is required and cannot be null.");
        }
        final String name = null;
        final String status = null;
        return service.updatePetWithForm(petId, name, status)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = updatePetWithFormDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return updatePetWithFormAsync(petId, name, status).toBlocking().single();
    }

    /**
     * Updates a pet in the store with form data.
     *
     * @param petId ID of pet that needs to be updated
     * @param name Updated name of the pet
     * @param status Updated status of the pet
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> updatePetWithFormAsync(String petId, String name, String status, final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(updatePetWithFormAsync(petId, name, status), serviceCallback);
    }

    /**
     * Updates a pet in the store with form data.
     *
     * @param petId ID of pet that needs to be updated
     * @param name Updated name of the pet
     * @param status Updated status of the pet
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> updatePetWithFormAsync(String petId, String name, String status) {
        if (petId == null) {
            throw new IllegalArgumentException("Parameter petId is required and cannot be null.");
        }
        return service.updatePetWithForm(petId, name, status)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = updatePetWithFormDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return deletePetAsync(petId).toBlocking().single();
    }

    /**
     * Deletes a pet.
     *
     * @param petId Pet id to delete
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> deletePetAsync(long petId, final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(deletePetAsync(petId), serviceCallback);
    }

    /**
     * Deletes a pet.
     *
     * @param petId Pet id to delete
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> deletePetAsync(long petId) {
        final String apiKey = null;
        return service.deletePet(petId, apiKey)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = deletePetDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return deletePetAsync(petId, apiKey).toBlocking().single();
    }

    /**
     * Deletes a pet.
     *
     * @param petId Pet id to delete
     * @param apiKey the String value
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> deletePetAsync(long petId, String apiKey, final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(deletePetAsync(petId, apiKey), serviceCallback);
    }

    /**
     * Deletes a pet.
     *
     * @param petId Pet id to delete
     * @param apiKey the String value
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> deletePetAsync(long petId, String apiKey) {
        return service.deletePet(petId, apiKey)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = deletePetDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return uploadFileAsync(petId).toBlocking().single();
    }

    /**
     * uploads an image.
     *
     * @param petId ID of pet to update
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> uploadFileAsync(long petId, final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(uploadFileAsync(petId), serviceCallback);
    }

    /**
     * uploads an image.
     *
     * @param petId ID of pet to update
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> uploadFileAsync(long petId) {
        final String additionalMetadata = null;
        final byte[] file = new byte[0];
        RequestBody fileConverted = RequestBody.create(MediaType.parse("multipart/form-data"), new byte[0]);
        if (file != null) {
            fileConverted = RequestBody.create(MediaType.parse("multipart/form-data"), file);
        }
        return service.uploadFile(petId, additionalMetadata, fileConverted)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = uploadFileDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return uploadFileAsync(petId, additionalMetadata, file).toBlocking().single();
    }

    /**
     * uploads an image.
     *
     * @param petId ID of pet to update
     * @param additionalMetadata Additional data to pass to server
     * @param file file to upload
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> uploadFileAsync(long petId, String additionalMetadata, byte[] file, final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(uploadFileAsync(petId, additionalMetadata, file), serviceCallback);
    }

    /**
     * uploads an image.
     *
     * @param petId ID of pet to update
     * @param additionalMetadata Additional data to pass to server
     * @param file file to upload
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> uploadFileAsync(long petId, String additionalMetadata, byte[] file) {
        RequestBody fileConverted = RequestBody.create(MediaType.parse("multipart/form-data"), new byte[0]);
        if (file != null) {
            fileConverted = RequestBody.create(MediaType.parse("multipart/form-data"), file);
        }
        return service.uploadFile(petId, additionalMetadata, fileConverted)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = uploadFileDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return getInventoryAsync().toBlocking().single();
    }

    /**
     * Returns pet inventories by status.
     * Returns a map of status codes to quantities.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Map<String, Integer>> getInventoryAsync(final ServiceCallback<Map<String, Integer>> serviceCallback) {
        return ServiceCall.create(getInventoryAsync(), serviceCallback);
    }

    /**
     * Returns pet inventories by status.
     * Returns a map of status codes to quantities.
     *
     * @return the observable to the Map&lt;String, Integer&gt; object
     */
    public Observable<ServiceResponse<Map<String, Integer>>> getInventoryAsync() {
        return service.getInventory()
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Map<String, Integer>>>>() {
                @Override
                public Observable<ServiceResponse<Map<String, Integer>>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Map<String, Integer>> clientResponse = getInventoryDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return placeOrderAsync().toBlocking().single();
    }

    /**
     * Place an order for a pet.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Order> placeOrderAsync(final ServiceCallback<Order> serviceCallback) {
        return ServiceCall.create(placeOrderAsync(), serviceCallback);
    }

    /**
     * Place an order for a pet.
     *
     * @return the observable to the Order object
     */
    public Observable<ServiceResponse<Order>> placeOrderAsync() {
        final Order body = null;
        return service.placeOrder(body)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Order>>>() {
                @Override
                public Observable<ServiceResponse<Order>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Order> clientResponse = placeOrderDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return placeOrderAsync(body).toBlocking().single();
    }

    /**
     * Place an order for a pet.
     *
     * @param body order placed for purchasing the pet
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Order> placeOrderAsync(Order body, final ServiceCallback<Order> serviceCallback) {
        return ServiceCall.create(placeOrderAsync(body), serviceCallback);
    }

    /**
     * Place an order for a pet.
     *
     * @param body order placed for purchasing the pet
     * @return the observable to the Order object
     */
    public Observable<ServiceResponse<Order>> placeOrderAsync(Order body) {
        Validator.validate(body);
        return service.placeOrder(body)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Order>>>() {
                @Override
                public Observable<ServiceResponse<Order>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Order> clientResponse = placeOrderDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return getOrderByIdAsync(orderId).toBlocking().single();
    }

    /**
     * Find purchase order by ID.
     * For valid response try integer IDs with value &lt;= 5 or &gt; 10. Other values will generated exceptions.
     *
     * @param orderId ID of pet that needs to be fetched
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Order> getOrderByIdAsync(String orderId, final ServiceCallback<Order> serviceCallback) {
        return ServiceCall.create(getOrderByIdAsync(orderId), serviceCallback);
    }

    /**
     * Find purchase order by ID.
     * For valid response try integer IDs with value &lt;= 5 or &gt; 10. Other values will generated exceptions.
     *
     * @param orderId ID of pet that needs to be fetched
     * @return the observable to the Order object
     */
    public Observable<ServiceResponse<Order>> getOrderByIdAsync(String orderId) {
        if (orderId == null) {
            throw new IllegalArgumentException("Parameter orderId is required and cannot be null.");
        }
        return service.getOrderById(orderId)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Order>>>() {
                @Override
                public Observable<ServiceResponse<Order>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Order> clientResponse = getOrderByIdDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return deleteOrderAsync(orderId).toBlocking().single();
    }

    /**
     * Delete purchase order by ID.
     * For valid response try integer IDs with value &lt; 1000. Anything above 1000 or nonintegers will generate API errors.
     *
     * @param orderId ID of the order that needs to be deleted
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> deleteOrderAsync(String orderId, final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(deleteOrderAsync(orderId), serviceCallback);
    }

    /**
     * Delete purchase order by ID.
     * For valid response try integer IDs with value &lt; 1000. Anything above 1000 or nonintegers will generate API errors.
     *
     * @param orderId ID of the order that needs to be deleted
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> deleteOrderAsync(String orderId) {
        if (orderId == null) {
            throw new IllegalArgumentException("Parameter orderId is required and cannot be null.");
        }
        return service.deleteOrder(orderId)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = deleteOrderDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return createUserAsync().toBlocking().single();
    }

    /**
     * Create user.
     * This can only be done by the logged in user.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> createUserAsync(final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(createUserAsync(), serviceCallback);
    }

    /**
     * Create user.
     * This can only be done by the logged in user.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> createUserAsync() {
        final User body = null;
        return service.createUser(body)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = createUserDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return createUserAsync(body).toBlocking().single();
    }

    /**
     * Create user.
     * This can only be done by the logged in user.
     *
     * @param body Created user object
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> createUserAsync(User body, final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(createUserAsync(body), serviceCallback);
    }

    /**
     * Create user.
     * This can only be done by the logged in user.
     *
     * @param body Created user object
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> createUserAsync(User body) {
        Validator.validate(body);
        return service.createUser(body)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = createUserDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return createUsersWithArrayInputAsync().toBlocking().single();
    }

    /**
     * Creates list of users with given input array.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> createUsersWithArrayInputAsync(final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(createUsersWithArrayInputAsync(), serviceCallback);
    }

    /**
     * Creates list of users with given input array.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> createUsersWithArrayInputAsync() {
        final List<User> body = null;
        return service.createUsersWithArrayInput(body)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = createUsersWithArrayInputDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return createUsersWithArrayInputAsync(body).toBlocking().single();
    }

    /**
     * Creates list of users with given input array.
     *
     * @param body List of user object
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> createUsersWithArrayInputAsync(List<User> body, final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(createUsersWithArrayInputAsync(body), serviceCallback);
    }

    /**
     * Creates list of users with given input array.
     *
     * @param body List of user object
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> createUsersWithArrayInputAsync(List<User> body) {
        Validator.validate(body);
        return service.createUsersWithArrayInput(body)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = createUsersWithArrayInputDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return createUsersWithListInputAsync().toBlocking().single();
    }

    /**
     * Creates list of users with given input array.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> createUsersWithListInputAsync(final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(createUsersWithListInputAsync(), serviceCallback);
    }

    /**
     * Creates list of users with given input array.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> createUsersWithListInputAsync() {
        final List<User> body = null;
        return service.createUsersWithListInput(body)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = createUsersWithListInputDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return createUsersWithListInputAsync(body).toBlocking().single();
    }

    /**
     * Creates list of users with given input array.
     *
     * @param body List of user object
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> createUsersWithListInputAsync(List<User> body, final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(createUsersWithListInputAsync(body), serviceCallback);
    }

    /**
     * Creates list of users with given input array.
     *
     * @param body List of user object
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> createUsersWithListInputAsync(List<User> body) {
        Validator.validate(body);
        return service.createUsersWithListInput(body)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = createUsersWithListInputDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return loginUserAsync().toBlocking().single();
    }

    /**
     * Logs user into the system.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<String> loginUserAsync(final ServiceCallback<String> serviceCallback) {
        return ServiceCall.create(loginUserAsync(), serviceCallback);
    }

    /**
     * Logs user into the system.
     *
     * @return the observable to the String object
     */
    public Observable<ServiceResponse<String>> loginUserAsync() {
        final String username = null;
        final String password = null;
        return service.loginUser(username, password)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<String>>>() {
                @Override
                public Observable<ServiceResponse<String>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<String> clientResponse = loginUserDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return loginUserAsync(username, password).toBlocking().single();
    }

    /**
     * Logs user into the system.
     *
     * @param username The user name for login
     * @param password The password for login in clear text
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<String> loginUserAsync(String username, String password, final ServiceCallback<String> serviceCallback) {
        return ServiceCall.create(loginUserAsync(username, password), serviceCallback);
    }

    /**
     * Logs user into the system.
     *
     * @param username The user name for login
     * @param password The password for login in clear text
     * @return the observable to the String object
     */
    public Observable<ServiceResponse<String>> loginUserAsync(String username, String password) {
        return service.loginUser(username, password)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<String>>>() {
                @Override
                public Observable<ServiceResponse<String>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<String> clientResponse = loginUserDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return logoutUserAsync().toBlocking().single();
    }

    /**
     * Logs out current logged in user session.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> logoutUserAsync(final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(logoutUserAsync(), serviceCallback);
    }

    /**
     * Logs out current logged in user session.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> logoutUserAsync() {
        return service.logoutUser()
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = logoutUserDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return getUserByNameAsync(username).toBlocking().single();
    }

    /**
     * Get user by user name.
     *
     * @param username The name that needs to be fetched. Use user1 for testing.
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<User> getUserByNameAsync(String username, final ServiceCallback<User> serviceCallback) {
        return ServiceCall.create(getUserByNameAsync(username), serviceCallback);
    }

    /**
     * Get user by user name.
     *
     * @param username The name that needs to be fetched. Use user1 for testing.
     * @return the observable to the User object
     */
    public Observable<ServiceResponse<User>> getUserByNameAsync(String username) {
        if (username == null) {
            throw new IllegalArgumentException("Parameter username is required and cannot be null.");
        }
        return service.getUserByName(username)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<User>>>() {
                @Override
                public Observable<ServiceResponse<User>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<User> clientResponse = getUserByNameDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return updateUserAsync(username).toBlocking().single();
    }

    /**
     * Updated user.
     * This can only be done by the logged in user.
     *
     * @param username name that need to be deleted
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> updateUserAsync(String username, final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(updateUserAsync(username), serviceCallback);
    }

    /**
     * Updated user.
     * This can only be done by the logged in user.
     *
     * @param username name that need to be deleted
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> updateUserAsync(String username) {
        if (username == null) {
            throw new IllegalArgumentException("Parameter username is required and cannot be null.");
        }
        final User body = null;
        return service.updateUser(username, body)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = updateUserDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return updateUserAsync(username, body).toBlocking().single();
    }

    /**
     * Updated user.
     * This can only be done by the logged in user.
     *
     * @param username name that need to be deleted
     * @param body Updated user object
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> updateUserAsync(String username, User body, final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(updateUserAsync(username, body), serviceCallback);
    }

    /**
     * Updated user.
     * This can only be done by the logged in user.
     *
     * @param username name that need to be deleted
     * @param body Updated user object
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> updateUserAsync(String username, User body) {
        if (username == null) {
            throw new IllegalArgumentException("Parameter username is required and cannot be null.");
        }
        Validator.validate(body);
        return service.updateUser(username, body)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = updateUserDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
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
        return deleteUserAsync(username).toBlocking().single();
    }

    /**
     * Delete user.
     * This can only be done by the logged in user.
     *
     * @param username The name that needs to be deleted
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> deleteUserAsync(String username, final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(deleteUserAsync(username), serviceCallback);
    }

    /**
     * Delete user.
     * This can only be done by the logged in user.
     *
     * @param username The name that needs to be deleted
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> deleteUserAsync(String username) {
        if (username == null) {
            throw new IllegalArgumentException("Parameter username is required and cannot be null.");
        }
        return service.deleteUser(username)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = deleteUserDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
    }

    private ServiceResponse<Void> deleteUserDelegate(Response<ResponseBody> response) throws ServiceException, IOException, IllegalArgumentException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.mapperAdapter())
                .register(404, new TypeToken<Void>() { }.getType())
                .register(400, new TypeToken<Void>() { }.getType())
                .build(response);
    }

}
