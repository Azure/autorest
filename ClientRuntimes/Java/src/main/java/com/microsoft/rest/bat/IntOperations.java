/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.bat;

import com.microsoft.rest.HttpOperationResponse;
import com.microsoft.rest.ServiceException;

import java.util.concurrent.Future;

public interface IntOperations {
    HttpOperationResponse<Integer> getNullWithHttpMessages() throws ServiceException;

    Future<HttpOperationResponse<Integer>> getNullWithHttpMessagesAsync();

    Integer getInvalidWithHttpMessages();

    Future<HttpOperationResponse<Integer>> getInvalidWithHttpMessagesAsync();

    Integer getOverflowInt32WithHttpMessages();

    Future<HttpOperationResponse<Integer>> getOverflowInt32WithHttpMessagesAsync();

    Integer getUnderflowInt64WithHttpMessages();

    Future<HttpOperationResponse<Long>> getUnderflowInt64WithHttpMessagesAsync();

    void putMax32WithHttpMessages();

    Future<HttpOperationResponse> putMax32WithHttpMessagesAsync(int intBody);

    void putMax64WithHttpMessages();

    Future<HttpOperationResponse> putMax64WithHttpMessagesAsync(long intBody);

    void putMin32WithHttpMessages();

    Future<HttpOperationResponse> putMin32WithHttpMessagesAsync(int intBody);

    void putMin64WithHttpMessages();

    Future<HttpOperationResponse> putMin64WithHttpMessagesAsync(long intBody);
}
