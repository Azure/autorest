/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.tracing;

import java.util.HashMap;
import org.apache.http.HttpRequest;
import org.apache.http.HttpResponse;

/**
 * The CloudTracingInterceptor provides useful information about cloud
 * operations. Interception is global and a tracing interceptor can be added via
 * CloudContext.Configuration.Tracing.AddTracingInterceptor.
 */
public interface CloudTracingInterceptor {
    /**
     * Trace information.
     * 
     * @param message
     *            The information to trace.
     */
    void information(String message);

    /**
     * Probe configuration for the value of a setting.
     * 
     * @param source
     *            The configuration source.
     * @param name
     *            The name of the setting.
     * @param value
     *            The value of the setting in the source.
     */
    void configuration(String source, String name, String value);

    /**
     * Enter a method.
     * 
     * @param invocationId
     *            Method invocation identifier.
     * @param instance
     *            The instance with the method.
     * @param method
     *            Name of the method.
     * @param parameters
     *            Method parameters.
     */
    void enter(String invocationId, Object instance, String method,
            HashMap<String, Object> parameters);

    /**
     * Send an HTTP request.
     * 
     * @param invocationId
     *            Method invocation identifier.
     * @param request
     *            The request about to be sent.
     */
    void sendRequest(String invocationId, HttpRequest request);

    /**
     * Receive an HTTP response.
     * 
     * @param invocationId
     *            Method invocation identifier.
     * @param response
     *            The response instance.
     */
    void receiveResponse(String invocationId, HttpResponse response);

    /**
     * Raise an error.
     * 
     * @param invocationId
     *            Method invocation identifier.
     * @param exception
     *            The error.
     */
    void error(String invocationId, Exception exception);

    /**
     * Exit a method. Note: Exit will not be called in the event of an error.
     * 
     * @param invocationId
     *            Method invocation identifier.
     * @param returnValue
     *            Method return value.
     */
    void exit(String invocationId, Object returnValue);
}