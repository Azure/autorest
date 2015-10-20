/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.fasterxml.jackson.core.type.TypeReference;
import com.microsoft.rest.PollingState.PollingResource;
import com.microsoft.rest.credentials.ServiceClientCredentials;
import com.microsoft.rest.serializer.JacksonHelper;
import com.squareup.okhttp.OkHttpClient;
import com.squareup.okhttp.ResponseBody;
import retrofit.Call;
import retrofit.Response;
import retrofit.Retrofit;
import retrofit.http.GET;
import retrofit.http.Path;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Timer;
import java.util.TimerTask;

/**
 * The base class for all REST clients for accessing Azure resources.
 */
public class AzureClient extends ServiceClient {
    private int longRunningOperationRetryTimeout;
    private ServiceClientCredentials credentials;

    public AzureClient() {
        super();
    }

    public AzureClient(OkHttpClient client, Retrofit.Builder retrofitBuilder) {
        super(client, retrofitBuilder);
    }

    /**
     * Handles an initial response from a PUT or PATCH operation response by polling
     * the status of the operation until the long running operation terminates.
     *
     * @param response  the initial response from the PUT or PATCH operation.
     * @param <T>       the generic type of the resource
     * @return          the terminal response for the operation.
     * @throws ServiceException service exception
     * @throws InterruptedException interrupted exception
     */
    public <T> ServiceResponse<T> getPutOrPatchResult(ServiceResponse<T> response) throws ServiceException, InterruptedException, IOException {
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

        return new ServiceResponse<T>(pollingState.getResource(), pollingState.getResponse());
    }

    public <T> AsyncPollingTask<T> getPutOrPatchResultAsync(ServiceResponse<T> response, ServiceCallback<T> callback) {
        if (response == null || response.getResponse() == null) {
            callback.failure(new ServiceException("response is null."));
            return null;
        }

        int statusCode = response.getResponse().code();
        if (statusCode != 200 && statusCode != 201 && statusCode!= 202) {
            callback.failure(new ServiceException(statusCode + " is not a valid polling status code"));
            return null;
        }

        PollingState<T> pollingState = new PollingState<T>(response, this.getLongRunningOperationRetryTimeout());
        String url = response.getResponse().raw().request().urlString();

        // Check provisioning state
        if (AzureAsyncOperation.getTerminalStatuses().contains(pollingState.getStatus())) {
            AsyncPollingTask<T> task = new AsyncPollingTask<T>(pollingState, url, callback);
            new Timer().schedule(task, pollingState.getDelayInMilliseconds());
            return task;
        }
        return null;
    }

    private <T> void updateStateFromLocationHeaderOnPut(PollingState<T> pollingState) throws ServiceException, IOException {
        ServiceResponse<PollingResource> response = poll(pollingState.getLocationHeaderLink());
        int statusCode = response.getResponse().code();
        if (statusCode == 202) {
            pollingState.setResponse(response.getResponse());
            pollingState.setStatus(AzureAsyncOperation.inProgressStatus);
        } else if (statusCode == 200 || statusCode == 201) {
            pollingState.updateFromResponse(response);
        }
    }

    private <T> Call<ResponseBody> updateStateFromLocationHeaderOnPutAsync(final PollingState<T> pollingState, final ServiceCallback<T> callback) {
        return pollAsync(pollingState.getLocationHeaderLink(), new ServiceCallback<PollingResource>() {
            @Override
            public void failure(Throwable t) { callback.failure(t); }

            @Override
            public void success(ServiceResponse<PollingResource> result) {
                try {
                    int statusCode = result.getResponse().code();
                    if (statusCode == 202) {
                        pollingState.setResponse(result.getResponse());
                        pollingState.setStatus(AzureAsyncOperation.inProgressStatus);
                    } else if (statusCode == 200 || statusCode == 201) {
                        pollingState.updateFromResponse(result);
                    }
                } catch (Throwable t) {
                    failure(t);
                }
            }
        });
    }

    private <T> void updateStateFromGetResourceOperation(PollingState<T> pollingState, String url) throws ServiceException, IOException {
        ServiceResponse<PollingResource> response = poll(url);
        pollingState.updateFromResponse(response);
    }

    private <T> Call<ResponseBody> updateStateFromGetResourceOperationAsync(final PollingState<T> pollingState, String url, final ServiceCallback<T> callback) {
        return pollAsync(url, new ServiceCallback<PollingResource>() {
            @Override
            public void failure(Throwable t) { callback.failure(t); }

            @Override
            public void success(ServiceResponse<PollingResource> result) {
                try {
                    pollingState.updateFromResponse(result);
                } catch (Throwable t) {
                    failure(t);
                }
            }
        });
    }

    private <T> void updateStateFromAzureAsyncOperationHeader(PollingState<T> pollingState) throws ServiceException, IOException {
        ServiceResponse<AzureAsyncOperation> response = poll(pollingState.getLocationHeaderLink());

        if (response.getBody() == null || response.getBody().getStatus() == null) {
            throw new ServiceException("no body");
        }

        pollingState.setStatus(response.getBody().getStatus());
        pollingState.setResponse(response.getResponse());
        pollingState.setResource(null);
    }

