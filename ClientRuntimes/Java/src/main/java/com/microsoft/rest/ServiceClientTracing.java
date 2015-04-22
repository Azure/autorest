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
     * @return the collection of tracing interceptors.
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
     * @return Boolean value indicating if tracing is enabled.
     */
    public static boolean getIsEnabled() {
        return isEnabled;
    }

    /**
     * Sets the value indicating whether tracing is enabled.
     * 
     * @param enabled
     *            Boolean value indicating if tracing is enabled.
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
     * @param serviceClientTracingInterceptor
     *            The tracing interceptor.
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
     * @param serviceClientTracingInterceptor
     *            The tracing interceptor.
     * @return True if the tracing interceptor was found and removed; false
     *         otherwise.
     */
    public static boolean removeTracingInterceptor(
            ServiceClientTracingInterceptor serviceClientTracingInterceptor) {
        if (serviceClientTracingInterceptor == null) {
            throw new NullPointerException();
        }

        return interceptors.remove(serviceClientTracingInterceptor);
    }

    private static long nextInvocationId = 0;

    public static long getNextInvocationId() {
        return ++nextInvocationId;
    }

    public static void information(String message, Object... parameters) {
        if (isEnabled) {
            information(String.format(message, parameters));
        }
    }

    public static void configuration(String source, String name, String value) {
        if (isEnabled) {
            synchronized (interceptors) {
                for (ServiceClientTracingInterceptor writer : interceptors) {
                    writer.configuration(source, name, value);
                }
            }
        }
    }

    public static void information(String message) {
        if (isEnabled) {
            synchronized (interceptors) {
                for (ServiceClientTracingInterceptor writer : interceptors) {
                    writer.information(message);
                }
            }
        }
    }

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

    public static void sendRequest(String invocationId, HttpRequest request) {
        if (isEnabled) {
            synchronized (interceptors) {
                for (ServiceClientTracingInterceptor writer : interceptors) {
                    writer.sendRequest(invocationId, request);
                }
            }
        }
    }

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

    public static void error(String invocationId, Exception ex) {
        if (isEnabled) {
            synchronized (interceptors) {
                for (ServiceClientTracingInterceptor writer : interceptors) {
                    writer.error(invocationId, ex);
                }
            }
        }
    }

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
