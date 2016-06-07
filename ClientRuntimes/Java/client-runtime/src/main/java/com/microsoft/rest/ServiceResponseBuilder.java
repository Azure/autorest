/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.fasterxml.jackson.core.type.TypeReference;
import com.microsoft.rest.serializer.JacksonMapperAdapter;

import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.Map;

import okhttp3.ResponseBody;
import retrofit2.Response;

/**
 * The builder for building a {@link ServiceResponse}.
 *
 * @param <T> The return type the caller expects from the REST response.
 * @param <E> the exception to throw in case of error.
 */
public class ServiceResponseBuilder<T, E extends RestException> {
    /**
     * A mapping of HTTP status codes and their corresponding return types.
     */
    protected Map<Integer, Type> responseTypes;

    /**
     * The exception type to thrown in case of error.
     */
    protected Class<? extends RestException> exceptionType;

    /**
     * The mapperAdapter used for deserializing the response.
     */
    protected JacksonMapperAdapter mapperAdapter;

    /**
     * Create a ServiceResponseBuilder instance.
     *
     * @param mapperAdapter the serialization utils to use for deserialization operations
     */
    public ServiceResponseBuilder(JacksonMapperAdapter mapperAdapter) {
        this(mapperAdapter, new HashMap<Integer, Type>());
    }

    /**
     * Create a ServiceResponseBuilder instance.
     *
     * @param mapperAdapter the serialization utils to use for deserialization operations
     * @param responseTypes a mapping of response status codes and response destination types
     */
    public ServiceResponseBuilder(JacksonMapperAdapter mapperAdapter, Map<Integer, Type> responseTypes) {
        this.mapperAdapter = mapperAdapter;
        this.responseTypes = responseTypes;
        this.exceptionType = ServiceException.class;
        this.responseTypes.put(0, Object.class);
    }

    /**
     * Register a mapping from a response status code to a response destination type.
     *
     * @param statusCode the status code.
     * @param type the type to deserialize.
     * @return the same builder instance.
     */
    public ServiceResponseBuilder<T, E> register(int statusCode, final Type type) {
        this.responseTypes.put(statusCode, type);
        return this;
    }

    /**
     * Register a destination type for errors with models.
     *
     * @param type the type to deserialize.
     * @return the same builder instance.
     */
    public ServiceResponseBuilder<T, E> registerError(final Class<? extends RestException> type) {
        this.exceptionType = type;
        try {
            Field f = type.getDeclaredField("body");
            this.responseTypes.put(0, f.getType());
        } catch (NoSuchFieldException e) {
            // AutoRestException always has a body. Register Object as a fallback plan.
            this.responseTypes.put(0, Object.class);
        }
        return this;
    }

    /**
     * Register all the mappings from a response status code to a response
     * destination type stored in a {@link Map}.
     *
     * @param responseTypes the mapping from response status codes to response types.
     * @return the same builder instance.
     */
    public ServiceResponseBuilder<T, E> registerAll(Map<Integer, Type> responseTypes) {
        this.responseTypes.putAll(responseTypes);
        return this;
    }

    /**
     * Build a ServiceResponse instance from a REST call response and a
     * possible error.
     *
     * <p>
     *     If the status code in the response is registered, the response will
     *     be considered valid and deserialized into the specified destination
     *     type. If the status code is not registered, the response will be
     *     considered invalid and deserialized into the specified error type if
     *     there is one. An AutoRestException is also thrown.
     * </p>
     *
     * @param response the {@link Response} instance from REST call
     * @return a ServiceResponse instance of generic type {@link T}
     * @throws E exceptions from the REST call
     * @throws IOException exceptions from deserialization
     */
    @SuppressWarnings("unchecked")
    public ServiceResponse<T> build(Response<ResponseBody> response) throws E, IOException {
        if (response == null) {
            return null;
        }

        int statusCode = response.code();
        ResponseBody responseBody;
        if (response.isSuccessful()) {
            responseBody = response.body();
        } else {
            responseBody = response.errorBody();
        }

        if (responseTypes.containsKey(statusCode)) {
            return new ServiceResponse<>((T) buildBody(statusCode, responseBody), response);
        } else if (response.isSuccessful() && responseTypes.size() == 1) {
            return new ServiceResponse<>((T) buildBody(statusCode, responseBody), response);
        } else {
            try {
                E exception = (E) exceptionType.getConstructor(String.class).newInstance("Invalid status code " + statusCode);
                exceptionType.getMethod("setResponse", response.getClass()).invoke(exception, response);
                exceptionType.getMethod("setBody", (Class<?>) responseTypes.get(0)).invoke(exception, buildBody(statusCode, responseBody));
                throw exception;
            } catch (InstantiationException | IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
                throw new IOException("Invalid status code " + statusCode + ", but an instance of " + exceptionType.getCanonicalName()
                    + " cannot be created.", e);
            }
        }
    }

