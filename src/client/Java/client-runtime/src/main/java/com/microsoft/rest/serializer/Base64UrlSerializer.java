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
import com.microsoft.rest.Base64Url;

import java.io.IOException;

/**
 * Custom serializer for serializing {@link Byte[]} objects into Base64 strings.
 */
public class Base64UrlSerializer extends JsonSerializer<Base64Url> {
    /**
     * Gets a module wrapping this serializer as an adapter for the Jackson
     * ObjectMapper.
     *
     * @return a simple module to be plugged onto Jackson ObjectMapper.
     */
    public static SimpleModule getModule() {
        SimpleModule module = new SimpleModule();
        module.addSerializer(Base64Url.class, new Base64UrlSerializer());
        return module;
    }

    @Override
    public void serialize(Base64Url value, JsonGenerator jgen, SerializerProvider provider) throws IOException {
        jgen.writeString(value.toString());
    }
}
