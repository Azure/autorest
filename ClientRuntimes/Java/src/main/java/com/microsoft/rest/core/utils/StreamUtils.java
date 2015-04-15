/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.core.utils;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

public final class StreamUtils {
    private StreamUtils() {
    }

    public static String toString(final InputStream inputStream)
            throws IOException {
        final BufferedInputStream bufferedStream = new BufferedInputStream(
                inputStream);
        final ByteArrayOutputStream byteStream = new ByteArrayOutputStream();

        int result = bufferedStream.read();
        while (result >= 0) {
            final byte data = (byte) result;
            byteStream.write(data);
            result = bufferedStream.read();
        }
        return byteStream.toString();
    }
}