    /**
     * Build a ServiceResponse instance from a REST call response and a
     * possible error, which does not have a response body.
     *
     * <p>
     *     If the status code in the response is registered, the response will
     *     be considered valid. If the status code is not registered, the
     *     response will be considered invalid. An AutoRestException is also thrown.
     * </p>
     *
     * @param response the {@link Response} instance from REST call
     * @return a ServiceResponse instance of generic type {@link T}
     * @throws E exceptions from the REST call
     * @throws IOException exceptions from deserialization
     */
    @SuppressWarnings("unchecked")
    public ServiceResponse<T> buildEmpty(Response<Void> response) throws E, IOException {
        int statusCode = response.code();
        if (responseTypes.containsKey(statusCode)) {
            return new ServiceResponse<>(response);
        } else if (response.isSuccessful() && responseTypes.size() == 1) {
            return new ServiceResponse<>(response);
        } else {
            try {
                E exception = (E) exceptionType.getConstructor(String.class).newInstance("Invalid status code " + statusCode);
                exceptionType.getMethod("setResponse", response.getClass()).invoke(exception, response);
                response.errorBody().close();
                throw exception;
            } catch (InstantiationException | IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
                throw new IOException("Invalid status code " + statusCode + ", but an instance of " + exceptionType.getCanonicalName()
                        + " cannot be created.", e);
            }
        }
    }

    /**
     * Build a ServiceResponseWithHeaders instance from a REST call response, a header
     * in JSON format, and a possible error.
     *
     * <p>
     *     If the status code in the response is registered, the response will
     *     be considered valid and deserialized into the specified destination
     *     type. If the status code is not registered, the response will be
     *     considered invalid and deserialized into the specified error type if
     *     there is one. An AutoRestException is also thrown.
     * </p>
     *
     * @param response the {@link Response} instance from REST call
     * @param headerType the type of the header
     * @param <THeader> the type of the header
     * @return a ServiceResponseWithHeaders instance of generic type {@link T}
     * @throws E exceptions from the REST call
     * @throws IOException exceptions from deserialization
     */
    public <THeader> ServiceResponseWithHeaders<T, THeader> buildWithHeaders(Response<ResponseBody> response, Class<THeader> headerType) throws E, IOException {
        ServiceResponse<T> bodyResponse = build(response);
        THeader headers = mapperAdapter.deserialize(
                mapperAdapter.serialize(response.headers()),
                headerType);
        return new ServiceResponseWithHeaders<>(bodyResponse.getBody(), headers, bodyResponse.getResponse());
    }

    /**
     * Build a ServiceResponseWithHeaders instance from a REST call response, a header
     * in JSON format, and a possible error, which does not have a response body.
     *
     * <p>
     *     If the status code in the response is registered, the response will
     *     be considered valid. If the status code is not registered, the
     *     response will be considered invalid. An AutoRestException is also thrown.
     * </p>
     *
     * @param response the {@link Response} instance from REST call
     * @param headerType the type of the header
     * @param <THeader> the type of the header
     * @return a ServiceResponseWithHeaders instance of generic type {@link T}
     * @throws E exceptions from the REST call
     * @throws IOException exceptions from deserialization
     */
    public <THeader> ServiceResponseWithHeaders<T, THeader> buildEmptyWithHeaders(Response<Void> response, Class<THeader> headerType) throws E, IOException {
        ServiceResponse<T> bodyResponse = buildEmpty(response);
        THeader headers = mapperAdapter.deserialize(
                mapperAdapter.serialize(response.headers()),
                headerType);
        ServiceResponseWithHeaders<T, THeader> serviceResponse = new ServiceResponseWithHeaders<>(headers, bodyResponse.getHeadResponse());
        serviceResponse.setBody(bodyResponse.getBody());
        return serviceResponse;
    }

    /**
     * Builds the body object from the HTTP status code and returned response
     * body undeserialized and wrapped in {@link ResponseBody}.
     *
     * @param statusCode the HTTP status code
     * @param responseBody the response body
     * @return the response body, deserialized
     * @throws IOException thrown for any deserialization errors
     */
    protected Object buildBody(int statusCode, ResponseBody responseBody) throws IOException {
        if (responseBody == null) {
            return null;
        }

        Type type;
        if (responseTypes.containsKey(statusCode)) {
            type = responseTypes.get(statusCode);
        } else if (responseTypes.get(0) != Object.class) {
            type = responseTypes.get(0);
        } else {
            type = new TypeReference<T>() { }.getType();
        }

        // Void response
        if (type == Void.class) {
            return null;
        }
        // Return raw response if InputStream is the target type
        else if (type == InputStream.class) {
            InputStream stream = responseBody.byteStream();
            return stream;
        }
        // Deserialize
        else {
            String responseContent = responseBody.string();
            responseBody.close();
            if (responseContent.length() <= 0) {
                return null;
            }
            return mapperAdapter.deserialize(responseContent, type);
        }
    }
}
