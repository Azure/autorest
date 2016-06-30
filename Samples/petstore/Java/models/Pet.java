/**
 */

package petstore.models;

import java.util.List;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * A pet.
 * A group of properties representing a pet.
 */
public class Pet {
    /**
     * The id of the pet.
     * A more detailed description of the id of the pet.
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
    public Long id() {
        return this.id;
    }

    /**
     * Set the id value.
     *
     * @param id the id value to set
     * @return the Pet object itself.
     */
    public Pet withId(Long id) {
        this.id = id;
        return this;
    }

    /**
     * Get the category value.
     *
     * @return the category value
     */
    public Category category() {
        return this.category;
    }

    /**
     * Set the category value.
     *
     * @param category the category value to set
     * @return the Pet object itself.
     */
    public Pet withCategory(Category category) {
        this.category = category;
        return this;
    }

    /**
     * Get the name value.
     *
     * @return the name value
     */
    public String name() {
        return this.name;
    }

    /**
     * Set the name value.
     *
     * @param name the name value to set
     * @return the Pet object itself.
     */
    public Pet withName(String name) {
        this.name = name;
        return this;
    }

    /**
     * Get the photoUrls value.
     *
     * @return the photoUrls value
     */
    public List<String> photoUrls() {
        return this.photoUrls;
    }

    /**
     * Set the photoUrls value.
     *
     * @param photoUrls the photoUrls value to set
     * @return the Pet object itself.
     */
    public Pet withPhotoUrls(List<String> photoUrls) {
        this.photoUrls = photoUrls;
        return this;
    }

    /**
     * Get the tags value.
     *
     * @return the tags value
     */
    public List<Tag> tags() {
        return this.tags;
    }

    /**
     * Set the tags value.
     *
     * @param tags the tags value to set
     * @return the Pet object itself.
     */
    public Pet withTags(List<Tag> tags) {
        this.tags = tags;
        return this;
    }

    /**
     * Get the status value.
     *
     * @return the status value
     */
    public String status() {
        return this.status;
    }

    /**
     * Set the status value.
     *
     * @param status the status value to set
     * @return the Pet object itself.
     */
    public Pet withStatus(String status) {
        this.status = status;
        return this;
    }

}
