/**
 */

package petstore;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * The custom domain assigned to this storage account. This can be set via
 * Update.
 */
public class CustomDomain {
    /**
     * Gets or sets the custom domain name. Name is the CNAME source.
     */
    @JsonProperty(required = true)
    private String name;

    /**
     * Indicates whether indirect CName validation is enabled. Default value
     * is false. This should only be set on updates.
     */
    private Boolean useSubDomain;

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
     * @return the CustomDomain object itself.
     */
    public CustomDomain withName(String name) {
        this.name = name;
        return this;
    }

    /**
     * Get the useSubDomain value.
     *
     * @return the useSubDomain value
     */
    public Boolean useSubDomain() {
        return this.useSubDomain;
    }

    /**
     * Set the useSubDomain value.
     *
     * @param useSubDomain the useSubDomain value to set
     * @return the CustomDomain object itself.
     */
    public CustomDomain withUseSubDomain(Boolean useSubDomain) {
        this.useSubDomain = useSubDomain;
        return this;
    }

}
