/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.core.pipeline;

import java.net.URI;
import java.util.Map;

public interface ServiceRequestContext {
    String getMethod();

    void setMethod(String method);

    URI getURI();

    void setURI(URI uri);

    String getHeader(String name);

    void setHeader(String name, String value);

    void removeHeader(String name);

    Object getEntity();

    void setEntity(Object entity);

    Object getProperty(String name);

    void setProperty(String name, Object value);

    Map<String, String> getAllHeaders();
}
