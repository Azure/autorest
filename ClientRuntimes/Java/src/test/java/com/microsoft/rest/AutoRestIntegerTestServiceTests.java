/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.microsoft.rest.bat.AutoRestIntegerTestService;
import com.microsoft.rest.bat.AutoRestIntegerTestServiceImpl;
import org.junit.Assert;
import org.junit.Test;
import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;

public class AutoRestIntegerTestServiceTests {

    @Test
    public void PutMaxInt() throws Exception {
        AutoRestIntegerTestService client = new AutoRestIntegerTestServiceImpl();
        Response response = client.getIntOperations().putMax32(Integer.MAX_VALUE);
        Assert.assertEquals(200, response.getStatus());
    }

    @Test
    public void GetNullInt() throws Exception {
        AutoRestIntegerTestService client = new AutoRestIntegerTestServiceImpl();
        try {
            client.getIntOperations().getNull();
        } catch (NullPointerException exception) {
            return;
        }
        Assert.assertTrue(false);
    }

    @Test
    public void GetNullIntAsync() throws Exception {
        AutoRestIntegerTestService client = new AutoRestIntegerTestServiceImpl();
        client.getIntOperations().getNullAsync(new Callback<Integer>() {
            @Override
            public void success(Integer integer, Response response) {
                Assert.assertNull(integer);
            }

            @Override
            public void failure(RetrofitError error) {
                throw error;
            }
        });
        Thread.sleep(1000);
    }
}
