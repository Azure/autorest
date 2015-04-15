/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.core;

import javax.xml.datatype.DatatypeConfigurationException;
import javax.xml.datatype.DatatypeFactory;
import javax.xml.datatype.Duration;

public abstract class TimeSpan8601Converter {
    public static String format(Duration duration) {
        return duration.toString();
    }

    public static Duration parse(String duration) {
        try {
            DatatypeFactory factory = DatatypeFactory.newInstance();
            return factory.newDuration(duration);
        } catch (DatatypeConfigurationException e) {
            String msg = String.format(
                    "The value \"%s\" is not a valid ISO8601 duration.",
                    duration);
            throw new IllegalArgumentException(msg, e);
        }
    }
}
