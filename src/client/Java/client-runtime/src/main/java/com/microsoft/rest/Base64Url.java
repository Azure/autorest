/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.google.common.io.BaseEncoding;

import java.util.Arrays;

/**
 * Simple wrapper over Base64Url encoded byte array used during serialization/deserialization.
 */
public final class Base64Url {
    /**
     * The Base64Url encoded bytes.
     */
    private final byte[] bytes;

    /**
     * Creates a new Base64Url object with the specified encoded string.
     *
     * @param string The encoded string.
     */
    private Base64Url(String string) {
        if (string == null) {
            this.bytes = null;
        } else {
            this.bytes = string.getBytes();
        }
    }

    /**
     * Encode a byte array into Base64Url encoded bytes.
     *
     * @param bytes The byte array to encode.
     * @return a Base64Url instance
     */
    public static Base64Url encode(byte[] bytes) {
        if (bytes == null) {
            return new Base64Url(null);
        } else {
            return new Base64Url(BaseEncoding.base64Url().omitPadding().encode(bytes));
        }
    }

    /**
     * Returns the underlying encoded byte array.
     *
     * @return The underlying encoded byte array.
     */
    public byte[] getEncodedBytes() {
        return bytes;
    }

    /**
     * Decode the bytes and return.
     *
     * @return The decoded byte array.
     */
    public byte[] getDecodedBytes() {
        if (this.bytes == null) {
            return null;
        }
        return BaseEncoding.base64Url().decode(new String(bytes));
    }

    @Override
    public String toString() {
        return new String(bytes);
    }

    @Override
    public int hashCode() {
        return Arrays.hashCode(bytes);
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }

        if (!(obj instanceof Base64Url)) {
            return false;
        }

        Base64Url rhs = (Base64Url) obj;
        return Arrays.equals(this.bytes, rhs.getEncodedBytes());
    }
}