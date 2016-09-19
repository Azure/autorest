/**
 */

package petstore.implementation;

import retrofit2.Retrofit;
import com.google.common.reflect.TypeToken;
import com.microsoft.azure.AzureServiceResponseBuilder;
import com.microsoft.azure.CloudException;
import com.microsoft.rest.ServiceCall;
import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.Validator;
import java.io.IOException;
import java.util.List;
import okhttp3.ResponseBody;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.Header;
import retrofit2.http.Headers;
import retrofit2.http.HTTP;
import retrofit2.http.PATCH;
import retrofit2.http.Path;
import retrofit2.http.POST;
import retrofit2.http.PUT;
import retrofit2.http.Query;
import retrofit2.Response;
import rx.functions.Func1;
import rx.Observable;

/**
 * An instance of this class provides access to all the operations defined
 * in StorageAccounts.
 */
public final class StorageAccountsInner {
    /** The Retrofit service to perform REST calls. */
    private StorageAccountsService service;
    /** The service client containing this operation class. */
    private StorageManagementClientImpl client;

    /**
     * Initializes an instance of StorageAccountsInner.
     *
     * @param retrofit the Retrofit instance built from a Retrofit Builder.
     * @param client the instance of the service client containing this operation class.
     */
    public StorageAccountsInner(Retrofit retrofit, StorageManagementClientImpl client) {
        this.service = retrofit.create(StorageAccountsService.class);
        this.client = client;
    }

    /**
     * The interface defining all the services for StorageAccounts to be
     * used by Retrofit to perform actually REST calls.
     */
    interface StorageAccountsService {
        @Headers("Content-Type: application/json; charset=utf-8")
        @POST("subscriptions/{subscriptionId}/providers/Microsoft.Storage/checkNameAvailability")
        Observable<Response<ResponseBody>> checkNameAvailability(@Path("subscriptionId") String subscriptionId, @Body StorageAccountCheckNameAvailabilityParametersInner accountName, @Query("api-version") String apiVersion, @Header("accept-language") String acceptLanguage, @Header("User-Agent") String userAgent);

        @Headers("Content-Type: application/json; charset=utf-8")
        @PUT("subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}")
        Observable<Response<ResponseBody>> create(@Path("resourceGroupName") String resourceGroupName, @Path("accountName") String accountName, @Path("subscriptionId") String subscriptionId, @Body StorageAccountCreateParametersInner parameters, @Query("api-version") String apiVersion, @Header("accept-language") String acceptLanguage, @Header("User-Agent") String userAgent);

        @Headers("Content-Type: application/json; charset=utf-8")
        @PUT("subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}")
        Observable<Response<ResponseBody>> beginCreate(@Path("resourceGroupName") String resourceGroupName, @Path("accountName") String accountName, @Path("subscriptionId") String subscriptionId, @Body StorageAccountCreateParametersInner parameters, @Query("api-version") String apiVersion, @Header("accept-language") String acceptLanguage, @Header("User-Agent") String userAgent);

        @Headers("Content-Type: application/json; charset=utf-8")
        @HTTP(path = "subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}", method = "DELETE", hasBody = true)
        Observable<Response<ResponseBody>> delete(@Path("resourceGroupName") String resourceGroupName, @Path("accountName") String accountName, @Path("subscriptionId") String subscriptionId, @Query("api-version") String apiVersion, @Header("accept-language") String acceptLanguage, @Header("User-Agent") String userAgent);

        @Headers("Content-Type: application/json; charset=utf-8")
        @GET("subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}")
        Observable<Response<ResponseBody>> getProperties(@Path("resourceGroupName") String resourceGroupName, @Path("accountName") String accountName, @Path("subscriptionId") String subscriptionId, @Query("api-version") String apiVersion, @Header("accept-language") String acceptLanguage, @Header("User-Agent") String userAgent);

        @Headers("Content-Type: application/json; charset=utf-8")
        @PATCH("subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}")
        Observable<Response<ResponseBody>> update(@Path("resourceGroupName") String resourceGroupName, @Path("accountName") String accountName, @Path("subscriptionId") String subscriptionId, @Body StorageAccountUpdateParametersInner parameters, @Query("api-version") String apiVersion, @Header("accept-language") String acceptLanguage, @Header("User-Agent") String userAgent);

        @Headers("Content-Type: application/json; charset=utf-8")
        @POST("subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/listKeys")
        Observable<Response<ResponseBody>> listKeys(@Path("resourceGroupName") String resourceGroupName, @Path("accountName") String accountName, @Path("subscriptionId") String subscriptionId, @Query("api-version") String apiVersion, @Header("accept-language") String acceptLanguage, @Header("User-Agent") String userAgent);

        @Headers("Content-Type: application/json; charset=utf-8")
        @GET("subscriptions/{subscriptionId}/providers/Microsoft.Storage/storageAccounts")
        Observable<Response<ResponseBody>> list(@Path("subscriptionId") String subscriptionId, @Query("api-version") String apiVersion, @Header("accept-language") String acceptLanguage, @Header("User-Agent") String userAgent);

