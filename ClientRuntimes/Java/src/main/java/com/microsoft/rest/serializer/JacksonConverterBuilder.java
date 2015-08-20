/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.serializer;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.joda.JodaModule;
import retrofit.converter.JacksonConverter;

/**
 * Inner callback used to merge both successful and failed responses into one
 * callback for customized response handling in a response handling delegate.
 */
public class JacksonConverterBuilder {
    private static ObjectMapper objectMapper;
    private static JacksonConverter converter;

    private JacksonConverterBuilder() {}

    public static ObjectMapper getObjectMapper() {
        if (objectMapper == null) {
            objectMapper = new ObjectMapper()
                    .configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false)
                    .registerModule(new JodaModule())
                    .registerModule(ByteArraySerializer.getModule());
        }
        return objectMapper;
    }

    public static JacksonConverter build() {
        if (converter == null) {
            converter = new JacksonConverter(getObjectMapper());
        }
        return converter;
    }
}
