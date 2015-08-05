/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.bat;

import com.microsoft.rest.ServiceClient;
import org.glassfish.jersey.client.ClientConfig;

import java.net.URI;

/**
 *
 */
public class AutoRestIntegerTestServiceImpl extends ServiceClient<AutoRestIntegerTestService> implements AutoRestIntegerTestService {
    private URI baseUri;

    public URI getBaseUri() {
        return this.baseUri;
    }

    private IntOperations intOperations;

    public IntOperations getIntOperations() {
        return this.intOperations;
    }

    public AutoRestIntegerTestServiceImpl() {
        super();
        initialize();
    }

    public AutoRestIntegerTestServiceImpl(ClientConfig clientConfig) {
        super(clientConfig);
        initialize();
    }

    private void initialize() {
        this.intOperations = new IntOperationsImpl(this);
    }
}
