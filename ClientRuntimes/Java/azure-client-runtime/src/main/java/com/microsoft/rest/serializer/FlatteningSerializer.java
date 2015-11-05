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
import java.util.Iterator;
import java.util.Map;

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
                    return new FlatteningSerializer<BaseResource>(BaseResource.class, serializer);
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

        ObjectMapper mapper = new JacksonHelper().getObjectMapper();
        ObjectNode root = mapper.valueToTree(value);
        ObjectNode res = root.deepCopy();
        Iterator<Map.Entry<String, JsonNode>> fields = root.fields();
        while (fields.hasNext()) {
            Map.Entry<String, JsonNode> field = fields.next();
            if (field.getKey().contains(".")) {
                ObjectNode node = res;
                String[] values = field.getKey().split("\\.");
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
                node.set(values[values.length - 1], field.getValue());
                res.remove(field.getKey());
            }
        }
        jgen.writeTree(res);
    }

    @Override
    public void resolve(SerializerProvider provider) throws JsonMappingException {
        ((ResolvableSerializer) defaultSerializer).resolve(provider);
    }
}
