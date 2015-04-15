/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.core.utils;

import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;
import java.lang.reflect.Constructor;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URISyntaxException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.TimeZone;

import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamConstants;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;

/**
 * RESERVED FOR INTERNAL USE. A class which provides utility methods.
 */
public final class Utility {
    /**
     * Stores a reference to the GMT time zone.
     */
    public static final TimeZone GMT_ZONE = TimeZone.getTimeZone("GMT");

    /**
     * Stores a reference to the UTC time zone.
     */
    public static final TimeZone UTC_ZONE = TimeZone.getTimeZone("UTC");

    /**
     * Stores a reference to the US locale.
     */
    public static final Locale LOCALE_US = Locale.US;

    /**
     * Stores a reference to the RFC1123 date/time pattern.
     */
    private static final String RFC1123_PATTERN = "EEE, dd MMM yyyy HH:mm:ss z";

    /**
     * Stores a reference to the ISO8061 date/time pattern.
     */
    public static final String ISO8061_PATTERN_NO_SECONDS = "yyyy-MM-dd'T'HH:mm'Z'";

    /**
     * Stores a reference to the ISO8061 date/time pattern.
     */
    public static final String ISO8061_PATTERN = "yyyy-MM-dd'T'HH:mm:ss'Z'";

    /**
     * Stores a reference to the ISO8061_LONG date/time pattern.
     */
    public static final String ISO8061_LONG_PATTERN = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS'Z'";

    /**
     * Asserts that a value is not <code>null</code>.
     * 
     * @param param
     *            A <code>String</code> that represents the name of the
     *            parameter, which becomes the exception message text if the
     *            <code>value</code> parameter is <code>null</code>.
     * @param value
     *            An <code>Object</code> object that represents the value of the
     *            specified parameter. This is the value being asserted as not
     *            <code>null</code>.
     */
    public static void assertNotNull(final String param, final Object value) {
        if (value == null) {
            throw new IllegalArgumentException(param);
        }
    }

    /**
     * Asserts that the specified string is not <code>null</code> or empty.
     * 
     * @param param
     *            A <code>String</code> that represents the name of the
     *            parameter, which becomes the exception message text if the
     *            <code>value</code> parameter is <code>null</code> or an empty
     *            string.
     * @param value
     *            A <code>String</code> that represents the value of the
     *            specified parameter. This is the value being asserted as not
     *            <code>null</code> and not an empty string.
     */
    public static void assertNotNullOrEmpty(final String param,
            final String value) {
        assertNotNull(param, value);

        if (Utility.isNullOrEmpty(value)) {
            throw new IllegalArgumentException(
                    "The argument must not be an empty string or null:"
                            .concat(param));
        }
    }

    /**
     * Asserts that the specified integer is in the valid range.
     * 
     * @param param
     *            A <code>String</code> that represents the name of the
     *            parameter, which becomes the exception message text if the
     *            <code>value</code> parameter is out of bounds.
     * @param value
     *            The value of the specified parameter.
     * @param min
     *            The minimum value for the specified parameter.
     * @param max
     *            The maximum value for the specified parameter.
     */
    public static void assertInBounds(final String param, final int value,
            final int min, final int max) {
        if (value < min || value > max) {
            throw new IllegalArgumentException(
                    String.format(
                            "The value of the parameter %s should be between %s and %s.",
                            param, min, max));
        }
    }

    /**
     * Creates an XML stream reader from the specified input stream.
     * 
     * @param streamRef
     *            An <code>InputStream</code> object that represents the input
     *            stream to use as the source.
     * 
     * @return A <code>java.xml.stream.XMLStreamReader</code> object that
     *         represents the XML stream reader created from the specified input
     *         stream.
     * 
     * @throws XMLStreamException
     *             If the XML stream reader could not be created.
     */
    public static XMLStreamReader createXMLStreamReaderFromStream(
            final InputStream streamRef) throws XMLStreamException {
        // TODO optimization keep this static
        XMLInputFactory xmlif = null;

        xmlif = XMLInputFactory.newInstance();
        xmlif.setProperty(XMLInputFactory.IS_REPLACING_ENTITY_REFERENCES,
                Boolean.TRUE);
        xmlif.setProperty(XMLInputFactory.IS_SUPPORTING_EXTERNAL_ENTITIES,
                Boolean.FALSE);
        // set the IS_COALESCING property to true , if application desires to
        // get whole text data as one event.
        xmlif.setProperty(XMLInputFactory.IS_COALESCING, Boolean.TRUE);

        return xmlif.createXMLStreamReader(streamRef);
    }

