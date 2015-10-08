/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.fasterxml.jackson.databind.JsonNode;
import com.microsoft.rest.serializer.JacksonHelper;
import retrofit.client.Header;
import retrofit.client.Response;

import java.io.IOException;

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
    private CloudError error;

    public PollingState(ServiceResponse<T> response, int retryTimeout) throws ServiceException {
        this.retryTimeout = retryTimeout;
        this.setResponse(response.getResponse());
        this.resource = response.getBody();

        try {
            JsonNode resource = JacksonHelper.getObjectMapper().readTree(this.response.getBody().in());
            if (resource != null && resource.get("properties") != null &&
                    resource.get("properties").get("provisioningState") != null) {
                setStatus(resource.get("properties").get("provisioningState").asText());
            } else {
                switch (this.response.getStatus()) {
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
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    public int getDelayInMilliseconds() {
        if (this.retryTimeout != null) {
            return this.retryTimeout * 1000;
        }
        if (this.response != null) {
            for (Header header: this.response.getHeaders()) {
                if (header.getName().equals("Retry-After")) {
                    return Integer.parseInt(header.getValue()) * 1000;
                }
            }
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
            for (Header header: response.getHeaders()) {
                if (header.getName().equals("Azure-AsyncOperation")) {
                    this.azureAsyncOperationHeaderLink = header.getValue();
                }
                if (header.getName().equals("Location")) {
                    this.locationHeaderLink = header.getValue();
                }
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
}
