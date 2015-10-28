/**
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 * 
 * Code generated by Microsoft (R) AutoRest Code Generator 0.13.0.0
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

package fixtures.bodyduration;

import com.google.common.reflect.TypeToken;
import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceException;
import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.ServiceResponseBuilder;
import com.microsoft.rest.ServiceResponseCallback;
import com.microsoft.rest.ServiceResponseEmptyCallback;
import com.squareup.okhttp.ResponseBody;
import retrofit.Retrofit;
import retrofit.Call;
import retrofit.Response;
import org.joda.time.Period;
import fixtures.bodyduration.models.Error;

public class DurationImpl implements Duration {
    private DurationService service;
    AutoRestDurationTestService client;

    public DurationImpl(Retrofit retrofit, AutoRestDurationTestService client) {
        this.service = retrofit.create(DurationService.class);
        this.client = client;
    }

    /**
     * Get null duration value
     *
     * @return the Period object if successful.
     * @throws ServiceException the exception wrapped in ServiceException if failed.
     */
    public Period getNull() throws ServiceException {
        try {
            Call<ResponseBody> call = service.getNull();
            ServiceResponse<Period> response = getNullDelegate(call.execute(), null);
            return response.getBody();
        } catch (ServiceException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * Get null duration value
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     */
    public Call<ResponseBody> getNullAsync(final ServiceCallback<Period> serviceCallback) {
        Call<ResponseBody> call = service.getNull();
        call.enqueue(new ServiceResponseCallback<Period>(serviceCallback) {
            @Override
            public void onResponse(Response<ResponseBody> response, Retrofit retrofit) {
                try {
                    serviceCallback.success(getNullDelegate(response, retrofit));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<Period> getNullDelegate(Response<ResponseBody> response, Retrofit retrofit) throws ServiceException {
        return new ServiceResponseBuilder<Period>()
                .register(200, new TypeToken<Period>(){}.getType())
                .registerError(new TypeToken<Error>(){}.getType())
                .build(response, retrofit);
    }

    /**
     * Put a positive duration value
     *
     * @param durationBody the Period value
     * @throws ServiceException the exception wrapped in ServiceException if failed.
     */
    public void putPositiveDuration(Period durationBody) throws ServiceException {
        if (durationBody == null) {
            throw new ServiceException(
                new IllegalArgumentException("Parameter durationBody is required and cannot be null."));
        }
        try {
            Call<ResponseBody> call = service.putPositiveDuration(durationBody);
            ServiceResponse<Void> response = putPositiveDurationDelegate(call.execute(), null);
            response.getBody();
        } catch (ServiceException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * Put a positive duration value
     *
     * @param durationBody the Period value
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     */
    public Call<ResponseBody> putPositiveDurationAsync(Period durationBody, final ServiceCallback<Void> serviceCallback) {
        if (durationBody == null) {
            serviceCallback.failure(new ServiceException(
                new IllegalArgumentException("Parameter durationBody is required and cannot be null.")));
        }
        Call<ResponseBody> call = service.putPositiveDuration(durationBody);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCallback) {
            @Override
            public void onResponse(Response<ResponseBody> response, Retrofit retrofit) {
                try {
                    serviceCallback.success(putPositiveDurationDelegate(response, retrofit));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<Void> putPositiveDurationDelegate(Response<ResponseBody> response, Retrofit retrofit) throws ServiceException {
        return new ServiceResponseBuilder<Void>()
                .register(200, new TypeToken<Void>(){}.getType())
                .registerError(new TypeToken<Error>(){}.getType())
                .build(response, retrofit);
    }

    /**
     * Get a positive duration value
     *
     * @return the Period object if successful.
     * @throws ServiceException the exception wrapped in ServiceException if failed.
     */
    public Period getPositiveDuration() throws ServiceException {
        try {
            Call<ResponseBody> call = service.getPositiveDuration();
            ServiceResponse<Period> response = getPositiveDurationDelegate(call.execute(), null);
            return response.getBody();
        } catch (ServiceException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * Get a positive duration value
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     */
    public Call<ResponseBody> getPositiveDurationAsync(final ServiceCallback<Period> serviceCallback) {
        Call<ResponseBody> call = service.getPositiveDuration();
        call.enqueue(new ServiceResponseCallback<Period>(serviceCallback) {
            @Override
            public void onResponse(Response<ResponseBody> response, Retrofit retrofit) {
                try {
                    serviceCallback.success(getPositiveDurationDelegate(response, retrofit));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<Period> getPositiveDurationDelegate(Response<ResponseBody> response, Retrofit retrofit) throws ServiceException {
        return new ServiceResponseBuilder<Period>()
                .register(200, new TypeToken<Period>(){}.getType())
                .registerError(new TypeToken<Error>(){}.getType())
                .build(response, retrofit);
    }

    /**
     * Get an invalid duration value
     *
     * @return the Period object if successful.
     * @throws ServiceException the exception wrapped in ServiceException if failed.
     */
    public Period getInvalid() throws ServiceException {
        try {
            Call<ResponseBody> call = service.getInvalid();
            ServiceResponse<Period> response = getInvalidDelegate(call.execute(), null);
            return response.getBody();
        } catch (ServiceException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * Get an invalid duration value
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     */
    public Call<ResponseBody> getInvalidAsync(final ServiceCallback<Period> serviceCallback) {
        Call<ResponseBody> call = service.getInvalid();
        call.enqueue(new ServiceResponseCallback<Period>(serviceCallback) {
            @Override
            public void onResponse(Response<ResponseBody> response, Retrofit retrofit) {
                try {
                    serviceCallback.success(getInvalidDelegate(response, retrofit));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<Period> getInvalidDelegate(Response<ResponseBody> response, Retrofit retrofit) throws ServiceException {
        return new ServiceResponseBuilder<Period>()
                .register(200, new TypeToken<Period>(){}.getType())
                .registerError(new TypeToken<Error>(){}.getType())
                .build(response, retrofit);
    }

}
