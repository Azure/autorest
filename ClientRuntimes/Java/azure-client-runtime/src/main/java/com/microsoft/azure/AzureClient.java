/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceException;
import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.ServiceResponseCallback;
import com.microsoft.rest.ServiceResponseWithHeaders;
import com.microsoft.rest.credentials.ServiceClientCredentials;
import com.microsoft.azure.serializer.AzureJacksonMapperAdapter;
import com.squareup.okhttp.OkHttpClient;
import com.squareup.okhttp.ResponseBody;

import java.io.IOException;
import java.lang.reflect.Type;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import retrofit.Call;
import retrofit.Response;
import retrofit.Retrofit;
import retrofit.http.GET;
import retrofit.http.Url;

/**
 * An instance of this class defines a ServiceClient that handles polling and
 * retrying for long running operations when accessing Azure resources.
 */
public class AzureClient extends AzureServiceClient {
    /**
     * The interval time between two long running operation polls. Default is
     * used if null.
     */
    private Integer longRunningOperationRetryTimeout;
    /**
     * The credentials to use for authentication for long running operations.
     */
    private ServiceClientCredentials credentials;
    /**
     * The executor for asynchronous requests.
     */
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
        this.mapperAdapter = new AzureJacksonMapperAdapter();
    }

    /**
     * Handles an initial response from a PUT or PATCH operation response by polling
     * the status of the operation until the long running operation terminates.
     *
     * @param response  the initial response from the PUT or PATCH operation.
     * @param <T>       the return type of the caller
     * @param resourceType the type of the resource
     * @return          the terminal response for the operation.
     * @throws CloudException REST exception
     * @throws InterruptedException interrupted exception
     * @throws IOException thrown by deserialization
     */
    public <T> ServiceResponse<T> getPutOrPatchResult(Response<ResponseBody> response, Type resourceType) throws CloudException, InterruptedException, IOException {
        if (response == null) {
            throw new CloudException("response is null.");
        }

        int statusCode = response.code();
        ResponseBody responseBody;
        if (response.isSuccess()) {
            responseBody = response.body();
        } else {
            responseBody = response.errorBody();
        }
        if (statusCode != 200 && statusCode != 201 && statusCode != 202) {
            CloudException exception = new CloudException(statusCode + " is not a valid polling status code");
            exception.setResponse(response);
            if (responseBody != null) {
                exception.setBody((CloudError) mapperAdapter.deserialize(responseBody.string(), CloudError.class));
            }
            throw exception;
        }

        PollingState<T> pollingState = new PollingState<>(response, this.getLongRunningOperationRetryTimeout(), resourceType);
        String url = response.raw().request().urlString();

        // Check provisioning state
        while (!AzureAsyncOperation.getTerminalStatuses().contains(pollingState.getStatus())) {
            Thread.sleep(pollingState.getDelayInMilliseconds());

            if (pollingState.getAzureAsyncOperationHeaderLink() != null
                    && !pollingState.getAzureAsyncOperationHeaderLink().isEmpty()) {
                updateStateFromAzureAsyncOperationHeader(pollingState);
            } else if (pollingState.getLocationHeaderLink() != null
                    && !pollingState.getLocationHeaderLink().isEmpty()) {
                updateStateFromLocationHeaderOnPut(pollingState);
            } else {
                updateStateFromGetResourceOperation(pollingState, url);
            }
        }

        if (AzureAsyncOperation.SUCCESS_STATUS.equals(pollingState.getStatus()) && pollingState.getResource() == null) {
            updateStateFromGetResourceOperation(pollingState, url);
        }

        if (AzureAsyncOperation.getFailedStatuses().contains(pollingState.getStatus())) {
            throw new CloudException("Async operation failed");
        }

        return new ServiceResponse<>(pollingState.getResource(), pollingState.getResponse());
    }

    /**
     * Handles an initial response from a PUT or PATCH operation response by polling
     * the status of the operation until the long running operation terminates.
     *
     * @param response  the initial response from the PUT or PATCH operation.
     * @param resourceType the type of the resource
     * @param headerType the type of the response header
     * @param <T>       the return type of the caller
     * @param <THeader> the type of the response header
     * @return          the terminal response for the operation.
     * @throws CloudException REST exception
     * @throws InterruptedException interrupted exception
     * @throws IOException thrown by deserialization
     */
    public <T, THeader> ServiceResponseWithHeaders<T, THeader> getPutOrPatchResultWithHeaders(Response<ResponseBody> response, Type resourceType, Class<THeader> headerType) throws CloudException, InterruptedException, IOException {
        ServiceResponse<T> bodyResponse = getPutOrPatchResult(response, resourceType);
        return new ServiceResponseWithHeaders<>(
                bodyResponse.getBody(),
                mapperAdapter.<THeader>deserialize(mapperAdapter.serialize(bodyResponse.getResponse().headers()), headerType),
                bodyResponse.getResponse()
        );
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
        ResponseBody responseBody;
        if (response.isSuccess()) {
            responseBody = response.body();
        } else {
            responseBody = response.errorBody();
        }
        if (statusCode != 200 && statusCode != 201 && statusCode != 202) {
            CloudException exception = new CloudException(statusCode + " is not a valid polling status code");
            exception.setResponse(response);
            try {
                if (responseBody != null) {
                    exception.setBody((CloudError) mapperAdapter.deserialize(responseBody.string(), CloudError.class));
                }
            } catch (Exception e) { /* ignore serialization errors on top of service errors */ }
            callback.failure(exception);
            return null;
        }

        PollingState<T> pollingState;
        try {
            pollingState = new PollingState<>(response, this.getLongRunningOperationRetryTimeout(), resourceType);
        } catch (IOException e) {
            callback.failure(e);
            return null;
        }
        String url = response.raw().request().urlString();

        // Task runner will take it from here
        PutPatchPollingTask<T> task = new PutPatchPollingTask<>(pollingState, url, callback);
        executor.schedule(task, pollingState.getDelayInMilliseconds(), TimeUnit.MILLISECONDS);
        return task;
    }

    /**
     * Handles an initial response from a PUT or PATCH operation response by polling
     * the status of the operation asynchronously, calling the user provided callback
     * when the operation terminates.
     *
     * @param response  the initial response from the PUT or PATCH operation.
     * @param <T>       the return type of the caller
     * @param <THeader> the type of the response header
     * @param resourceType the type of the resource.
     * @param headerType the type of the response header
     * @param callback  the user callback to call when operation terminates.
     * @return          the task describing the asynchronous polling.
     */
    public <T, THeader> AsyncPollingTask<T> getPutOrPatchResultWithHeadersAsync(Response<ResponseBody> response, Type resourceType, final Class<THeader> headerType, final ServiceCallback<T> callback) {
        return this.getPutOrPatchResultAsync(response, resourceType, new ServiceCallback<T>() {
            @Override
            public void failure(Throwable t) {
                callback.failure(t);
            }

            @Override
            public void success(ServiceResponse<T> result) {
                try {
                    callback.success(new ServiceResponseWithHeaders<>(
                            result.getBody(),
                            mapperAdapter.<THeader>deserialize(mapperAdapter.serialize(result.getResponse().headers()), headerType),
                            result.getResponse()
                    ));
                } catch (IOException e) {
                    failure(e);
                }
            }
        });
    }

    /**
     * Handles an initial response from a POST or DELETE operation response by polling
     * the status of the operation until the long running operation terminates.
     *
     * @param response  the initial response from the POST or DELETE operation.
     * @param <T>       the return type of the caller
     * @param resourceType the type of the resource
     * @return          the terminal response for the operation.
     * @throws CloudException REST exception
     * @throws InterruptedException interrupted exception
     * @throws IOException thrown by deserialization
     */
    public <T> ServiceResponse<T> getPostOrDeleteResult(Response<ResponseBody> response, Type resourceType) throws CloudException, InterruptedException, IOException {
        if (response == null) {
            throw new CloudException("response is null.");
        }

        int statusCode = response.code();
        ResponseBody responseBody;
        if (response.isSuccess()) {
            responseBody = response.body();
        } else {
            responseBody = response.errorBody();
        }
        if (statusCode != 200 && statusCode != 202 && statusCode != 204) {
            CloudException exception = new CloudException(statusCode + " is not a valid polling status code");
            exception.setResponse(response);
            if (responseBody != null) {
                exception.setBody((CloudError) mapperAdapter.deserialize(responseBody.string(), CloudError.class));
            }
            throw exception;
        }

        PollingState<T> pollingState = new PollingState<>(response, this.getLongRunningOperationRetryTimeout(), resourceType);

        // Check provisioning state
        while (!AzureAsyncOperation.getTerminalStatuses().contains(pollingState.getStatus())) {
            Thread.sleep(pollingState.getDelayInMilliseconds());

            if (pollingState.getAzureAsyncOperationHeaderLink() != null
                    && !pollingState.getAzureAsyncOperationHeaderLink().isEmpty()) {
                updateStateFromAzureAsyncOperationHeader(pollingState);
            } else if (pollingState.getLocationHeaderLink() != null
                    && !pollingState.getLocationHeaderLink().isEmpty()) {
                updateStateFromLocationHeaderOnPostOrDelete(pollingState);
            } else {
                CloudException exception = new CloudException("No header in response");
                exception.setResponse(response);
                throw exception;
            }
        }

        // Check if operation failed
        if (AzureAsyncOperation.getFailedStatuses().contains(pollingState.getStatus()))
        {
            throw new CloudException("Async operation failed");
        }

        return new ServiceResponse<>(pollingState.getResource(), pollingState.getResponse());
    }

    /**
     * Handles an initial response from a POST or DELETE operation response by polling
     * the status of the operation until the long running operation terminates.
     *
     * @param response  the initial response from the POST or DELETE operation.
     * @param resourceType the type of the resource
     * @param headerType the type of the response header
     * @param <T>       the return type of the caller
     * @param <THeader> the type of the response header
     * @return          the terminal response for the operation.
     * @throws CloudException REST exception
     * @throws InterruptedException interrupted exception
     * @throws IOException thrown by deserialization
     */
    public <T, THeader> ServiceResponseWithHeaders<T, THeader> getPostOrDeleteResultWithHeaders(Response<ResponseBody> response, Type resourceType, Class<THeader> headerType) throws CloudException, InterruptedException, IOException {
        ServiceResponse<T> bodyResponse = getPostOrDeleteResult(response, resourceType);
        return new ServiceResponseWithHeaders<>(
                bodyResponse.getBody(),
                mapperAdapter.<THeader>deserialize(mapperAdapter.serialize(bodyResponse.getResponse().headers()), headerType),
                bodyResponse.getResponse()
        );
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
        ResponseBody responseBody;
        if (response.isSuccess()) {
            responseBody = response.body();
        } else {
            responseBody = response.errorBody();
        }
        if (statusCode != 200 && statusCode != 201 && statusCode != 202) {
            CloudException exception = new CloudException(statusCode + " is not a valid polling status code");
            exception.setResponse(response);
            try {
                if (responseBody != null) {
                    exception.setBody((CloudError) mapperAdapter.deserialize(responseBody.string(), CloudError.class));
                }
            } catch (Exception e) { /* ignore serialization errors on top of service errors */ }
            callback.failure(exception);
            return null;
        }

        PollingState<T> pollingState;
        try {
            pollingState = new PollingState<>(response, this.getLongRunningOperationRetryTimeout(), resourceType);
        } catch (IOException e) {
            callback.failure(e);
            return null;
        }

        // Task runner will take it from here
        PostDeletePollingTask<T> task = new PostDeletePollingTask<>(pollingState, callback);
        executor.schedule(task, pollingState.getDelayInMilliseconds(), TimeUnit.MILLISECONDS);
        return task;
    }

    /**
     * Handles an initial response from a POST or DELETE operation response by polling
     * the status of the operation asynchronously, calling the user provided callback
     * when the operation terminates.
     *
     * @param response  the initial response from the POST or DELETE operation.
     * @param <T>       the return type of the caller
     * @param <THeader> the type of the response header
     * @param resourceType the type of the resource.
     * @param headerType the type of the response header
     * @param callback  the user callback to call when operation terminates.
     * @return          the task describing the asynchronous polling.
     */
    public <T, THeader> AsyncPollingTask<T> getPostOrDeleteResultWithHeadersAsync(Response<ResponseBody> response, Type resourceType, final Class<THeader> headerType, final ServiceCallback<T> callback) {
        return this.getPostOrDeleteResultAsync(response, resourceType, new ServiceCallback<T>() {
            @Override
            public void failure(Throwable t) {
                callback.failure(t);
            }

            @Override
            public void success(ServiceResponse<T> result) {
                try {
                    callback.success(new ServiceResponseWithHeaders<>(
                            result.getBody(),
                            mapperAdapter.<THeader>deserialize(mapperAdapter.serialize(result.getResponse().headers()), headerType),
                            result.getResponse()
                    ));
                } catch (IOException e) {
                    failure(e);
                }
            }
        });
    }

    /**
     * Polls from the location header and updates the polling state with the
     * polling response for a PUT operation.
     *
     * @param pollingState the polling state for the current operation.
     * @param <T> the return type of the caller.
     * @throws CloudException REST exception
     * @throws IOException thrown by deserialization
     */
    private <T> void updateStateFromLocationHeaderOnPut(PollingState<T> pollingState) throws CloudException, IOException {
        Response<ResponseBody> response = poll(pollingState.getLocationHeaderLink());
        int statusCode = response.code();
        if (statusCode == 202) {
            pollingState.setResponse(response);
            pollingState.setStatus(AzureAsyncOperation.IN_PROGRESS_STATUS);
        } else if (statusCode == 200 || statusCode == 201) {
            pollingState.updateFromResponseOnPutPatch(response);
        }
    }

    /**
     * Polls from the location header and updates the polling state with the
     * polling response for a PUT operation.
     *
     * @param pollingState the polling state for the current operation.
     * @param callback  the user callback to call when operation terminates.
     * @param <T> the return type of the caller.
     * @return the task describing the asynchronous polling.
     */
    private <T> Call<ResponseBody> updateStateFromLocationHeaderOnPutAsync(final PollingState<T> pollingState, final ServiceCallback<T> callback) {
        return pollAsync(pollingState.getLocationHeaderLink(), new ServiceCallback<ResponseBody>() {
            @Override
            public void failure(Throwable t) {
                callback.failure(t);
            }

            @Override
            public void success(ServiceResponse<ResponseBody> result) {
                try {
                    int statusCode = result.getResponse().code();
                    if (statusCode == 202) {
                        pollingState.setResponse(result.getResponse());
                        pollingState.setStatus(AzureAsyncOperation.IN_PROGRESS_STATUS);
                    } else if (statusCode == 200 || statusCode == 201) {
                        pollingState.updateFromResponseOnPutPatch(result.<ResponseBody>getResponse());
                    }
                    callback.success(new ServiceResponse<>(pollingState.getResource(), pollingState.getResponse()));
                } catch (Throwable t) {
                    failure(t);
                }
            }
        });
    }

    /**
     * Polls from the location header and updates the polling state with the
     * polling response for a POST or DELETE operation.
     *
     * @param pollingState the polling state for the current operation.
     * @param <T> the return type of the caller.
     * @throws CloudException service exception
     * @throws IOException thrown by deserialization
     */
    private <T> void updateStateFromLocationHeaderOnPostOrDelete(PollingState<T> pollingState) throws CloudException, IOException {
        Response<ResponseBody> response = poll(pollingState.getLocationHeaderLink());
        int statusCode = response.code();
        if (statusCode == 202) {
            pollingState.setResponse(response);
            pollingState.setStatus(AzureAsyncOperation.IN_PROGRESS_STATUS);
        } else if (statusCode == 200 || statusCode == 201 || statusCode == 204) {
            pollingState.updateFromResponseOnDeletePost(response);
        }
    }

    /**
     * Polls from the location header and updates the polling state with the
     * polling response for a POST or DELETE operation.
     *
     * @param pollingState the polling state for the current operation.
     * @param callback  the user callback to call when operation terminates.
     * @param <T> the return type of the caller.
     * @return the task describing the asynchronous polling.
     */
    private <T> Call<ResponseBody> updateStateFromLocationHeaderOnPostOrDeleteAsync(final PollingState<T> pollingState, final ServiceCallback<T> callback) {
        return pollAsync(pollingState.getLocationHeaderLink(), new ServiceCallback<ResponseBody>() {
            @Override
            public void failure(Throwable t) {
                callback.failure(t);
            }

            @Override
            public void success(ServiceResponse<ResponseBody> result) {
                try {
                    int statusCode = result.getResponse().code();
                    if (statusCode == 202) {
                        pollingState.setResponse(result.getResponse());
                        pollingState.setStatus(AzureAsyncOperation.IN_PROGRESS_STATUS);
                    } else if (statusCode == 200 || statusCode == 201 || statusCode == 204) {
                        pollingState.updateFromResponseOnDeletePost(result.getResponse());
                    }
                    callback.success(new ServiceResponse<>(pollingState.getResource(), pollingState.getResponse()));
                } catch (Throwable t) {
                    failure(t);
                }
            }
        });
    }

    /**
     * Polls from the provided URL and updates the polling state with the
     * polling response.
     *
     * @param pollingState the polling state for the current operation.
     * @param url the url to poll from
     * @param <T> the return type of the caller.
     * @throws CloudException service exception
     * @throws IOException thrown by deserialization
     */
    private <T> void updateStateFromGetResourceOperation(PollingState<T> pollingState, String url) throws CloudException, IOException {
        Response<ResponseBody> response = poll(url);
        pollingState.updateFromResponseOnPutPatch(response);
    }

    /**
     * Polls from the provided URL and updates the polling state with the
     * polling response.
     *
     * @param pollingState the polling state for the current operation.
     * @param url the url to poll from
     * @param callback  the user callback to call when operation terminates.
     * @param <T> the return type of the caller.
     * @return the task describing the asynchronous polling.
     */
    private <T> Call<ResponseBody> updateStateFromGetResourceOperationAsync(final PollingState<T> pollingState, String url, final ServiceCallback<T> callback) {
        return pollAsync(url, new ServiceCallback<ResponseBody>() {
            @Override
            public void failure(Throwable t) {
                callback.failure(t);
            }

            @Override
            public void success(ServiceResponse<ResponseBody> result) {
                try {
                    pollingState.updateFromResponseOnPutPatch(result.getResponse());
                    callback.success(new ServiceResponse<>(pollingState.getResource(), pollingState.getResponse()));
                } catch (Throwable t) {
                    failure(t);
                }
            }
        });
    }

    /**
     * Polls from the 'Azure-AsyncOperation' header and updates the polling
     * state with the polling response.
     *
     * @param pollingState the polling state for the current operation.
     * @param <T> the return type of the caller.
     * @throws CloudException service exception
     * @throws IOException thrown by deserialization
     */
    private <T> void updateStateFromAzureAsyncOperationHeader(PollingState<T> pollingState) throws CloudException, IOException {
        Response<ResponseBody> response = poll(pollingState.getAzureAsyncOperationHeaderLink());

        AzureAsyncOperation body = null;
        if (response.body() != null) {
            body = mapperAdapter.deserialize(response.body().string(), AzureAsyncOperation.class);
        }

        if (body == null || body.getStatus() == null) {
            CloudException exception = new CloudException("no body");
            exception.setResponse(response);
            if (response.errorBody() != null) {
                exception.setBody((CloudError) mapperAdapter.deserialize(response.errorBody().string(), CloudError.class));
            }
            throw exception;
        }

        pollingState.setStatus(body.getStatus());
        pollingState.setResponse(response);
        pollingState.setResource(null);
    }

    /**
     * Polls from the 'Azure-AsyncOperation' header and updates the polling
     * state with the polling response.
     *
     * @param pollingState the polling state for the current operation.
     * @param callback  the user callback to call when operation terminates.
     * @param <T> the return type of the caller.
     * @return the task describing the asynchronous polling.
     */
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
                        body = mapperAdapter.deserialize(result.getBody().string(), AzureAsyncOperation.class);
                    }
                    if (body == null || body.getStatus() == null) {
                        CloudException exception = new CloudException("no body");
                        exception.setResponse(result.getResponse());
                        if (result.getResponse().errorBody() != null) {
                            exception.setBody((CloudError) mapperAdapter.deserialize(result.getResponse().errorBody().string(), CloudError.class));
                        }
                        failure(exception);
                    } else {
                        pollingState.setStatus(body.getStatus());
                        pollingState.setResponse(result.getResponse());
                        pollingState.setResource(null);
                        callback.success(new ServiceResponse<>(pollingState.getResource(), pollingState.getResponse()));
                    }
                } catch (IOException ex) {
                    failure(ex);
                }
            }
        });
    }

    /**
     * Polls from the URL provided.
     *
     * @param url the URL to poll from.
     * @return the raw response.
     * @throws CloudException REST exception
     * @throws IOException thrown by deserialization
     */
    private Response<ResponseBody> poll(String url) throws CloudException, IOException {
        URL endpoint;
        endpoint = new URL(url);
        int port = endpoint.getPort();
        if (port == -1) {
            port = endpoint.getDefaultPort();
        }
        AsyncService service = this.retrofitBuilder
                .baseUrl(endpoint.getProtocol() + "://" + endpoint.getHost() + ":" + port).build().create(AsyncService.class);
        Response<ResponseBody> response = service.get(endpoint.getFile()).execute();
        int statusCode = response.code();
        if (statusCode != 200 && statusCode != 201 && statusCode != 202 && statusCode != 204) {
            CloudException exception = new CloudException(statusCode + " is not a valid polling status code");
            exception.setResponse(response);
            if (response.body() != null) {
                exception.setBody((CloudError) mapperAdapter.deserialize(response.body().string(), CloudError.class));
            } else if (response.errorBody() != null) {
                exception.setBody((CloudError) mapperAdapter.deserialize(response.errorBody().string(), CloudError.class));
            }
            throw exception;
        }
        return response;
    }

    /**
     * Polls asynchronously from the URL provided.
     *
     * @param url the URL to poll from.
     * @param callback  the user callback to call when operation terminates.
     * @return the {@link Call} object from Retrofit.
     */
    private Call<ResponseBody> pollAsync(String url, final ServiceCallback<ResponseBody> callback) {
        URL endpoint;
        try {
            endpoint = new URL(url);
        } catch (MalformedURLException e) {
            callback.failure(e);
            return null;
        }
        int port = endpoint.getPort();
        if (port == -1) {
            port = endpoint.getDefaultPort();
        }
        AsyncService service = this.retrofitBuilder
                .baseUrl(endpoint.getProtocol() + "://" + endpoint.getHost() + ":" + port).build().create(AsyncService.class);
        Call<ResponseBody> call = service.get(endpoint.getFile());
        call.enqueue(new ServiceResponseCallback<ResponseBody>(callback) {
            @Override
            public void onResponse(Response<ResponseBody> response, Retrofit retrofit) {
                try {
                    int statusCode = response.code();
                    if (statusCode != 200 && statusCode != 201 && statusCode != 202 && statusCode != 204) {
                        CloudException exception = new CloudException(statusCode + " is not a valid polling status code");
                        exception.setResponse(response);
                        if (response.body() != null) {
                            exception.setBody((CloudError) mapperAdapter.deserialize(response.body().string(), CloudError.class));
                        } else if (response.errorBody() != null) {
                            exception.setBody((CloudError) mapperAdapter.deserialize(response.errorBody().string(), CloudError.class));
                        }
                        callback.failure(exception);
                        return;
                    }
                    callback.success(new ServiceResponse<>(response.body(), response));
                } catch (IOException ex) {
                    callback.failure(ex);
                }
            }
        });
        return call;
    }

    /**
     * Gets the interval time between two long running operation polls.
     *
     * @return the time in milliseconds.
     */
    public Integer getLongRunningOperationRetryTimeout() {
        return longRunningOperationRetryTimeout;
    }

    /**
     * Sets the interval time between two long running operation polls.
     *
     * @param longRunningOperationRetryTimeout the time in milliseconds.
     */
    public void setLongRunningOperationRetryTimeout(Integer longRunningOperationRetryTimeout) {
        this.longRunningOperationRetryTimeout = longRunningOperationRetryTimeout;
    }

    /**
     * Gets the credentials used for authentication.
     *
     * @return the credentials.
     */
    public ServiceClientCredentials getCredentials() {
        return credentials;
    }

    /**
     * Sets the credentials used for authentication.
     *
     * @param credentials the credentials.
     */
    public void setCredentials(ServiceClientCredentials credentials) {
        this.credentials = credentials;
    }

    /**
     * The Retrofit service used for polling.
     */
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
        /** The {@link Call} object from Retrofit. */
        protected Call<ResponseBody> call;
        /** The polling state for the current operation. */
        protected PollingState<T> pollingState;
        /** The callback used for asynchronous polling. */
        protected ServiceCallback<T> pollingCallback;
        /** The client callback to call when polling finishes. */
        protected ServiceCallback<T> clientCallback;

        /**
         * Gets the {@link Call} object from Retrofit so that the client can
         * cancel or perform other operations on the polling.
         *
         * @return the {@link Call} object.
         */
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
        /** The URL to poll from. */
        private String url;

        /**
         * Creates an instance of Polling task for PUT or PATCH operations.
         *
         * @param pollingState the current polling state.
         * @param url the URL to poll from.
         * @param clientCallback the client callback to call when a terminal status is hit.
         */
        public PutPatchPollingTask(final PollingState<T> pollingState, final String url, final ServiceCallback<T> clientCallback) {
            this.create(pollingState, url, clientCallback);
        }

        /**
         * Creates an instance of Polling task for PUT or PATCH operations.
         *
         * @param pollingState the current polling state.
         * @param url the URL to poll from.
         * @param clientCallback the client callback to call when a terminal status is hit.
         * @return a PutPatchPollingTask instance
         */
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
                    PutPatchPollingTask<T> task = new PutPatchPollingTask<>(pollingState, url, clientCallback);
                    executor.schedule(task, pollingState.getDelayInMilliseconds(), TimeUnit.MILLISECONDS);
                }
            };
            return this;
        }

        @Override
        public void run() {
            // Check provisioning state
            if (!AzureAsyncOperation.getTerminalStatuses().contains(pollingState.getStatus())) {
                if (pollingState.getAzureAsyncOperationHeaderLink() != null
                        && !pollingState.getAzureAsyncOperationHeaderLink().isEmpty()) {
                    this.call = updateStateFromAzureAsyncOperationHeaderAsync(pollingState, pollingCallback);
                } else if (pollingState.getLocationHeaderLink() != null
                        && !pollingState.getLocationHeaderLink().isEmpty()) {
                    this.call = updateStateFromLocationHeaderOnPutAsync(pollingState, pollingCallback);
                } else {
                    this.call = updateStateFromGetResourceOperationAsync(pollingState, url, pollingCallback);
                }
            } else {
                if (AzureAsyncOperation.SUCCESS_STATUS.equals(pollingState.getStatus()) && pollingState.getResource() == null) {
                    call = updateStateFromGetResourceOperationAsync(pollingState, url, clientCallback);
                } else if (AzureAsyncOperation.getFailedStatuses().contains(pollingState.getStatus())) {
                    clientCallback.failure(new ServiceException("Async operation failed"));
                } else {
                    clientCallback.success(new ServiceResponse<>(pollingState.getResource(), pollingState.getResponse()));
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
        /**
         * Creates an instance of Polling task for POST or DELETE operations.
         *
         * @param pollingState the current polling state.
         * @param clientCallback the client callback to call when a terminal status is hit.
         */
        public PostDeletePollingTask(final PollingState<T> pollingState, final ServiceCallback<T> clientCallback) {
            this.create(pollingState, clientCallback);
        }

        /**
         * Creates an instance of Polling task for POST or DELETE operations.
         *
         * @param pollingState the current polling state.
         * @param clientCallback the client callback to call when a terminal status is hit.
         * @return a PostDeletePollingTask instance.
         */
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
                    PostDeletePollingTask<T> task = new PostDeletePollingTask<>(pollingState, clientCallback);
                    executor.schedule(task, pollingState.getDelayInMilliseconds(), TimeUnit.MILLISECONDS);
                }
            };
            return this;
        }

        @Override
        public void run() {
            if (!AzureAsyncOperation.getTerminalStatuses().contains(pollingState.getStatus())) {
                if (pollingState.getAzureAsyncOperationHeaderLink() != null
                        && !pollingState.getAzureAsyncOperationHeaderLink().isEmpty()) {
                    updateStateFromAzureAsyncOperationHeaderAsync(pollingState, pollingCallback);
                } else if (pollingState.getLocationHeaderLink() != null
                        && !pollingState.getLocationHeaderLink().isEmpty()) {
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
                    clientCallback.success(new ServiceResponse<>(pollingState.getResource(), pollingState.getResponse()));
                }
            }
        }
    }
}