    /**
     * Creates an XML stream reader from the specified input stream.
     * 
     * @param reader
     *            An <code>InputStreamReader</code> object that represents the
     *            input reader to use as the source.
     * 
     * @return A <code>java.xml.stream.XMLStreamReader</code> object that
     *         represents the XML stream reader created from the specified input
     *         stream.
     * 
     * @throws XMLStreamException
     *             If the XML stream reader could not be created.
     */
    public static XMLStreamReader createXMLStreamReaderFromReader(
            final Reader reader) throws XMLStreamException {
        // TODO optimization keep this static
        XMLInputFactory xmlif = null;

        xmlif = XMLInputFactory.newInstance();
        xmlif.setProperty(XMLInputFactory.IS_REPLACING_ENTITY_REFERENCES,
                Boolean.TRUE);
        xmlif.setProperty(XMLInputFactory.IS_SUPPORTING_EXTERNAL_ENTITIES,
                Boolean.FALSE);
        // set the IS_COALESCING property to true , if application desires to
        // get whole text data as one event.
        xmlif.setProperty(XMLInputFactory.IS_COALESCING, Boolean.TRUE);

        return xmlif.createXMLStreamReader(reader);
    }

    /**
     * Returns a value that indicates whether a specified URI is a path-style
     * URI.
     * 
     * @param baseURI
     *            A <code>java.net.URI</code> value that represents the URI
     *            being checked.
     * @param knownAccountName
     *            A <code>String</code> that represents the known account name
     *            to examine with <code>baseURI</code>, or <code>null</code> to
     *            examine <code>baseURI</code> on its own for being a path-style
     *            URI.
     * 
     * @return <code>true</code> if the specified URI is path-style; otherwise,
     *         <code>false</code>.
     */
    public static boolean determinePathStyleFromUri(final URI baseURI,
            final String knownAccountName) {
        String path = baseURI.getPath();

        if (knownAccountName == null) {
            if (Utility.isNullOrEmpty(path) || path.equals("/")) {
                return false;
            }

            return true;
        }

        if (!Utility.isNullOrEmpty(path) && path.startsWith("/")) {
            path = path.substring(1);
        }

        if (Utility.isNullOrEmpty(path)
                || baseURI.getHost().startsWith(knownAccountName)) {
            return false;
        } else if (!Utility.isNullOrEmpty(path)
                && path.startsWith(knownAccountName)) {
            return true;
        }

        return false;
    }

    /**
     * Returns a byte array that represents the data of a <code>long</code>
     * value.
     * 
     * @param value
     *            The value from which the byte array will be returned.
     * 
     * @return A byte array that represents the data of the specified
     *         <code>long</code> value.
     */
    public static byte[] getBytesFromLong(final long value) {
        final byte[] tempArray = new byte[8];

        for (int m = 0; m < 8; m++) {
            tempArray[7 - m] = (byte) ((value >> (8 * m)) & 0xFF);
        }

        return tempArray;
    }

    /**
     * Returns the current GMT date/time using the RFC1123 pattern.
     * 
     * @return A <code>String</code> that represents the current GMT date/time
     *         using the RFC1123 pattern.
     */
    public static String getGMTTime() {
        final DateFormat rfc1123Format = new SimpleDateFormat(RFC1123_PATTERN,
                LOCALE_US);
        rfc1123Format.setTimeZone(GMT_ZONE);
        return rfc1123Format.format(new Date());
    }

    public static String getTimeByZoneAndFormat(Date date, TimeZone zone,
            String format) {
        final DateFormat formatter = new SimpleDateFormat(format, LOCALE_US);
        formatter.setTimeZone(zone);
        return formatter.format(date);
    }