        @Headers("Content-Type: application/json; charset=utf-8")
        @GET("subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts")
        Observable<Response<ResponseBody>> listByResourceGroup(@Path("resourceGroupName") String resourceGroupName, @Path("subscriptionId") String subscriptionId, @Query("api-version") String apiVersion, @Header("accept-language") String acceptLanguage, @Header("User-Agent") String userAgent);

        @Headers("Content-Type: application/json; charset=utf-8")
        @POST("subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/regenerateKey")
        Observable<Response<ResponseBody>> regenerateKey(@Path("resourceGroupName") String resourceGroupName, @Path("accountName") String accountName, @Path("subscriptionId") String subscriptionId, @Body StorageAccountRegenerateKeyParametersInner regenerateKey, @Query("api-version") String apiVersion, @Header("accept-language") String acceptLanguage, @Header("User-Agent") String userAgent);

    }

    /**
     * Checks that account name is valid and is not in use.
     *
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @return the CheckNameAvailabilityResultInner object if successful.
     */
    public CheckNameAvailabilityResultInner checkNameAvailability(StorageAccountCheckNameAvailabilityParametersInner accountName) {
        return checkNameAvailabilityWithServiceResponseAsync(accountName).toBlocking().single().getBody();
    }

    /**
     * Checks that account name is valid and is not in use.
     *
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<CheckNameAvailabilityResultInner> checkNameAvailabilityAsync(StorageAccountCheckNameAvailabilityParametersInner accountName, final ServiceCallback<CheckNameAvailabilityResultInner> serviceCallback) {
        return ServiceCall.create(checkNameAvailabilityWithServiceResponseAsync(accountName), serviceCallback);
    }

    /**
     * Checks that account name is valid and is not in use.
     *
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @return the observable to the CheckNameAvailabilityResultInner object
     */
    public Observable<CheckNameAvailabilityResultInner> checkNameAvailabilityAsync(StorageAccountCheckNameAvailabilityParametersInner accountName) {
        return checkNameAvailabilityWithServiceResponseAsync(accountName).map(new Func1<ServiceResponse<CheckNameAvailabilityResultInner>, CheckNameAvailabilityResultInner>() {
            @Override
            public CheckNameAvailabilityResultInner call(ServiceResponse<CheckNameAvailabilityResultInner> response) {
                return response.getBody();
            }
        });
    }

