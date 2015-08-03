/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import static org.junit.Assert.assertEquals;

import com.microsoft.rest.pipeline.ServiceRequestFilter;
import junit.framework.Assert;
import org.apache.http.Header;
import org.apache.http.HttpRequest;
import org.apache.http.client.methods.HttpGet;
import org.glassfish.jersey.apache.connector.ApacheConnectorProvider;
import org.glassfish.jersey.client.ClientConfig;
import org.junit.Test;

import javax.annotation.Priority;
import javax.ws.rs.Priorities;
import javax.ws.rs.client.ClientRequestContext;
import javax.ws.rs.client.ClientRequestFilter;
import javax.ws.rs.client.WebTarget;
import java.io.IOException;

public class ServiceClientTests {

    @Test
    public void FilterTests() throws Exception {
        ServiceClient serviceClient = new ServiceClient() {};
        serviceClient.addRequestFilter(new FirstFilter());
        serviceClient.addRequestFilter(new SecondFilter());
        serviceClient.addRequestFilter(new ClientRequestFilter() {
            @Override
            public void filter(ClientRequestContext requestContext) throws IOException {
                Assert.assertEquals("1", requestContext.getHeaderString("filter1"));
                Assert.assertEquals("2", requestContext.getHeaderString("filter2"));
            }
        });
        WebTarget target = serviceClient.getClient().target("http://www.microsoft.com");
        String response = target.request().get(String.class);
    }

    @Test
    public void ApacheFilterTests() throws Exception {
        ClientConfig config = new ClientConfig();
        config.connectorProvider(new ApacheConnectorProvider());
        ServiceClient serviceClient = new ServiceClient(config) {};
        serviceClient.addRequestFilter(new FirstFilter());
        serviceClient.addRequestFilter(new SecondFilter());
        serviceClient.addRequestFilter(new ClientRequestFilter() {
            @Override
            public void filter(ClientRequestContext requestContext) throws IOException {
                Assert.assertEquals("1", requestContext.getHeaderString("filter1"));
                Assert.assertEquals("2", requestContext.getHeaderString("filter2"));
            }
        });
        WebTarget target = serviceClient.getClient().target("http://www.microsoft.com");
        String response = target.request().get(String.class);
    }

    @Priority(1)
    public class FirstFilter implements ClientRequestFilter {
        @Override
        public void filter(ClientRequestContext requestContext) throws IOException {
            requestContext.getHeaders().add("filter1", "1");
        }
    }

    @Priority(2)
    public class SecondFilter implements ClientRequestFilter {
        @Override
        public void filter(ClientRequestContext requestContext) throws IOException {
            requestContext.getHeaders().add("filter2", "2");
        }
    }
}
