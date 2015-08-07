/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.microsoft.rest.bat.AutoRestIntegerTestService;
import com.microsoft.rest.bat.AutoRestIntegerTestServiceImpl;
import junit.framework.Assert;
import org.junit.Test;
import retrofit.client.Response;

public class AutoRestIntegerTestServiceTests {

    @Test
    public void GetMaxInt() throws Exception {
        AutoRestIntegerTestService client = new AutoRestIntegerTestServiceImpl();
        try {
            Response response = client.getIntOperations().putMax32(Integer.MAX_VALUE);
            Assert.assertEquals(200, response.getStatus());
        } catch (Exception ex) {
            System.out.println(ex.toString());
        }
    }
}
