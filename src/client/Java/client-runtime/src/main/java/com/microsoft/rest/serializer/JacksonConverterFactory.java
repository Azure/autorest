/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.serializer;

import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectReader;
import com.fasterxml.jackson.databind.ObjectWriter;
import okhttp3.MediaType;
import okhttp3.RequestBody;
import okhttp3.ResponseBody;
import retrofit2.Converter;
import retrofit2.Retrofit;

import java.io.IOException;
import java.io.Reader;
import java.lang.annotation.Annotation;
import java.lang.reflect.Type;

/**
 * A similar implementation of {@link retrofit2.converter.jackson.JacksonConverterFactory} which supports polymorphism.
 */
public final class JacksonConverterFactory extends Converter.Factory {
    /**
     * Create an instance using a default {@link ObjectMapper} instance for conversion.
     *
     * @return an instance of JacksonConverterFactory
     */
    public static JacksonConverterFactory create() {
        return create(new ObjectMapper());
    }


    /**
     * Create an instance using {@code mapper} for conversion.
     *
     * @param mapper a user-provided {@link ObjectMapper} to use
     * @return an instance of JacksonConverterFactory
     */
    public static JacksonConverterFactory create(ObjectMapper mapper) {
        return new JacksonConverterFactory(mapper);
    }

    /**
     * The Jackson object mapper.
     */
    private final ObjectMapper mapper;

    private JacksonConverterFactory(ObjectMapper mapper) {
        if (mapper == null) {
            throw new NullPointerException("mapper == null");
        }
        this.mapper = mapper;
    }

    @Override
    public Converter<ResponseBody, ?> responseBodyConverter(Type type, Annotation[] annotations, Retrofit retrofit) {
        JavaType javaType = mapper.getTypeFactory().constructType(type);
        ObjectReader reader = mapper.reader(javaType);
        return new JacksonResponseBodyConverter<>(reader);
    }

    @Override
    public Converter<?, RequestBody> requestBodyConverter(Type type,
            Annotation[] parameterAnnotations, Annotation[] methodAnnotations, Retrofit retrofit) {
        ObjectWriter writer = mapper.writer();
        return new JacksonRequestBodyConverter<>(writer);
    }

    /**
     * An instance of this class converts an object into JSON.
     *
     * @param <T> type of request object
     */
    final class JacksonRequestBodyConverter<T> implements Converter<T, RequestBody> {
        /** Jackson object writer. */
        private final ObjectWriter adapter;

        JacksonRequestBodyConverter(ObjectWriter adapter) {
            this.adapter = adapter;
        }

        @Override public RequestBody convert(T value) throws IOException {
            byte[] bytes = adapter.writeValueAsBytes(value);
            return RequestBody.create(MediaType.parse("application/json; charset=UTF-8"), bytes);
        }
    }

    /**
     * An instance of this class converts a JSON payload into an object.
     *
     * @param <T> the expected object type to convert to
     */
    final class JacksonResponseBodyConverter<T> implements Converter<ResponseBody, T> {
        /** Jackson object reader. */
        private final ObjectReader adapter;

        JacksonResponseBodyConverter(ObjectReader adapter) {
            this.adapter = adapter;
        }

        @Override public T convert(ResponseBody value) throws IOException {
            Reader reader = value.charStream();
            try {
                return adapter.readValue(reader);
            } finally {
                if (reader != null) {
                    try {
                        reader.close();
                    } catch (IOException ignored) {
                    }
                }
            }
        }
    }
}

