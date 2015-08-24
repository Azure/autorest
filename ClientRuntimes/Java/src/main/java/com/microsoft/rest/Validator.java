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

import java.lang.reflect.Field;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * ServiceClient is the abstraction for accessing REST operations and their payload data types.
 */
public class Validator {
    public static void validate(Object request, Class type) throws NullPointerException {
        Field[] fields = FieldUtils.getAllFields(type);
        for (Field field : fields) {
            field.setAccessible(true);
            JsonProperty annotation = field.getAnnotation(JsonProperty.class);
            Object property = null;
            try {
                property = field.get(request);
            } catch (IllegalAccessException e) {
                // Ignore inaccessible fields
            }
            if (annotation != null && annotation.required()) {
                Objects.requireNonNull(property, field.getName() + " == null");
            }

            if (property != null) {
                Class propertyType = property.getClass();
                if (ClassUtils.isAssignable(propertyType, List.class)) {
                    List<?> items = (List<?>)property;
                    for (Object item : items) {
                        Validator.validate(item, item.getClass());
                    }
                }
                if (ClassUtils.isAssignable(propertyType, Map.class)) {
                    Map<?, ?> entries = (Map<?, ?>)property;
                    for (Map.Entry<?, ?> entry : entries.entrySet()) {
                        Validator.validate(entry.getKey(), entry.getKey().getClass());
                        Validator.validate(entry.getValue(), entry.getValue().getClass());
                    }
                }
                else if (!(ClassUtils.isPrimitiveOrWrapper(propertyType) ||
                        ClassUtils.isAssignable(propertyType, LocalDate.class) ||
                        ClassUtils.isAssignable(propertyType, DateTime.class) ||
                        ClassUtils.isAssignable(propertyType, String.class))) {
                    Validator.validate(property, propertyType);
                }
            }
        }
    }
}
