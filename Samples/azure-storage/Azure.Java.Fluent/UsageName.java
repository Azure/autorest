/**
 */

package petstore;


/**
 * The Usage Names.
 */
public class UsageName {
    /**
     * Gets a string describing the resource name.
     */
    private String value;

    /**
     * Gets a localized string describing the resource name.
     */
    private String localizedValue;

    /**
     * Get the value value.
     *
     * @return the value value
     */
    public String value() {
        return this.value;
    }

    /**
     * Set the value value.
     *
     * @param value the value value to set
     * @return the UsageName object itself.
     */
    public UsageName withValue(String value) {
        this.value = value;
        return this;
    }

    /**
     * Get the localizedValue value.
     *
     * @return the localizedValue value
     */
    public String localizedValue() {
        return this.localizedValue;
    }

    /**
     * Set the localizedValue value.
     *
     * @param localizedValue the localizedValue value to set
     * @return the UsageName object itself.
     */
    public UsageName withLocalizedValue(String localizedValue) {
        this.localizedValue = localizedValue;
        return this;
    }

}
