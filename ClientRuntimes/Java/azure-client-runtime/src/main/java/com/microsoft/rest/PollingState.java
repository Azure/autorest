/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.core.type.TypeReference;
import com.microsoft.rest.serializer.AzureJacksonUtils;
import com.microsoft.rest.serializer.JacksonUtils;
import com.squareup.okhttp.ResponseBody;
import retrofit.Response;

import java.io.IOException;
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

    /**
     * Initializes an instance of {@link PollingState}.
     *
     * @param response the response from Retrofit REST call.
     * @param retryTimeout the long running operation retry timeout.
     * @param resourceType the type of the resource the long running operation returns
     * @throws IOException thrown by deserialization
     */
    public PollingState(Response<ResponseBody> response, int retryTimeout, Type resourceType) throws IOException {
        this.retryTimeout = retryTimeout;
        this.setResponse(response);
        this.resourceType = resourceType;

        String responseContent = null;
        PollingResource resource = null;
        if (response.body() != null) {
            responseContent = response.body().string();
        }
        if (responseContent != null && !responseContent.isEmpty()) {
            this.resource = new AzureJacksonUtils().deserialize(responseContent, resourceType);
            resource = new AzureJacksonUtils().deserialize(responseContent, new TypeReference<PollingResource>() {
            });
        }
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

    /**
     * Updates the polling state from a PUT or PATCH operation.
     *
     * @param response the response from Retrofit REST call
     * @throws ServiceException thrown if the response is invalid
     * @throws IOException thrown by deserialization
     */
    public void updateFromResponseOnPutPatch(Response<ResponseBody> response) throws ServiceException, IOException {
        String responseContent = null;
        if (response.body() != null) {
            responseContent = response.body().string();
        }

        if (responseContent == null || responseContent.isEmpty()) {
            ServiceException exception = new ServiceException("no body");
            exception.setResponse(response);
            throw exception;
        }

        PollingResource resource = new AzureJacksonUtils().deserialize(responseContent, new TypeReference<PollingResource>() {});
        if (resource != null && resource.getProperties() != null && resource.getProperties().getProvisioningState() != null) {
            this.setStatus(resource.getProperties().getProvisioningState());
        } else {
            this.setStatus(AzureAsyncOperation.successStatus);
        }

        CloudError error = new CloudError();
        this.setError(error);
        error.setCode(this.getStatus());
        error.setMessage("Long running operation failed");
        this.setResponse(response);
        this.setResource(new AzureJacksonUtils().<T>deserialize(responseContent, new TypeReference<T>() {
            @Override
            public Type getType() {
                return resourceType;
            }
        }));
    }

    /**
     * Updates the polling state from a DELETE or POST operation.
     *
     * @param response the response from Retrofit REST call
     * @throws IOException thrown by deserialization
     */

    public void updateFromResponseOnDeletePost(Response<ResponseBody> response) throws IOException {
        this.setResponse(response);
        String responseContent = null;
        if (response.body() != null) {
            responseContent = response.body().string();
        }
        this.setResource(new AzureJacksonUtils().<T>deserialize(responseContent, new TypeReference<T>() {
            @Override
            public Type getType() {
                return resourceType;
            }
        }));
        setStatus(AzureAsyncOperation.successStatus);
    }

    /**
     * Gets long running operation delay in milliseconds.
     *
     * @return the delay in milliseconds.
     */
    public int getDelayInMilliseconds() {
        if (this.retryTimeout != null) {
            return this.retryTimeout * 1000;
        }
        if (this.response != null) {
            return Integer.parseInt(response.headers().get("Retry-After"));
        }
        return AzureAsyncOperation.defaultDelay * 1000;
    }

    /**
     * Gets the polling status.
     *
     * @return the polling status.
     */
    public String getStatus() {
        return status;
    }


    /**
     * Sets the polling status.
     *
     * @param status the polling status.
     */
    public void setStatus(String status) throws IllegalArgumentException {
        if (status == null) {
            throw new IllegalArgumentException("Status is null.");
        }
        this.status = status;
    }

    /**
     * Gets the last operation response.
     *
     * @return the last operation response.
     */
    public Response getResponse() {
        return this.response;
    }


    /**
     * Sets the last operation response.
     *
     * @param response the last operation response.
     */
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

    /**
     * Gets the latest value captured from Azure-AsyncOperation header.
     *
     * @return the link in the header.
     */
    public String getAzureAsyncOperationHeaderLink() {
        return azureAsyncOperationHeaderLink;
    }

    /**
     * Gets the latest value captured from Location header.
     *
     * @return the link in the header.
     */
    public String getLocationHeaderLink() {
        return locationHeaderLink;
    }

    /**
     * Gets the resource.
     *
     * @return the resource.
     */
    public T getResource() {
        return resource;
    }

    /**
     * Sets the resource.
     *
     * @param resource the resource.
     */
    public void setResource(T resource) {
        this.resource = resource;
    }

    /**
     * Gets {@link CloudError} from current instance.
     *
     * @return the cloud error.
     */
    public CloudError getError() {
        return error;
    }

    /**
     * Sets {@link CloudError} from current instance.
     *
     * @param error the cloud error.
     */
    public void setError(CloudError error) {
        this.error = error;
    }

    /**
     * An instance of this class describes the status of a long running operation
     * and is returned from server each time.
     */
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
