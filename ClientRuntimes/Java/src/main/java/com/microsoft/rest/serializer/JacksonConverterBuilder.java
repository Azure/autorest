/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.serializer;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.joda.JodaModule;
import com.google.gson.reflect.TypeToken;
import com.microsoft.rest.ServiceException;
import org.apache.commons.codec.binary.Base64;
import retrofit.converter.JacksonConverter;

import java.io.IOException;
import java.io.StringWriter;
import java.nio.charset.Charset;

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
                    .configure(DeserializationFeature.ACCEPT_EMPTY_STRING_AS_NULL_OBJECT, true)
                    .setSerializationInclusion(JsonInclude.Include.NON_NULL)
                    .registerModule(new JodaModule())
                    .registerModule(ByteArraySerializer.getModule())
                    .registerModule(DateTimeSerializer.getModule());
        }
        return objectMapper;
    }

    public static JacksonConverter build() {
        if (converter == null) {
            converter = new JacksonConverter(getObjectMapper());
        }
        return converter;
    }

    public static <T> String serialize(T object) {
        if (object == null) return null;
        try {
            StringWriter writer = new StringWriter();
            getObjectMapper().writeValue(writer, object);
            return writer.toString();
        } catch (Exception e) {
            return null;
        }
    }

    @SuppressWarnings("unchecked")
    public static <T> T deserialize(String value) {
        Byte[] a = new Byte[] {(byte) 255};
        Base64.encodeBase64String(a);
        if (value == null) return null;
        try {
            return (T)getObjectMapper().readValue(value, new TypeToken<T>(){}.getRawType());
        } catch (Exception e) {
            return null;
        }
    }
}
