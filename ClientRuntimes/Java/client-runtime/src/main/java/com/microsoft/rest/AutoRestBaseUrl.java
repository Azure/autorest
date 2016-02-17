/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import java.util.HashMap;
import java.util.Map;

import okhttp3.HttpUrl;
import retrofit2.BaseUrl;

/**
 * An instance of this class stores information of the host of a service.
 */
public class AutoRestBaseUrl implements BaseUrl {
    /** A template based URL with variables wrapped in {}s. */
    private String template;
    /** a mapping from {} wrapped variables in the template and their actual values. */
    private Map<CharSequence, String> mappings;

    @Override
    public HttpUrl url() {
        String url = template;
        for (Map.Entry<CharSequence, String> entry : mappings.entrySet()) {
            url = url.replace(entry.getKey(), entry.getValue());
        }
        mappings.clear();
        return HttpUrl.parse(url);
    }

    /**
     * Creates an instance of a template based URL.
     *
     * @param url the template based URL to use.
     */
    public AutoRestBaseUrl(String url) {
        this.template = url;
        this.mappings = new HashMap<>();
    }

    /**
     * Sets the value for the {} wrapped variables in the template URL.
     * @param matcher the {} wrapped variable to replace.
     * @param value the value to set for the variable.
     */
    public void set(CharSequence matcher, String value) {
        this.mappings.put(matcher, value);
    }
}
