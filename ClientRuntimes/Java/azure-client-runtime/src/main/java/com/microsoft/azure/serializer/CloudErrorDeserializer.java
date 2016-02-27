/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure.serializer;

import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.module.SimpleModule;
import com.microsoft.azure.CloudError;

import java.io.IOException;

/**
 * Custom serializer for serializing {@link CloudError} objects.
 */
public class CloudErrorDeserializer extends JsonDeserializer<CloudError> {
    /** Object mapper for default deserializations. */
    private ObjectMapper mapper;

    /**
     * Creates an instance of CloudErrorDeserializer.
     *
     * @param mapper the object mapper for default deserializations.
     */
    protected CloudErrorDeserializer(ObjectMapper mapper) {
        this.mapper = mapper;
    }

    /**
     * Gets a module wrapping this serializer as an adapter for the Jackson
     * ObjectMapper.
     *
     * @param mapper the object mapper for default deserializations.
     * @return a simple module to be plugged onto Jackson ObjectMapper.
     */
    public static SimpleModule getModule(ObjectMapper mapper) {
        SimpleModule module = new SimpleModule();
        module.addDeserializer(CloudError.class, new CloudErrorDeserializer(mapper));
        return module;
    }

    @Override
    public CloudError deserialize(JsonParser p, DeserializationContext ctxt) throws IOException, JsonProcessingException {
        JsonNode topNode = p.readValueAsTree();
        if (topNode == null) {
            return null;
        }
        JsonNode errorNode = topNode.get("error");
        if (errorNode == null) {
            return null;
        }
        JsonParser parser = new JsonFactory().createParser(errorNode.toString());
        parser.setCodec(mapper);
        return parser.readValueAs(CloudError.class);
    }
}
