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
import java.io.IOException;
import java.util.List;
import okhttp3.ResponseBody;
import retrofit2.http.GET;
import retrofit2.http.Header;
import retrofit2.http.Headers;
import retrofit2.http.Path;
import retrofit2.http.Query;
import retrofit2.Response;
import rx.functions.Func1;
import rx.Observable;

/**
 * An instance of this class provides access to all the operations defined
 * in Usages.
 */
public final class UsagesInner {
    /** The Retrofit service to perform REST calls. */
    private UsagesService service;
    /** The service client containing this operation class. */
    private StorageManagementClientImpl client;

    /**
     * Initializes an instance of UsagesInner.
     *
     * @param retrofit the Retrofit instance built from a Retrofit Builder.
     * @param client the instance of the service client containing this operation class.
     */
    public UsagesInner(Retrofit retrofit, StorageManagementClientImpl client) {
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
        Observable<Response<ResponseBody>> list(@Path("subscriptionId") String subscriptionId, @Query("api-version") String apiVersion, @Header("accept-language") String acceptLanguage, @Header("User-Agent") String userAgent);

    }

    /**
     * Gets the current usage count and the limit for the resources under the subscription.
     *
     * @return the List&lt;UsageInner&gt; object if successful.
     */
    public List<UsageInner> list() {
        return listWithServiceResponseAsync().toBlocking().single().getBody();
    }

    /**
     * Gets the current usage count and the limit for the resources under the subscription.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<List<UsageInner>> listAsync(final ServiceCallback<List<UsageInner>> serviceCallback) {
        return ServiceCall.create(listWithServiceResponseAsync(), serviceCallback);
    }

    /**
     * Gets the current usage count and the limit for the resources under the subscription.
     *
     * @return the observable to the List&lt;UsageInner&gt; object
     */
    public Observable<List<UsageInner>> listAsync() {
        return listWithServiceResponseAsync().map(new Func1<ServiceResponse<List<UsageInner>>, List<UsageInner>>() {
            @Override
            public List<UsageInner> call(ServiceResponse<List<UsageInner>> response) {
                return response.getBody();
            }
        });
    }

    /**
     * Gets the current usage count and the limit for the resources under the subscription.
     *
     * @return the observable to the List&lt;UsageInner&gt; object
     */
    public Observable<ServiceResponse<List<UsageInner>>> listWithServiceResponseAsync() {
        if (this.client.subscriptionId() == null) {
            throw new IllegalArgumentException("Parameter this.client.subscriptionId() is required and cannot be null.");
        }
        if (this.client.apiVersion() == null) {
            throw new IllegalArgumentException("Parameter this.client.apiVersion() is required and cannot be null.");
        }
        return service.list(this.client.subscriptionId(), this.client.apiVersion(), this.client.acceptLanguage(), this.client.userAgent())
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<List<UsageInner>>>>() {
                @Override
                public Observable<ServiceResponse<List<UsageInner>>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<PageImpl<UsageInner>> result = listDelegate(response);
                        ServiceResponse<List<UsageInner>> clientResponse = new ServiceResponse<List<UsageInner>>(result.getBody().getItems(), result.getResponse());
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
    }

    private ServiceResponse<PageImpl<UsageInner>> listDelegate(Response<ResponseBody> response) throws CloudException, IOException, IllegalArgumentException {
        return new AzureServiceResponseBuilder<PageImpl<UsageInner>, CloudException>(this.client.mapperAdapter())
                .register(200, new TypeToken<PageImpl<UsageInner>>() { }.getType())
                .registerError(CloudException.class)
                .build(response);
    }

}
