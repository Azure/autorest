/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.microsoft.rest.serializer.JacksonHelper;
import retrofit.RetrofitError;
import retrofit.client.Response;
import retrofit.converter.Converter;
import retrofit.mime.TypedInput;

import java.io.InputStream;
import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.Map;

/**
 * The builder for building a {@link ServiceResponse}.
 */
public class ServiceResponseBuilder<T> {
    private Map<Integer, Type> responseTypes;
    private Converter converter;

    /**
     * Create a ServiceResponseBuilder instance.
     */
    public ServiceResponseBuilder() {
        this(new HashMap<Integer, Type>(), JacksonHelper.getConverter());
    }

    /**
     * Create a ServiceResponseBuilder instance.
     *
     * @param responseTypes a mapping of response status codes and response destination types.
     * @param converter JSON converter to use.
     */
    public ServiceResponseBuilder(Map<Integer, Type> responseTypes, Converter converter) {
        this.responseTypes = responseTypes;
        this.converter = converter;
    }

    /**
     * Register a mapping from a response status code to a response destination type.
     *
     * @param statusCode the status code.
     * @param responseType the response destination type.
     * @return the same builder instance.
     */
    public ServiceResponseBuilder<T> register(int statusCode, Type responseType) {
        this.responseTypes.put(statusCode, responseType);
        return this;
    }

    /**
     * Register a destination type for errors with models.
     *
     * @param errorType the error model type.
     * @return the same builder instance.
     */
    public ServiceResponseBuilder<T> registerError(Type errorType) {
        this.responseTypes.put(0, errorType);
        return this;
    }

    /**
     * Register all the mappings from a response status code to a response
     * destination type stored in a {@link Map}.
     *
     * @param responseTypes the mapping from response status codes to response types.
     * @return the same builder instance.
     */
    public ServiceResponseBuilder<T> registerAll(Map<Integer, Type> responseTypes) {
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
     * @param error the {@link RetrofitError} instance from REST call
     * @return a ServiceResponse instance of generic type {@link T}
     * @throws ServiceException all exceptions will be wrapped in ServiceException
     */
    @SuppressWarnings("unchecked")
    public ServiceResponse<T> build(Response response, RetrofitError error) throws ServiceException {
        if (response == null) {
            throw new ServiceException(error);
        }

        ServiceResponse<T> result;
        try {
            TypedInput responseContent = response.getBody();
            int statusCode = response.getStatus();
            if (responseTypes.containsKey(statusCode)) {
                // Pre-defined successful status code
                T body = null;
                Type type = responseTypes.get(statusCode);
                if (type != null && type == InputStream.class) {
                    body = (T) responseContent.in();
                }
                else if (type != null && type != Void.class && responseContent.length() > 0) {
                    body = (T) this.converter.fromBody(responseContent, type);
                }
                result = new ServiceResponse<T>(body, response);
            } else if (error == null && responseTypes.isEmpty()) {
                // no pre-defined successful status code, use retrofit default
                result = new ServiceResponse<T>(null, response);
            } else if (error == null && responseTypes.size() == 1 && responseTypes.containsKey(0)) {
                // no pre-defined successful status code, use retrofit default
                T body = null;
                Type type = responseTypes.get(0);
                if (type != null && type == InputStream.class) {
                    body = (T) responseContent.in();
                }
                else if (type != null && type != Void.class && responseContent.length() > 0) {
                    body = (T) this.converter.fromBody(responseContent, type);
                }
                result = new ServiceResponse<T>(body, response);
            } else {
                // not in pre-defined successful status code list or
                // standard HTTP error codes
                ServiceException exception = new ServiceException(error);
                exception.setResponse(response);
                if (responseTypes.containsKey(0) && responseContent.length() > 0) {
                    exception.setErrorModel(this.converter.fromBody(
                            responseContent,
                            Object.class));
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
