/**
 */

package petstore.models;

import org.joda.time.DateTime;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * The Order model.
 */
public class Order {
    /**
     * The id property.
     */
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private Long id;

    /**
     * The petId property.
     */
    private Long petId;

    /**
     * The quantity property.
     */
    private Integer quantity;

    /**
     * The shipDate property.
     */
    private DateTime shipDate;

    /**
     * Order Status. Possible values include: 'placed', 'approved',
     * 'delivered'.
     */
    private String status;

    /**
     * The complete property.
     */
    private Boolean complete;

    /**
     * Get the id value.
     *
     * @return the id value
     */
    public Long id() {
        return this.id;
    }

    /**
     * Get the petId value.
     *
     * @return the petId value
     */
    public Long petId() {
        return this.petId;
    }

    /**
     * Set the petId value.
     *
     * @param petId the petId value to set
     * @return the Order object itself.
     */
    public Order withPetId(Long petId) {
        this.petId = petId;
        return this;
    }

    /**
     * Get the quantity value.
     *
     * @return the quantity value
     */
    public Integer quantity() {
        return this.quantity;
    }

    /**
     * Set the quantity value.
     *
     * @param quantity the quantity value to set
     * @return the Order object itself.
     */
    public Order withQuantity(Integer quantity) {
        this.quantity = quantity;
        return this;
    }

    /**
     * Get the shipDate value.
     *
     * @return the shipDate value
     */
    public DateTime shipDate() {
        return this.shipDate;
    }

    /**
     * Set the shipDate value.
     *
     * @param shipDate the shipDate value to set
     * @return the Order object itself.
     */
    public Order withShipDate(DateTime shipDate) {
        this.shipDate = shipDate;
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
     * @return the Order object itself.
     */
    public Order withStatus(String status) {
        this.status = status;
        return this;
    }

    /**
     * Get the complete value.
     *
     * @return the complete value
     */
    public Boolean complete() {
        return this.complete;
    }

    /**
     * Set the complete value.
     *
     * @param complete the complete value to set
     * @return the Order object itself.
     */
    public Order withComplete(Boolean complete) {
        this.complete = complete;
        return this;
    }

}