    /**
     * Returns the GTM date/time for the specified value using the RFC1123
     * pattern.
     * 
     * @param inDate
     *            A <code>Date</code> object that represents the date to convert
     *            to GMT date/time in the RFC1123 pattern.
     * 
     * @return A <code>String</code> that represents the GMT date/time for the
     *         specified value using the RFC1123 pattern.
     */
    public static String getGMTTime(final Date inDate) {
        final DateFormat rfc1123Format = new SimpleDateFormat(RFC1123_PATTERN,
                LOCALE_US);
        rfc1123Format.setTimeZone(GMT_ZONE);
        return rfc1123Format.format(inDate);
    }

    /**
     * Returns the standard header value from the specified connection request,
     * or an empty string if no header value has been specified for the request.
     * 
     * @param conn
     *            An <code>HttpURLConnection</code> object that represents the
     *            request.
     * @param headerName
     *            A <code>String</code> that represents the name of the header
     *            being requested.
     * 
     * @return A <code>String</code> that represents the header value, or
     *         <code>null</code> if there is no corresponding header value for
     *         <code>headerName</code>.
     */
    public static String getStandardHeaderValue(final HttpURLConnection conn,
            final String headerName) {
        final String headerValue = conn.getRequestProperty(headerName);

        // Coalesce null value
        return headerValue == null ? Constants.EMPTY_STRING : headerValue;
    }

    /**
     * Returns the current UTC date/time using the RFC1123 pattern.
     * 
     * @return A <code>String</code> that represents the current UTC date/time
     *         using the RFC1123 pattern.
     */
    protected static String getUTCTime() {
        final DateFormat rfc1123Format = new SimpleDateFormat(RFC1123_PATTERN,
                LOCALE_US);
        rfc1123Format.setTimeZone(UTC_ZONE);
        return rfc1123Format.format(new Date());
    }

    /**
     * Returns the UTC date/time for the specified value using the RFC1123
     * pattern.
     * 
     * @param inDate
     *            A <code>Date</code> object that represents the date to convert
     *            to UTC date/time in the RFC1123 pattern.
     * 
     * @return A <code>String</code> that represents the UTC date/time for the
     *         specified value using the RFC1123 pattern.
     */
    protected static String getUTCTime(final Date inDate) {
        final DateFormat rfc1123Format = new SimpleDateFormat(RFC1123_PATTERN,
                LOCALE_US);
        rfc1123Format.setTimeZone(UTC_ZONE);
        return rfc1123Format.format(inDate);
    }

    /**
     * Returns the UTC date/time for the specified value using the ISO8061
     * pattern.
     * 
     * @param value
     *            A <code>Date</code> object that represents the date to convert
     *            to UTC date/time in the ISO8061 pattern. If this value is
     *            <code>null</code>, this method returns an empty string.
     * 
     * @return A <code>String</code> that represents the UTC date/time for the
     *         specified value using the ISO8061 pattern, or an empty string if
     *         <code>value</code> is <code>null</code>.
     */
    public static String getUTCTimeOrEmpty(final Date value) {
        if (value == null) {
            return Constants.EMPTY_STRING;
        }

        final DateFormat iso8061Format = new SimpleDateFormat(ISO8061_PATTERN,
                LOCALE_US);
        iso8061Format.setTimeZone(UTC_ZONE);

        return iso8061Format.format(value);
    }

    /**
     * Creates an instance of the <code>IOException</code> class using the
     * specified exception.
     * 
     * @param ex
     *            An <code>Exception</code> object that represents the exception
     *            used to create the IO exception.
     * 
     * @return A <code>java.io.IOException</code> object that represents the
     *         created IO exception.
     */
    public static IOException initIOException(final Exception ex) {
        final IOException retEx = new IOException();
        retEx.initCause(ex);
        return retEx;
    }

    /**
     * Returns a value that indicates whether the specified string is
     * <code>null</code> or empty.
     * 
     * @param value
     *            A <code>String</code> being examined for <code>null</code> or
     *            empty.
     * 
     * @return <code>true</code> if the specified value is <code>null</code> or
     *         empty; otherwise, <code>false</code>
     */
    public static boolean isNullOrEmpty(final String value) {
        return value == null || value.length() == 0;
    }

