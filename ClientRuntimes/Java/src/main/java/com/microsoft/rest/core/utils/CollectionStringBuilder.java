/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.core.utils;

import org.apache.commons.lang.StringUtils;

import java.util.List;

public class CollectionStringBuilder {
    private static final String DEFAULT_SEPARATOR = ",";
    private final StringBuilder sb;
    private static String separator;

    public CollectionStringBuilder() {
        sb = new StringBuilder();
        separator = DEFAULT_SEPARATOR;
    }

    public CollectionStringBuilder(String separator) {
        sb = new StringBuilder();
        CollectionStringBuilder.separator = separator;
    }

    public void add(String representation) {
        if (sb.length() > 0) {
            sb.append(separator);
        }
        sb.append(representation);
    }

    public void addValue(boolean value, String representation) {
        if (value) {
            add(representation);
        }
    }

    public static String join(List<String> values) {
        return StringUtils.join(values, separator);
    }

    public static String join(List<String> values, String separator) {
        return StringUtils.join(values, separator);
    }

    public static String join(String... values) {
        CollectionStringBuilder sb = new CollectionStringBuilder();

        for (String value : values) {
            sb.add(value);
        }

        return sb.toString();
    }

    @Override
    public String toString() {
        if (sb.length() == 0) {
            return null;
        }

        return sb.toString();
    }
}
