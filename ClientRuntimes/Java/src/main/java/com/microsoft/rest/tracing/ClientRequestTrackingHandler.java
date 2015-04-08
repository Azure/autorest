/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.tracing;

import com.microsoft.rest.core.pipeline.ServiceRequestContext;
import com.microsoft.rest.core.pipeline.ServiceRequestFilter;
import com.microsoft.rest.core.pipeline.ServiceResponseContext;
import com.microsoft.rest.core.pipeline.ServiceResponseFilter;

public class ClientRequestTrackingHandler implements ServiceRequestFilter,
        ServiceResponseFilter {
    private final String trackingId;

    public String getTrackingId() {
        return trackingId;
    }

    public ClientRequestTrackingHandler(String trackingId) {
        this.trackingId = trackingId;
    }

    @Override
    public void filter(ServiceRequestContext request) {
        request.setHeader("client-tracking-id", trackingId);
    }

    @Override
    public void filter(ServiceRequestContext request,
            ServiceResponseContext response) {
        response.setHeader("client-tracking-id", trackingId);
    }
}