    /**
     * Parses a connection string and returns its values as a hash map of
     * key/value pairs.
     * 
     * @param parseString
     *            A <code>String</code> that represents the connection string to
     *            parse.
     * 
     * @return A <code>java.util.HashMap</code> object that represents the hash
     *         map of the key / value pairs parsed from the connection string.
     */
    public static HashMap<String, String> parseAccountString(
            final String parseString) {

        // 1. split name value pairs by splitting on the ';' character
        final String[] valuePairs = parseString.split(";");
        final HashMap<String, String> retVals = new HashMap<String, String>();

        // 2. for each field value pair parse into appropriate map entries
        for (int m = 0; m < valuePairs.length; m++) {
            final int equalDex = valuePairs[m].indexOf("=");
            if (equalDex < 1) {
                throw new IllegalArgumentException("Invalid Connection String");
            }

            final String key = valuePairs[m].substring(0, equalDex);
            final String value = valuePairs[m].substring(equalDex + 1);

            // 2.1 add to map
            retVals.put(key, value);
        }

        return retVals;
    }

    /**
     * Returns a GMT date in the specified format
     * 
     * @param value
     *            the string to parse
     * @return the GMT date, as a <code>Date</code>
     * @throws ParseException
     *             If the specified string is invalid
     */
    public static Date parseDateFromString(final String value,
            final String pattern, final TimeZone timeZone)
            throws ParseException {
        final DateFormat rfc1123Format = new SimpleDateFormat(pattern,
                Utility.LOCALE_US);
        rfc1123Format.setTimeZone(timeZone);
        return rfc1123Format.parse(value);
    }

    /**
     * Returns a date in the ISO8061 long pattern for the specified string.
     * 
     * @param value
     *            A <code>String</code> that represents the string to parse.
     * 
     * @return A <code>Date</code> object that represents the date in the
     *         ISO8061 long pattern.
     * 
     * @throws ParseException
     *             If the specified string is invalid.
     */
    public static Date parseISO8061LongDateFromString(final String value)
            throws ParseException {
        return parseDateFromString(value, ISO8061_LONG_PATTERN,
                Utility.UTC_ZONE);
    }

    /**
     * Returns a GMT date in the RFC1123 pattern for the specified string.
     * 
     * @param value
     *            A <code>String</code> that represents the string to parse.
     * 
     * @return A <code>Date</code> object that represents the GMT date in the
     *         RFC1123 pattern.
     * 
     * @throws ParseException
     *             If the specified string is invalid.
     */
    public static Date parseRFC1123DateFromStringInGMT(final String value)
            throws ParseException {
        return parseDateFromString(value, RFC1123_PATTERN, Utility.GMT_ZONE);
    }

    /**
     * Reads character data for the specified XML element from an XML stream
     * reader. This method will read start events, characters, and end events
     * from a stream.
     * 
     * @param xmlr
     *            An <code>XMLStreamReader</code> object that represents the
     *            source XML stream reader.
     * 
     * @param elementName
     *            A <code>String</code> that represents XML element name.
     * 
     * @return A <code>String</code> that represents the character data for the
     *         specified element.
     * 
     * @throws XMLStreamException
     *             If an XML stream failure occurs.
     */
    public static String readElementFromXMLReader(final XMLStreamReader xmlr,
            final String elementName) throws XMLStreamException {
        return readElementFromXMLReader(xmlr, elementName, true);
    }

    /**
     * Reads character data for the specified XML element from an XML stream
     * reader. This method will read start events, characters, and end events
     * from a stream.
     * 
     * @param xmlr
     *            An <code>XMLStreamReader</code> object that represents the
     *            source XML stream reader.
     * 
     * @param elementName
     *            A <code>String</code> that represents XML element name.
     * @param returnNullOnEmpty
     *            If true, returns null when a empty string is read, otherwise
     *            EmptyString ("") is returned.
     * 
     * @return A <code>String</code> that represents the character data for the
     *         specified element.
     * 
     * @throws XMLStreamException
     *             If an XML stream failure occurs.
     */
    public static String readElementFromXMLReader(final XMLStreamReader xmlr,
            final String elementName, boolean returnNullOnEmpty)
            throws XMLStreamException {
        xmlr.require(XMLStreamConstants.START_ELEMENT, null, elementName);
        int eventType = xmlr.next();
        final StringBuilder retVal = new StringBuilder();

        if (eventType == XMLStreamConstants.CHARACTERS) {
            // This do while is in case the XMLStreamReader does not have
            // the IS_COALESCING property set
            // to true which may result in text being read in multiple events
            // If we ensure all xmlreaders have this property we can optimize
            // the StringBuilder and while loop
            // away
            do {
                retVal.append(xmlr.getText());
                eventType = xmlr.next();

            } while (eventType == XMLStreamConstants.CHARACTERS);
        }

        xmlr.require(XMLStreamConstants.END_ELEMENT, null, elementName);
        if (retVal.length() == 0) {
            return returnNullOnEmpty ? null : Constants.EMPTY_STRING;
        } else {
            return retVal.toString();
        }
    }

