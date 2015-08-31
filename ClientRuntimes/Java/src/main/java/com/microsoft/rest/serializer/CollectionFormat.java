/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.serializer;

/**
 * Swagger collection format to use for joining {@link java.util.List} parameters in
 * paths, queries, and headers.
 * See <a href="https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#fixed-fields-7">https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#fixed-fields-7</a>.
 */
public enum CollectionFormat {
    CSV(","),
    SSV(" "),
    TSV("\t"),
    PIPES("|"),
    MULTI("&");

    private String delimiter;

    private CollectionFormat(String delimiter) {
        this.delimiter = delimiter;
    }

    /**
     * Gets the delimiter used to join a list of parameters.
     * @return the delimiter of the current collection format.
     */
    public String getDelimiter() {
        return delimiter;
    }
}
