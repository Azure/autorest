/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.core;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

/*
 * RFC 1123 date to string conversion
 */
public class RFC1123DateConverter {
    private static final String RFC1123_PATTERN = "EEE, dd MMM yyyy HH:mm:ss z";

    public String format(Date date) {
        return getFormat().format(date);
    }

    public Date parse(String date) {
        try {
            return getFormat().parse(date);
        } catch (ParseException e) {
            String msg = String.format(
                    "The value \"%s\" is not a valid RFC 1123 date.", date);
            throw new IllegalArgumentException(msg, e);
        }
    }

    private DateFormat getFormat() {
        DateFormat rfc1123Format = new SimpleDateFormat(RFC1123_PATTERN,
                Locale.US);
        rfc1123Format.setTimeZone(TimeZone.getTimeZone("GMT"));
        return rfc1123Format;
    }
}
