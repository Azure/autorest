/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.google.common.reflect.TypeToken;
import com.microsoft.rest.serializer.JacksonUtils;
import retrofit.Response;
import retrofit.Retrofit;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.Map;

/**
 * The builder for building a {@link ServiceResponse}.
 *
 * @param <T> the return type from caller.
 * @param <E> the exception to throw in case of error.
 */
public class AzureServiceResponseBuilder<T, E extends AutoRestException> extends ServiceResponseBuilder<T, E> {
    /**
     * Create a ServiceResponseBuilder instance.
     */
    public AzureServiceResponseBuilder() {
        this(new JacksonUtils());
    }

    /**
     * Create a ServiceResponseBuilder instance.
     *
     * @param deserializer the serialization utils to use for deserialization operations
     */
    public AzureServiceResponseBuilder(JacksonUtils deserializer) {
        this(deserializer, new HashMap<Integer, Type>());
    }

    /**
     * Create a ServiceResponseBuilder instance.
     *
     * @param deserializer the serialization utils to use for deserialization operations
     * @param responseTypes a mapping of response status codes and response destination types.
     */
    public AzureServiceResponseBuilder(JacksonUtils deserializer, Map<Integer, Type> responseTypes) {
        super(deserializer, responseTypes);
    }

    @SuppressWarnings("unchecked")
    @Override
    public ServiceResponse<T> buildEmpty(Response<Void> response, Retrofit retrofit) throws E, IOException {
        int statusCode = response.code();
        if (responseTypes.containsKey(statusCode)) {
            if (new TypeToken<T>(getClass()) { }.getRawType().isAssignableFrom(Boolean.class)) {
                return new ServiceResponse<>((T) (Object) (statusCode / 100 == 2), response);
            } else {
                return new ServiceResponse<>(null, response);
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
