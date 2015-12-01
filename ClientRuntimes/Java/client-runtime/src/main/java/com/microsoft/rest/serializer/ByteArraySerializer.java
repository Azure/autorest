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

import java.io.IOException;

/**
 * Custom serializer for serializing {@link Byte[]} objects into Base64 strings.
 */
public class ByteArraySerializer extends JsonSerializer<Byte[]> {
    /**
     * Gets a module wrapping this serializer as an adapter for the Jackson
     * ObjectMapper.
     *
     * @return a simple module to be plugged onto Jackson ObjectMapper.
     */
    public static SimpleModule getModule() {
        SimpleModule module = new SimpleModule();
        module.addSerializer(Byte[].class, new ByteArraySerializer());
        return module;
    }

    @Override
    public void serialize(Byte[] value, JsonGenerator jgen, SerializerProvider provider) throws IOException {
        byte[] bytes = new byte[value.length];
        for (int i = 0; i < value.length; i++) {
            bytes[i] = value[i];
        }
        jgen.writeBinary(bytes);
    }
}
