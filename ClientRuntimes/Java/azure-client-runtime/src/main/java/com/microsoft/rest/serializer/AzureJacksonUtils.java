/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.serializer;

import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * A serialization helper class overriding {@link JacksonUtils} with extra
 * functionality useful for Azure operations.
 */
public final class AzureJacksonUtils extends JacksonUtils {
    @Override
    public ObjectMapper getObjectMapper() {
        return super.getObjectMapper()
                .registerModule(FlatteningDeserializer.getModule());
    }
}
