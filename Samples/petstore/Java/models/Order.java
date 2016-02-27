/**
 */

package petstore.models;

import com.fasterxml.jackson.annotation.JsonProperty;
import org.joda.time.DateTime;

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
    public Long getId() {
        return this.id;
    }

    /**
     * Get the petId value.
     *
     * @return the petId value
     */
    public Long getPetId() {
        return this.petId;
    }

    /**
     * Set the petId value.
     *
     * @param petId the petId value to set
     */
    public void setPetId(Long petId) {
        this.petId = petId;
    }

    /**
     * Get the quantity value.
     *
     * @return the quantity value
     */
    public Integer getQuantity() {
        return this.quantity;
    }

    /**
     * Set the quantity value.
     *
     * @param quantity the quantity value to set
     */
    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    /**
     * Get the shipDate value.
     *
     * @return the shipDate value
     */
    public DateTime getShipDate() {
        return this.shipDate;
    }

    /**
     * Set the shipDate value.
     *
     * @param shipDate the shipDate value to set
     */
    public void setShipDate(DateTime shipDate) {
        this.shipDate = shipDate;
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

    /**
     * Get the complete value.
     *
     * @return the complete value
     */
    public Boolean getComplete() {
        return this.complete;
    }

    /**
     * Set the complete value.
     *
     * @param complete the complete value to set
     */
    public void setComplete(Boolean complete) {
        this.complete = complete;
    }

}
