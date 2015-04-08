/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.core;

import com.microsoft.rest.core.pipeline.ServiceRequestFilter;
import com.microsoft.rest.core.pipeline.ServiceResponseFilter;

public interface FilterableService<T> {
    FilterableService<T> withRequestFilterFirst(ServiceRequestFilter serviceRequestFilter);

    FilterableService<T> withRequestFilterLast(ServiceRequestFilter serviceRequestFilter);

    FilterableService<T> withResponseFilterFirst(ServiceResponseFilter serviceResponseFilter);

    FilterableService<T> withResponseFilterLast(ServiceResponseFilter serviceResponseFilter);
}
