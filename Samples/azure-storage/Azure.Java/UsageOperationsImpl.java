/**
 */

package petstore;

import com.google.common.reflect.TypeToken;
import com.microsoft.azure.AzureServiceResponseBuilder;
import com.microsoft.azure.CloudException;
import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.ServiceResponseCallback;
import java.io.IOException;
import java.util.List;
import okhttp3.ResponseBody;
import petstore.models.PageImpl;
import petstore.models.Usage;
import retrofit2.Call;
import retrofit2.Response;
import retrofit2.Retrofit;

/**
 * An instance of this class provides access to all the operations defined
 * in UsageOperations.
 */
public final class UsageOperationsImpl implements UsageOperations {
    /** The Retrofit service to perform REST calls. */
    private UsageService service;
    /** The service client containing this operation class. */
    private StorageManagementClient client;

    /**
     * Initializes an instance of UsageOperations.
     *
     * @param retrofit the Retrofit instance built from a Retrofit Builder.
     * @param client the instance of the service client containing this operation class.
     */
    public UsageOperationsImpl(Retrofit retrofit, StorageManagementClient client) {
        this.service = retrofit.create(UsageService.class);
        this.client = client;
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
        if (this.client.getSubscriptionId() == null) {
            throw new IllegalArgumentException("Parameter this.client.getSubscriptionId() is required and cannot be null.");
        }
        if (this.client.getApiVersion() == null) {
            throw new IllegalArgumentException("Parameter this.client.getApiVersion() is required and cannot be null.");
        }
        Call<ResponseBody> call = service.list(this.client.getSubscriptionId(), this.client.getApiVersion(), this.client.getAcceptLanguage());
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
    public Call<ResponseBody> listAsync(final ServiceCallback<List<Usage>> serviceCallback) {
        if (this.client.getSubscriptionId() == null) {
            serviceCallback.failure(new IllegalArgumentException("Parameter this.client.getSubscriptionId() is required and cannot be null."));
            return null;
        }
        if (this.client.getApiVersion() == null) {
            serviceCallback.failure(new IllegalArgumentException("Parameter this.client.getApiVersion() is required and cannot be null."));
            return null;
        }
        Call<ResponseBody> call = service.list(this.client.getSubscriptionId(), this.client.getApiVersion(), this.client.getAcceptLanguage());
        call.enqueue(new ServiceResponseCallback<List<Usage>>(serviceCallback) {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                try {
                    ServiceResponse<PageImpl<Usage>> result = listDelegate(response);
                    serviceCallback.success(new ServiceResponse<>(result.getBody().getItems(), result.getResponse()));
                } catch (CloudException | IOException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<PageImpl<Usage>> listDelegate(Response<ResponseBody> response) throws CloudException, IOException, IllegalArgumentException {
        return new AzureServiceResponseBuilder<PageImpl<Usage>, CloudException>()
                .register(200, new TypeToken<PageImpl<Usage>>() { }.getType())
                .registerError(CloudException.class)
                .build(response);
    }

}
