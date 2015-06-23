/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import org.apache.http.HttpRequest;
import org.apache.http.HttpResponse;

/**
 * Provides tracing utilities that insight into all aspects of client operations
 * via implementations of the ICloudTracingInterceptor interface. All tracing is
 * global.
 */
public abstract class ServiceClientTracing {
    private ServiceClientTracing() {
    }

    /**
     * The collection of tracing interceptors to notify.
     */
    private static List<ServiceClientTracingInterceptor> interceptors;

    /**
     * Gets the collection of tracing interceptors to notify.
     * 
     * @return the collection of tracing interceptors
     */
    public static List<ServiceClientTracingInterceptor> getInterceptors() {
        return interceptors;
    }

    /**
     * Gets a value indicating whether tracing is enabled. Tracing can be
     * disabled for performance.
     */
    private static boolean isEnabled;

    /**
     * Gets the value indicating whether tracing is enabled.
     * 
     * @return <code>boolean</code> value indicating if tracing is enabled
     */
    public static boolean getIsEnabled() {
        return isEnabled;
    }

    /**
     * Sets the value indicating whether tracing is enabled.
     * 
     * @param enabled <code>boolean</code> value indicating if tracing is enabled
     */
    public static void setIsEnabled(final boolean enabled) {
        isEnabled = enabled;
    }

    static {
        isEnabled = true;
        interceptors = Collections
                .synchronizedList(new ArrayList<ServiceClientTracingInterceptor>());
    }

    /**
     * Add a tracing interceptor to be notified of changes.
     * 
     * @param serviceClientTracingInterceptor the tracing interceptor
     */
    public static void addTracingInterceptor(
            final ServiceClientTracingInterceptor serviceClientTracingInterceptor) {
        if (serviceClientTracingInterceptor == null) {
            throw new NullPointerException();
        }

        interceptors.add(serviceClientTracingInterceptor);
    }

    /**
     * Remove a tracing interceptor from change notifications.
     * 
     * @param serviceClientTracingInterceptor the tracing interceptor
     * @return                                <code>true</code> if the tracing
     *                                        interceptor was found and removed;
     *                                        <code>false</code> otherwise
     */
    public static boolean removeTracingInterceptor(
            ServiceClientTracingInterceptor serviceClientTracingInterceptor) {
        if (serviceClientTracingInterceptor == null) {
            throw new NullPointerException();
        }

        return interceptors.remove(serviceClientTracingInterceptor);
    }

    /**
     * The invocation identifier.
     */
    private static long nextInvocationId = 0;

    /**
     * Get the next invocation identifier.
     * @return the next invocation identifier
     */
    public static long getNextInvocationId() {
        return ++nextInvocationId;
    }

    /**
     * Write the informational tracing message.
     *
     * @param message    the msessage to trace
     * @param parameters an object array containing zero or more objects to format
     */
    public static void information(String message, Object... parameters) {
        if (isEnabled) {
            information(String.format(message, parameters));
        }
    }

    /**
     * Represents the tracing configuration for the value of a setting.
     *
     * @param source the configuration source
     * @param name   the name of the setting
     * @param value  the name of the setting
     */
    public static void configuration(String source, String name, String value) {
        if (isEnabled) {
            synchronized (interceptors) {
                for (ServiceClientTracingInterceptor writer : interceptors) {
                    writer.configuration(source, name, value);
                }
            }
        }
    }

    /**
     * Write the informational tracing message.
     *
     * @param message the message to trace
     */
    public static void information(String message) {
        if (isEnabled) {
            synchronized (interceptors) {
                for (ServiceClientTracingInterceptor writer : interceptors) {
                    writer.information(message);
                }
            }
        }
    }

    /**
     * Represents the tracing entry.
     *
     * @param invocationId the invocation identifier
     * @param instance     the tracing instance
     * @param method       the tracing method
     * @param parameters   method parameters
     */
    public static void enter(String invocationId, Object instance,
            String method, HashMap<String, Object> parameters) {
        if (isEnabled) {
            synchronized (interceptors) {
                for (ServiceClientTracingInterceptor writer : interceptors) {
                    writer.enter(invocationId, instance, method, parameters);
                }
            }
        }
    }

    /**
     * Sends a tracing request.
     *
     * @param invocationId the invocation identifier
     * @param request      the request about to be sent
     */
    public static void sendRequest(String invocationId, HttpRequest request) {
        if (isEnabled) {
            synchronized (interceptors) {
                for (ServiceClientTracingInterceptor writer : interceptors) {
                    writer.sendRequest(invocationId, request);
                }
            }
        }
    }

    /**
     * Receives a tracing response.
     *
     * @param invocationId the invocation identifier
     * @param response     the response message instance
     */
    public static void receiveResponse(String invocationId,
            HttpResponse response) {
        if (isEnabled) {
            synchronized (interceptors) {
                for (ServiceClientTracingInterceptor writer : interceptors) {
                    writer.receiveResponse(invocationId, response);
                }
            }
        }
    }

    /**
     * Represents the tracing error.
     *
     * @param invocationId the invocation identifier
     * @param ex           the tracing exception
     */
    public static void error(String invocationId, Exception ex) {
        if (isEnabled) {
            synchronized (interceptors) {
                for (ServiceClientTracingInterceptor writer : interceptors) {
                    writer.error(invocationId, ex);
                }
            }
        }
    }

    /**
     * Abandons the tracing method.
     *
     * @param invocationId the invocation identifier
     * @param result       method return result
     */
    public static void exit(String invocationId, Object result) {
        if (isEnabled) {
            synchronized (interceptors) {
                for (ServiceClientTracingInterceptor writer : interceptors) {
                    writer.exit(invocationId, result);
                }
            }
        }
    }
}
