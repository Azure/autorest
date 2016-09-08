/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import com.microsoft.rest.ServiceCallback;

import java.util.List;

/**
 * The callback used for client side asynchronous list operations.
 *
 * @param <E> the item type
 */
public abstract class ListOperationCallback<E> extends ServiceCallback<List<E>> {
    /**
     * A list result that stores the accumulated resources loaded from server.
     */
    private List<E> result;

    /**
     * Number of loaded pages.
     */
    private int pageCount;

    /**
     * Creates an instance of ListOperationCallback.
     */
    public ListOperationCallback() {
        this.pageCount = 0;
    }

    /**
     * Override this method to handle progressive results.
     * The user is responsible for returning a {@link PagingBehavior} Enum to indicate
     * whether the client should continue loading or stop.
     *
     * @param partial the list of resources from the current request.
     * @return CONTINUE if you want to go on loading, STOP otherwise.
     *
     */
    public abstract PagingBehavior progress(List<E> partial);

    /**
     * Get the list result that stores the accumulated resources loaded from server.
     *
     * @return the list of resources.
     */
    public List<E> get() {
        return result;
    }

    /**
     * This method is called by the client to load the most recent list of resources.
     * This method should only be called by the service client.
     *
     * @param result the most recent list of resources.
     */
    public void load(List<E> result) {
        ++pageCount;
        if (this.result == null || this.result.isEmpty()) {
            this.result = result;
        } else {
            this.result.addAll(result);
        }
    }

    @Override
    public void success(List<E> result) {
        success();
    }

    /**
     * Override this method to handle successful REST call results.
     */
    public abstract void success();

    /**
     * Get the number of loaded pages.
     *
     * @return the number of pages.
     */
    public int pageCount() {
        return pageCount;
    }

    /**
     * An enum to indicate whether the client should continue loading or stop.
     */
    public enum PagingBehavior {
        /**
         * Indicates that the client should continue loading.
         */
        CONTINUE,
        /**
         * Indicates that the client should stop loading.
         */
        STOP
    }
}
