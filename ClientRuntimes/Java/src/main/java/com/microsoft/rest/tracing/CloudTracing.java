/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.tracing;

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
public abstract class CloudTracing {
    private CloudTracing() {
    }

    /**
     * The collection of tracing interceptors to notify.
     */
    private static List<CloudTracingInterceptor> interceptors;

    /**
     * Gets the collection of tracing interceptors to notify.
     * 
     * @return the collection of tracing interceptors.
     */
    public static List<CloudTracingInterceptor> getInterceptors() {
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
                .synchronizedList(new ArrayList<CloudTracingInterceptor>());
    }

    /**
     * Add a tracing interceptor to be notified of changes.
     * 
     * @param cloudTracingInterceptor
     *            The tracing interceptor.
     */
    public static void addTracingInterceptor(
            final CloudTracingInterceptor cloudTracingInterceptor) {
        if (cloudTracingInterceptor == null) {
            throw new NullPointerException();
        }

        interceptors.add(cloudTracingInterceptor);
    }

    /**
     * Remove a tracing interceptor from change notifications.
     * 
     * @param cloudTracingInterceptor
     *            The tracing interceptor.
     * @return True if the tracing interceptor was found and removed; false
     *         otherwise.
     */
    public static boolean removeTracingInterceptor(
            CloudTracingInterceptor cloudTracingInterceptor) {
        if (cloudTracingInterceptor == null) {
            throw new NullPointerException();
        }

        return interceptors.remove(cloudTracingInterceptor);
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
                for (CloudTracingInterceptor writer : interceptors) {
                    writer.configuration(source, name, value);
                }
            }
        }
    }

    public static void information(String message) {
        if (isEnabled) {
            synchronized (interceptors) {
                for (CloudTracingInterceptor writer : interceptors) {
                    writer.information(message);
                }
            }
        }
    }

    public static void enter(String invocationId, Object instance,
            String method, HashMap<String, Object> parameters) {
        if (isEnabled) {
            synchronized (interceptors) {
                for (CloudTracingInterceptor writer : interceptors) {
                    writer.enter(invocationId, instance, method, parameters);
                }
            }
        }
    }

    public static void sendRequest(String invocationId, HttpRequest request) {
        if (isEnabled) {
            synchronized (interceptors) {
                for (CloudTracingInterceptor writer : interceptors) {
                    writer.sendRequest(invocationId, request);
                }
            }
        }
    }

    public static void receiveResponse(String invocationId,
            HttpResponse response) {
        if (isEnabled) {
            synchronized (interceptors) {
                for (CloudTracingInterceptor writer : interceptors) {
                    writer.receiveResponse(invocationId, response);
                }
            }
        }
    }

    public static void error(String invocationId, Exception ex) {
        if (isEnabled) {
            synchronized (interceptors) {
                for (CloudTracingInterceptor writer : interceptors) {
                    writer.error(invocationId, ex);
                }
            }
        }
    }

    public static void exit(String invocationId, Object result) {
        if (isEnabled) {
            synchronized (interceptors) {
                for (CloudTracingInterceptor writer : interceptors) {
                    writer.exit(invocationId, result);
                }
            }
        }
    }
}
