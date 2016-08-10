/**
 */

package petstore.implementation;

import petstore.UsageUnit;
import petstore.UsageName;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Describes Storage Resource Usage.
 */
public class UsageInner {
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
    public UsageUnit unit() {
        return this.unit;
    }

    /**
     * Set the unit value.
     *
     * @param unit the unit value to set
     * @return the UsageInner object itself.
     */
    public UsageInner withUnit(UsageUnit unit) {
        this.unit = unit;
        return this;
    }

    /**
     * Get the currentValue value.
     *
     * @return the currentValue value
     */
    public int currentValue() {
        return this.currentValue;
    }

    /**
     * Set the currentValue value.
     *
     * @param currentValue the currentValue value to set
     * @return the UsageInner object itself.
     */
    public UsageInner withCurrentValue(int currentValue) {
        this.currentValue = currentValue;
        return this;
    }

    /**
     * Get the limit value.
     *
     * @return the limit value
     */
    public int limit() {
        return this.limit;
    }

    /**
     * Set the limit value.
     *
     * @param limit the limit value to set
     * @return the UsageInner object itself.
     */
    public UsageInner withLimit(int limit) {
        this.limit = limit;
        return this;
    }

    /**
     * Get the name value.
     *
     * @return the name value
     */
    public UsageName name() {
        return this.name;
    }

    /**
     * Set the name value.
     *
     * @param name the name value to set
     * @return the UsageInner object itself.
     */
    public UsageInner withName(UsageName name) {
        this.name = name;
        return this;
    }

}
