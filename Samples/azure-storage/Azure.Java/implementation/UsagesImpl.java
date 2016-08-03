/**
 */

package petstore.implementation;

import retrofit2.Retrofit;
import petstore.Usages;
import com.google.common.reflect.TypeToken;
import com.microsoft.azure.AzureServiceResponseBuilder;
import com.microsoft.azure.CloudException;
import com.microsoft.rest.ServiceCall;
import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.ServiceResponseCallback;
import java.io.IOException;
import java.util.List;
import okhttp3.ResponseBody;
import petstore.models.PageImpl;
import petstore.models.Usage;
import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Header;
import retrofit2.http.Headers;
import retrofit2.http.Path;
import retrofit2.http.Query;
import retrofit2.Response;

/**
 * An instance of this class provides access to all the operations defined
 * in Usages.
 */
public final class UsagesImpl implements Usages {
    /** The Retrofit service to perform REST calls. */
    private UsagesService service;
    /** The service client containing this operation class. */
    private StorageManagementClientImpl client;

    /**
     * Initializes an instance of UsagesImpl.
     *
     * @param retrofit the Retrofit instance built from a Retrofit Builder.
     * @param client the instance of the service client containing this operation class.
     */
    public UsagesImpl(Retrofit retrofit, StorageManagementClientImpl client) {
        this.service = retrofit.create(UsagesService.class);
        this.client = client;
    }

    /**
     * The interface defining all the services for Usages to be
     * used by Retrofit to perform actually REST calls.
     */
    interface UsagesService {
        @Headers("Content-Type: application/json; charset=utf-8")
        @GET("subscriptions/{subscriptionId}/providers/Microsoft.Storage/usages")
        Call<ResponseBody> list(@Path("subscriptionId") String subscriptionId, @Query("api-version") String apiVersion, @Header("accept-language") String acceptLanguage, @Header("User-Agent") String userAgent);

    }

    /**
     * Gets the current usage count and the limit for the resources under the subscription.
     *
     * @throws CloudException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @throws IllegalArgumentException exception thrown from invalid parameters
     * @return the List&lt;Usage&gt; object wrapped in {@link ServiceResponse} if successful.
     */
    public ServiceResponse<List<Usage>> list() throws CloudException, IOException, IllegalArgumentException {
        if (this.client.subscriptionId() == null) {
            throw new IllegalArgumentException("Parameter this.client.subscriptionId() is required and cannot be null.");
        }
        if (this.client.apiVersion() == null) {
            throw new IllegalArgumentException("Parameter this.client.apiVersion() is required and cannot be null.");
        }
        Call<ResponseBody> call = service.list(this.client.subscriptionId(), this.client.apiVersion(), this.client.acceptLanguage(), this.client.userAgent());
        ServiceResponse<PageImpl<Usage>> response = listDelegate(call.execute());
        List<Usage> result = response.getBody().getItems();
        return new ServiceResponse<>(result, response.getResponse());
    }

    /**
     * Gets the current usage count and the limit for the resources under the subscription.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link Call} object
     */
    public ServiceCall<List<Usage>> listAsync(final ServiceCallback<List<Usage>> serviceCallback) {
        if (this.client.subscriptionId() == null) {
            throw new IllegalArgumentException("Parameter this.client.subscriptionId() is required and cannot be null.");
        }
        if (this.client.apiVersion() == null) {
            throw new IllegalArgumentException("Parameter this.client.apiVersion() is required and cannot be null.");
        }
        Call<ResponseBody> call = service.list(this.client.subscriptionId(), this.client.apiVersion(), this.client.acceptLanguage(), this.client.userAgent());
        final ServiceCall<List<Usage>> serviceCall = new ServiceCall<>(call);
        call.enqueue(new ServiceResponseCallback<List<Usage>>(serviceCall, serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<PageImpl<Usage>> result = listDelegate(response);
                    serviceCallback.success(new ServiceResponse<>(result.getBody().getItems(), result.getResponse()));
                } catch (CloudException | IOException exception) {
                    if (serviceCallback != null) {
                        serviceCallback.failure(exception);
                    }
                    serviceCall.failure(exception);
                }
            }
        });
        return serviceCall;
    }

    private ServiceResponse<PageImpl<Usage>> listDelegate(Response<ResponseBody> response) throws CloudException, IOException, IllegalArgumentException {
        return new AzureServiceResponseBuilder<PageImpl<Usage>, CloudException>(this.client.mapperAdapter())
                .register(200, new TypeToken<PageImpl<Usage>>() { }.getType())
                .registerError(CloudException.class)
                .build(response);
    }

}
