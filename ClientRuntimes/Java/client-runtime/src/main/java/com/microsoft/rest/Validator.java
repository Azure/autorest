/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.fasterxml.jackson.annotation.JsonProperty;
import org.apache.commons.lang3.ClassUtils;
import org.apache.commons.lang3.reflect.FieldUtils;
import org.joda.time.DateTime;
import org.joda.time.LocalDate;
import retrofit.RetrofitError;

import java.lang.reflect.Field;
import java.util.List;
import java.util.Map;

/**
 * Validates user provided parameters are not null if they are required.
 */
public class Validator {
    /**
     * Validates a user provided required parameter to be not null.
     * A {@link ServiceException} is thrown if a property fails the validation.
     *
     * @param parameter the parameter to validate
     * @throws ServiceException failures wrapped in {@link ServiceException}
     */
    public static void validate(Object parameter) throws ServiceException {
        // Validation of top level payload is done outside
        if (parameter == null) {
            return;
        }

        Class parameterType = parameter.getClass();
        if (ClassUtils.isPrimitiveOrWrapper(parameterType) ||
                parameterType.isEnum() ||
                ClassUtils.isAssignable(parameterType, LocalDate.class) ||
                ClassUtils.isAssignable(parameterType, DateTime.class) ||
                ClassUtils.isAssignable(parameterType, String.class)) {
            return;
        }

        Field[] fields = FieldUtils.getAllFields(parameterType);
        for (Field field : fields) {
            field.setAccessible(true);
            JsonProperty annotation = field.getAnnotation(JsonProperty.class);
            Object property;
            try {
                property = field.get(parameter);
            } catch (IllegalAccessException e) {
                throw new ServiceException(e);
            }
            if (property == null) {
                if (annotation != null && annotation.required()) {
                    throw new ServiceException(
                            new IllegalArgumentException(field.getName() + " is required and cannot be null."));
                }
            } else {
                try {
                    Class propertyType = property.getClass();
                    if (ClassUtils.isAssignable(propertyType, List.class)) {
                        List<?> items = (List<?>)property;
                        for (Object item : items) {
                            Validator.validate(item);
                        }
                    }
                    else if (ClassUtils.isAssignable(propertyType, Map.class)) {
                        Map<?, ?> entries = (Map<?, ?>)property;
                        for (Map.Entry<?, ?> entry : entries.entrySet()) {
                            Validator.validate(entry.getKey());
                            Validator.validate(entry.getValue());
                        }
                    }
                    else if (parameter.getClass().getDeclaringClass() != propertyType) {
                        Validator.validate(property);
                    }
                } catch (ServiceException ex) {
                    IllegalArgumentException cause = (IllegalArgumentException)(ex.getCause());
                    if (cause != null) {
                        // Build property chain
                        throw new ServiceException(
                                new IllegalArgumentException(field.getName() + "." + cause.getMessage()));
                    } else {
                        throw ex;
                    }
                }
            }
        }
    }

    /**
     * Validates a user provided required parameter to be not null. Returns if
     * the parameter passes the validation. A {@link ServiceException} is passed
     * to the {@link ServiceCallback#failure(RetrofitError)} if a property fails the validation.
     *
     * @param parameter the parameter to validate
     * @param serviceCallback the callback to call with the failure
     */
    public static void validate(Object parameter, ServiceCallback<?> serviceCallback) {
        try {
            validate(parameter);
        } catch (ServiceException ex) {
            serviceCallback.failure(ex);
        }
    }
}
