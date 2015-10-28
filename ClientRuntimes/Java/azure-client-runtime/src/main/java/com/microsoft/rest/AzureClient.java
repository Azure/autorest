/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.fasterxml.jackson.core.type.TypeReference;
import com.microsoft.rest.credentials.ServiceClientCredentials;
import com.microsoft.rest.serializer.JacksonHelper;
import com.squareup.okhttp.OkHttpClient;
import com.squareup.okhttp.ResponseBody;
import retrofit.Call;
import retrofit.Response;
import retrofit.Retrofit;
import retrofit.http.GET;
import retrofit.http.Url;

import java.io.IOException;
import java.lang.reflect.Type;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * An instance of this class defines a ServiceClient that handles polling and
 * retrying for long running operations when accessing Azure resources.
 */
public class AzureClient extends ServiceClient {
    private int longRunningOperationRetryTimeout;
    private ServiceClientCredentials credentials;
    private ScheduledExecutorService executor = Executors.newSingleThreadScheduledExecutor();

    /**
     * Initializes an instance of this class.
     */
    public AzureClient() {
        super();
    }

    /**
     * Initializes an instance of this class with customized client metadata.
     *
     * @param client customized http client.
     * @param retrofitBuilder customized retrofit builder
     */
    public AzureClient(OkHttpClient client, Retrofit.Builder retrofitBuilder) {
        super(client, retrofitBuilder);
    }

