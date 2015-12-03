/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

/**
 * An instance of this class holds a response object and a raw REST response.
 */
public final class URLEncoderAdapter {
    /**
     * Hidden constructor for utility class.
     */
    private URLEncoderAdapter() { }

    /**
     * Encodes a string into UTF-8 format.
     *
     * @param str the string to encode
     * @return the encoded string
     */
    public static String encode(String str) {
        if (str == null) {
            return null;
        }

        try {
            return URLEncoder.encode(str, "UTF-8");
        } catch (UnsupportedEncodingException ex) {
            return null;
        }
    }
}
