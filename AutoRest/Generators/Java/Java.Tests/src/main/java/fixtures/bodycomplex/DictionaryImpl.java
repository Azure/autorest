/**
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 * 
 * Code generated by Microsoft (R) AutoRest Code Generator 0.13.0.0
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

package fixtures.bodycomplex;

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
import fixtures.bodycomplex.models.DictionaryWrapper;
import fixtures.bodycomplex.models.Error;
import com.microsoft.rest.Validator;

public class DictionaryImpl implements Dictionary {
    private DictionaryService service;
    AutoRestComplexTestService client;

    public DictionaryImpl(Retrofit retrofit, AutoRestComplexTestService client) {
        this.service = retrofit.create(DictionaryService.class);
        this.client = client;
    }

    /**
     * Get complex types with dictionary property
     *
     * @return the DictionaryWrapper object if successful.
     * @throws ServiceException the exception wrapped in ServiceException if failed.
     */
    public DictionaryWrapper getValid() throws ServiceException {
        try {
            Call<ResponseBody> call = service.getValid();
            ServiceResponse<DictionaryWrapper> response = getValidDelegate(call.execute(), null);
            return response.getBody();
        } catch (ServiceException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * Get complex types with dictionary property
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     */
    public Call<ResponseBody> getValidAsync(final ServiceCallback<DictionaryWrapper> serviceCallback) {
        Call<ResponseBody> call = service.getValid();
        call.enqueue(new ServiceResponseCallback<DictionaryWrapper>(serviceCallback) {
            @Override
            public void onResponse(Response<ResponseBody> response, Retrofit retrofit) {
                try {
                    serviceCallback.success(getValidDelegate(response, retrofit));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<DictionaryWrapper> getValidDelegate(Response<ResponseBody> response, Retrofit retrofit) throws ServiceException {
        return new ServiceResponseBuilder<DictionaryWrapper>()
                .register(200, new TypeToken<DictionaryWrapper>(){}.getType())
                .registerError(new TypeToken<Error>(){}.getType())
                .build(response, retrofit);
    }

    /**
     * Put complex types with dictionary property
     *
     * @param complexBody Please put a dictionary with 5 key-value pairs: "txt":"notepad", "bmp":"mspaint", "xls":"excel", "exe":"", "":null
     * @throws ServiceException the exception wrapped in ServiceException if failed.
     */
    public void putValid(DictionaryWrapper complexBody) throws ServiceException {
        if (complexBody == null) {
            throw new ServiceException(
                new IllegalArgumentException("Parameter complexBody is required and cannot be null."));
        }
        Validator.validate(complexBody);
        try {
            Call<ResponseBody> call = service.putValid(complexBody);
            ServiceResponse<Void> response = putValidDelegate(call.execute(), null);
            response.getBody();
        } catch (ServiceException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * Put complex types with dictionary property
     *
     * @param complexBody Please put a dictionary with 5 key-value pairs: "txt":"notepad", "bmp":"mspaint", "xls":"excel", "exe":"", "":null
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     */
    public Call<ResponseBody> putValidAsync(DictionaryWrapper complexBody, final ServiceCallback<Void> serviceCallback) {
        if (complexBody == null) {
            serviceCallback.failure(new ServiceException(
                new IllegalArgumentException("Parameter complexBody is required and cannot be null.")));
        }
        Validator.validate(complexBody, serviceCallback);
        Call<ResponseBody> call = service.putValid(complexBody);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCallback) {
            @Override
            public void onResponse(Response<ResponseBody> response, Retrofit retrofit) {
                try {
                    serviceCallback.success(putValidDelegate(response, retrofit));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<Void> putValidDelegate(Response<ResponseBody> response, Retrofit retrofit) throws ServiceException {
        return new ServiceResponseBuilder<Void>()
                .register(200, new TypeToken<Void>(){}.getType())
                .registerError(new TypeToken<Error>(){}.getType())
                .build(response, retrofit);
    }

    /**
     * Get complex types with dictionary property which is empty
     *
     * @return the DictionaryWrapper object if successful.
     * @throws ServiceException the exception wrapped in ServiceException if failed.
     */
    public DictionaryWrapper getEmpty() throws ServiceException {
        try {
            Call<ResponseBody> call = service.getEmpty();
            ServiceResponse<DictionaryWrapper> response = getEmptyDelegate(call.execute(), null);
            return response.getBody();
        } catch (ServiceException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * Get complex types with dictionary property which is empty
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     */
    public Call<ResponseBody> getEmptyAsync(final ServiceCallback<DictionaryWrapper> serviceCallback) {
        Call<ResponseBody> call = service.getEmpty();
        call.enqueue(new ServiceResponseCallback<DictionaryWrapper>(serviceCallback) {
            @Override
            public void onResponse(Response<ResponseBody> response, Retrofit retrofit) {
                try {
                    serviceCallback.success(getEmptyDelegate(response, retrofit));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<DictionaryWrapper> getEmptyDelegate(Response<ResponseBody> response, Retrofit retrofit) throws ServiceException {
        return new ServiceResponseBuilder<DictionaryWrapper>()
                .register(200, new TypeToken<DictionaryWrapper>(){}.getType())
                .registerError(new TypeToken<Error>(){}.getType())
                .build(response, retrofit);
    }

    /**
     * Put complex types with dictionary property which is empty
     *
     * @param complexBody Please put an empty dictionary
     * @throws ServiceException the exception wrapped in ServiceException if failed.
     */
    public void putEmpty(DictionaryWrapper complexBody) throws ServiceException {
        if (complexBody == null) {
            throw new ServiceException(
                new IllegalArgumentException("Parameter complexBody is required and cannot be null."));
        }
        Validator.validate(complexBody);
        try {
            Call<ResponseBody> call = service.putEmpty(complexBody);
            ServiceResponse<Void> response = putEmptyDelegate(call.execute(), null);
            response.getBody();
        } catch (ServiceException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * Put complex types with dictionary property which is empty
     *
     * @param complexBody Please put an empty dictionary
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     */
    public Call<ResponseBody> putEmptyAsync(DictionaryWrapper complexBody, final ServiceCallback<Void> serviceCallback) {
        if (complexBody == null) {
            serviceCallback.failure(new ServiceException(
                new IllegalArgumentException("Parameter complexBody is required and cannot be null.")));
        }
        Validator.validate(complexBody, serviceCallback);
        Call<ResponseBody> call = service.putEmpty(complexBody);
        call.enqueue(new ServiceResponseCallback<Void>(serviceCallback) {
            @Override
            public void onResponse(Response<ResponseBody> response, Retrofit retrofit) {
                try {
                    serviceCallback.success(putEmptyDelegate(response, retrofit));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<Void> putEmptyDelegate(Response<ResponseBody> response, Retrofit retrofit) throws ServiceException {
        return new ServiceResponseBuilder<Void>()
                .register(200, new TypeToken<Void>(){}.getType())
                .registerError(new TypeToken<Error>(){}.getType())
                .build(response, retrofit);
    }

    /**
     * Get complex types with dictionary property which is null
     *
     * @return the DictionaryWrapper object if successful.
     * @throws ServiceException the exception wrapped in ServiceException if failed.
     */
    public DictionaryWrapper getNull() throws ServiceException {
        try {
            Call<ResponseBody> call = service.getNull();
            ServiceResponse<DictionaryWrapper> response = getNullDelegate(call.execute(), null);
            return response.getBody();
        } catch (ServiceException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * Get complex types with dictionary property which is null
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     */
    public Call<ResponseBody> getNullAsync(final ServiceCallback<DictionaryWrapper> serviceCallback) {
        Call<ResponseBody> call = service.getNull();
        call.enqueue(new ServiceResponseCallback<DictionaryWrapper>(serviceCallback) {
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

    private ServiceResponse<DictionaryWrapper> getNullDelegate(Response<ResponseBody> response, Retrofit retrofit) throws ServiceException {
        return new ServiceResponseBuilder<DictionaryWrapper>()
                .register(200, new TypeToken<DictionaryWrapper>(){}.getType())
                .registerError(new TypeToken<Error>(){}.getType())
                .build(response, retrofit);
    }

    /**
     * Get complex types with dictionary property while server doesn't provide a response payload
     *
     * @return the DictionaryWrapper object if successful.
     * @throws ServiceException the exception wrapped in ServiceException if failed.
     */
    public DictionaryWrapper getNotProvided() throws ServiceException {
        try {
            Call<ResponseBody> call = service.getNotProvided();
            ServiceResponse<DictionaryWrapper> response = getNotProvidedDelegate(call.execute(), null);
            return response.getBody();
        } catch (ServiceException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * Get complex types with dictionary property while server doesn't provide a response payload
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     */
    public Call<ResponseBody> getNotProvidedAsync(final ServiceCallback<DictionaryWrapper> serviceCallback) {
        Call<ResponseBody> call = service.getNotProvided();
        call.enqueue(new ServiceResponseCallback<DictionaryWrapper>(serviceCallback) {
            @Override
            public void onResponse(Response<ResponseBody> response, Retrofit retrofit) {
                try {
                    serviceCallback.success(getNotProvidedDelegate(response, retrofit));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
        return call;
    }

    private ServiceResponse<DictionaryWrapper> getNotProvidedDelegate(Response<ResponseBody> response, Retrofit retrofit) throws ServiceException {
        return new ServiceResponseBuilder<DictionaryWrapper>()
                .register(200, new TypeToken<DictionaryWrapper>(){}.getType())
                .registerError(new TypeToken<Error>(){}.getType())
                .build(response, retrofit);
    }

}
