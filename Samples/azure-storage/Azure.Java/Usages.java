/**
 */

package petstore;

import com.microsoft.rest.ServiceCall;
import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceResponse;
import java.util.List;
import petstore.models.Usage;
import rx.Observable;

/**
 * An instance of this class provides access to all the operations defined
 * in Usages.
 */
public interface Usages {
    /**
     * Gets the current usage count and the limit for the resources under the subscription.
     *
     * @return the List&lt;Usage&gt; object if successful.
     */
    List<Usage> list();

    /**
     * Gets the current usage count and the limit for the resources under the subscription.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    ServiceCall<List<Usage>> listAsync(final ServiceCallback<List<Usage>> serviceCallback);

    /**
     * Gets the current usage count and the limit for the resources under the subscription.
     *
     * @return the observable to the List&lt;Usage&gt; object
     */
    Observable<List<Usage>> listAsync();

    /**
     * Gets the current usage count and the limit for the resources under the subscription.
     *
     * @return the observable to the List&lt;Usage&gt; object
     */
    Observable<ServiceResponse<List<Usage>>> listWithServiceResponseAsync();

}
