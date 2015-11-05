/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.fasterxml.jackson.core.type.TypeReference;
import com.microsoft.rest.serializer.JacksonHelper;
import com.squareup.okhttp.ResponseBody;
import retrofit.Response;
import retrofit.Retrofit;

import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.Map;

/**
 * The builder for building a {@link ServiceResponse}.
 */
public class ServiceResponseBuilder<T> {
    private Map<Integer, TypeReference<?>> responseTypes;
    private JacksonHelper deserializer;

    /**
     * Create a ServiceResponseBuilder instance.
     */
    public ServiceResponseBuilder() {
        this(new JacksonHelper(), new HashMap<>());
    }

    /**
     * Create a ServiceResponseBuilder instance.
     *
     * @param deserializer the serialization utils to use for deserialization operations
     */
    public ServiceResponseBuilder(JacksonHelper deserializer) {
        this(deserializer, new HashMap<>());
    }

    /**
     * Create a ServiceResponseBuilder instance.
     *
     * @param deserializer the serialization utils to use for deserialization operations
     * @param responseTypes a mapping of response status codes and response destination types.
     */
    public ServiceResponseBuilder(JacksonHelper deserializer, Map<Integer, TypeReference<?>> responseTypes) {
        this.deserializer = deserializer;
        this.responseTypes = responseTypes;
    }

    /**
     * Register a mapping from a response status code to a response destination type.
     *
     * @param statusCode the status code.
     * @param <V> the response destination type.
     * @param type the type to deserialize.
     * @return the same builder instance.
     */
    public <V> ServiceResponseBuilder<T> register(int statusCode, final Type type) {
        this.responseTypes.put(statusCode, new TypeReference<V>() {
            @Override
            public Type getType() {
                return type;
            }
        });
        return this;
    }

    /**
     * Register a destination type for errors with models.
     *
     * @param <V> the error model type.
     * @param type the type to deserialize.
     * @return the same builder instance.
     */
    public <V> ServiceResponseBuilder<T> registerError(final Type type) {
        this.responseTypes.put(0, new TypeReference<V>() {
            @Override
            public Type getType() {
                return type;
            }
        });
        return this;
    }

    /**
     * Register all the mappings from a response status code to a response
     * destination type stored in a {@link Map}.
     *
     * @param responseTypes the mapping from response status codes to response types.
     * @return the same builder instance.
     */
    public ServiceResponseBuilder<T> registerAll(Map<Integer, TypeReference<?>> responseTypes) {
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
     *     there is one. A ServiceException is also thrown.
     * </p>
     *
     * @param response the {@link Response} instance from REST call
     * @param retrofit the {@link Retrofit} instance from REST call
     * @return a ServiceResponse instance of generic type {@link T}
     * @throws ServiceException all exceptions will be wrapped in ServiceException
     */
    public ServiceResponse<T> build(Response<ResponseBody> response, Retrofit retrofit) throws ServiceException {
        if (response == null) {
            throw new ServiceException("no response");
        }

        try {
            int statusCode = response.code();
            ResponseBody responseBody;
            if (response.isSuccess()) {
                responseBody = response.body();
            } else {
                responseBody = response.errorBody();
            }

            if (responseTypes.containsKey(statusCode)) {
                return new ServiceResponse<T>(buildBody(statusCode, responseBody), response);
            } else if (response.isSuccess() &&
                    (responseTypes.isEmpty() || (responseTypes.size() == 1 && responseTypes.containsKey(0)))) {
                return new ServiceResponse<T>(buildBody(statusCode, responseBody), response);
            } else {
                ServiceException exception = new ServiceException("Invalid status code " + statusCode);
                exception.setResponse(response);
                exception.setErrorModel(buildBody(statusCode, responseBody));
                throw exception;
            }
        } catch (ServiceException ex) {
            throw ex;
        } catch (Exception ex) {
            ServiceException exception = new ServiceException(ex);
            exception.setResponse(response);
            throw exception;
        }
    }

    public ServiceResponse<T> buildEmpty(Response<Void> response, Retrofit retrofit) throws ServiceException {
        int statusCode = response.code();
        if (responseTypes.containsKey(statusCode)) {
            return new ServiceResponse<T>(null, response);
        } else if (response.isSuccess() &&
                (responseTypes.isEmpty() || (responseTypes.size() == 1 && responseTypes.containsKey(0)))) {
            return new ServiceResponse<T>(null, response);
        } else {
            ServiceException exception = new ServiceException();
            exception.setResponse(response);
            throw exception;
        }
    }

    @SuppressWarnings("unchecked")
    private T buildBody(int statusCode, ResponseBody responseBody) throws IOException {
        if (responseBody == null) {
            return null;
        }

        TypeReference<?> type = null;
        if (responseTypes.containsKey(statusCode)) {
            type = responseTypes.get(statusCode);
        } else if (responseTypes.containsKey(0)) {
            type = responseTypes.get(0);
        } else {
            type = new TypeReference<T>() {};
        }

        // Void response
        if (type.getType() == new TypeReference<Void>(){}.getType()) {
            return null;
        }
        // Return raw response if InputStream is the target type
        else if (type.getType() == new TypeReference<InputStream>(){}.getType()) {
            return (T)responseBody.byteStream();
        }
        // Deserialize
        else {
            String responseContent = responseBody.string();
            if (responseContent.length() <= 0) {
                return null;
            }
            return deserializer.deserialize(responseContent, type);
        }
    }

}
