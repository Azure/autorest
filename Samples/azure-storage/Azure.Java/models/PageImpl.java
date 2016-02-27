/**
 */

package petstore.models;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.microsoft.azure.Page;
import java.util.List;

/**
 * An instance of this class defines a page of Azure resources and a link to
 * get the next page of resources, if any.
 *
 * @param <T> type of Azure resource
 */
public class PageImpl<T> implements Page<T> {
    /**
     * The link to the next page.
     */
    @JsonProperty("")
    private String nextPageLink;

    /**
     * The list of items.
     */
    @JsonProperty("value")
    private List<T> items;

    /**
     * Gets the link to the next page.
     *
     * @return the link to the next page.
     */
    @Override
    public String getNextPageLink() {
        return this.nextPageLink;
    }

    /**
     * Gets the list of items.
     *
     * @return the list of items in {@link List}.
     */
    @Override
    public List<T> getItems() {
        return items;
    }
}
