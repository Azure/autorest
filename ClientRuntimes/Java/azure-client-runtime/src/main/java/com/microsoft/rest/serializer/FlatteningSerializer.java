/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.serializer;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.BeanDescription;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationConfig;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.module.SimpleModule;
import com.fasterxml.jackson.databind.node.JsonNodeFactory;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.databind.ser.BeanSerializerModifier;
import com.fasterxml.jackson.databind.ser.ResolvableSerializer;
import com.fasterxml.jackson.databind.ser.std.StdSerializer;
import com.microsoft.rest.BaseResource;
import org.apache.commons.lang3.reflect.FieldUtils;

import java.io.IOException;
import java.lang.reflect.Field;

/**
 * Custom serializer for deserializing {@link BaseResource} with wrapped properties.
 * For example, a property with annotation @JsonProperty(value = "properties.name")
 * will be mapped to a top level "name" property in the POJO model.
 */
public class FlatteningSerializer<T> extends StdSerializer<T> implements ResolvableSerializer {
    private final JsonSerializer<?> defaultSerializer;

    protected FlatteningSerializer(Class<T> vc, JsonSerializer<?> defaultDeserializer) {
        super(vc);
        this.defaultSerializer = defaultDeserializer;
    }

    public static SimpleModule getModule() {
        SimpleModule module = new SimpleModule();
        module.setSerializerModifier(new BeanSerializerModifier() {
            @Override
            public JsonSerializer<?> modifySerializer(SerializationConfig config, BeanDescription beanDesc, JsonSerializer<?> serializer) {
                if (BaseResource.class.isAssignableFrom(beanDesc.getBeanClass()) && BaseResource.class != beanDesc.getBeanClass())
                    return new FlatteningSerializer<>(BaseResource.class, serializer);
                return serializer;
            }
        });
        return module;
    }

    @Override
    public void serialize(T value, JsonGenerator jgen, SerializerProvider provider) throws IOException, JsonGenerationException {
        if (value == null) {
            jgen.writeNull();
            return;
        }

        ObjectMapper mapper = new AzureJacksonHelper().getObjectMapper();
        final Class<?> tClass = this.defaultSerializer.handledType();
        ObjectNode root = new ObjectNode(JsonNodeFactory.instance);
        for (Field field : FieldUtils.getAllFields(tClass)) {
            field.setAccessible(true);
            JsonNode propNode = null;
            try {
                propNode =mapper.valueToTree(field.get(value));
            } catch (IllegalAccessException ex) {
                ex.printStackTrace();
            }
            if (propNode == null) {
                continue;
            }

            JsonProperty property = field.getAnnotation(JsonProperty.class);
            if (property != null && property.value().contains(".")) {
                ObjectNode node = root;
                String[] values = property.value().split("\\.");
                for (int i = 0; i < values.length - 1; ++i) {
                    String val = values[i];
                    if (node.has(val)) {
                        node = (ObjectNode)node.get(val);
                    } else {
                        ObjectNode child = new ObjectNode(JsonNodeFactory.instance);
                        node.put(val, child);
                        node = child;
                    }
                }
                node.set(values[values.length - 1], propNode);
            } else {
                root.set(property != null ? property.value() : field.getName(), propNode);
            }
        }
        jgen.writeTree(root);
    }

    @Override
    public void resolve(SerializerProvider provider) throws JsonMappingException {
        ((ResolvableSerializer) defaultSerializer).resolve(provider);
    }
}
