/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.bat;

import com.microsoft.rest.ServiceClient;
import com.squareup.okhttp.OkHttpClient;
import retrofit.RestAdapter;

/**
 *
 */
public class AutoRestIntegerTestServiceImpl extends ServiceClient<AutoRestIntegerTestService> implements AutoRestIntegerTestService {
    private String baseUri;

    public String getBaseUri() {
        return this.baseUri;
    }

    private IntOperations intOperations;

    public IntOperations getIntOperations() {
        return this.intOperations;
    }

    public AutoRestIntegerTestServiceImpl() {
        this("http://localhost:3000");
    }

    public AutoRestIntegerTestServiceImpl(String baseUri) {
        super();
        this.baseUri = baseUri;
        initialize();
    }

    public AutoRestIntegerTestServiceImpl(String baseUri, OkHttpClient client, RestAdapter.Builder restAdapterBuilder) {
        super(client, restAdapterBuilder);
        this.baseUri = baseUri;
        initialize();
    }

    private void initialize() {
        RestAdapter restAdapter = restAdapterBuilder.setEndpoint(baseUri).build();
        this.intOperations = restAdapter.create(IntOperations.class);
    }
}
