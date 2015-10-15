/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.core.type.TypeReference;
import com.microsoft.rest.credentials.ServiceClientCredentials;
import com.microsoft.rest.serializer.JacksonHelper;
import com.squareup.okhttp.ResponseBody;
import retrofit.Call;
import retrofit.Response;
import retrofit.http.GET;
import retrofit.http.Path;

import java.net.URL;

/**
 * The base class for all REST clients for accessing Azure resources.
 */
public abstract class AzureClient extends ServiceClient{
    public abstract ServiceClientCredentials getCredentials();

    public abstract int getLongRunningOperationRetryTimeout();

    /**
     * Handles an initial response from a PUT or PATCH operation response by polling
     * the status of the operation until the long running operation terminates.
     *
     * @param response  the initial response from the PUT or PATCH operation.
     * @param <T>       the generic type of the resource
     * @return          the terminal response for the operation.
     * @throws ServiceException
     * @throws InterruptedException
     */
    public <T> AzureResponse<T> GetPutOrPatchResult(AzureResponse<T> response) throws ServiceException, InterruptedException {
        if (response == null || response.getResponse() == null) {
            throw new ServiceException("response is null.");
        }

        int statusCode = response.getResponse().code();
        if (statusCode != 200 && statusCode != 201 && statusCode!= 202) {
            throw new ServiceException(statusCode + " is not a valid polling status code");
        }

        PollingState<T> pollingState = new PollingState<T>(response, this.getLongRunningOperationRetryTimeout());
        String url = response.getResponse().raw().request().urlString();

        // Check provisioning state
        while (AzureAsyncOperation.getTerminalStatuses().contains(pollingState.getStatus())) {
            Thread.sleep(pollingState.getDelayInMilliseconds());

            if (pollingState.getAzureAsyncOperationHeaderLink() != null &&
                    !pollingState.getAzureAsyncOperationHeaderLink().isEmpty()) {
                updateStateFromAzureAsyncOperationHeader(pollingState);
            } else if (pollingState.getLocationHeaderLink() != null &&
                    !pollingState.getLocationHeaderLink().isEmpty()) {
                updateStateFromLocationHeaderOnPut(pollingState);
            } else {
                updateStateFromGetResourceOperation(pollingState, url);
            }
        }

        if (AzureAsyncOperation.successStatus.equals(pollingState.getStatus()) && pollingState.getResource() == null) {
            updateStateFromGetResourceOperation(pollingState, url);
        }

        if (AzureAsyncOperation.getFailedStatuses().contains(pollingState.getStatus())) {
            throw new ServiceException("Async operation failed");
        }

        return new AzureResponse<T>(pollingState.getResource(), pollingState.getResponse());
    }

    private <T> void updateStateFromLocationHeaderOnPut(PollingState<T> pollingState) throws ServiceException {
        AzureResponse<PollingResource> response = getAsync(pollingState.getLocationHeaderLink());

        pollingState.setResponse(response.getResponse());

        int statusCode = response.getResponse().code();
        if (statusCode == 202) {
            pollingState.setStatus(AzureAsyncOperation.inProgressStatus);
        } else if (statusCode == 200 || statusCode == 201) {
            if (response.getBody() == null) {
                throw new ServiceException("no body");
            }

            PollingResource resource = response.getBody();
            if (resource.getProperties() != null && resource.getProperties().getProvisioningState() != null) {
                pollingState.setStatus(resource.getProperties().getProvisioningState());
            } else {
                pollingState.setStatus(AzureAsyncOperation.successStatus);
            }

            CloudError error = new CloudError();
            pollingState.setError(error);
            error.setCode(pollingState.getStatus());
            error.setMessage("Long running operation failed");
            try {
                pollingState.setResource(JacksonHelper.<T>deserialize(response.getResponse().raw().body().string(), new TypeReference<T>() {}));
            } catch (Exception ex) {
                throw new ServiceException("Cannot deserialize response", ex);
            }
        }
    }

    private <T> void updateStateFromGetResourceOperation(PollingState<T> pollingState, String url) throws ServiceException {
        AzureResponse<PollingResource> response = getAsync(url);

        if (response.getBody() == null) {
            throw new ServiceException("no body");
        }

        PollingResource resource = response.getBody();
        if (resource.getProperties() != null && resource.getProperties().getProvisioningState() != null) {
            pollingState.setStatus(resource.getProperties().getProvisioningState());
        } else {
            pollingState.setStatus(AzureAsyncOperation.successStatus);
        }

        CloudError error = new CloudError();
        pollingState.setError(error);
        error.setCode(pollingState.getStatus());
        error.setMessage("Long running operation failed");

        pollingState.setResponse(response.getResponse());
        try {
            pollingState.setResource(JacksonHelper.<T>deserialize(response.getResponse().raw().body().string(), new TypeReference<T>(){}));
        } catch (Exception ex) {
            throw new ServiceException("Cannot deserialize response", ex);
        }
    }

    private <T> void updateStateFromAzureAsyncOperationHeader(PollingState<T> pollingState) throws ServiceException {
        AzureResponse<AzureAsyncOperation> response = getAsync(pollingState.getLocationHeaderLink());

        if (response.getBody() == null || response.getBody().getStatus() == null) {
            throw new ServiceException("no body");
        }

        pollingState.setStatus(response.getBody().getStatus());
        pollingState.setResponse(response.getResponse());
        pollingState.setResource(null);
    }

    private <T> AzureResponse<T> getAsync(String url) throws ServiceException {
        URL endpoint = null;
        try {
            endpoint = new URL(url);
        } catch (Exception ex) {
            throw new ServiceException("Invalid url " + url, ex);
        }
        AsyncService service = this.retrofitBuilder
                .baseUrl(endpoint.getHost()).build().create(AsyncService.class);
        try {
            Response<ResponseBody> response = service.get(endpoint.getPath()).execute();
            return new AzureResponse<T>(
                    JacksonHelper.<T>deserialize(response.raw().body().string(), new TypeReference<T>() {}),
                    response);
        } catch (Exception ex) {
            throw new ServiceException("Cannot deserialize response", ex);
        }
    }

    private interface AsyncService {
        @GET("/{url}")
        Call<ResponseBody> get(@Path("url") String url);
    }

    private class PollingResource {
        @JsonProperty
        private Properties properties;

        public Properties getProperties() {
            return properties;
        }

        private class Properties {
            @JsonProperty
            private String provisioningState;

            public String getProvisioningState() {
                return provisioningState;
            }
        }
    }
}
