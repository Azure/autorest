/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure.serializer;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.BeanDescription;
import com.fasterxml.jackson.databind.DeserializationConfig;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.deser.BeanDeserializerModifier;
import com.fasterxml.jackson.databind.deser.ResolvableDeserializer;
import com.fasterxml.jackson.databind.deser.std.StdDeserializer;
import com.fasterxml.jackson.databind.module.SimpleModule;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.microsoft.azure.BaseResource;

import java.io.IOException;
import java.lang.reflect.Field;

/**
 * Custom serializer for deserializing {@link BaseResource} with wrapped properties.
 * For example, a property with annotation @JsonProperty(value = "properties.name")
 * will be mapped to a top level "name" property in the POJO model.
 *
 * @param <T> the type to deserialize into.
 */
public class FlatteningDeserializer<T> extends StdDeserializer<T> implements ResolvableDeserializer {
    /**
     * The default mapperAdapter for the current type.
     */
    private final JsonDeserializer<?> defaultDeserializer;

    /**
     * Creates an instance of FlatteningDeserializer.
     * @param vc handled type
     * @param defaultDeserializer the default JSON mapperAdapter
     */
    protected FlatteningDeserializer(Class<?> vc, JsonDeserializer<?> defaultDeserializer) {
        super(vc);
        this.defaultDeserializer = defaultDeserializer;
    }

    /**
     * Gets a module wrapping this serializer as an adapter for the Jackson
     * ObjectMapper.
     *
     * @return a simple module to be plugged onto Jackson ObjectMapper.
     */
    public static SimpleModule getModule() {
        final Class<?> vc = BaseResource.class;
        SimpleModule module = new SimpleModule();
        module.setDeserializerModifier(new BeanDeserializerModifier() {
            @Override
            public JsonDeserializer<?> modifyDeserializer(DeserializationConfig config, BeanDescription beanDesc, JsonDeserializer<?> deserializer) {
                if (vc.isAssignableFrom(beanDesc.getBeanClass()) && vc != beanDesc.getBeanClass()) {
                    return new FlatteningDeserializer<BaseResource>(beanDesc.getBeanClass(), deserializer);
                }
                return deserializer;
            }
        });
        return module;
    }

    @SuppressWarnings("unchecked")
    @Override
    public T deserialize(JsonParser jp, DeserializationContext ctxt) throws IOException {
        JsonNode root = new AzureJacksonMapperAdapter().getObjectMapper().readTree(jp);
        final Class<?> tClass = this.defaultDeserializer.handledType();
        for (Field field : tClass.getDeclaredFields()) {
            JsonNode node = root;
            JsonProperty property = field.getAnnotation(JsonProperty.class);
            if (property != null) {
                String value = property.value();
                if (value.contains(".")) {
                    String[] values = value.split("\\.");
                    for (String val : values) {
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
        return (T) defaultDeserializer.deserialize(parser, ctxt);
    }

    @Override
    public void resolve(DeserializationContext ctxt) throws JsonMappingException {
        ((ResolvableDeserializer) defaultDeserializer).resolve(ctxt);
    }
}
