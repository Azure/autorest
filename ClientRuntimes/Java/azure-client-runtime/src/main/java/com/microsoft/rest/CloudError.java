/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import java.util.ArrayList;
import java.util.List;

/**
 * An instance of this class provides additional information about an http error response.
 */
public class CloudError {
    /**
     * The error code parsed from the body of the http error response.
     */
    private String code;

    /**
     * The error message parsed from the body of the http error response.
     */
    private String message;

    /**
     * The target of the error.
     */
    private String target;

    /**
     * Details for the error.
     */
    private List<CloudError> details;

    /**
     * Initializes a new instance of CloudError.
     */
    public CloudError() {
        this.details = new ArrayList<CloudError>();
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getTarget() {
        return target;
    }

    public void setTarget(String target) {
        this.target = target;
    }

    public List<CloudError> getDetails() {
        return details;
    }
}
