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
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

/*
 * "not quite" ISO 8601 date time conversion routines
 */
public class ISO8601DateConverter {
    // Note: because of the trailing "0000000", this is not quite ISO 8601
    // compatible
    private static final String DATETIME_PATTERN = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    private static final String SHORT_DATETIME_PATTERN = "yyyy-MM-dd'T'HH:mm:ss'Z'";
    private static final String DATETIME_PATTERN_NO_S = "yyyy-MM-dd'T'HH:mm'Z'";
    private static final String DATETIME_PATTERN_TO_DECIMAL = "yyyy-MM-dd'T'HH:mm:ss.";

    public String format(Date date) {
        DateFormat iso8601Format = new SimpleDateFormat(DATETIME_PATTERN,
                Locale.US);
        iso8601Format.setTimeZone(TimeZone.getTimeZone("GMT"));
        return iso8601Format.format(date);
    }

    public String shortFormat(Date date) {
        DateFormat iso8601Format = new SimpleDateFormat(SHORT_DATETIME_PATTERN,
                Locale.US);
        iso8601Format.setTimeZone(TimeZone.getTimeZone("GMT"));
        return iso8601Format.format(date);
    }

    public Date parse(String date) throws ParseException {
        if (date == null) {
            return null;
        }

        int length = date.length();
        if (length == 17) {
            // [2012-01-04T23:21Z] length = 17
            return parseDateFromString(date, DATETIME_PATTERN_NO_S);
        } else if (length == 20) {
            // [2012-01-04T23:21:59Z] length = 20
            return parseDateFromString(date, SHORT_DATETIME_PATTERN);
        } else if (length >= 22 && length <= 28) {
            // [2012-01-04T23:21:59.1Z] length = 22
            // [2012-01-04T23:21:59.1234567Z] length = 28
            // Need to handle the milliseconds gently.

            Date allExceptMilliseconds = parseDateFromString(date,
                    DATETIME_PATTERN_TO_DECIMAL);
            long timeWithSecondGranularity = allExceptMilliseconds.getTime();
            // Decimal point is at 19
            String secondDecimalString = date.substring(19, date.indexOf('Z'));
            Float secondDecimal = Float.parseFloat(secondDecimalString);
            int milliseconds = Math.round(secondDecimal * 1000);
            long timeInMS = timeWithSecondGranularity + milliseconds;
            Calendar calendar = Calendar.getInstance();
            calendar.setTimeInMillis(timeInMS);
            return calendar.getTime();
        } else {
            throw new IllegalArgumentException(String.format(
                    "Invalid Date String: %s", date));
        }
    }

    private static Date parseDateFromString(final String value,
            final String pattern) throws ParseException {
        final DateFormat iso8601Format = new SimpleDateFormat(pattern,
                Locale.US);
        iso8601Format.setTimeZone(TimeZone.getTimeZone("GMT"));
        return iso8601Format.parse(value);
    }
}
