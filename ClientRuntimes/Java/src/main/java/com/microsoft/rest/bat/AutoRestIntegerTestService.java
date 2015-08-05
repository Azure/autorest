/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.bat;

import com.microsoft.rest.ServiceClient;

import java.net.URI;

/**
 *
 */
public interface AutoRestIntegerTestService {
    URI getBaseUri();

    IntOperations getIntOperations();
}
