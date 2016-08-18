/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.google.common.util.concurrent.AbstractFuture;

import rx.Observable;
import rx.Subscription;
import rx.functions.Action1;

/**
 * An instance of this class provides access to the underlying REST call invocation.
 * This class wraps around the Retrofit Call object and allows updates to it in the
 * progress of a long running operation or a paging operation.
 *
 * @param <T> the type of the returning object
 */
public class ServiceCall<T> extends AbstractFuture<ServiceResponse<T>> {
    /**
     * The Retrofit method invocation.
     */
    private Subscription subscription;

    private ServiceCall() {
    }

    public static <T> ServiceCall<T> create(final Observable<ServiceResponse<T>> observable) {
        final ServiceCall<T> serviceCall = new ServiceCall<>();
        serviceCall.subscription = observable
            .last()
            .subscribe(new Action1<ServiceResponse<T>>() {
                @Override
                public void call(ServiceResponse<T> t) {
                    serviceCall.set(t);
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    serviceCall.setException(throwable);
                }
            });
        return serviceCall;
    }

    public static <T> ServiceCall<T> create(final Observable<ServiceResponse<T>> observable, final ServiceCallback<T> callback) {
        final ServiceCall<T> serviceCall = new ServiceCall<>();
        serviceCall.subscription = observable
            .last()
            .subscribe(new Action1<ServiceResponse<T>>() {
                @Override
                public void call(ServiceResponse<T> t) {
                    if (callback != null) {
                        callback.success(t);
                    }
                    serviceCall.set(t);
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    if (callback != null) {
                        callback.failure(throwable);
                    }
                    serviceCall.setException(throwable);
                }
            });
        return serviceCall;
    }

    public static <T, V> ServiceCall<T> createWithHeaders(final Observable<ServiceResponseWithHeaders<T, V>> observable, final ServiceCallback<T> callback) {
        final ServiceCall<T> serviceCall = new ServiceCall<>();
        serviceCall.subscription = observable
            .last()
            .subscribe(new Action1<ServiceResponse<T>>() {
                @Override
                public void call(ServiceResponse<T> t) {
                    if (callback != null) {
                        callback.success(t);
                    }
                    serviceCall.set(t);
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    if (callback != null) {
                        callback.failure(throwable);
                    }
                    serviceCall.setException(throwable);
                }
            });
        return serviceCall;
    }

    /**
     * Cancel the Retrofit call if possible. Parameter
     * 'mayInterruptIfRunning is ignored.
     *
     * @param mayInterruptIfRunning ignored
     */
    @Override
    public boolean cancel(boolean mayInterruptIfRunning) {
        subscription.unsubscribe();
        return super.cancel(mayInterruptIfRunning);
    }

    @Override
    public boolean isCancelled() {
        return subscription.isUnsubscribed();
    }
}
