/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import java.util.HashMap;
import org.apache.http.HttpRequest;
import org.apache.http.HttpResponse;

/**
 * ServiceClientTracingInterceptor provides useful information about cloud
 * operations.
 * <p>
 * Interception is global and a tracing interceptor can be added via
 * CloudContext.Configuration.Tracing.AddTracingInterceptor.
 * </p>
 */
public interface ServiceClientTracingInterceptor {
    /**
     * Trace information.
     * 
     * @param message the information to trace
     */
    void information(String message);

    /**
     * Probe configuration for the value of a setting.
     * 
     * @param source the configuration source
     * @param name   the name of the setting
     * @param value  the value of the setting in the source
     */
    void configuration(String source, String name, String value);

    /**
     * Enter a method.
     * 
     * @param invocationId method invocation identifier
     * @param instance     the instance with the method
     * @param method       name of the method
     * @param parameters   method parameters
     */
    void enter(String invocationId, Object instance, String method,
            HashMap<String, Object> parameters);

    /**
     * Send an HTTP request.
     * 
     * @param invocationId method invocation identifier
     * @param request      the request about to be sent
     */
    void sendRequest(String invocationId, HttpRequest request);

    /**
     * Receive an HTTP response.
     * 
     * @param invocationId method invocation identifier
     * @param response     the response instance
     */
    void receiveResponse(String invocationId, HttpResponse response);

    /**
     * Raise an error.
     * 
     * @param invocationId method invocation identifier
     * @param exception    the error
     */
    void error(String invocationId, Exception exception);

    /**
     * Exit a method. Note: Exit will not be called in the event of an error.
     * 
     * @param invocationId method invocation identifier
     * @param returnValue method return value
     */
    void exit(String invocationId, Object returnValue);
}