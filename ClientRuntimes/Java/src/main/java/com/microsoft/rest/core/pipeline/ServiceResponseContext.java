/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.core.pipeline;

import java.io.InputStream;

public interface ServiceResponseContext {
    int getStatus();

    void setStatus(int status);

    String getHeader(String name);

    void setHeader(String name, String value);

    void removeHeader(String name);

    boolean hasEntity();

    InputStream getEntityInputStream();

    void setEntityInputStream(InputStream entity);

    Object getProperty(String name);

    void setProperty(String name, Object value);
}