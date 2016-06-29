/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import com.google.common.reflect.TypeToken;
import com.microsoft.rest.RestException;
import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.ServiceResponseBuilder;
import com.microsoft.rest.serializer.JacksonMapperAdapter;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.Map;

import retrofit2.Response;

/**
 * The builder for building a {@link ServiceResponse}.
 *
 * @param <T> the return type from caller.
 * @param <E> the exception to throw in case of error.
 */
public class AzureServiceResponseBuilder<T, E extends RestException> extends ServiceResponseBuilder<T, E> {
    /**
     * Create a ServiceResponseBuilder instance.
     *
     * @param deserializer the serialization utils to use for deserialization operations
     */
    public AzureServiceResponseBuilder(JacksonMapperAdapter deserializer) {
        this(deserializer, new HashMap<Integer, Type>());
    }

    /**
     * Create a ServiceResponseBuilder instance.
     *
     * @param deserializer the serialization utils to use for deserialization operations
     * @param responseTypes a mapping of response status codes and response destination types.
     */
    public AzureServiceResponseBuilder(JacksonMapperAdapter deserializer, Map<Integer, Type> responseTypes) {
        super(deserializer, responseTypes);
    }

    @SuppressWarnings("unchecked")
    @Override
    public ServiceResponse<T> buildEmpty(Response<Void> response) throws E, IOException {
        int statusCode = response.code();
        if (responseTypes.containsKey(statusCode)) {
            if (new TypeToken<T>(getClass()) { }.getRawType().isAssignableFrom(Boolean.class)) {
                ServiceResponse<T> serviceResponse =  new ServiceResponse<>(response);
                serviceResponse.setBody((T) (Object) (statusCode / 100 == 2));
                return serviceResponse;
            } else {
                return new ServiceResponse<>(response);
            }
        } else {
            try {
                E exception = (E) exceptionType.getConstructor(String.class).newInstance("Invalid status code " + statusCode);
                exceptionType.getMethod("setResponse", response.getClass()).invoke(exception, response);
                throw exception;
            } catch (InstantiationException | IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
                throw new IOException("Invalid status code " + statusCode + ", but an instance of " + exceptionType.getCanonicalName()
                        + " cannot be created.", e);
            }
        }
    }
}
