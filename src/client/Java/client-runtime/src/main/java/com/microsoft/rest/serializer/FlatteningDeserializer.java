/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.serializer;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.BeanDescription;
import com.fasterxml.jackson.databind.DeserializationConfig;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.deser.BeanDeserializerModifier;
import com.fasterxml.jackson.databind.deser.ResolvableDeserializer;
import com.fasterxml.jackson.databind.deser.std.StdDeserializer;
import com.fasterxml.jackson.databind.module.SimpleModule;
import com.fasterxml.jackson.databind.node.ObjectNode;

import java.io.IOException;
import java.lang.reflect.Field;

/**
 * Custom serializer for deserializing complex types with wrapped properties.
 * For example, a property with annotation @JsonProperty(value = "properties.name")
 * will be mapped to a top level "name" property in the POJO model.
 */
public class FlatteningDeserializer extends StdDeserializer<Object> implements ResolvableDeserializer {
    /**
     * The default mapperAdapter for the current type.
     */
    private final JsonDeserializer<?> defaultDeserializer;

    /**
     * The object mapper for default deserializations.
     */
    private final ObjectMapper mapper;

    /**
     * Creates an instance of FlatteningDeserializer.
     * @param vc handled type
     * @param defaultDeserializer the default JSON mapperAdapter
     * @param mapper the object mapper for default deserializations
     */
    protected FlatteningDeserializer(Class<?> vc, JsonDeserializer<?> defaultDeserializer, ObjectMapper mapper) {
        super(vc);
        this.defaultDeserializer = defaultDeserializer;
        this.mapper = mapper;
    }

    /**
     * Gets a module wrapping this serializer as an adapter for the Jackson
     * ObjectMapper.
     *
     * @param mapper the object mapper for default deserializations
     * @return a simple module to be plugged onto Jackson ObjectMapper.
     */
    public static SimpleModule getModule(final ObjectMapper mapper) {
        SimpleModule module = new SimpleModule();
        module.setDeserializerModifier(new BeanDeserializerModifier() {
            @Override
            public JsonDeserializer<?> modifyDeserializer(DeserializationConfig config, BeanDescription beanDesc, JsonDeserializer<?> deserializer) {
                if (beanDesc.getBeanClass().getAnnotation(JsonFlatten.class) != null) {
                    return new FlatteningDeserializer(beanDesc.getBeanClass(), deserializer, mapper);
                }
                return deserializer;
            }
        });
        return module;
    }

    @SuppressWarnings("unchecked")
    @Override
    public Object deserialize(JsonParser jp, DeserializationContext ctxt) throws IOException {
        JsonNode root = mapper.readTree(jp);
        final Class<?> tClass = this.defaultDeserializer.handledType();
        for (Field field : tClass.getDeclaredFields()) {
            JsonNode node = root;
            JsonProperty property = field.getAnnotation(JsonProperty.class);
            if (property != null) {
                String value = property.value();
                if (value.matches(".+[^\\\\]\\..+")) {
                    String[] values = value.split("((?<!\\\\))\\.");
                    for (String val : values) {
                        val = val.replace("\\.", ".");
                        node = node.get(val);
                        if (node == null) {
                            break;
                        }
                    }
                    ((ObjectNode) root).put(value, node);
                }
            }
        }
        JsonParser parser = new JsonFactory().createParser(root.toString());
        parser.nextToken();
        return defaultDeserializer.deserialize(parser, ctxt);
    }

    @Override
    public void resolve(DeserializationContext ctxt) throws JsonMappingException {
        ((ResolvableDeserializer) defaultDeserializer).resolve(ctxt);
    }
}
