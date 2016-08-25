/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import com.microsoft.rest.ServiceCall;
import com.microsoft.rest.ServiceResponse;

import rx.Observable;
import rx.Subscriber;
import rx.functions.Func1;

/**
 * An instance of this class provides access to the underlying REST call invocation.
 * This class wraps around the Retrofit Call object and allows updates to it in the
 * progress of a long running operation or a paging operation.
 *
 * @param <T> the type of the returning object
 */
public final class AzureServiceCall<T> extends ServiceCall<T> {
    private AzureServiceCall() {
    }

    /**
     * Creates a ServiceCall from a paging operation.
     *
     * @param first the observable to the first page
     * @param next the observable to poll subsequent pages
     * @param callback the client-side callback
     * @param <T> the Page type
     * @param <V> the element type
     * @return the future based ServiceCall
     */
    public static <T extends Page<V>, V> ServiceCall<T> create(Observable<ServiceResponse<T>> first, final Func1<String, Observable<ServiceResponse<T>>> next, final ListOperationCallback<V> callback) {
        final AzureServiceCall<T> serviceCall = new AzureServiceCall<>();
        final PagingSubscriber<T, V> subscriber = new PagingSubscriber<>(serviceCall, next, callback);
        serviceCall.setSubscription(first
            .single()
            .subscribe(subscriber));
        return serviceCall;
    }

    /**
     * The subscriber that handles user callback and automatically subscribes to the next page.
     *
     * @param <T> the Page type
     * @param <V> the element type
     */
    private static class PagingSubscriber<T extends Page<V>, V> extends Subscriber<ServiceResponse<T>> {
        private AzureServiceCall<T> serviceCall;
        private Func1<String, Observable<ServiceResponse<T>>> next;
        private ListOperationCallback<V> callback;
        private ServiceResponse<T> lastResponse;

        PagingSubscriber(final AzureServiceCall<T> serviceCall, final Func1<String, Observable<ServiceResponse<T>>> next, final ListOperationCallback<V> callback) {
            this.serviceCall = serviceCall;
            this.next = next;
            this.callback = callback;
        }

        @Override
        public void onCompleted() {
            // do nothing
        }

        @Override
        public void onError(Throwable e) {
            serviceCall.setException(e);
            if (callback != null) {
                callback.failure(e);
            }
        }

        @Override
        public void onNext(ServiceResponse<T> serviceResponse) {
            lastResponse = serviceResponse;
            ListOperationCallback.PagingBehavior behavior = ListOperationCallback.PagingBehavior.CONTINUE;
            if (callback != null) {
                behavior = callback.progress(serviceResponse.getBody().getItems());
                if (behavior == ListOperationCallback.PagingBehavior.STOP || serviceResponse.getBody().getNextPageLink() == null) {
                    callback.success();
                }
            }
            if (behavior == ListOperationCallback.PagingBehavior.STOP || serviceResponse.getBody().getNextPageLink() == null) {
                serviceCall.set(lastResponse);
            } else {
                serviceCall.setSubscription(next.call(serviceResponse.getBody().getNextPageLink()).single().subscribe(this));
            }
        }
    }
}
