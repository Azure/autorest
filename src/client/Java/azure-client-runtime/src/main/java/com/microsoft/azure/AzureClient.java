/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.ServiceResponseWithHeaders;

import java.io.IOException;
import java.lang.reflect.Type;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Arrays;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import okhttp3.ResponseBody;
import retrofit2.Response;
import retrofit2.http.GET;
import retrofit2.http.Header;
import retrofit2.http.Url;
import rx.Observable;
import rx.functions.Func1;

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
     * The executor for asynchronous requests.
     */
    private ScheduledExecutorService executor = Executors.newSingleThreadScheduledExecutor();

    /**
     * The user agent from the service client that owns this Azure Client.
     */
    private final String serviceClientUserAgent;

    /**
     * Initializes an instance of this class with customized client metadata.
     *
     * @param serviceClient the caller client that initiates the asynchronous request.
     */
    public AzureClient(AzureServiceClient serviceClient) {
        super(serviceClient.restClient());
        this.serviceClientUserAgent = serviceClient.userAgent();
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
    public void withLongRunningOperationRetryTimeout(Integer longRunningOperationRetryTimeout) {
        this.longRunningOperationRetryTimeout = longRunningOperationRetryTimeout;
    }

    /**
     * Handles an initial response from a PUT or PATCH operation response by polling
     * the status of the operation until the long running operation terminates.
     *
     * @param observable  the initial observable from the PUT or PATCH operation.
     * @param <T>       the return type of the caller
     * @param resourceType the type of the resource
     * @return          the terminal response for the operation.
     * @throws CloudException REST exception
     * @throws InterruptedException interrupted exception
     * @throws IOException thrown by deserialization
     */
    public <T> ServiceResponse<T> getPutOrPatchResult(Observable<Response<ResponseBody>> observable, Type resourceType) throws CloudException, InterruptedException, IOException {
        Observable<ServiceResponse<T>> asyncObservable = getPutOrPatchResultAsync(observable, resourceType);
        return asyncObservable.toBlocking().last();
    }

    /**
     * Handles an initial response from a PUT or PATCH operation response by polling
     * the status of the operation until the long running operation terminates.
     *
     * @param observable  the initial observable from the PUT or PATCH operation.
     * @param resourceType the type of the resource
     * @param headerType the type of the response header
     * @param <T>       the return type of the caller
     * @param <THeader> the type of the response header
     * @return          the terminal response for the operation.
     * @throws CloudException REST exception
     * @throws InterruptedException interrupted exception
     * @throws IOException thrown by deserialization
     */
    public <T, THeader> ServiceResponseWithHeaders<T, THeader> getPutOrPatchResultWithHeaders(Observable<Response<ResponseBody>> observable, Type resourceType, Class<THeader> headerType) throws CloudException, InterruptedException, IOException {
        ServiceResponse<T> bodyResponse = getPutOrPatchResult(observable, resourceType);
        return new ServiceResponseWithHeaders<>(
            bodyResponse.getBody(),
            restClient().mapperAdapter().<THeader>deserialize(restClient().mapperAdapter().serialize(bodyResponse.getResponse().headers()), headerType),
            bodyResponse.getResponse()
        );
    }

    /**
     * Handles an initial response from a PUT or PATCH operation response by polling
     * the status of the operation asynchronously, calling the user provided callback
     * when the operation terminates.
     *
     * @param observable  the initial observable from the PUT or PATCH operation.
     * @param <T>       the return type of the caller.
     * @param resourceType the type of the resource.
     * @return          the observable of which a subscription will lead to a final response.
     */
    public <T> Observable<ServiceResponse<T>> getPutOrPatchResultAsync(Observable<Response<ResponseBody>> observable, final Type resourceType) {
        return observable
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<T>>>() {
                @Override
                public Observable<ServiceResponse<T>> call(Response<ResponseBody> response) {
                    CloudException exception = createExceptionFromResponse(response, 200, 201, 202);
                    if (exception != null) {
                        return Observable.error(exception);
                    }

                    try {
                        final PollingState<T> pollingState = new PollingState<>(response, getLongRunningOperationRetryTimeout(), resourceType, restClient().mapperAdapter());
                        final String url = response.raw().request().url().toString();

                        // Task runner will take it from here
                        return Observable.just(pollingState)
                            // Emit a polling task intermittently
                            .repeatWhen(new Func1<Observable<? extends Void>, Observable<?>>() {
                                @Override
                                public Observable<?> call(Observable<? extends Void> observable) {
                                    return observable.delay(pollingState.getDelayInMilliseconds(), TimeUnit.MILLISECONDS);
                                }
                            })
                            // Conditionally polls if it's not a terminal status
                            .flatMap(new Func1<PollingState<T>, Observable<PollingState<T>>>() {
                                @Override
                                public Observable<PollingState<T>> call(PollingState<T> pollingState) {
                                    if (!AzureAsyncOperation.getTerminalStatuses().contains(pollingState.getStatus())) {
                                        return putOrPatchPollingDispatcher(pollingState, url);
                                    } else {
                                        return Observable.just(pollingState);
                                    }
                                }
                            })
                            // The above process continues until this filter passes
                            .filter(new Func1<PollingState<T>, Boolean>() {
                                @Override
                                public Boolean call(PollingState<T> pollingState) {
                                    return AzureAsyncOperation.getTerminalStatuses().contains(pollingState.getStatus());
                                }
                            })
                            .first()
                            // Possible extra get to receive the actual resource
                            .flatMap(new Func1<PollingState<T>, Observable<PollingState<T>>>() {
                                @Override
                                public Observable<PollingState<T>> call(PollingState<T> pollingState) {
                                    if (AzureAsyncOperation.SUCCESS_STATUS.equals(pollingState.getStatus()) && pollingState.getResource() == null) {
                                        return updateStateFromGetResourceOperationAsync(pollingState, url);
                                    }
                                    if (AzureAsyncOperation.getFailedStatuses().contains(pollingState.getStatus())) {
                                        return Observable.error(new CloudException("Async operation failed with provisioning state: " + pollingState.getStatus()));
                                    }
                                    return Observable.just(pollingState);
                                }
                            })
                            .map(new Func1<PollingState<T>, ServiceResponse<T>>() {
                                @Override
                                public ServiceResponse<T> call(PollingState<T> pollingState) {
                                    return new ServiceResponse<>(pollingState.getResource(), pollingState.getResponse());
                                }
                            });
                    } catch (IOException e) {
                        return Observable.error(e);
                    }
                }
            });
    }

    /**
     * Handles an initial response from a PUT or PATCH operation response by polling
     * the status of the operation asynchronously, calling the user provided callback
     * when the operation terminates.
     *
     * @param observable  the initial response from the PUT or PATCH operation.
     * @param <T>       the return type of the caller
     * @param <THeader> the type of the response header
     * @param resourceType the type of the resource.
     * @param headerType the type of the response header
     * @return          the task describing the asynchronous polling.
     */
    public <T, THeader> Observable<ServiceResponseWithHeaders<T, THeader>> getPutOrPatchResultWithHeadersAsync(Observable<Response<ResponseBody>> observable, Type resourceType, final Class<THeader> headerType) {
        Observable<ServiceResponse<T>> bodyResponse = getPutOrPatchResultAsync(observable, resourceType);
        return bodyResponse
            .flatMap(new Func1<ServiceResponse<T>, Observable<ServiceResponseWithHeaders<T, THeader>>>() {
                @Override
                public Observable<ServiceResponseWithHeaders<T, THeader>> call(ServiceResponse<T> serviceResponse) {
                    try {
                        return Observable
                            .just(new ServiceResponseWithHeaders<>(serviceResponse.getBody(),
                                restClient().mapperAdapter().<THeader>deserialize(restClient().mapperAdapter().serialize(serviceResponse.getResponse().headers()), headerType),
                                serviceResponse.getResponse()));
                    } catch (IOException e) {
                        return Observable.error(e);
                    }
                }
            });
    }

    /**
     * Handles an initial response from a POST or DELETE operation response by polling
     * the status of the operation until the long running operation terminates.
     *
     * @param observable  the initial observable from the POST or DELETE operation.
     * @param <T>       the return type of the caller
     * @param resourceType the type of the resource
     * @return          the terminal response for the operation.
     * @throws CloudException REST exception
     * @throws InterruptedException interrupted exception
     * @throws IOException thrown by deserialization
     */
    public <T> ServiceResponse<T> getPostOrDeleteResult(Observable<Response<ResponseBody>> observable, Type resourceType) throws CloudException, InterruptedException, IOException {
        Observable<ServiceResponse<T>> asyncObservable = getPutOrPatchResultAsync(observable, resourceType);
        return asyncObservable.toBlocking().last();
    }

    /**
     * Handles an initial response from a POST or DELETE operation response by polling
     * the status of the operation until the long running operation terminates.
     *
     * @param observable  the initial observable from the POST or DELETE operation.
     * @param resourceType the type of the resource
     * @param headerType the type of the response header
     * @param <T>       the return type of the caller
     * @param <THeader> the type of the response header
     * @return          the terminal response for the operation.
     * @throws CloudException REST exception
     * @throws InterruptedException interrupted exception
     * @throws IOException thrown by deserialization
     */
    public <T, THeader> ServiceResponseWithHeaders<T, THeader> getPostOrDeleteResultWithHeaders(Observable<Response<ResponseBody>> observable, Type resourceType, Class<THeader> headerType) throws CloudException, InterruptedException, IOException {
        ServiceResponse<T> bodyResponse = getPostOrDeleteResult(observable, resourceType);
        return new ServiceResponseWithHeaders<>(
            bodyResponse.getBody(),
            restClient().mapperAdapter().<THeader>deserialize(restClient().mapperAdapter().serialize(bodyResponse.getResponse().headers()), headerType),
            bodyResponse.getResponse()
        );
    }

    /**
     * Handles an initial response from a POST or DELETE operation response by polling
     * the status of the operation asynchronously, calling the user provided callback
     * when the operation terminates.
     *
     * @param observable  the initial response from the POST or DELETE operation.
     * @param <T>       the return type of the caller.
     * @param resourceType the type of the resource.
     * @return          the task describing the asynchronous polling.
     */
    public <T> Observable<ServiceResponse<T>> getPostOrDeleteResultAsync(Observable<Response<ResponseBody>> observable, final Type resourceType) {
        return observable
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<T>>>() {
                @Override
                public Observable<ServiceResponse<T>> call(Response<ResponseBody> response) {
                    CloudException exception = createExceptionFromResponse(response, 200, 202, 204);
                    if (exception != null) {
                        return Observable.error(exception);
                    }

                    try {
                        final PollingState<T> pollingState = new PollingState<>(response, getLongRunningOperationRetryTimeout(), resourceType, restClient().mapperAdapter());
                        return Observable.just(pollingState)
                            // Emit a polling task intermittently
                            .repeatWhen(new Func1<Observable<? extends Void>, Observable<?>>() {
                                @Override
                                public Observable<?> call(Observable<? extends Void> observable) {
                                    return observable.delay(pollingState.getDelayInMilliseconds(), TimeUnit.MILLISECONDS);
                                }
                            })
                            // Conditionally polls if it's not a terminal status
                            .flatMap(new Func1<PollingState<T>, Observable<PollingState<T>>>() {
                                @Override
                                public Observable<PollingState<T>> call(PollingState<T> pollingState) {
                                    if (!AzureAsyncOperation.getTerminalStatuses().contains(pollingState.getStatus())) {
                                        return postOrDeletePollingDispatcher(pollingState);
                                    }
                                    return Observable.just(pollingState);
                                }
                            })
                            // The above process continues until this filter passes
                            .filter(new Func1<PollingState<T>, Boolean>() {
                                @Override
                                public Boolean call(PollingState<T> pollingState) {
                                    return AzureAsyncOperation.getTerminalStatuses().contains(pollingState.getStatus());
                                }
                            })
                            .first()
                            .flatMap(new Func1<PollingState<T>, Observable<ServiceResponse<T>>>() {
                                @Override
                                public Observable<ServiceResponse<T>> call(PollingState<T> pollingState) {
                                    if (AzureAsyncOperation.getFailedStatuses().contains(pollingState.getStatus())) {
                                        return Observable.error(new CloudException("Async operation failed with provisioning state: " + pollingState.getStatus()));
                                    } else {
                                        return Observable.just(new ServiceResponse<>(pollingState.getResource(), pollingState.getResponse()));
                                    }
                                }
                            });
                    } catch (IOException e) {
                        return Observable.error(e);
                    }
                }
            });
    }

    /**
     * Handles an initial response from a POST or DELETE operation response by polling
     * the status of the operation asynchronously, calling the user provided callback
     * when the operation terminates.
     *
     * @param observable  the initial observable from the POST or DELETE operation.
     * @param <T>       the return type of the caller
     * @param <THeader> the type of the response header
     * @param resourceType the type of the resource.
     * @param headerType the type of the response header
     * @return          the task describing the asynchronous polling.
     */
    public <T, THeader> Observable<ServiceResponseWithHeaders<T, THeader>> getPostOrDeleteResultWithHeadersAsync(Observable<Response<ResponseBody>> observable, Type resourceType, final Class<THeader> headerType) {
        Observable<ServiceResponse<T>> bodyResponse = getPostOrDeleteResultAsync(observable, resourceType);
        return bodyResponse
            .flatMap(new Func1<ServiceResponse<T>, Observable<ServiceResponseWithHeaders<T, THeader>>>() {
                @Override
                public Observable<ServiceResponseWithHeaders<T, THeader>> call(ServiceResponse<T> serviceResponse) {
                    try {
                        return Observable
                            .just(new ServiceResponseWithHeaders<>(serviceResponse.getBody(),
                                restClient().mapperAdapter().<THeader>deserialize(restClient().mapperAdapter().serialize(serviceResponse.getResponse().headers()), headerType),
                                serviceResponse.getResponse()));
                    } catch (IOException e) {
                        return Observable.error(e);
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
     */
    private <T> Observable<PollingState<T>> updateStateFromLocationHeaderOnPutAsync(final PollingState<T> pollingState) {
        return pollAsync(pollingState.getLocationHeaderLink())
            .flatMap(new Func1<Response<ResponseBody>, Observable<PollingState<T>>>() {
                @Override
                public Observable<PollingState<T>> call(Response<ResponseBody> response) {
                    int statusCode = response.code();
                    if (statusCode == 202) {
                        pollingState.setResponse(response);
                        pollingState.setStatus(AzureAsyncOperation.IN_PROGRESS_STATUS);
                    } else if (statusCode == 200 || statusCode == 201) {
                        try {
                            pollingState.updateFromResponseOnPutPatch(response);
                        } catch (CloudException | IOException e) {
                            return Observable.error(e);
                        }
                    }
                    return Observable.just(pollingState);
                }
            });
    }

    /**
     * Polls from the location header and updates the polling state with the
     * polling response for a POST or DELETE operation.
     *
     * @param pollingState the polling state for the current operation.
     * @param <T> the return type of the caller.
     */
    private <T> Observable<PollingState<T>> updateStateFromLocationHeaderOnPostOrDeleteAsync(final PollingState<T> pollingState) {
        return pollAsync(pollingState.getLocationHeaderLink())
            .flatMap(new Func1<Response<ResponseBody>, Observable<PollingState<T>>>() {
                @Override
                public Observable<PollingState<T>> call(Response<ResponseBody> response) {
                    int statusCode = response.code();
                    if (statusCode == 202) {
                        pollingState.setResponse(response);
                        pollingState.setStatus(AzureAsyncOperation.IN_PROGRESS_STATUS);
                    } else if (statusCode == 200 || statusCode == 201 || statusCode == 204) {
                        try {
                            pollingState.updateFromResponseOnDeletePost(response);
                        } catch (IOException e) {
                            return Observable.error(e);
                        }
                    }
                    return Observable.just(pollingState);
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
     */
    private <T> Observable<PollingState<T>> updateStateFromGetResourceOperationAsync(final PollingState<T> pollingState, String url) {
        return pollAsync(url)
            .flatMap(new Func1<Response<ResponseBody>, Observable<PollingState<T>>>() {
                @Override
                public Observable<PollingState<T>> call(Response<ResponseBody> response) {
                    try {
                        pollingState.updateFromResponseOnPutPatch(response);
                        return Observable.just(pollingState);
                    } catch (CloudException | IOException e) {
                        return Observable.error(e);
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
     */
    private <T> Observable<PollingState<T>> updateStateFromAzureAsyncOperationHeaderAsync(final PollingState<T> pollingState) {
        return pollAsync(pollingState.getAzureAsyncOperationHeaderLink())
            .flatMap(new Func1<Response<ResponseBody>, Observable<PollingState<T>>>() {
                @Override
                public Observable<PollingState<T>> call(Response<ResponseBody> response) {
                    AzureAsyncOperation body = null;
                    if (response.body() != null) {
                        try {
                            body = restClient().mapperAdapter().deserialize(response.body().string(), AzureAsyncOperation.class);
                            response.body().close();
                        } catch (IOException e) {
                            body = null;
                        }
                    }

                    if (body == null || body.getStatus() == null) {
                        CloudException exception = new CloudException("polling response does not contain a valid body: " + body);
                        exception.setResponse(response);
                        return Observable.error(exception);
                    }

                    pollingState.setStatus(body.getStatus());
                    pollingState.setResponse(response);
                    pollingState.setResource(null);
                    return Observable.just(pollingState);
                }
            });
    }

    /**
     * Polls from the URL provided.
     *
     * @param url the URL to poll from.
     * @return the raw response.
     */
    private Observable<Response<ResponseBody>> pollAsync(String url) {
        URL endpoint;
        try {
            endpoint = new URL(url);
        } catch (MalformedURLException e) {
            return Observable.error(e);
        }
        int port = endpoint.getPort();
        if (port == -1) {
            port = endpoint.getDefaultPort();
        }
        AsyncService service = restClient().retrofit().create(AsyncService.class);
        return service.get(endpoint.getFile(), serviceClientUserAgent)
            .flatMap(new Func1<Response<ResponseBody>, Observable<Response<ResponseBody>>>() {
                @Override
                public Observable<Response<ResponseBody>> call(Response<ResponseBody> response) {
                    CloudException exception = createExceptionFromResponse(response, 200, 201, 202, 204);
                    if (exception != null) {
                        return Observable.error(exception);
                    } else {
                        return Observable.just(response);
                    }
                }
            });
    }

    private CloudException createExceptionFromResponse(Response<ResponseBody> response, Integer... allowedStatusCodes) {
        int statusCode = response.code();
        ResponseBody responseBody;
        if (response.isSuccessful()) {
            responseBody = response.body();
        } else {
            responseBody = response.errorBody();
        }
        if (!Arrays.asList(allowedStatusCodes).contains(statusCode)) {
            CloudException exception;
            try {
                CloudError errorBody = restClient().mapperAdapter().deserialize(responseBody.string(), CloudError.class);
                if (errorBody != null) {
                    exception = new CloudException(errorBody.getMessage());
                } else {
                    exception = new CloudException("Unknown error with status code " + statusCode);
                }
                exception.setBody(errorBody);
                exception.setResponse(response);
                return exception;
            } catch (Exception e) {
                /* ignore serialization errors on top of service errors */
                return new CloudException("Unknown error with status code " + statusCode, e);
            }
        }
        return null;
    }

    private <T> Observable<PollingState<T>> putOrPatchPollingDispatcher(PollingState<T> pollingState, String url) {
        if (pollingState.getAzureAsyncOperationHeaderLink() != null
            && !pollingState.getAzureAsyncOperationHeaderLink().isEmpty()) {
            return updateStateFromAzureAsyncOperationHeaderAsync(pollingState);
        } else if (pollingState.getLocationHeaderLink() != null
            && !pollingState.getLocationHeaderLink().isEmpty()) {
            return updateStateFromLocationHeaderOnPutAsync(pollingState);
        } else {
            return updateStateFromGetResourceOperationAsync(pollingState, url);
        }
    }

    private <T> Observable<PollingState<T>> postOrDeletePollingDispatcher(PollingState<T> pollingState) {
        if (pollingState.getAzureAsyncOperationHeaderLink() != null
            && !pollingState.getAzureAsyncOperationHeaderLink().isEmpty()) {
            return updateStateFromAzureAsyncOperationHeaderAsync(pollingState);
        } else if (pollingState.getLocationHeaderLink() != null
            && !pollingState.getLocationHeaderLink().isEmpty()) {
            return updateStateFromLocationHeaderOnPostOrDeleteAsync(pollingState);
        } else {
            CloudException exception = new CloudException("Response does not contain an Azure-AsyncOperation or Location header.");
            exception.setBody(pollingState.getError());
            exception.setResponse(pollingState.getResponse());
            return Observable.error(exception);
        }
    }

    /**
     * The Retrofit service used for polling.
     */
    private interface AsyncService {
        @GET
        Observable<Response<ResponseBody>> get(@Url String url, @Header("User-Agent") String userAgent);
    }
}