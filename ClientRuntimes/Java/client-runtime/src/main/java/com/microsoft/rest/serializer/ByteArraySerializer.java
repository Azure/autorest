/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.serializer;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.module.SimpleModule;
import org.apache.commons.lang3.ArrayUtils;

import java.io.ByteArrayInputStream;
import java.io.IOException;

/**
 * Custom serializer for serializing {@link Byte[]} objects into Base64 strings.
 */
public class ByteArraySerializer extends JsonSerializer<Byte[]> {
    public static SimpleModule getModule() {
        SimpleModule module = new SimpleModule();
        module.addSerializer(Byte[].class, new ByteArraySerializer());
        return module;
    }

    @Override
    public void serialize(Byte[] value, JsonGenerator jgen, SerializerProvider provider) throws IOException {
        jgen.writeBinary(ArrayUtils.toPrimitive(value));
    }
}
