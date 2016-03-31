/**
 */

package petstore.models;

import java.util.List;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * The Pet model.
 */
public class Pet {
    /**
     * The id property.
     */
    private Long id;

    /**
     * The category property.
     */
    private Category category;

    /**
     * The name property.
     */
    @JsonProperty(required = true)
    private String name;

    /**
     * The photoUrls property.
     */
    @JsonProperty(required = true)
    private List<String> photoUrls;

    /**
     * The tags property.
     */
    private List<Tag> tags;

    /**
     * pet status in the store. Possible values include: 'available',
     * 'pending', 'sold'.
     */
    private String status;

    /**
     * Get the id value.
     *
     * @return the id value
     */
    public Long getId() {
        return this.id;
    }

    /**
     * Set the id value.
     *
     * @param id the id value to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * Get the category value.
     *
     * @return the category value
     */
    public Category getCategory() {
        return this.category;
    }

    /**
     * Set the category value.
     *
     * @param category the category value to set
     */
    public void setCategory(Category category) {
        this.category = category;
    }

    /**
     * Get the name value.
     *
     * @return the name value
     */
    public String getName() {
        return this.name;
    }

    /**
     * Set the name value.
     *
     * @param name the name value to set
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Get the photoUrls value.
     *
     * @return the photoUrls value
     */
    public List<String> getPhotoUrls() {
        return this.photoUrls;
    }

    /**
     * Set the photoUrls value.
     *
     * @param photoUrls the photoUrls value to set
     */
    public void setPhotoUrls(List<String> photoUrls) {
        this.photoUrls = photoUrls;
    }

    /**
     * Get the tags value.
     *
     * @return the tags value
     */
    public List<Tag> getTags() {
        return this.tags;
    }

    /**
     * Set the tags value.
     *
     * @param tags the tags value to set
     */
    public void setTags(List<Tag> tags) {
        this.tags = tags;
    }

    /**
     * Get the status value.
     *
     * @return the status value
     */
    public String getStatus() {
        return this.status;
    }

    /**
     * Set the status value.
     *
     * @param status the status value to set
     */
    public void setStatus(String status) {
        this.status = status;
    }

}
