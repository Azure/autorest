/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.microsoft.rest.retrofit.AutoRestIntegerTestService;
import com.microsoft.rest.retrofit.AutoRestIntegerTestServiceImpl;
import org.junit.Assert;
import org.junit.Test;
import retrofit.client.Response;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

public class AutoRestIntegerTestServiceTests {
    private CountDownLatch lock = new CountDownLatch(1);

    @Test
    public void PutMaxInt() throws Exception {
        AutoRestIntegerTestService client = new AutoRestIntegerTestServiceImpl();
        client.getIntOperations().putMax32(Integer.MAX_VALUE);
    }

    @Test
    public void PutMaxIntAsync() throws Exception {
        AutoRestIntegerTestService client = new AutoRestIntegerTestServiceImpl();
        client.getIntOperations().putMax32Async(Integer.MAX_VALUE, new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {}

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(200, response.getResponse().getStatus());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void GetNullInt() throws Exception {
        AutoRestIntegerTestService client = new AutoRestIntegerTestServiceImpl();
        try {
            client.getIntOperations().getNull();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(NullPointerException.class, exception.getClass());
        }
    }

    @Test
    public void GetNullIntAsync() throws Exception {
        AutoRestIntegerTestService client = new AutoRestIntegerTestServiceImpl();
        client.getIntOperations().getNullAsync(new ServiceCallback<Integer>() {
            @Override
            public void failure(ServiceException exception) {}

            @Override
            public void success(ServiceResponse<Integer> response) {
                Assert.assertEquals(200, response.getResponse().getStatus());
                Assert.assertNull(response.getBody());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void GetInvalidInt() throws Exception {
        AutoRestIntegerTestService client = new AutoRestIntegerTestServiceImpl();
        try {
            client.getIntOperations().getInvalid();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            Assert.assertEquals(ServiceException.class, exception.getClass());
            Assert.assertTrue(exception.getMessage().contains("Expected an int but was STRING"));
        }
    }
}
