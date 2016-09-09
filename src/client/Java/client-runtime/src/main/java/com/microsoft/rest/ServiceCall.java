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
public class ServiceCall<T> extends AbstractFuture<T> {
    /**
     * The Retrofit method invocation.
     */
    private Subscription subscription;

    protected ServiceCall() {
    }

    /**
     * Creates a ServiceCall from an observable object.
     *
     * @param observable the observable to create from
     * @param <T> the type of the response
     * @return the created ServiceCall
     */
    public static <T> ServiceCall<T> create(final Observable<ServiceResponse<T>> observable) {
        final ServiceCall<T> serviceCall = new ServiceCall<>();
        serviceCall.subscription = observable
            .last()
            .subscribe(new Action1<ServiceResponse<T>>() {
                @Override
                public void call(ServiceResponse<T> t) {
                    serviceCall.set(t.getBody());
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    serviceCall.setException(throwable);
                }
            });
        return serviceCall;
    }

    /**
     * Creates a ServiceCall from an observable object and a callback.
     *
     * @param observable the observable to create from
     * @param callback the callback to call when events happen
     * @param <T> the type of the response
     * @return the created ServiceCall
     */
    public static <T> ServiceCall<T> create(final Observable<ServiceResponse<T>> observable, final ServiceCallback<T> callback) {
        final ServiceCall<T> serviceCall = new ServiceCall<>();
        serviceCall.subscription = observable
            .last()
            .subscribe(new Action1<ServiceResponse<T>>() {
                @Override
                public void call(ServiceResponse<T> t) {
                    if (callback != null) {
                        callback.success(t.getBody());
                    }
                    serviceCall.set(t.getBody());
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
     * Creates a ServiceCall from an observable and a callback for a header response.
     *
     * @param observable the observable of a REST call that returns JSON in a header
     * @param callback the callback to call when events happen
     * @param <T> the type of the response body
     * @param <V> the type of the response header
     * @return the created ServiceCall
     */
    public static <T, V> ServiceCall<T> createWithHeaders(final Observable<ServiceResponseWithHeaders<T, V>> observable, final ServiceCallback<T> callback) {
        final ServiceCall<T> serviceCall = new ServiceCall<>();
        serviceCall.subscription = observable
            .last()
            .subscribe(new Action1<ServiceResponse<T>>() {
                @Override
                public void call(ServiceResponse<T> t) {
                    if (callback != null) {
                        callback.success(t.getBody());
                    }
                    serviceCall.set(t.getBody());
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
     * @return the current Rx subscription associated with the ServiceCall.
     */
    public Subscription getSubscription() {
        return subscription;
    }

    protected void setSubscription(Subscription subscription) {
        this.subscription = subscription;
    }

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