    /**
     * Checks that account name is valid and is not in use.
     *
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @return the observable to the CheckNameAvailabilityResultInner object
     */
    public Observable<ServiceResponse<CheckNameAvailabilityResultInner>> checkNameAvailabilityWithServiceResponseAsync(StorageAccountCheckNameAvailabilityParametersInner accountName) {
        if (this.client.subscriptionId() == null) {
            throw new IllegalArgumentException("Parameter this.client.subscriptionId() is required and cannot be null.");
        }
        if (accountName == null) {
            throw new IllegalArgumentException("Parameter accountName is required and cannot be null.");
        }
        if (this.client.apiVersion() == null) {
            throw new IllegalArgumentException("Parameter this.client.apiVersion() is required and cannot be null.");
        }
        Validator.validate(accountName);
        return service.checkNameAvailability(this.client.subscriptionId(), accountName, this.client.apiVersion(), this.client.acceptLanguage(), this.client.userAgent())
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<CheckNameAvailabilityResultInner>>>() {
                @Override
                public Observable<ServiceResponse<CheckNameAvailabilityResultInner>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<CheckNameAvailabilityResultInner> clientResponse = checkNameAvailabilityDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
    }

    private ServiceResponse<CheckNameAvailabilityResultInner> checkNameAvailabilityDelegate(Response<ResponseBody> response) throws CloudException, IOException, IllegalArgumentException {
        return new AzureServiceResponseBuilder<CheckNameAvailabilityResultInner, CloudException>(this.client.mapperAdapter())
                .register(200, new TypeToken<CheckNameAvailabilityResultInner>() { }.getType())
                .registerError(CloudException.class)
                .build(response);
    }

    /**
     * Asynchronously creates a new storage account with the specified parameters. Existing accounts cannot be updated with this API and should instead use the Update Storage Account API. If an account is already created and subsequent PUT request is issued with exact same set of properties, then HTTP 200 would be returned.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param parameters The parameters to provide for the created account.
     * @return the StorageAccountInner object if successful.
     */
    public StorageAccountInner create(String resourceGroupName, String accountName, StorageAccountCreateParametersInner parameters) {
        return createWithServiceResponseAsync(resourceGroupName, accountName, parameters).toBlocking().last().getBody();
    }

    /**
     * Asynchronously creates a new storage account with the specified parameters. Existing accounts cannot be updated with this API and should instead use the Update Storage Account API. If an account is already created and subsequent PUT request is issued with exact same set of properties, then HTTP 200 would be returned.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param parameters The parameters to provide for the created account.
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<StorageAccountInner> createAsync(String resourceGroupName, String accountName, StorageAccountCreateParametersInner parameters, final ServiceCallback<StorageAccountInner> serviceCallback) {
        return ServiceCall.create(createWithServiceResponseAsync(resourceGroupName, accountName, parameters), serviceCallback);
    }

    /**
     * Asynchronously creates a new storage account with the specified parameters. Existing accounts cannot be updated with this API and should instead use the Update Storage Account API. If an account is already created and subsequent PUT request is issued with exact same set of properties, then HTTP 200 would be returned.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param parameters The parameters to provide for the created account.
     * @return the observable for the request
     */
    public Observable<StorageAccountInner> createAsync(String resourceGroupName, String accountName, StorageAccountCreateParametersInner parameters) {
        return createWithServiceResponseAsync(resourceGroupName, accountName, parameters).map(new Func1<ServiceResponse<StorageAccountInner>, StorageAccountInner>() {
            @Override
            public StorageAccountInner call(ServiceResponse<StorageAccountInner> response) {
                return response.getBody();
            }
        });
    }

    /**
     * Asynchronously creates a new storage account with the specified parameters. Existing accounts cannot be updated with this API and should instead use the Update Storage Account API. If an account is already created and subsequent PUT request is issued with exact same set of properties, then HTTP 200 would be returned.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param parameters The parameters to provide for the created account.
     * @return the observable for the request
     */
    public Observable<ServiceResponse<StorageAccountInner>> createWithServiceResponseAsync(String resourceGroupName, String accountName, StorageAccountCreateParametersInner parameters) {
        if (resourceGroupName == null) {
            throw new IllegalArgumentException("Parameter resourceGroupName is required and cannot be null.");
        }
        if (accountName == null) {
            throw new IllegalArgumentException("Parameter accountName is required and cannot be null.");
        }
        if (this.client.subscriptionId() == null) {
            throw new IllegalArgumentException("Parameter this.client.subscriptionId() is required and cannot be null.");
        }
        if (parameters == null) {
            throw new IllegalArgumentException("Parameter parameters is required and cannot be null.");
        }
        if (this.client.apiVersion() == null) {
            throw new IllegalArgumentException("Parameter this.client.apiVersion() is required and cannot be null.");
        }
        Validator.validate(parameters);
        Observable<Response<ResponseBody>> observable = service.create(resourceGroupName, accountName, this.client.subscriptionId(), parameters, this.client.apiVersion(), this.client.acceptLanguage(), this.client.userAgent());
        return client.getAzureClient().getPutOrPatchResultAsync(observable, new TypeToken<StorageAccountInner>() { }.getType());
    }

    /**
     * Asynchronously creates a new storage account with the specified parameters. Existing accounts cannot be updated with this API and should instead use the Update Storage Account API. If an account is already created and subsequent PUT request is issued with exact same set of properties, then HTTP 200 would be returned.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param parameters The parameters to provide for the created account.
     * @return the StorageAccountInner object if successful.
     */
    public StorageAccountInner beginCreate(String resourceGroupName, String accountName, StorageAccountCreateParametersInner parameters) {
        return beginCreateWithServiceResponseAsync(resourceGroupName, accountName, parameters).toBlocking().single().getBody();
    }

    /**
     * Asynchronously creates a new storage account with the specified parameters. Existing accounts cannot be updated with this API and should instead use the Update Storage Account API. If an account is already created and subsequent PUT request is issued with exact same set of properties, then HTTP 200 would be returned.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param parameters The parameters to provide for the created account.
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<StorageAccountInner> beginCreateAsync(String resourceGroupName, String accountName, StorageAccountCreateParametersInner parameters, final ServiceCallback<StorageAccountInner> serviceCallback) {
        return ServiceCall.create(beginCreateWithServiceResponseAsync(resourceGroupName, accountName, parameters), serviceCallback);
    }

    /**
     * Asynchronously creates a new storage account with the specified parameters. Existing accounts cannot be updated with this API and should instead use the Update Storage Account API. If an account is already created and subsequent PUT request is issued with exact same set of properties, then HTTP 200 would be returned.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param parameters The parameters to provide for the created account.
     * @return the observable to the StorageAccountInner object
     */
    public Observable<StorageAccountInner> beginCreateAsync(String resourceGroupName, String accountName, StorageAccountCreateParametersInner parameters) {
        return beginCreateWithServiceResponseAsync(resourceGroupName, accountName, parameters).map(new Func1<ServiceResponse<StorageAccountInner>, StorageAccountInner>() {
            @Override
            public StorageAccountInner call(ServiceResponse<StorageAccountInner> response) {
                return response.getBody();
            }
        });
    }

    /**
     * Asynchronously creates a new storage account with the specified parameters. Existing accounts cannot be updated with this API and should instead use the Update Storage Account API. If an account is already created and subsequent PUT request is issued with exact same set of properties, then HTTP 200 would be returned.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param parameters The parameters to provide for the created account.
     * @return the observable to the StorageAccountInner object
     */
    public Observable<ServiceResponse<StorageAccountInner>> beginCreateWithServiceResponseAsync(String resourceGroupName, String accountName, StorageAccountCreateParametersInner parameters) {
        if (resourceGroupName == null) {
            throw new IllegalArgumentException("Parameter resourceGroupName is required and cannot be null.");
        }
        if (accountName == null) {
            throw new IllegalArgumentException("Parameter accountName is required and cannot be null.");
        }
        if (this.client.subscriptionId() == null) {
            throw new IllegalArgumentException("Parameter this.client.subscriptionId() is required and cannot be null.");
        }
        if (parameters == null) {
            throw new IllegalArgumentException("Parameter parameters is required and cannot be null.");
        }
        if (this.client.apiVersion() == null) {
            throw new IllegalArgumentException("Parameter this.client.apiVersion() is required and cannot be null.");
        }
        Validator.validate(parameters);
        return service.beginCreate(resourceGroupName, accountName, this.client.subscriptionId(), parameters, this.client.apiVersion(), this.client.acceptLanguage(), this.client.userAgent())
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<StorageAccountInner>>>() {
                @Override
                public Observable<ServiceResponse<StorageAccountInner>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<StorageAccountInner> clientResponse = beginCreateDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
    }

    private ServiceResponse<StorageAccountInner> beginCreateDelegate(Response<ResponseBody> response) throws CloudException, IOException, IllegalArgumentException {
        return new AzureServiceResponseBuilder<StorageAccountInner, CloudException>(this.client.mapperAdapter())
                .register(200, new TypeToken<StorageAccountInner>() { }.getType())
                .register(202, new TypeToken<Void>() { }.getType())
                .registerError(CloudException.class)
                .build(response);
    }

    /**
     * Deletes a storage account in Microsoft Azure.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     */
    public void delete(String resourceGroupName, String accountName) {
        deleteWithServiceResponseAsync(resourceGroupName, accountName).toBlocking().single().getBody();
    }

    /**
     * Deletes a storage account in Microsoft Azure.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> deleteAsync(String resourceGroupName, String accountName, final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(deleteWithServiceResponseAsync(resourceGroupName, accountName), serviceCallback);
    }

    /**
     * Deletes a storage account in Microsoft Azure.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<Void> deleteAsync(String resourceGroupName, String accountName) {
        return deleteWithServiceResponseAsync(resourceGroupName, accountName).map(new Func1<ServiceResponse<Void>, Void>() {
            @Override
            public Void call(ServiceResponse<Void> response) {
                return response.getBody();
            }
        });
    }

    /**
     * Deletes a storage account in Microsoft Azure.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> deleteWithServiceResponseAsync(String resourceGroupName, String accountName) {
        if (resourceGroupName == null) {
            throw new IllegalArgumentException("Parameter resourceGroupName is required and cannot be null.");
        }
        if (accountName == null) {
            throw new IllegalArgumentException("Parameter accountName is required and cannot be null.");
        }
        if (this.client.subscriptionId() == null) {
            throw new IllegalArgumentException("Parameter this.client.subscriptionId() is required and cannot be null.");
        }
        if (this.client.apiVersion() == null) {
            throw new IllegalArgumentException("Parameter this.client.apiVersion() is required and cannot be null.");
        }
        return service.delete(resourceGroupName, accountName, this.client.subscriptionId(), this.client.apiVersion(), this.client.acceptLanguage(), this.client.userAgent())
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = deleteDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
    }

    private ServiceResponse<Void> deleteDelegate(Response<ResponseBody> response) throws CloudException, IOException, IllegalArgumentException {
        return new AzureServiceResponseBuilder<Void, CloudException>(this.client.mapperAdapter())
                .register(200, new TypeToken<Void>() { }.getType())
                .register(204, new TypeToken<Void>() { }.getType())
                .build(response);
    }

    /**
     * Returns the properties for the specified storage account including but not limited to name, account type, location, and account status. The ListKeys operation should be used to retrieve storage keys.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @return the StorageAccountInner object if successful.
     */
    public StorageAccountInner getProperties(String resourceGroupName, String accountName) {
        return getPropertiesWithServiceResponseAsync(resourceGroupName, accountName).toBlocking().single().getBody();
    }

    /**
     * Returns the properties for the specified storage account including but not limited to name, account type, location, and account status. The ListKeys operation should be used to retrieve storage keys.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<StorageAccountInner> getPropertiesAsync(String resourceGroupName, String accountName, final ServiceCallback<StorageAccountInner> serviceCallback) {
        return ServiceCall.create(getPropertiesWithServiceResponseAsync(resourceGroupName, accountName), serviceCallback);
    }

    /**
     * Returns the properties for the specified storage account including but not limited to name, account type, location, and account status. The ListKeys operation should be used to retrieve storage keys.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @return the observable to the StorageAccountInner object
     */
    public Observable<StorageAccountInner> getPropertiesAsync(String resourceGroupName, String accountName) {
        return getPropertiesWithServiceResponseAsync(resourceGroupName, accountName).map(new Func1<ServiceResponse<StorageAccountInner>, StorageAccountInner>() {
            @Override
            public StorageAccountInner call(ServiceResponse<StorageAccountInner> response) {
                return response.getBody();
            }
        });
    }

    /**
     * Returns the properties for the specified storage account including but not limited to name, account type, location, and account status. The ListKeys operation should be used to retrieve storage keys.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @return the observable to the StorageAccountInner object
     */
    public Observable<ServiceResponse<StorageAccountInner>> getPropertiesWithServiceResponseAsync(String resourceGroupName, String accountName) {
        if (resourceGroupName == null) {
            throw new IllegalArgumentException("Parameter resourceGroupName is required and cannot be null.");
        }
        if (accountName == null) {
            throw new IllegalArgumentException("Parameter accountName is required and cannot be null.");
        }
        if (this.client.subscriptionId() == null) {
            throw new IllegalArgumentException("Parameter this.client.subscriptionId() is required and cannot be null.");
        }
        if (this.client.apiVersion() == null) {
            throw new IllegalArgumentException("Parameter this.client.apiVersion() is required and cannot be null.");
        }
        return service.getProperties(resourceGroupName, accountName, this.client.subscriptionId(), this.client.apiVersion(), this.client.acceptLanguage(), this.client.userAgent())
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<StorageAccountInner>>>() {
                @Override
                public Observable<ServiceResponse<StorageAccountInner>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<StorageAccountInner> clientResponse = getPropertiesDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
    }

    private ServiceResponse<StorageAccountInner> getPropertiesDelegate(Response<ResponseBody> response) throws CloudException, IOException, IllegalArgumentException {
        return new AzureServiceResponseBuilder<StorageAccountInner, CloudException>(this.client.mapperAdapter())
                .register(200, new TypeToken<StorageAccountInner>() { }.getType())
                .registerError(CloudException.class)
                .build(response);
    }

    /**
     * Updates the account type or tags for a storage account. It can also be used to add a custom domain (note that custom domains cannot be added via the Create operation). Only one custom domain is supported per storage account. In order to replace a custom domain, the old value must be cleared before a new value may be set. To clear a custom domain, simply update the custom domain with empty string. Then call update again with the new cutsom domain name. The update API can only be used to update one of tags, accountType, or customDomain per call. To update multiple of these properties, call the API multiple times with one change per call. This call does not change the storage keys for the account. If you want to change storage account keys, use the RegenerateKey operation. The location and name of the storage account cannot be changed after creation.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param parameters The parameters to update on the account. Note that only one property can be changed at a time using this API.
     * @return the StorageAccountInner object if successful.
     */
    public StorageAccountInner update(String resourceGroupName, String accountName, StorageAccountUpdateParametersInner parameters) {
        return updateWithServiceResponseAsync(resourceGroupName, accountName, parameters).toBlocking().single().getBody();
    }

    /**
     * Updates the account type or tags for a storage account. It can also be used to add a custom domain (note that custom domains cannot be added via the Create operation). Only one custom domain is supported per storage account. In order to replace a custom domain, the old value must be cleared before a new value may be set. To clear a custom domain, simply update the custom domain with empty string. Then call update again with the new cutsom domain name. The update API can only be used to update one of tags, accountType, or customDomain per call. To update multiple of these properties, call the API multiple times with one change per call. This call does not change the storage keys for the account. If you want to change storage account keys, use the RegenerateKey operation. The location and name of the storage account cannot be changed after creation.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param parameters The parameters to update on the account. Note that only one property can be changed at a time using this API.
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<StorageAccountInner> updateAsync(String resourceGroupName, String accountName, StorageAccountUpdateParametersInner parameters, final ServiceCallback<StorageAccountInner> serviceCallback) {
        return ServiceCall.create(updateWithServiceResponseAsync(resourceGroupName, accountName, parameters), serviceCallback);
    }

    /**
     * Updates the account type or tags for a storage account. It can also be used to add a custom domain (note that custom domains cannot be added via the Create operation). Only one custom domain is supported per storage account. In order to replace a custom domain, the old value must be cleared before a new value may be set. To clear a custom domain, simply update the custom domain with empty string. Then call update again with the new cutsom domain name. The update API can only be used to update one of tags, accountType, or customDomain per call. To update multiple of these properties, call the API multiple times with one change per call. This call does not change the storage keys for the account. If you want to change storage account keys, use the RegenerateKey operation. The location and name of the storage account cannot be changed after creation.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param parameters The parameters to update on the account. Note that only one property can be changed at a time using this API.
     * @return the observable to the StorageAccountInner object
     */
    public Observable<StorageAccountInner> updateAsync(String resourceGroupName, String accountName, StorageAccountUpdateParametersInner parameters) {
        return updateWithServiceResponseAsync(resourceGroupName, accountName, parameters).map(new Func1<ServiceResponse<StorageAccountInner>, StorageAccountInner>() {
            @Override
            public StorageAccountInner call(ServiceResponse<StorageAccountInner> response) {
                return response.getBody();
            }
        });
    }

    /**
     * Updates the account type or tags for a storage account. It can also be used to add a custom domain (note that custom domains cannot be added via the Create operation). Only one custom domain is supported per storage account. In order to replace a custom domain, the old value must be cleared before a new value may be set. To clear a custom domain, simply update the custom domain with empty string. Then call update again with the new cutsom domain name. The update API can only be used to update one of tags, accountType, or customDomain per call. To update multiple of these properties, call the API multiple times with one change per call. This call does not change the storage keys for the account. If you want to change storage account keys, use the RegenerateKey operation. The location and name of the storage account cannot be changed after creation.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param parameters The parameters to update on the account. Note that only one property can be changed at a time using this API.
     * @return the observable to the StorageAccountInner object
     */
    public Observable<ServiceResponse<StorageAccountInner>> updateWithServiceResponseAsync(String resourceGroupName, String accountName, StorageAccountUpdateParametersInner parameters) {
        if (resourceGroupName == null) {
            throw new IllegalArgumentException("Parameter resourceGroupName is required and cannot be null.");
        }
        if (accountName == null) {
            throw new IllegalArgumentException("Parameter accountName is required and cannot be null.");
        }
        if (this.client.subscriptionId() == null) {
            throw new IllegalArgumentException("Parameter this.client.subscriptionId() is required and cannot be null.");
        }
        if (parameters == null) {
            throw new IllegalArgumentException("Parameter parameters is required and cannot be null.");
        }
        if (this.client.apiVersion() == null) {
            throw new IllegalArgumentException("Parameter this.client.apiVersion() is required and cannot be null.");
        }
        Validator.validate(parameters);
        return service.update(resourceGroupName, accountName, this.client.subscriptionId(), parameters, this.client.apiVersion(), this.client.acceptLanguage(), this.client.userAgent())
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<StorageAccountInner>>>() {
                @Override
                public Observable<ServiceResponse<StorageAccountInner>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<StorageAccountInner> clientResponse = updateDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
    }

    private ServiceResponse<StorageAccountInner> updateDelegate(Response<ResponseBody> response) throws CloudException, IOException, IllegalArgumentException {
        return new AzureServiceResponseBuilder<StorageAccountInner, CloudException>(this.client.mapperAdapter())
                .register(200, new TypeToken<StorageAccountInner>() { }.getType())
                .registerError(CloudException.class)
                .build(response);
    }

    /**
     * Lists the access keys for the specified storage account.
     *
     * @param resourceGroupName The name of the resource group.
     * @param accountName The name of the storage account.
     * @return the StorageAccountKeysInner object if successful.
     */
    public StorageAccountKeysInner listKeys(String resourceGroupName, String accountName) {
        return listKeysWithServiceResponseAsync(resourceGroupName, accountName).toBlocking().single().getBody();
    }

    /**
     * Lists the access keys for the specified storage account.
     *
     * @param resourceGroupName The name of the resource group.
     * @param accountName The name of the storage account.
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<StorageAccountKeysInner> listKeysAsync(String resourceGroupName, String accountName, final ServiceCallback<StorageAccountKeysInner> serviceCallback) {
        return ServiceCall.create(listKeysWithServiceResponseAsync(resourceGroupName, accountName), serviceCallback);
    }

    /**
     * Lists the access keys for the specified storage account.
     *
     * @param resourceGroupName The name of the resource group.
     * @param accountName The name of the storage account.
     * @return the observable to the StorageAccountKeysInner object
     */
    public Observable<StorageAccountKeysInner> listKeysAsync(String resourceGroupName, String accountName) {
        return listKeysWithServiceResponseAsync(resourceGroupName, accountName).map(new Func1<ServiceResponse<StorageAccountKeysInner>, StorageAccountKeysInner>() {
            @Override
            public StorageAccountKeysInner call(ServiceResponse<StorageAccountKeysInner> response) {
                return response.getBody();
            }
        });
    }

    /**
     * Lists the access keys for the specified storage account.
     *
     * @param resourceGroupName The name of the resource group.
     * @param accountName The name of the storage account.
     * @return the observable to the StorageAccountKeysInner object
     */
    public Observable<ServiceResponse<StorageAccountKeysInner>> listKeysWithServiceResponseAsync(String resourceGroupName, String accountName) {
        if (resourceGroupName == null) {
            throw new IllegalArgumentException("Parameter resourceGroupName is required and cannot be null.");
        }
        if (accountName == null) {
            throw new IllegalArgumentException("Parameter accountName is required and cannot be null.");
        }
        if (this.client.subscriptionId() == null) {
            throw new IllegalArgumentException("Parameter this.client.subscriptionId() is required and cannot be null.");
        }
        if (this.client.apiVersion() == null) {
            throw new IllegalArgumentException("Parameter this.client.apiVersion() is required and cannot be null.");
        }
        return service.listKeys(resourceGroupName, accountName, this.client.subscriptionId(), this.client.apiVersion(), this.client.acceptLanguage(), this.client.userAgent())
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<StorageAccountKeysInner>>>() {
                @Override
                public Observable<ServiceResponse<StorageAccountKeysInner>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<StorageAccountKeysInner> clientResponse = listKeysDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
    }

    private ServiceResponse<StorageAccountKeysInner> listKeysDelegate(Response<ResponseBody> response) throws CloudException, IOException, IllegalArgumentException {
        return new AzureServiceResponseBuilder<StorageAccountKeysInner, CloudException>(this.client.mapperAdapter())
                .register(200, new TypeToken<StorageAccountKeysInner>() { }.getType())
                .registerError(CloudException.class)
                .build(response);
    }

    /**
     * Lists all the storage accounts available under the subscription. Note that storage keys are not returned; use the ListKeys operation for this.
     *
     * @return the List&lt;StorageAccountInner&gt; object if successful.
     */
    public List<StorageAccountInner> list() {
        return listWithServiceResponseAsync().toBlocking().single().getBody();
    }

    /**
     * Lists all the storage accounts available under the subscription. Note that storage keys are not returned; use the ListKeys operation for this.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<List<StorageAccountInner>> listAsync(final ServiceCallback<List<StorageAccountInner>> serviceCallback) {
        return ServiceCall.create(listWithServiceResponseAsync(), serviceCallback);
    }

    /**
     * Lists all the storage accounts available under the subscription. Note that storage keys are not returned; use the ListKeys operation for this.
     *
     * @return the observable to the List&lt;StorageAccountInner&gt; object
     */
    public Observable<List<StorageAccountInner>> listAsync() {
        return listWithServiceResponseAsync().map(new Func1<ServiceResponse<List<StorageAccountInner>>, List<StorageAccountInner>>() {
            @Override
            public List<StorageAccountInner> call(ServiceResponse<List<StorageAccountInner>> response) {
                return response.getBody();
            }
        });
    }

    /**
     * Lists all the storage accounts available under the subscription. Note that storage keys are not returned; use the ListKeys operation for this.
     *
     * @return the observable to the List&lt;StorageAccountInner&gt; object
     */
    public Observable<ServiceResponse<List<StorageAccountInner>>> listWithServiceResponseAsync() {
        if (this.client.subscriptionId() == null) {
            throw new IllegalArgumentException("Parameter this.client.subscriptionId() is required and cannot be null.");
        }
        if (this.client.apiVersion() == null) {
            throw new IllegalArgumentException("Parameter this.client.apiVersion() is required and cannot be null.");
        }
        return service.list(this.client.subscriptionId(), this.client.apiVersion(), this.client.acceptLanguage(), this.client.userAgent())
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<List<StorageAccountInner>>>>() {
                @Override
                public Observable<ServiceResponse<List<StorageAccountInner>>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<PageImpl<StorageAccountInner>> result = listDelegate(response);
                        ServiceResponse<List<StorageAccountInner>> clientResponse = new ServiceResponse<List<StorageAccountInner>>(result.getBody().getItems(), result.getResponse());
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
    }

    private ServiceResponse<PageImpl<StorageAccountInner>> listDelegate(Response<ResponseBody> response) throws CloudException, IOException, IllegalArgumentException {
        return new AzureServiceResponseBuilder<PageImpl<StorageAccountInner>, CloudException>(this.client.mapperAdapter())
                .register(200, new TypeToken<PageImpl<StorageAccountInner>>() { }.getType())
                .registerError(CloudException.class)
                .build(response);
    }

    /**
     * Lists all the storage accounts available under the given resource group. Note that storage keys are not returned; use the ListKeys operation for this.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @return the List&lt;StorageAccountInner&gt; object if successful.
     */
    public List<StorageAccountInner> listByResourceGroup(String resourceGroupName) {
        return listByResourceGroupWithServiceResponseAsync(resourceGroupName).toBlocking().single().getBody();
    }

    /**
     * Lists all the storage accounts available under the given resource group. Note that storage keys are not returned; use the ListKeys operation for this.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<List<StorageAccountInner>> listByResourceGroupAsync(String resourceGroupName, final ServiceCallback<List<StorageAccountInner>> serviceCallback) {
        return ServiceCall.create(listByResourceGroupWithServiceResponseAsync(resourceGroupName), serviceCallback);
    }

    /**
     * Lists all the storage accounts available under the given resource group. Note that storage keys are not returned; use the ListKeys operation for this.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @return the observable to the List&lt;StorageAccountInner&gt; object
     */
    public Observable<List<StorageAccountInner>> listByResourceGroupAsync(String resourceGroupName) {
        return listByResourceGroupWithServiceResponseAsync(resourceGroupName).map(new Func1<ServiceResponse<List<StorageAccountInner>>, List<StorageAccountInner>>() {
            @Override
            public List<StorageAccountInner> call(ServiceResponse<List<StorageAccountInner>> response) {
                return response.getBody();
            }
        });
    }

    /**
     * Lists all the storage accounts available under the given resource group. Note that storage keys are not returned; use the ListKeys operation for this.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @return the observable to the List&lt;StorageAccountInner&gt; object
     */
    public Observable<ServiceResponse<List<StorageAccountInner>>> listByResourceGroupWithServiceResponseAsync(String resourceGroupName) {
        if (resourceGroupName == null) {
            throw new IllegalArgumentException("Parameter resourceGroupName is required and cannot be null.");
        }
        if (this.client.subscriptionId() == null) {
            throw new IllegalArgumentException("Parameter this.client.subscriptionId() is required and cannot be null.");
        }
        if (this.client.apiVersion() == null) {
            throw new IllegalArgumentException("Parameter this.client.apiVersion() is required and cannot be null.");
        }
        return service.listByResourceGroup(resourceGroupName, this.client.subscriptionId(), this.client.apiVersion(), this.client.acceptLanguage(), this.client.userAgent())
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<List<StorageAccountInner>>>>() {
                @Override
                public Observable<ServiceResponse<List<StorageAccountInner>>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<PageImpl<StorageAccountInner>> result = listByResourceGroupDelegate(response);
                        ServiceResponse<List<StorageAccountInner>> clientResponse = new ServiceResponse<List<StorageAccountInner>>(result.getBody().getItems(), result.getResponse());
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
    }

    private ServiceResponse<PageImpl<StorageAccountInner>> listByResourceGroupDelegate(Response<ResponseBody> response) throws CloudException, IOException, IllegalArgumentException {
        return new AzureServiceResponseBuilder<PageImpl<StorageAccountInner>, CloudException>(this.client.mapperAdapter())
                .register(200, new TypeToken<PageImpl<StorageAccountInner>>() { }.getType())
                .registerError(CloudException.class)
                .build(response);
    }

    /**
     * Regenerates the access keys for the specified storage account.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param regenerateKey Specifies name of the key which should be regenerated. key1 or key2 for the default keys
     * @return the StorageAccountKeysInner object if successful.
     */
    public StorageAccountKeysInner regenerateKey(String resourceGroupName, String accountName, StorageAccountRegenerateKeyParametersInner regenerateKey) {
        return regenerateKeyWithServiceResponseAsync(resourceGroupName, accountName, regenerateKey).toBlocking().single().getBody();
    }

    /**
     * Regenerates the access keys for the specified storage account.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param regenerateKey Specifies name of the key which should be regenerated. key1 or key2 for the default keys
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<StorageAccountKeysInner> regenerateKeyAsync(String resourceGroupName, String accountName, StorageAccountRegenerateKeyParametersInner regenerateKey, final ServiceCallback<StorageAccountKeysInner> serviceCallback) {
        return ServiceCall.create(regenerateKeyWithServiceResponseAsync(resourceGroupName, accountName, regenerateKey), serviceCallback);
    }

    /**
     * Regenerates the access keys for the specified storage account.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param regenerateKey Specifies name of the key which should be regenerated. key1 or key2 for the default keys
     * @return the observable to the StorageAccountKeysInner object
     */
    public Observable<StorageAccountKeysInner> regenerateKeyAsync(String resourceGroupName, String accountName, StorageAccountRegenerateKeyParametersInner regenerateKey) {
        return regenerateKeyWithServiceResponseAsync(resourceGroupName, accountName, regenerateKey).map(new Func1<ServiceResponse<StorageAccountKeysInner>, StorageAccountKeysInner>() {
            @Override
            public StorageAccountKeysInner call(ServiceResponse<StorageAccountKeysInner> response) {
                return response.getBody();
            }
        });
    }

    /**
     * Regenerates the access keys for the specified storage account.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param regenerateKey Specifies name of the key which should be regenerated. key1 or key2 for the default keys
     * @return the observable to the StorageAccountKeysInner object
     */
    public Observable<ServiceResponse<StorageAccountKeysInner>> regenerateKeyWithServiceResponseAsync(String resourceGroupName, String accountName, StorageAccountRegenerateKeyParametersInner regenerateKey) {
        if (resourceGroupName == null) {
            throw new IllegalArgumentException("Parameter resourceGroupName is required and cannot be null.");
        }
        if (accountName == null) {
            throw new IllegalArgumentException("Parameter accountName is required and cannot be null.");
        }
        if (this.client.subscriptionId() == null) {
            throw new IllegalArgumentException("Parameter this.client.subscriptionId() is required and cannot be null.");
        }
        if (regenerateKey == null) {
            throw new IllegalArgumentException("Parameter regenerateKey is required and cannot be null.");
        }
        if (this.client.apiVersion() == null) {
            throw new IllegalArgumentException("Parameter this.client.apiVersion() is required and cannot be null.");
        }
        Validator.validate(regenerateKey);
        return service.regenerateKey(resourceGroupName, accountName, this.client.subscriptionId(), regenerateKey, this.client.apiVersion(), this.client.acceptLanguage(), this.client.userAgent())
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<StorageAccountKeysInner>>>() {
                @Override
                public Observable<ServiceResponse<StorageAccountKeysInner>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<StorageAccountKeysInner> clientResponse = regenerateKeyDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
    }

    private ServiceResponse<StorageAccountKeysInner> regenerateKeyDelegate(Response<ResponseBody> response) throws CloudException, IOException, IllegalArgumentException {
        return new AzureServiceResponseBuilder<StorageAccountKeysInner, CloudException>(this.client.mapperAdapter())
                .register(200, new TypeToken<StorageAccountKeysInner>() { }.getType())
                .registerError(CloudException.class)
                .build(response);
    }

}
