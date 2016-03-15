/**
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 *
 * Code generated by Microsoft (R) AutoRest Code Generator.
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

package fixtures.azurespecials.models;


/**
 * The Error model.
 */
public class Error {
    /**
     * The status property.
     */
    private Integer status;

    /**
     * The constantId property.
     */
    private Integer constantId;

    /**
     * The message property.
     */
    private String message;

    /**
     * Get the status value.
     *
     * @return the status value
     */
    public Integer getStatus() {
        return this.status;
    }

    /**
     * Set the status value.
     *
     * @param status the status value to set
     */
    public void setStatus(Integer status) {
        this.status = status;
    }

    /**
     * Set the status value.
     *
     * @param status the status value to set
     * @return the Error object itself.
     */
    public Error withStatus(Integer status) {
        this.status = status;
        return this;
    }

    /**
     * Get the constantId value.
     *
     * @return the constantId value
     */
    public Integer getConstantId() {
        return this.constantId;
    }

    /**
     * Set the constantId value.
     *
     * @param constantId the constantId value to set
     */
    public void setConstantId(Integer constantId) {
        this.constantId = constantId;
    }

    /**
     * Set the constantId value.
     *
     * @param constantId the constantId value to set
     * @return the Error object itself.
     */
    public Error withConstantId(Integer constantId) {
        this.constantId = constantId;
        return this;
    }

    /**
     * Get the message value.
     *
     * @return the message value
     */
    public String getMessage() {
        return this.message;
    }

    /**
     * Set the message value.
     *
     * @param message the message value to set
     */
    public void setMessage(String message) {
        this.message = message;
    }

    /**
     * Set the message value.
     *
     * @param message the message value to set
     * @return the Error object itself.
     */
    public Error withMessage(String message) {
        this.message = message;
        return this;
    }

}