    /**
     * Determines the relative difference between the two specified URIs.
     * 
     * @param baseURI
     *            A <code>java.net.URI</code> object that represents the base
     *            URI for which <code>toUri</code> will be made relative.
     * @param toUri
     *            A <code>java.net.URI</code> object that represents the URI to
     *            make relative to <code>baseURI</code>.
     * 
     * @return A <code>String</code> that either represents the relative URI of
     *         <code>toUri</code> to <code>baseURI</code>, or the URI of
     *         <code>toUri</code> itself, depending on whether the hostname and
     *         scheme are identical for <code>toUri</code> and
     *         <code>baseURI</code>. If the hostname and scheme of
     *         <code>baseURI</code> and <code>toUri</code> are identical, this
     *         method returns a relative URI such that if appended to
     *         <code>baseURI</code>, it will yield <code>toUri</code>. If the
     *         hostname or scheme of <code>baseURI</code> and <code>toUri</code>
     *         are not identical, this method returns the full URI specified by
     *         <code>toUri</code>.
     * 
     * @throws URISyntaxException
     *             If <code>baseURI</code> or <code>toUri</code> is invalid.
     */
    public static String safeRelativize(final URI baseURI, final URI toUri)
            throws URISyntaxException {
        // For compatibility followed
        // http://msdn.microsoft.com/en-us/library/system.uri.makerelativeuri.aspx

        // if host and scheme are not identical return from uri
        if (!baseURI.getHost().equals(toUri.getHost())
                || !baseURI.getScheme().equals(toUri.getScheme())) {
            return toUri.toString();
        }

        final String basePath = baseURI.getPath();
        String toPath = toUri.getPath();

        int truncatePtr = 1;

        // Seek to first Difference
        // int maxLength = Math.min(basePath.length(), toPath.length());
        int m = 0;
        int ellipsesCount = 0;
        for (; m < basePath.length(); m++) {
            if (m >= toPath.length()) {
                if (basePath.charAt(m) == '/') {
                    ellipsesCount++;
                }
            } else {
                if (basePath.charAt(m) != toPath.charAt(m)) {
                    break;
                } else if (basePath.charAt(m) == '/') {
                    truncatePtr = m + 1;
                }
            }
        }

        if (m == toPath.length()) {
            // No path difference, return query + fragment
            return new URI(null, null, null, toUri.getQuery(),
                    toUri.getFragment()).toString();
        } else {
            toPath = toPath.substring(truncatePtr);
            final StringBuilder sb = new StringBuilder();
            while (ellipsesCount > 0) {
                sb.append("../");
                ellipsesCount--;
            }

            if (!Utility.isNullOrEmpty(toPath)) {
                sb.append(toPath);
            }

            if (!Utility.isNullOrEmpty(toUri.getQuery())) {
                sb.append("?");
                sb.append(toUri.getQuery());
            }
            if (!Utility.isNullOrEmpty(toUri.getFragment())) {
                sb.append("#");
                sb.append(toUri.getRawFragment());
            }

            return sb.toString();
        }
    }

    /**
     * Trims the specified character from the end of a string.
     * 
     * @param value
     *            A <code>String</code> that represents the string to trim.
     * @param trimChar
     *            The character to trim from the end of the string.
     * 
     * @return The string with the specified character trimmed from the end.
     */
    protected static String trimEnd(final String value, final char trimChar) {
        int stopDex = value.length() - 1;
        while (stopDex > 0 && value.charAt(stopDex) == trimChar) {
            stopDex--;
        }

        return stopDex == value.length() - 1 ? value : value.substring(stopDex);
    }

