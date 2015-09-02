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
 * A serialization helper class wrapped around {@link JacksonConverter} and {@link ObjectMapper}.
 */
public class JacksonHelper {
    private static ObjectMapper objectMapper;
    private static JacksonConverter converter;

    private JacksonHelper() {}

    /**
     * Gets a static instance of {@link ObjectMapper}.
     *
     * @return an instance of {@link ObjectMapper}.
     */
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

    /**
     * Gets a static instance of {@link JacksonConverter}.
     *
     * @return an instance of {@link JacksonConverter}.
     */
    public static JacksonConverter getConverter() {
        if (converter == null) {
            converter = new JacksonConverter(getObjectMapper());
        }
        return converter;
    }

    /**
     * Serializes an object into a JSON string using the current {@link ObjectMapper}.
     *
     * @param object the object to serialize.
     * @return the serialized string. Null if the object to serialize is null.
     */
    public static String serialize(Object object) {
        if (object == null) return null;
        try {
            StringWriter writer = new StringWriter();
            getObjectMapper().writeValue(writer, object);
            return writer.toString();
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Serializes an object into a raw string using the current {@link ObjectMapper}.
     * The leading and trailing quotes will be trimmed.
     *
     * @param object the object to serialize.
     * @return the serialized string. Null if the object to serialize is null.
     */
    public static String serializeRaw(Object object) {
        if (object == null) return null;
        return StringUtils.strip(serialize(object), "\"");
    }

    /**
     * Serializes a list into a string with the delimiter specified with the
     * Swagger collection format joining each individual serialized items in
     * the list.
     *
     * @param list the list to serialize.
     * @param format the Swagger collection format.
     * @return the serialized string
     */
    public static String serializeList(List<?> list, CollectionFormat format) {
        if (list == null) return null;
        List<String> serialized = new ArrayList<String>();
        for (Object element : list) {
            String raw = serializeRaw(element);
            serialized.add(raw != null ? raw : "");
        }
        return StringUtils.join(serialized, format.getDelimiter());
    }

    /**
     * Deserializes a string into a {@link T} object using the current {@link ObjectMapper}.
     *
     * @param value the string value to deserialize.
     * @param <T> the type of the deserialized object.
     * @return the deserialized object.
     */
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
