/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.ServiceResponseCallback;
import com.squareup.okhttp.ResponseBody;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import javax.xml.ws.Service;

import retrofit.Call;
import retrofit.Response;
import retrofit.Retrofit;

/**
 * Inner callback used to merge both successful and failed responses into one
 * callback for customized response handling in a response handling delegate.
 *
 * @param <E> the item type
 */
public abstract class ListOperationCallback<E> extends ServiceCallback<List<E>> {
    /**
     * The client callback.
     */
    private List<E> result;

    private int pageCount;

    /**
     * Creates an instance of ServiceResponseCallback.
     */
    public ListOperationCallback() {
        this.pageCount = 0;
    }

    public PagingBahavior progress(List<E> partial) {
        return PagingBahavior.CONTINUE;
    }

    public List<E> get() {
        return result;
    }

    public void load(List<E> result) {
        ++pageCount;
        if (this.result == null || this.result.isEmpty()) {
            this.result = result;
        } else {
            this.result.addAll(result);
        }
    }

    public int pageCount() {
        return pageCount;
    }

    public enum PagingBahavior {
        CONTINUE,
        STOP
    }
}