    private <T> Call<ResponseBody> updateStateFromAzureAsyncOperationHeaderAsync(final PollingState<T> pollingState, final ServiceCallback<T> callback) {
        return pollAsync(pollingState.getLocationHeaderLink(), new ServiceCallback<AzureAsyncOperation>() {
            @Override
            public void failure(Throwable t) {
                callback.failure(t);
            }

            @Override
            public void success(ServiceResponse<AzureAsyncOperation> result) {
                if (result.getBody() == null || result.getBody().getStatus() == null) {
                    failure(new ServiceException("no body"));
                }

                pollingState.setStatus(result.getBody().getStatus());
                pollingState.setResponse(result.getResponse());
                pollingState.setResource(null);
            }
        });
    }

    private <T> ServiceResponse<T> poll(String url) throws IOException {
        URL endpoint;
        endpoint = new URL(url);
        AsyncService service = this.retrofitBuilder
                .baseUrl(endpoint.getHost()).build().create(AsyncService.class);
        Response<ResponseBody> response = service.get(endpoint.getPath()).execute();
        return new ServiceResponse<T>(
                JacksonHelper.<T>deserialize(response.raw().body().string(), new TypeReference<T>() {}),
                response);
    }

    private <T> Call<ResponseBody> pollAsync(String url, final ServiceCallback<T> callback) {
        URL endpoint;
        try {
            endpoint = new URL(url);
        } catch (MalformedURLException e) {
            callback.failure(e);
            return null;
        }
        AsyncService service = this.retrofitBuilder
                .baseUrl(endpoint.getHost()).build().create(AsyncService.class);
        Call<ResponseBody> call = service.get(endpoint.getFile());
        call.enqueue(new ServiceResponseCallback<T>(callback) {
            @Override
            public void onResponse(Response<ResponseBody> response, Retrofit retrofit) {
                try {
                    callback.success(new ServiceResponse<T>(
                            JacksonHelper.<T>deserialize(response.raw().body().string(), new TypeReference<T>() {}),
                            response));
                } catch (IOException ex) {
                    callback.failure(ex);
                }
            }
        });
        return call;
    }

    public int getLongRunningOperationRetryTimeout() {
        return longRunningOperationRetryTimeout;
    }

    public void setLongRunningOperationRetryTimeout(int longRunningOperationRetryTimeout) {
        this.longRunningOperationRetryTimeout = longRunningOperationRetryTimeout;
    }

    public ServiceClientCredentials getCredentials() {
        return credentials;
    }

    public void setCredentials(ServiceClientCredentials credentials) {
        this.credentials = credentials;
    }

    private interface AsyncService {
        @GET("/{url}")
        Call<ResponseBody> get(@Path("url") String url);
    }

    public class AsyncPollingTask<T> extends TimerTask {
        private final String url;
        private PollingState<T> pollingState;
        private ServiceCallback<T> pollingCallback;
        private Call<ResponseBody> call;

        public AsyncPollingTask(final PollingState<T> pollingState, final String url, final ServiceCallback<T> clientCallback) {
            this.pollingState = pollingState;
            this.url = url;
            this.pollingCallback = new ServiceCallback<T>() {
                @Override
                public void failure(Throwable t) {
                    clientCallback.failure(t);
                }

                @Override
                public void success(ServiceResponse<T> result) {
                    // Check provisioning state
                    if (AzureAsyncOperation.getTerminalStatuses().contains(pollingState.getStatus())) {
                        new Timer().schedule(
                                new AsyncPollingTask<T>(pollingState, url, clientCallback),
                                pollingState.getDelayInMilliseconds());
                    } else {
                        if (AzureAsyncOperation.successStatus.equals(pollingState.getStatus()) && pollingState.getResource() == null) {
                            call = updateStateFromGetResourceOperationAsync(pollingState, url, new ServiceCallback<T>() {
                                @Override
                                public void failure(Throwable t) {
                                    clientCallback.failure(t);
                                }

                                @Override
                                public void success(ServiceResponse<T> result) {
                                    clientCallback.success(new ServiceResponse<T>(pollingState.getResource(), pollingState.getResponse()));
                                }
                            });
                        }

                        if (AzureAsyncOperation.getFailedStatuses().contains(pollingState.getStatus())) {
                            clientCallback.failure(new ServiceException("Async operation failed"));
                        }

                        clientCallback.success(new ServiceResponse<T>(pollingState.getResource(), pollingState.getResponse()));
                    }
                }
            };
        }

        @Override
        public void run() {
            if (pollingState.getAzureAsyncOperationHeaderLink() != null &&
                    !pollingState.getAzureAsyncOperationHeaderLink().isEmpty()) {
                this.call = updateStateFromAzureAsyncOperationHeaderAsync(pollingState, pollingCallback);
            } else if (pollingState.getLocationHeaderLink() != null &&
                    !pollingState.getLocationHeaderLink().isEmpty()) {
                this.call = updateStateFromLocationHeaderOnPutAsync(pollingState, pollingCallback);
            } else {
                this.call = updateStateFromGetResourceOperationAsync(pollingState, url, pollingCallback);
            }
        }

        @Override
        public boolean cancel() {
            if (call != null) {
                call.cancel();
            }
            return super.cancel();
        }
    }
}
