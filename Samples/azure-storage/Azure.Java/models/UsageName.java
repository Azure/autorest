/**
 */

package petstore.models;


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
    public String getValue() {
        return this.value;
    }

    /**
     * Set the value value.
     *
     * @param value the value value to set
     */
    public void setValue(String value) {
        this.value = value;
    }

    /**
     * Get the localizedValue value.
     *
     * @return the localizedValue value
     */
    public String getLocalizedValue() {
        return this.localizedValue;
    }

    /**
     * Set the localizedValue value.
     *
     * @param localizedValue the localizedValue value to set
     */
    public void setLocalizedValue(String localizedValue) {
        this.localizedValue = localizedValue;
    }

}
