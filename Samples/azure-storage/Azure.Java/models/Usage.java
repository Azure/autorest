/**
 */

package petstore.models;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Describes Storage Resource Usage.
 */
public class Usage {
    /**
     * Gets the unit of measurement. Possible values include: 'Count',
     * 'Bytes', 'Seconds', 'Percent', 'CountsPerSecond', 'BytesPerSecond'.
     */
    @JsonProperty(required = true)
    private UsageUnit unit;

    /**
     * Gets the current count of the allocated resources in the subscription.
     */
    @JsonProperty(required = true)
    private int currentValue;

    /**
     * Gets the maximum count of the resources that can be allocated in the
     * subscription.
     */
    @JsonProperty(required = true)
    private int limit;

    /**
     * Gets the name of the type of usage.
     */
    @JsonProperty(required = true)
    private UsageName name;

    /**
     * Get the unit value.
     *
     * @return the unit value
     */
    public UsageUnit getUnit() {
        return this.unit;
    }

    /**
     * Set the unit value.
     *
     * @param unit the unit value to set
     */
    public void setUnit(UsageUnit unit) {
        this.unit = unit;
    }

    /**
     * Get the currentValue value.
     *
     * @return the currentValue value
     */
    public int getCurrentValue() {
        return this.currentValue;
    }

    /**
     * Set the currentValue value.
     *
     * @param currentValue the currentValue value to set
     */
    public void setCurrentValue(int currentValue) {
        this.currentValue = currentValue;
    }

    /**
     * Get the limit value.
     *
     * @return the limit value
     */
    public int getLimit() {
        return this.limit;
    }

    /**
     * Set the limit value.
     *
     * @param limit the limit value to set
     */
    public void setLimit(int limit) {
        this.limit = limit;
    }

    /**
     * Get the name value.
     *
     * @return the name value
     */
    public UsageName getName() {
        return this.name;
    }

    /**
     * Set the name value.
     *
     * @param name the name value to set
     */
    public void setName(UsageName name) {
        this.name = name;
    }

}
