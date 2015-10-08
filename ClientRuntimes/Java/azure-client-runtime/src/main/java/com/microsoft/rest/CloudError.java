/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import java.util.ArrayList;
import java.util.List;

public class CloudError {
    private String code;

    private String message;

    private String target;

    private List<CloudError> details;

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
