/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.serializer;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.joda.JodaModule;
import com.google.common.reflect.TypeToken;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import retrofit.Converter;
import retrofit.JacksonConverterFactory;

import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.List;

/**
 * A serialization helper class wrapped around {@link JacksonConverterFactory} and {@link ObjectMapper}.
 */
public class JacksonHelper {
    private static ObjectMapper objectMapper;
    private static JacksonConverterFactory converterFactory;

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
     * Gets a static instance of {@link Converter.Factory}.
     *
     * @return an instance of {@link Converter.Factory}.
     */
    public static JacksonConverterFactory getConverterFactory() {
        if (converterFactory == null) {
            converterFactory = JacksonConverterFactory.create(getObjectMapper());
        }
        return converterFactory;
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
     * @param type the type to deserialize.
     * @return the deserialized object.
     * @throws IOException exception in deserialization
     */
    @SuppressWarnings("unchecked")
    public static <T> T deserialize(String value, TypeReference<?> type) throws IOException {
        if (value == null || value.isEmpty()) return null;
        return (T)getObjectMapper().readValue(value, type);
    }

    /**
     * Deserializes an input stream into a {@link T} object using the current {@link ObjectMapper}.
     * @param input the input stream to deserialize.
     * @param <T> the type of the deserialized object.
     * @param type the type to deserialize.
     * @return the deserialized object.
     * @throws IOException exception in deserialization
     */
    public static <T> T deserialize(InputStream input, TypeReference<?> type) throws IOException {
        if (input == null) return null;
        return deserialize(IOUtils.toString(input), type);
    }
}
