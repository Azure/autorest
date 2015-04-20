/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.pipeline;

import org.apache.http.HttpRequest;

public interface ServiceRequestFilter {
    void filter(HttpRequest request);
}
