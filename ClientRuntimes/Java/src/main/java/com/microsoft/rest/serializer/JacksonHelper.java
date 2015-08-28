/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.serializer;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.joda.JodaModule;
import com.google.gson.reflect.TypeToken;
import org.apache.commons.lang3.StringUtils;
import retrofit.converter.JacksonConverter;

import java.io.StringWriter;
import java.util.ArrayList;
import java.util.List;

/**
 * Inner callback used to merge both successful and failed responses into one
 * callback for customized response handling in a response handling delegate.
 */
public class JacksonHelper {
    private static ObjectMapper objectMapper;
    private static JacksonConverter converter;

    private JacksonHelper() {}

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

    public static JacksonConverter getConverter() {
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

    public static <T> String serializeRaw(T object) {
        if (object == null) return null;
        return StringUtils.strip(serialize(object), "\"");
    }

    public static <E> String serializeList(List<E> collection, CollectionFormat format) {
        if (collection == null) return null;
        List<String> serialized = new ArrayList<String>();
        for (E element : collection) {
            String raw = serializeRaw(element);
            serialized.add(raw != null ? raw : "");
        }
        return StringUtils.join(serialized, format.getDelimeter());
    }

    @SuppressWarnings("unchecked")
    public static <T> T deserialize(String value) {
        if (value == null) return null;
        try {
            return (T)getObjectMapper().readValue(value, new TypeToken<T>(){}.getRawType());
        } catch (Exception e) {
            return null;
        }
    }
}
