/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import com.microsoft.rest.ServiceCall;
import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.ServiceResponseWithHeaders;

import java.util.List;

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
     * @param <E> the element type
     * @return the future based ServiceCall
     */
    public static <E> ServiceCall<List<E>> create(Observable<ServiceResponse<Page<E>>> first, final Func1<String, Observable<ServiceResponse<Page<E>>>> next, final ListOperationCallback<E> callback) {
        final AzureServiceCall<List<E>> serviceCall = new AzureServiceCall<>();
        final PagingSubscriber<E> subscriber = new PagingSubscriber<>(serviceCall, next, callback);
        serviceCall.setSubscription(first
            .single()
            .subscribe(subscriber));
        return serviceCall;
    }

    /**
     * Creates a ServiceCall from a paging operation that returns a header response.
     *
     * @param first the observable to the first page
     * @param next the observable to poll subsequent pages
     * @param callback the client-side callback
     * @param <E> the element type
     * @param <V> the header object type
     * @return the future based ServiceCall
     */
    public static <E, V> ServiceCall<List<E>> createWithHeaders(Observable<ServiceResponseWithHeaders<Page<E>, V>> first, final Func1<String, Observable<ServiceResponseWithHeaders<Page<E>, V>>> next, final ListOperationCallback<E> callback) {
        final AzureServiceCall<List<E>> serviceCall = new AzureServiceCall<>();
        final PagingSubscriber<E> subscriber = new PagingSubscriber<>(serviceCall, new Func1<String, Observable<ServiceResponse<Page<E>>>>() {
            @Override
            public Observable<ServiceResponse<Page<E>>> call(String s) {
                return next.call(s)
                        .map(new Func1<ServiceResponseWithHeaders<Page<E>, V>, ServiceResponse<Page<E>>>() {
                            @Override
                            public ServiceResponse<Page<E>> call(ServiceResponseWithHeaders<Page<E>, V> pageVServiceResponseWithHeaders) {
                                return pageVServiceResponseWithHeaders;
                            }
                        });
            }
        }, callback);
        serviceCall.setSubscription(first
                .single()
                .subscribe(subscriber));
        return serviceCall;
    }

    /**
     * The subscriber that handles user callback and automatically subscribes to the next page.
     *
     * @param <E> the element type
     */
    private static class PagingSubscriber<E> extends Subscriber<ServiceResponse<Page<E>>> {
        private AzureServiceCall<List<E>> serviceCall;
        private Func1<String, Observable<ServiceResponse<Page<E>>>> next;
        private ListOperationCallback<E> callback;
        private ServiceResponse<Page<E>> lastResponse;

        PagingSubscriber(final AzureServiceCall<List<E>> serviceCall, final Func1<String, Observable<ServiceResponse<Page<E>>>> next, final ListOperationCallback<E> callback) {
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
        public void onNext(ServiceResponse<Page<E>> serviceResponse) {
            lastResponse = serviceResponse;
            ListOperationCallback.PagingBehavior behavior = ListOperationCallback.PagingBehavior.CONTINUE;
            if (callback != null) {
                behavior = callback.progress(serviceResponse.getBody().getItems());
                if (behavior == ListOperationCallback.PagingBehavior.STOP || serviceResponse.getBody().getNextPageLink() == null) {
                    callback.success();
                }
            }
            if (behavior == ListOperationCallback.PagingBehavior.STOP || serviceResponse.getBody().getNextPageLink() == null) {
                serviceCall.set(lastResponse.getBody().getItems());
            } else {
                serviceCall.setSubscription(next.call(serviceResponse.getBody().getNextPageLink()).single().subscribe(this));
            }
        }
    }
}
