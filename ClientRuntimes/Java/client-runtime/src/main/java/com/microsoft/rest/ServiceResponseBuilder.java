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
import retrofit.JacksonConverterFactory;
import retrofit.Response;
import retrofit.Retrofit;

import java.io.InputStream;
import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.Map;

/**
 * The builder for building a {@link ServiceResponse}.
 */
public class ServiceResponseBuilder<T> {
    private Map<Integer, TypeReference<?>> responseTypes;

    /**
     * Create a ServiceResponseBuilder instance.
     */
    public ServiceResponseBuilder() {
        this(new HashMap<Integer, TypeReference<?>>());
    }

    /**
     * Create a ServiceResponseBuilder instance.
     *
     * @param responseTypes a mapping of response status codes and response destination types.
     */
    public ServiceResponseBuilder(Map<Integer, TypeReference<?>> responseTypes) {
        this.responseTypes = responseTypes;
    }

    /**
     * Register a mapping from a response status code to a response destination type.
     *
     * @param statusCode the status code.
     * @param <V> the response destination type.
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
    @SuppressWarnings("unchecked")
    public ServiceResponse<T> build(Response<ResponseBody> response, Retrofit retrofit) throws ServiceException {
        if (response == null) {
            throw new ServiceException("no response");
        }

        ServiceResponse<T> result;
        try {
            int statusCode = response.code();
            if (responseTypes.containsKey(statusCode) ||
                    (response.isSuccess() && responseTypes.size() == 1 && responseTypes.containsKey(0))) {
                // Pre-defined successful status code
                ResponseBody responseBody = null;
                if (response.isSuccess()) {
                    responseBody = response.body();
                } else {
                    responseBody = response.errorBody();
                }
                T body = null;
                TypeReference<?> type = responseTypes.get(statusCode);
                if (type.getType() == new TypeReference<InputStream>(){}.getType() && responseBody != null) {
                    body = (T) responseBody.byteStream();
                }
                else if (type.getType() != new TypeReference<Void>(){}.getType() && responseBody != null) {
                    String responseContent = responseBody.string();
                    body = JacksonHelper.deserialize(responseContent, type);
                }
                result = new ServiceResponse<T>(body, response);
            } else if (response.isSuccess() && responseTypes.isEmpty()) {
                // no pre-defined successful status code, use retrofit default
                result = new ServiceResponse<T>(null, response);
            } else {
                // not in pre-defined successful status code list or
                // standard HTTP error codes
                ResponseBody errorBody = response.errorBody();
                ServiceException exception = new ServiceException();
                exception.setResponse(response);
                if (responseTypes.containsKey(0) && errorBody != null) {
                    exception.setErrorModel(JacksonHelper.deserialize(errorBody.byteStream(), responseTypes.get(0)));
                }
                throw exception;
            }
            return result;
        } catch (ServiceException ex) {
            throw ex;
        } catch (Exception ex) {
            ServiceException exception = new ServiceException(ex);
            exception.setResponse(response);
            throw exception;
        }
    }
}
