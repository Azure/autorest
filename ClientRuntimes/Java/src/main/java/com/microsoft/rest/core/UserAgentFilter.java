/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.core;

import com.microsoft.rest.core.pipeline.ServiceRequestContext;
import com.microsoft.rest.core.pipeline.ServiceRequestFilter;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * The Class UserAgentFilter.
 */
public class UserAgentFilter implements ServiceRequestFilter {

    /** The azure SDK product token. */
    private String productUserAgent;

    /**
     * Instantiates a new user agent filter.
     */
    public UserAgentFilter(String productUserAgent) {
        this.productUserAgent = productUserAgent;
    }

    @Override
    public void filter(ServiceRequestContext request) {
        String userAgent;

        if (request.getHeader("User-Agent") != null) {
            String currentUserAgent = request.getHeader("User-Agent");
            userAgent = productUserAgent + " " + currentUserAgent;
            request.removeHeader("User-Agent");
        } else {
            userAgent = productUserAgent;
        }

        request.setHeader("User-Agent", userAgent);
    }

    /**
     * Creates the azure SDK product token.
     * 
     * @return the string
     */
    private String createAzureSDKProductToken() {
        String version = getVersionFromResources();
        String productToken;
        if ((version != null) && (!version.isEmpty())) {
            productToken = version;
        } else {
            productToken = "";
        }

        return productToken;
    }

    /**
     * Gets the version of the SDK from resources.
     * 
     * @return the version from resources
     */
    private String getVersionFromResources() {
        String version = null;
        Properties properties = new Properties();
        try {
            InputStream inputStream = getClass()
                    .getClassLoader()
                    .getResourceAsStream(
                            "META-INF/maven/com.microsoft.azure/azure-core/pom.properties");
            if (inputStream != null) {
                properties.load(inputStream);
                version = properties.getProperty("version");
                inputStream.close();
            }
        } catch (IOException e) {
            // Do nothing
        }

        return version;
    }
}
