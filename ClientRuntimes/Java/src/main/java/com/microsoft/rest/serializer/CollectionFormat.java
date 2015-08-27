/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.serializer;

public enum CollectionFormat {
    CSV(","),
    SSV(" "),
    TSV("\t"),
    PIPES("|"),
    MULTI("&");

    private String delimeter;

    private CollectionFormat(String delimeter) {
        this.delimeter = delimeter;
    }

    public String getDelimeter() {
        return delimeter;
    }
}
