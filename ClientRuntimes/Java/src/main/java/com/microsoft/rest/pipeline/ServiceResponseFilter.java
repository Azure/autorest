/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.pipeline;

import org.apache.http.HttpRequest;
import org.apache.http.HttpResponse;

public interface ServiceResponseFilter {
    void filter(HttpResponse response);
}
