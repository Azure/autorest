/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.serializer;

import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * A serialization helper class overriding {@link JacksonMapperAdapter} with extra
 * functionality useful for Azure operations.
 */
public final class AzureJacksonMapperAdapter extends JacksonMapperAdapter {
    /**
     * An instance of {@link ObjectMapper} to serialize/deserialize objects.
     */
    private static ObjectMapper azureObjectMapper;

    @Override
    public ObjectMapper getObjectMapper() {
        if (azureObjectMapper == null) {
            azureObjectMapper = new ObjectMapper();
            initializeObjectMapper(azureObjectMapper);
            azureObjectMapper
                    .registerModule(FlatteningDeserializer.getModule())
                    .registerModule(FlatteningSerializer.getModule());
        }
        return azureObjectMapper;
    }
}
