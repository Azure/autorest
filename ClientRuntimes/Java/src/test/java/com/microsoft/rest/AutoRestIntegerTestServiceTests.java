/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.microsoft.rest.bat.AutoRestIntegerTestService;
import com.microsoft.rest.bat.AutoRestIntegerTestServiceImpl;
import org.junit.Test;
import retrofit.client.Response;

public class AutoRestIntegerTestServiceTests {

    @Test
    public void Get() throws Exception {
        AutoRestIntegerTestService client = new AutoRestIntegerTestServiceImpl();
        try {
            Response response = client.getIntOperations().putMax32(Integer.MAX_VALUE);
            System.out.println(response.getStatus());
            int intInvalid = client.getIntOperations().getInvalid();
        } catch (Exception ex) {
            System.out.println(ex.toString());
        }
    }
}
