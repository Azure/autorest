/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.bat;

import com.microsoft.rest.HttpOperationResponse;
import com.microsoft.rest.ServiceClientTracing;
import com.microsoft.rest.ServiceException;
import com.microsoft.rest.bat.models.ErrorModel;
import org.apache.http.HttpStatus;
import org.glassfish.jersey.message.internal.TracingLogger;

import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.Response;
import java.util.HashMap;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Future;

public class IntOperationsImpl implements IntOperations {
    public AutoRestIntegerTestServiceImpl client;

    public IntOperationsImpl(AutoRestIntegerTestServiceImpl client) {
        this.client = client;
    }

    @Override
    public Future<HttpOperationResponse<Integer>> getNullWithHttpMessagesAsync() {
        return null;
    }

    // TODO: Add ServiceClientTracing calls
    @Override
    public HttpOperationResponse<Integer> getNullWithHttpMessages() throws ServiceException {
        // Tracing
        boolean shouldTrace = ServiceClientTracing.getIsEnabled();
        String invocationId = null;

        if (shouldTrace) {
            invocationId = Long.toString(ServiceClientTracing.getNextInvocationId());
            HashMap<String, Object> tracingParameters = new HashMap<String, Object>();
            ServiceClientTracing.enter(invocationId, this, "listAsync", tracingParameters);
        }

        // Construct URL
        String url = this.client.getBaseUri().getPath().concat("/int/null");
        url = url.replaceAll("([^:]/)/+", "$1");

        // Create HTTP transport objects
        WebTarget target = this.client.getClient().target(url);
        // Set headers

        // Send request
        Response response = null;
        response = target.request().get();
        int statusCode = response.getStatus();
        if (statusCode != HttpStatus.SC_OK) {
            ServiceException ex = new ServiceException();
            ErrorModel errorModel = response.readEntity(ErrorModel.class);
            if (errorModel != null) {
                ex.setErrorModel(errorModel);
            }
            //TODO: Save request and response into exception
            throw ex;
        }
        // Create Result
        HttpOperationResponse<Integer> result = new HttpOperationResponse<Integer>();
        //TODO: Save request and response into result
        if (statusCode == HttpStatus.SC_OK) {
            result.setBody(response.readEntity(Integer.class));
        }
        return result;
    }

    @Override
    public Integer getInvalidWithHttpMessages() {
        return null;
    }

    @Override
    public Future<HttpOperationResponse<Integer>> getInvalidWithHttpMessagesAsync() {
        return null;
    }

    @Override
    public Integer getOverflowInt32WithHttpMessages() {
        return null;
    }

    @Override
    public Future<HttpOperationResponse<Integer>> getOverflowInt32WithHttpMessagesAsync() {
        return null;
    }

    @Override
    public Integer getUnderflowInt64WithHttpMessages() {
        return null;
    }

    @Override
    public Future<HttpOperationResponse<Long>> getUnderflowInt64WithHttpMessagesAsync() {
        return null;
    }

    @Override
    public void putMax32WithHttpMessages() {

    }

    @Override
    public Future<HttpOperationResponse> putMax32WithHttpMessagesAsync(int intBody) {
        return null;
    }

    @Override
    public void putMax64WithHttpMessages() {

    }

    @Override
    public Future<HttpOperationResponse> putMax64WithHttpMessagesAsync(long intBody) {
        return null;
    }

    @Override
    public void putMin32WithHttpMessages() {

    }

    @Override
    public Future<HttpOperationResponse> putMin32WithHttpMessagesAsync(int intBody) {
        return null;
    }

    @Override
    public void putMin64WithHttpMessages() {

    }

    @Override
    public Future<HttpOperationResponse> putMin64WithHttpMessagesAsync(long intBody) {
        return null;
    }
}
