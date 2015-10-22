/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.reflect.TypeToken;
import com.microsoft.rest.serializer.AzureJacksonHelper;
import com.microsoft.rest.serializer.JacksonHelper;
import com.squareup.okhttp.ResponseBody;
import retrofit.Response;

import java.io.IOException;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;

/**
 * An instance of this class defines the state of a long running operation.
 *
 * @param <T> the type of the resource the operation returns.
 */
public class PollingState<T> {
    private Response response;
    private String status;
    private String azureAsyncOperationHeaderLink;
    private String locationHeaderLink;
    private Integer retryTimeout;
    private T resource;
    private Type resourceType;
    private CloudError error;

    public PollingState(Response<ResponseBody> response, int retryTimeout, Type resourceType) throws IOException {
        this.retryTimeout = retryTimeout;
        this.setResponse(response);

        String responseContent = response.body().string();
        this.resource = JacksonHelper.deserialize(responseContent, resourceType);
        this.resourceType = resourceType;

        PollingResource resource = JacksonHelper.deserialize(responseContent, new TypeReference<PollingResource>() {});
        if (resource != null && resource.getProperties() != null &&
                resource.getProperties().getProvisioningState() != null) {
            setStatus(resource.getProperties().getProvisioningState());
        } else {
            switch (this.response.code()) {
                case 202:
                    setStatus(AzureAsyncOperation.inProgressStatus);
                    break;
                case 204:
                case 201:
                case 200:
                    setStatus(AzureAsyncOperation.successStatus);
                    break;
                default:
                    setStatus(AzureAsyncOperation.failedStatus);
            }
        }
    }

    public void updateFromResponseOnPut(Response<ResponseBody> response) throws ServiceException, IOException {
        if (response.body() == null) {
            throw new ServiceException("no body");
        }

        String responseContent = response.body().string();
        final PollingResource resource = JacksonHelper.deserialize(responseContent, new TypeReference<PollingResource>() {});
        if (resource.getProperties() != null && resource.getProperties().getProvisioningState() != null) {
            this.setStatus(resource.getProperties().getProvisioningState());
        } else {
            this.setStatus(AzureAsyncOperation.successStatus);
        }

        CloudError error = new CloudError();
        this.setError(error);
        error.setCode(this.getStatus());
        error.setMessage("Long running operation failed");
        this.setResponse(response);
        this.setResource(JacksonHelper.<T>deserialize(responseContent, new TypeReference<T>() {
            @Override
            public Type getType() {
                return resourceType;
            }
        }));
    }

    public void updateFromResponseOnDelete(Response<ResponseBody> response) throws IOException {
        this.setResponse(response);
        this.setResource(JacksonHelper.<T>deserialize(response.body().string(), new TypeReference<T>() {
            @Override
            public Type getType() {
                return resourceType;
            }
        }));
    }

    public int getDelayInMilliseconds() {
        if (this.retryTimeout != null) {
            return this.retryTimeout * 1000;
        }
        if (this.response != null) {
            return Integer.parseInt(response.headers().get("Retry-After"));
        }
        return AzureAsyncOperation.defaultDelay * 1000;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) throws IllegalArgumentException {
        if (status == null) {
            throw new IllegalArgumentException("Status is null.");
        }
        this.status = status;
    }

    public Response getResponse() {
        return this.response;
    }

    public void setResponse(Response response) {
        this.response = response;
        if (response != null) {
            String asyncHeader = response.headers().get("Azure-AsyncOperation");
            String locationHeader = response.headers().get("Location");
            if (asyncHeader != null) {
                this.azureAsyncOperationHeaderLink = asyncHeader;
            }
            if (locationHeader != null) {
                this.locationHeaderLink = locationHeader;
            }
        }
    }

    public String getAzureAsyncOperationHeaderLink() {
        return azureAsyncOperationHeaderLink;
    }

    public String getLocationHeaderLink() {
        return locationHeaderLink;
    }

    public T getResource() {
        return resource;
    }

    public void setResource(T resource) {
        this.resource = resource;
    }

    public CloudError getError() {
        return error;
    }

    public void setError(CloudError error) {
        this.error = error;
    }

    static class PollingResource {
        @JsonProperty(value = "properties")
        private Properties properties;

        public Properties getProperties() {
            return properties;
        }

        public void setProperties(Properties properties) {
            this.properties = properties;
        }

        static class Properties {
            @JsonProperty(value = "provisioningState")
            private String provisioningState;

            public String getProvisioningState() {
                return provisioningState;
            }

            public void setProvisioningState(String provisioningState) {
                this.provisioningState = provisioningState;
            }
        }
    }
}