    /**
     * Handles an initial response from a PUT or PATCH operation response by polling
     * the status of the operation until the long running operation terminates.
     *
     * @param response  the initial response from the PUT or PATCH operation.
     * @param <T>       the return type of the caller
     * @param resourceType the type of the resource
     * @return          the terminal response for the operation.
     * @throws ServiceException service exception
     * @throws InterruptedException interrupted exception
     * @throws IOException thrown by deserialization
     */
    public <T> ServiceResponse<T> getPutOrPatchResult(Response<ResponseBody> response, Type resourceType) throws ServiceException, InterruptedException, IOException {
        if (response == null) {
            throw new ServiceException("response is null.");
        }

        int statusCode = response.code();
        if (statusCode != 200 && statusCode != 201 && statusCode!= 202) {
            ServiceException exception = new ServiceException(statusCode + " is not a valid polling status code");
            exception.setResponse(response);
            throw exception;
        }

        PollingState<T> pollingState = new PollingState<T>(response, this.getLongRunningOperationRetryTimeout(), resourceType);
        String url = response.raw().request().urlString();

        // Check provisioning state
        while (!AzureAsyncOperation.getTerminalStatuses().contains(pollingState.getStatus())) {
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

    /**
     * Handles an initial response from a PUT or PATCH operation response by polling
     * the status of the operation asynchronously, calling the user provided callback
     * when the operation terminates.
     *
     * @param response  the initial response from the PUT or PATCH operation.
     * @param <T>       the return type of the caller.
     * @param resourceType the type of the resource.
     * @param callback  the user callback to call when operation terminates.
     * @return          the task describing the asynchronous polling.
     */
    public <T> AsyncPollingTask<T> getPutOrPatchResultAsync(Response<ResponseBody> response, Type resourceType, ServiceCallback<T> callback) {
        if (response == null) {
            callback.failure(new ServiceException("response is null."));
            return null;
        }

        int statusCode = response.code();
        if (statusCode != 200 && statusCode != 201 && statusCode!= 202) {
            ServiceException exception = new ServiceException(statusCode + " is not a valid polling status code");
            exception.setResponse(response);
            callback.failure(exception);
            return null;
        }

        PollingState<T> pollingState;
        try {
            pollingState = new PollingState<T>(response, this.getLongRunningOperationRetryTimeout(), resourceType);
        } catch (IOException e) {
            callback.failure(e);
            return null;
        }
        String url = response.raw().request().urlString();

        // Task runner will take it from here
        PutPatchPollingTask<T> task = new PutPatchPollingTask<T>(pollingState, url, callback);
        executor.schedule(task, pollingState.getDelayInMilliseconds(), TimeUnit.MILLISECONDS);
        return task;
    }

    /**
     * Handles an initial response from a POST or DELETE operation response by polling
     * the status of the operation until the long running operation terminates.
     *
     * @param response  the initial response from the POST or DELETE operation.
     * @param <T>       the return type of the caller
     * @param resourceType the type of the resource
     * @return          the terminal response for the operation.
     * @throws ServiceException service exception
     * @throws InterruptedException interrupted exception
     * @throws IOException thrown by deserialization
     */
    public <T> ServiceResponse<T> getPostOrDeleteResult(Response<ResponseBody> response, Type resourceType) throws ServiceException, InterruptedException, IOException {
        if (response == null) {
            throw new ServiceException("response is null.");
        }

        int statusCode = response.code();
        if (statusCode != 200 && statusCode != 202 && statusCode != 204) {
            ServiceException exception = new ServiceException(statusCode + " is not a valid polling status code");
            exception.setResponse(response);
            throw exception;
        }

        PollingState<T> pollingState = new PollingState<T>(response, this.getLongRunningOperationRetryTimeout(), resourceType);

        // Check provisioning state
        while (!AzureAsyncOperation.getTerminalStatuses().contains(pollingState.getStatus())) {
            Thread.sleep(pollingState.getDelayInMilliseconds());

            if (pollingState.getAzureAsyncOperationHeaderLink() != null &&
                    !pollingState.getAzureAsyncOperationHeaderLink().isEmpty()) {
                updateStateFromAzureAsyncOperationHeader(pollingState);
            } else if (pollingState.getLocationHeaderLink() != null &&
                    !pollingState.getLocationHeaderLink().isEmpty()) {
                updateStateFromLocationHeaderOnPostOrDelete(pollingState);
            } else {
                ServiceException exception = new ServiceException("No header in response");
                exception.setResponse(response);
                throw exception;
            }
        }

        // Check if operation failed
        if (AzureAsyncOperation.getFailedStatuses().contains(pollingState.getStatus()))
        {
            throw new ServiceException("Async operation failed");
        }

        return new ServiceResponse<T>(pollingState.getResource(), pollingState.getResponse());
    }

    /**
     * Handles an initial response from a POST or DELETE operation response by polling
     * the status of the operation asynchronously, calling the user provided callback
     * when the operation terminates.
     *
     * @param response  the initial response from the POST or DELETE operation.
     * @param <T>       the return type of the caller.
     * @param resourceType the type of the resource.
     * @param callback  the user callback to call when operation terminates.
     * @return          the task describing the asynchronous polling.
     */
    public <T> AsyncPollingTask<T> getPostOrDeleteResultAsync(Response<ResponseBody> response, Type resourceType, ServiceCallback<T> callback) {
        if (response == null) {
            callback.failure(new ServiceException("response is null."));
            return null;
        }

        int statusCode = response.code();
        if (statusCode != 200 && statusCode != 201 && statusCode!= 202) {
            ServiceException exception = new ServiceException(statusCode + " is not a valid polling status code");
            exception.setResponse(response);
            callback.failure(exception);
            return null;
        }

        PollingState<T> pollingState;
        try {
            pollingState = new PollingState<T>(response, this.getLongRunningOperationRetryTimeout(), resourceType);
        } catch (IOException e) {
            callback.failure(e);
            return null;
        }

        // Task runner will take it from here
        PostDeletePollingTask<T> task = new PostDeletePollingTask<T>(pollingState, callback);
        executor.schedule(task, pollingState.getDelayInMilliseconds(), TimeUnit.MILLISECONDS);
        return task;
    }

    private <T> void updateStateFromLocationHeaderOnPut(PollingState<T> pollingState) throws ServiceException, IOException {
        Response<ResponseBody> response = poll(pollingState.getLocationHeaderLink());
        int statusCode = response.code();
        if (statusCode == 202) {
            pollingState.setResponse(response);
            pollingState.setStatus(AzureAsyncOperation.inProgressStatus);
        } else if (statusCode == 200 || statusCode == 201) {
            pollingState.updateFromResponseOnPutPatch(response);
        }
    }

    private <T> Call<ResponseBody> updateStateFromLocationHeaderOnPutAsync(final PollingState<T> pollingState, final ServiceCallback<T> callback) {
        return pollAsync(pollingState.getLocationHeaderLink(), new ServiceCallback<ResponseBody>() {
            @Override
            public void failure(Throwable t) { callback.failure(t); }

            @Override
            public void success(ServiceResponse<ResponseBody> result) {
                try {
                    int statusCode = result.getResponse().code();
                    if (statusCode == 202) {
                        pollingState.setResponse(result.getResponse());
                        pollingState.setStatus(AzureAsyncOperation.inProgressStatus);
                    } else if (statusCode == 200 || statusCode == 201) {
                        pollingState.updateFromResponseOnPutPatch(result.getResponse());
                    }
                    callback.success(new ServiceResponse<T>(pollingState.getResource(), pollingState.getResponse()));
                } catch (Throwable t) {
                    failure(t);
                }
            }
        });
    }

    private <T> void updateStateFromLocationHeaderOnPostOrDelete(PollingState<T> pollingState) throws ServiceException, IOException {
        Response<ResponseBody> response = poll(pollingState.getLocationHeaderLink());
        int statusCode = response.code();
        if (statusCode == 202) {
            pollingState.setResponse(response);
            pollingState.setStatus(AzureAsyncOperation.inProgressStatus);
        } else if (statusCode == 200 || statusCode == 201 || statusCode == 204) {
            pollingState.updateFromResponseOnDeletePost(response);
        }
    }

    private <T> Call<ResponseBody> updateStateFromLocationHeaderOnPostOrDeleteAsync(final PollingState<T> pollingState, final ServiceCallback<T> callback) {
        return pollAsync(pollingState.getLocationHeaderLink(), new ServiceCallback<ResponseBody>() {
            @Override
            public void failure(Throwable t) { callback.failure(t); }

            @Override
            public void success(ServiceResponse<ResponseBody> result) {
                try {
                    int statusCode = result.getResponse().code();
                    if (statusCode == 202) {
                        pollingState.setResponse(result.getResponse());
                        pollingState.setStatus(AzureAsyncOperation.inProgressStatus);
                    } else if (statusCode == 200 || statusCode == 201 || statusCode == 204) {
                        pollingState.updateFromResponseOnDeletePost(result.getResponse());
                    }
                    callback.success(new ServiceResponse<T>(pollingState.getResource(), pollingState.getResponse()));
                } catch (Throwable t) {
                    failure(t);
                }
            }
        });
    }

    private <T> void updateStateFromGetResourceOperation(PollingState<T> pollingState, String url) throws ServiceException, IOException {
        Response<ResponseBody> response = poll(url);
        pollingState.updateFromResponseOnPutPatch(response);
    }

    private <T> Call<ResponseBody> updateStateFromGetResourceOperationAsync(final PollingState<T> pollingState, String url, final ServiceCallback<T> callback) {
        return pollAsync(url, new ServiceCallback<ResponseBody>() {
            @Override
            public void failure(Throwable t) { callback.failure(t); }

            @Override
            public void success(ServiceResponse<ResponseBody> result) {
                try {
                    pollingState.updateFromResponseOnPutPatch(result.getResponse());
                    callback.success(new ServiceResponse<T>(pollingState.getResource(), pollingState.getResponse()));
                } catch (Throwable t) {
                    failure(t);
                }
            }
        });
    }

    private <T> void updateStateFromAzureAsyncOperationHeader(PollingState<T> pollingState) throws ServiceException, IOException {
        Response<ResponseBody> response = poll(pollingState.getAzureAsyncOperationHeaderLink());

        AzureAsyncOperation body = null;
        if (response.body() != null) {
            body = JacksonHelper.deserialize(response.body().byteStream(), new TypeReference<AzureAsyncOperation>() {});
        }

        if (body == null || body.getStatus() == null) {
            ServiceException exception = new ServiceException("no body");
            exception.setResponse(response);
            throw exception;
        }

        pollingState.setStatus(body.getStatus());
        pollingState.setResponse(response);
        pollingState.setResource(null);
    }

    private <T> Call<ResponseBody> updateStateFromAzureAsyncOperationHeaderAsync(final PollingState<T> pollingState, final ServiceCallback<T> callback) {
        return pollAsync(pollingState.getAzureAsyncOperationHeaderLink(), new ServiceCallback<ResponseBody>() {
            @Override
            public void failure(Throwable t) {
                callback.failure(t);
            }

            @Override
            public void success(ServiceResponse<ResponseBody> result) {
                try {
                    AzureAsyncOperation body = null;
                    if (result.getBody() != null) {
                        body = JacksonHelper.deserialize(result.getBody().byteStream(), new TypeReference<AzureAsyncOperation>() {});
                    }
                    if (body == null || body.getStatus() == null) {
                        ServiceException exception = new ServiceException("no body");
                        exception.setResponse(result.getResponse());
                        failure(exception);
                    } else {
                        pollingState.setStatus(body.getStatus());
                        pollingState.setResponse(result.getResponse());
                        pollingState.setResource(null);
                        callback.success(new ServiceResponse<T>(pollingState.getResource(), pollingState.getResponse()));
                    }
                } catch (IOException ex) {
                    failure(ex);
                }
            }
        });
    }

    private Response<ResponseBody> poll(String url) throws ServiceException, IOException {
        URL endpoint;
        endpoint = new URL(url);
        AsyncService service = this.retrofitBuilder
                .baseUrl(endpoint.getProtocol() + "://" + endpoint.getHost() + ":" + endpoint.getPort()).build().create(AsyncService.class);
        Response<ResponseBody> response = service.get(endpoint.getFile()).execute();
        int statusCode = response.code();
        if (statusCode != 200 && statusCode != 201 && statusCode != 202 && statusCode != 204) {
            ServiceException exception = new ServiceException(statusCode + " is not a valid polling status code");
            exception.setResponse(response);
            if (response.body() != null) {
                exception.setErrorModel(JacksonHelper.deserialize(response.body().byteStream(), new TypeReference<Object>() {}));
            }
            throw exception;
        }
        return response;
    }

    private Call<ResponseBody> pollAsync(String url, final ServiceCallback<ResponseBody> callback) {
        URL endpoint;
        try {
            endpoint = new URL(url);
        } catch (MalformedURLException e) {
            callback.failure(e);
            return null;
        }
        AsyncService service = this.retrofitBuilder
                .baseUrl(endpoint.getProtocol() + "://" + endpoint.getHost() + ":" + endpoint.getPort()).build().create(AsyncService.class);
        Call<ResponseBody> call = service.get(endpoint.getFile());
        call.enqueue(new ServiceResponseCallback<ResponseBody>(callback) {
            @Override
            public void onResponse(Response<ResponseBody> response, Retrofit retrofit) {
                try {
                    int statusCode = response.code();
                    if (statusCode != 200 && statusCode != 201 && statusCode != 202 && statusCode != 204) {
                        ServiceException exception = new ServiceException(statusCode + " is not a valid polling status code");
                        exception.setResponse(response);
                        if (response.body() != null) {
                            exception.setErrorModel(JacksonHelper.deserialize(response.body().byteStream(), new TypeReference<Object>() {
                            }));
                        }
                        callback.failure(exception);
                        return;
                    }
                    callback.success(new ServiceResponse<ResponseBody>(response.body(), response));
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
        @GET
        Call<ResponseBody> get(@Url String url);
    }

    /**
     * The task runner that describes the state of an asynchronous long running
     * operation.
     *
     * @param <T> the return type of the caller.
     */
    abstract class AsyncPollingTask<T> implements Runnable {
        protected Call<ResponseBody> call;
        protected PollingState<T> pollingState;
        protected ServiceCallback<T> pollingCallback;
        protected ServiceCallback<T> clientCallback;

        public Call<ResponseBody> getRestCall() {
            return this.call;
        }
    }

    /**
     * The task runner that handles PUT or PATCH operations.
     *
     * @param <T> the return type of the caller.
     */
    class PutPatchPollingTask<T> extends AsyncPollingTask<T> {
        private String url;

        public PutPatchPollingTask(final PollingState<T> pollingState, final String url, final ServiceCallback<T> clientCallback) {
            this.create(pollingState, url, clientCallback);
        }

        private PutPatchPollingTask<T> create(final PollingState<T> pollingState, final String url, final ServiceCallback<T> clientCallback) {
            this.call = null;
            this.pollingState = pollingState;
            this.url = url;
            this.clientCallback = clientCallback;
            this.pollingCallback = new ServiceCallback<T>() {
                @Override
                public void failure(Throwable t) {
                    clientCallback.failure(t);
                }

                @Override
                public void success(ServiceResponse<T> result) {
                    PutPatchPollingTask<T> task = new PutPatchPollingTask<T>(pollingState, url, clientCallback);
                    executor.schedule(task, pollingState.getDelayInMilliseconds(), TimeUnit.MILLISECONDS);
                }
            };
            return this;
        }

        @Override
        public void run() {
            // Check provisioning state
            if (!AzureAsyncOperation.getTerminalStatuses().contains(pollingState.getStatus())) {
                if (pollingState.getAzureAsyncOperationHeaderLink() != null &&
                        !pollingState.getAzureAsyncOperationHeaderLink().isEmpty()) {
                    this.call = updateStateFromAzureAsyncOperationHeaderAsync(pollingState, pollingCallback);
                } else if (pollingState.getLocationHeaderLink() != null &&
                        !pollingState.getLocationHeaderLink().isEmpty()) {
                    this.call = updateStateFromLocationHeaderOnPutAsync(pollingState, pollingCallback);
                } else {
                    this.call = updateStateFromGetResourceOperationAsync(pollingState, url, pollingCallback);
                }
            } else {
                if (AzureAsyncOperation.successStatus.equals(pollingState.getStatus()) && pollingState.getResource() == null) {
                    call = updateStateFromGetResourceOperationAsync(pollingState, url, clientCallback);
                } else if (AzureAsyncOperation.getFailedStatuses().contains(pollingState.getStatus())) {
                    clientCallback.failure(new ServiceException("Async operation failed"));
                } else {
                    clientCallback.success(new ServiceResponse<T>(pollingState.getResource(), pollingState.getResponse()));
                }
            }
        }
    }
    /**
     * The task runner that handles POST or DELETE operations.
     *
     * @param <T> the return type of the caller.
     */
    class PostDeletePollingTask<T> extends AsyncPollingTask<T> {
        public PostDeletePollingTask(final PollingState<T> pollingState, final ServiceCallback<T> clientCallback) {
            this.create(pollingState, clientCallback);
        }

        private PostDeletePollingTask<T> create(final PollingState<T> pollingState, final ServiceCallback<T> clientCallback) {
            this.call = null;
            this.pollingState = pollingState;
            this.pollingCallback = new ServiceCallback<T>() {
                @Override
                public void failure(Throwable t) {
                    clientCallback.failure(t);
                }

                @Override
                public void success(ServiceResponse<T> result) {
                    PostDeletePollingTask<T> task = new PostDeletePollingTask<T>(pollingState, clientCallback);
                    executor.schedule(task, pollingState.getDelayInMilliseconds(), TimeUnit.MILLISECONDS);
                }
            };
            return this;
        }

        @Override
        public void run() {
            if (!AzureAsyncOperation.getTerminalStatuses().contains(pollingState.getStatus())) {
                if (pollingState.getAzureAsyncOperationHeaderLink() != null &&
                        !pollingState.getAzureAsyncOperationHeaderLink().isEmpty()) {
                    updateStateFromAzureAsyncOperationHeaderAsync(pollingState, pollingCallback);
                } else if (pollingState.getLocationHeaderLink() != null &&
                        !pollingState.getLocationHeaderLink().isEmpty()) {
                    updateStateFromLocationHeaderOnPostOrDeleteAsync(pollingState, pollingCallback);
                } else {
                    pollingCallback.failure(new ServiceException("No header in response"));
                }
            } else {
                // Check if operation failed
                if (AzureAsyncOperation.getFailedStatuses().contains(pollingState.getStatus()))
                {
                    clientCallback.failure(new ServiceException("Async operation failed"));
                } else {
                    clientCallback.success(new ServiceResponse<T>(pollingState.getResource(), pollingState.getResponse()));
                }
            }
        }
    }
}
