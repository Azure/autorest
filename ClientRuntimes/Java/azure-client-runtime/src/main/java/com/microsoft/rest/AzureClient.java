/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.microsoft.rest.credentials.ServiceClientCredentials;

public interface AzureClient {
    ServiceClientCredentials getCredentials();

    int getLongRunningOperationRetryTimeout();
}