    /**
     * Trims whitespace from the beginning of a string.
     * 
     * @param value
     *            A <code>String</code> that represents the string to trim.
     * 
     * @return The string with whitespace trimmed from the beginning.
     */
    public static String trimStart(final String value) {
        int spaceDex = 0;
        while (spaceDex < value.length() && value.charAt(spaceDex) == ' ') {
            spaceDex++;
        }

        return value.substring(spaceDex);
    }

    /**
     * Private Default Ctor.
     */
    private Utility() {
        // No op
    }

    public static void checkNullaryCtor(Class<?> clazzType) {
        Constructor<?> ctor = null;
        try {
            ctor = clazzType.getDeclaredConstructor((Class<?>[]) null);
        } catch (Exception e) {
            throw new IllegalArgumentException(
                    "Class type must have contain a nullary constructor.");
        }

        if (ctor == null) {
            throw new IllegalArgumentException(
                    "Class type must have contain a nullary constructor.");
        }
    }

    public static Date parseDate(String dateString) {
        try {
            if (dateString.length() == 28) {
                // "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS'Z'"->
                // [2012-01-04T23:21:59.1234567Z] length = 28
                return Utility.parseDateFromString(dateString,
                        Utility.ISO8061_LONG_PATTERN, Utility.UTC_ZONE);
            } else if (dateString.length() == 20) {
                // "yyyy-MM-dd'T'HH:mm:ss'Z'"-> [2012-01-04T23:21:59Z] length =
                // 20
                return Utility.parseDateFromString(dateString,
                        Utility.ISO8061_PATTERN, Utility.UTC_ZONE);
            } else if (dateString.length() == 17) {
                // "yyyy-MM-dd'T'HH:mm'Z'"-> [2012-01-04T23:21Z] length = 17
                return Utility.parseDateFromString(dateString,
                        Utility.ISO8061_PATTERN_NO_SECONDS, Utility.UTC_ZONE);
            } else if (dateString.length() == 27) {
                // "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"->
                // [2012-01-04T23:21:59.123456Z] length = 27
                return Utility.parseDateFromString(dateString,
                        "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'", Utility.UTC_ZONE);
            } else if (dateString.length() == 26) {
                // "yyyy-MM-dd'T'HH:mm:ss.SSSSS'Z'"->
                // [2012-01-04T23:21:59.12345Z] length = 26
                return Utility.parseDateFromString(dateString,
                        "yyyy-MM-dd'T'HH:mm:ss.SSSSS'Z'", Utility.UTC_ZONE);
            } else if (dateString.length() == 25) {
                // "yyyy-MM-dd'T'HH:mm:ss.SSSS'Z'"-> [2012-01-04T23:21:59.1234Z]
                // length = 25
                return Utility.parseDateFromString(dateString,
                        "yyyy-MM-dd'T'HH:mm:ss.SSSS'Z'", Utility.UTC_ZONE);
            } else if (dateString.length() == 24) {
                // "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"-> [2012-01-04T23:21:59.123Z]
                // length = 24
                return Utility.parseDateFromString(dateString,
                        "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Utility.UTC_ZONE);
            } else if (dateString.length() == 23) {
                // "yyyy-MM-dd'T'HH:mm:ss.SS'Z'"-> [2012-01-04T23:21:59.12Z]
                // length = 23
                return Utility.parseDateFromString(dateString,
                        "yyyy-MM-dd'T'HH:mm:ss.SS'Z'", Utility.UTC_ZONE);
            } else if (dateString.length() == 22) {
                // "yyyy-MM-dd'T'HH:mm:ss.S'Z'"-> [2012-01-04T23:21:59.1Z]
                // length = 22
                return Utility.parseDateFromString(dateString,
                        "yyyy-MM-dd'T'HH:mm:ss.S'Z'", Utility.UTC_ZONE);
            } else {
                throw new IllegalArgumentException(String.format(
                        "Invalid Date String: %s", dateString));
            }
        } catch (final ParseException e) {
            throw new IllegalArgumentException(String.format(
                    "Invalid Date String: %s", dateString), e);
        }
    }
}
