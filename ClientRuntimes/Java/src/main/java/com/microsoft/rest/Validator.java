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

import java.lang.reflect.Field;
import java.util.List;
import java.util.Map;

/**
 * ServiceClient is the abstraction for accessing REST operations and their payload data types.
 */
public class Validator {
    public static void validate(Object parameter) throws IllegalArgumentException {
        // Validation of top level payload is done outside
        if (parameter == null) {
            return;
        }

        Field[] fields = FieldUtils.getAllFields(parameter.getClass());
        for (Field field : fields) {
            field.setAccessible(true);
            JsonProperty annotation = field.getAnnotation(JsonProperty.class);
            Object property = null;
            try {
                property = field.get(parameter);
            } catch (IllegalAccessException e) {
                // Ignore inaccessible fields
            }
            if (property == null) {
                if (annotation != null && annotation.required()) {
                    throw new IllegalArgumentException(field.getName() + " is required and cannot be null.");
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
                    if (ClassUtils.isAssignable(propertyType, Map.class)) {
                        Map<?, ?> entries = (Map<?, ?>)property;
                        for (Map.Entry<?, ?> entry : entries.entrySet()) {
                            Validator.validate(entry.getKey());
                            Validator.validate(entry.getValue());
                        }
                    }
                    else if (!(ClassUtils.isPrimitiveOrWrapper(propertyType) ||
                            propertyType.isEnum() ||
                            ClassUtils.isAssignable(propertyType, LocalDate.class) ||
                            ClassUtils.isAssignable(propertyType, DateTime.class) ||
                            ClassUtils.isAssignable(propertyType, String.class))) {
                        Validator.validate(property);
                    }
                } catch (IllegalArgumentException ex) {
                    // Build property chain
                    throw new IllegalArgumentException(field.getName() + "." + ex.getMessage());
                }
            }
        }
    }

    public static void validate(Object parameter, ServiceCallback<?> serviceCallback) {
        try {
            validate(parameter);
        } catch (IllegalArgumentException ex) {
            serviceCallback.failure(new ServiceException(ex));
        }
    }
}
