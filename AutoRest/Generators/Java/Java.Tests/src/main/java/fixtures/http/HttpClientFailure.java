// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator 0.11.0.0
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.


package fixtures.http;

import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceException;
import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.ServiceResponseBuilder;
import com.microsoft.rest.ServiceResponseCallback;
import retrofit.client.Response;
import retrofit.RestAdapter;
import retrofit.RetrofitError;
import fixtures.http.models.Error;
import retrofit.http.HEAD;
import retrofit.http.GET;
import retrofit.http.PUT;
import retrofit.http.Body;
import retrofit.http.PATCH;
import retrofit.http.POST;
import retrofit.http.DELETE;

public class HttpClientFailure {
    private HttpClientFailureService service;
    public HttpClientFailure(RestAdapter restAdapter) {
        service = restAdapter.create(HttpClientFailureService.class);
    }
    public interface HttpClientFailureService {
        @HEAD("/http/failure/client/400")
        Error head400() throws ServiceException;

        @HEAD("/http/failure/client/400")
        void head400Async(ServiceCallback<Error> serviceCallback);

        @GET("/http/failure/client/400")
        Error get400() throws ServiceException;

        @GET("/http/failure/client/400")
        void get400Async(ServiceCallback<Error> serviceCallback);

        @PUT("/http/failure/client/400")
        Error put400(@Body Boolean booleanValue) throws ServiceException;

        @PUT("/http/failure/client/400")
        void put400Async(@Body Boolean booleanValue, ServiceCallback<Error> serviceCallback);

        @PATCH("/http/failure/client/400")
        Error patch400(@Body Boolean booleanValue) throws ServiceException;

        @PATCH("/http/failure/client/400")
        void patch400Async(@Body Boolean booleanValue, ServiceCallback<Error> serviceCallback);

        @POST("/http/failure/client/400")
        Error post400(@Body Boolean booleanValue) throws ServiceException;

        @POST("/http/failure/client/400")
        void post400Async(@Body Boolean booleanValue, ServiceCallback<Error> serviceCallback);

        @DELETE("/http/failure/client/400")
        Error delete400(@Body Boolean booleanValue) throws ServiceException;

        @DELETE("/http/failure/client/400")
        void delete400Async(@Body Boolean booleanValue, ServiceCallback<Error> serviceCallback);

        @HEAD("/http/failure/client/401")
        Error head401() throws ServiceException;

        @HEAD("/http/failure/client/401")
        void head401Async(ServiceCallback<Error> serviceCallback);

        @GET("/http/failure/client/402")
        Error get402() throws ServiceException;

        @GET("/http/failure/client/402")
        void get402Async(ServiceCallback<Error> serviceCallback);

        @GET("/http/failure/client/403")
        Error get403() throws ServiceException;

        @GET("/http/failure/client/403")
        void get403Async(ServiceCallback<Error> serviceCallback);

        @PUT("/http/failure/client/404")
        Error put404(@Body Boolean booleanValue) throws ServiceException;

        @PUT("/http/failure/client/404")
        void put404Async(@Body Boolean booleanValue, ServiceCallback<Error> serviceCallback);

        @PATCH("/http/failure/client/405")
        Error patch405(@Body Boolean booleanValue) throws ServiceException;

        @PATCH("/http/failure/client/405")
        void patch405Async(@Body Boolean booleanValue, ServiceCallback<Error> serviceCallback);

        @POST("/http/failure/client/406")
        Error post406(@Body Boolean booleanValue) throws ServiceException;

        @POST("/http/failure/client/406")
        void post406Async(@Body Boolean booleanValue, ServiceCallback<Error> serviceCallback);

        @DELETE("/http/failure/client/407")
        Error delete407(@Body Boolean booleanValue) throws ServiceException;

        @DELETE("/http/failure/client/407")
        void delete407Async(@Body Boolean booleanValue, ServiceCallback<Error> serviceCallback);

        @PUT("/http/failure/client/409")
        Error put409(@Body Boolean booleanValue) throws ServiceException;

        @PUT("/http/failure/client/409")
        void put409Async(@Body Boolean booleanValue, ServiceCallback<Error> serviceCallback);

        @HEAD("/http/failure/client/410")
        Error head410() throws ServiceException;

        @HEAD("/http/failure/client/410")
        void head410Async(ServiceCallback<Error> serviceCallback);

        @GET("/http/failure/client/411")
        Error get411() throws ServiceException;

        @GET("/http/failure/client/411")
        void get411Async(ServiceCallback<Error> serviceCallback);

        @GET("/http/failure/client/412")
        Error get412() throws ServiceException;

        @GET("/http/failure/client/412")
        void get412Async(ServiceCallback<Error> serviceCallback);

        @PUT("/http/failure/client/413")
        Error put413(@Body Boolean booleanValue) throws ServiceException;

        @PUT("/http/failure/client/413")
        void put413Async(@Body Boolean booleanValue, ServiceCallback<Error> serviceCallback);

        @PATCH("/http/failure/client/414")
        Error patch414(@Body Boolean booleanValue) throws ServiceException;

        @PATCH("/http/failure/client/414")
        void patch414Async(@Body Boolean booleanValue, ServiceCallback<Error> serviceCallback);

        @POST("/http/failure/client/415")
        Error post415(@Body Boolean booleanValue) throws ServiceException;

        @POST("/http/failure/client/415")
        void post415Async(@Body Boolean booleanValue, ServiceCallback<Error> serviceCallback);

        @GET("/http/failure/client/416")
        Error get416() throws ServiceException;

        @GET("/http/failure/client/416")
        void get416Async(ServiceCallback<Error> serviceCallback);

        @DELETE("/http/failure/client/417")
        Error delete417(@Body Boolean booleanValue) throws ServiceException;

        @DELETE("/http/failure/client/417")
        void delete417Async(@Body Boolean booleanValue, ServiceCallback<Error> serviceCallback);

        @HEAD("/http/failure/client/429")
        Error head429() throws ServiceException;

        @HEAD("/http/failure/client/429")
        void head429Async(ServiceCallback<Error> serviceCallback);

    }
    public Error head400() throws ServiceException {
        try {
            return head400Delegate(service.head400(), null).getBody();
        } catch (RetrofitError error) {
            return head400Delegate(error.getResponse(), error).getBody();
        }
    }

    public void head400Async(final ServiceCallback<Error> serviceCallback) {
        service.head400Asyncd(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(head400Delegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Error> head400Delegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Error>()
                  .registerError(Error)
                  .build(response, error);
    }

    public Error get400() throws ServiceException {
        try {
            return get400Delegate(service.get400(), null).getBody();
        } catch (RetrofitError error) {
            return get400Delegate(error.getResponse(), error).getBody();
        }
    }

    public void get400Async(final ServiceCallback<Error> serviceCallback) {
        service.get400Asyncd(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(get400Delegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Error> get400Delegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Error>()
                  .registerError(Error)
                  .build(response, error);
    }

    public Error put400(Boolean booleanValue) throws ServiceException {
        try {
            return put400Delegate(service.put400(booleanValue), null).getBody();
        } catch (RetrofitError error) {
            return put400Delegate(error.getResponse(), error).getBody();
        }
    }

    public void put400Async(Boolean booleanValue, final ServiceCallback<Error> serviceCallback) {
        service.put400Asyncd(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(put400Delegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Error> put400Delegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Error>()
                  .registerError(Error)
                  .build(response, error);
    }

    public Error patch400(Boolean booleanValue) throws ServiceException {
        try {
            return patch400Delegate(service.patch400(booleanValue), null).getBody();
        } catch (RetrofitError error) {
            return patch400Delegate(error.getResponse(), error).getBody();
        }
    }

    public void patch400Async(Boolean booleanValue, final ServiceCallback<Error> serviceCallback) {
        service.patch400Asyncd(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(patch400Delegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Error> patch400Delegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Error>()
                  .registerError(Error)
                  .build(response, error);
    }

    public Error post400(Boolean booleanValue) throws ServiceException {
        try {
            return post400Delegate(service.post400(booleanValue), null).getBody();
        } catch (RetrofitError error) {
            return post400Delegate(error.getResponse(), error).getBody();
        }
    }

    public void post400Async(Boolean booleanValue, final ServiceCallback<Error> serviceCallback) {
        service.post400Asyncd(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(post400Delegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Error> post400Delegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Error>()
                  .registerError(Error)
                  .build(response, error);
    }

    public Error delete400(Boolean booleanValue) throws ServiceException {
        try {
            return delete400Delegate(service.delete400(booleanValue), null).getBody();
        } catch (RetrofitError error) {
            return delete400Delegate(error.getResponse(), error).getBody();
        }
    }

    public void delete400Async(Boolean booleanValue, final ServiceCallback<Error> serviceCallback) {
        service.delete400Asyncd(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(delete400Delegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Error> delete400Delegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Error>()
                  .registerError(Error)
                  .build(response, error);
    }

    public Error head401() throws ServiceException {
        try {
            return head401Delegate(service.head401(), null).getBody();
        } catch (RetrofitError error) {
            return head401Delegate(error.getResponse(), error).getBody();
        }
    }

    public void head401Async(final ServiceCallback<Error> serviceCallback) {
        service.head401Asyncd(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(head401Delegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Error> head401Delegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Error>()
                  .registerError(Error)
                  .build(response, error);
    }

    public Error get402() throws ServiceException {
        try {
            return get402Delegate(service.get402(), null).getBody();
        } catch (RetrofitError error) {
            return get402Delegate(error.getResponse(), error).getBody();
        }
    }

    public void get402Async(final ServiceCallback<Error> serviceCallback) {
        service.get402Asyncd(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(get402Delegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Error> get402Delegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Error>()
                  .registerError(Error)
                  .build(response, error);
    }

    public Error get403() throws ServiceException {
        try {
            return get403Delegate(service.get403(), null).getBody();
        } catch (RetrofitError error) {
            return get403Delegate(error.getResponse(), error).getBody();
        }
    }

    public void get403Async(final ServiceCallback<Error> serviceCallback) {
        service.get403Asyncd(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(get403Delegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Error> get403Delegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Error>()
                  .registerError(Error)
                  .build(response, error);
    }

    public Error put404(Boolean booleanValue) throws ServiceException {
        try {
            return put404Delegate(service.put404(booleanValue), null).getBody();
        } catch (RetrofitError error) {
            return put404Delegate(error.getResponse(), error).getBody();
        }
    }

    public void put404Async(Boolean booleanValue, final ServiceCallback<Error> serviceCallback) {
        service.put404Asyncd(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(put404Delegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Error> put404Delegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Error>()
                  .registerError(Error)
                  .build(response, error);
    }

    public Error patch405(Boolean booleanValue) throws ServiceException {
        try {
            return patch405Delegate(service.patch405(booleanValue), null).getBody();
        } catch (RetrofitError error) {
            return patch405Delegate(error.getResponse(), error).getBody();
        }
    }

    public void patch405Async(Boolean booleanValue, final ServiceCallback<Error> serviceCallback) {
        service.patch405Asyncd(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(patch405Delegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Error> patch405Delegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Error>()
                  .registerError(Error)
                  .build(response, error);
    }

    public Error post406(Boolean booleanValue) throws ServiceException {
        try {
            return post406Delegate(service.post406(booleanValue), null).getBody();
        } catch (RetrofitError error) {
            return post406Delegate(error.getResponse(), error).getBody();
        }
    }

    public void post406Async(Boolean booleanValue, final ServiceCallback<Error> serviceCallback) {
        service.post406Asyncd(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(post406Delegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Error> post406Delegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Error>()
                  .registerError(Error)
                  .build(response, error);
    }

    public Error delete407(Boolean booleanValue) throws ServiceException {
        try {
            return delete407Delegate(service.delete407(booleanValue), null).getBody();
        } catch (RetrofitError error) {
            return delete407Delegate(error.getResponse(), error).getBody();
        }
    }

    public void delete407Async(Boolean booleanValue, final ServiceCallback<Error> serviceCallback) {
        service.delete407Asyncd(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(delete407Delegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Error> delete407Delegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Error>()
                  .registerError(Error)
                  .build(response, error);
    }

    public Error put409(Boolean booleanValue) throws ServiceException {
        try {
            return put409Delegate(service.put409(booleanValue), null).getBody();
        } catch (RetrofitError error) {
            return put409Delegate(error.getResponse(), error).getBody();
        }
    }

    public void put409Async(Boolean booleanValue, final ServiceCallback<Error> serviceCallback) {
        service.put409Asyncd(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(put409Delegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Error> put409Delegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Error>()
                  .registerError(Error)
                  .build(response, error);
    }

    public Error head410() throws ServiceException {
        try {
            return head410Delegate(service.head410(), null).getBody();
        } catch (RetrofitError error) {
            return head410Delegate(error.getResponse(), error).getBody();
        }
    }

    public void head410Async(final ServiceCallback<Error> serviceCallback) {
        service.head410Asyncd(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(head410Delegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Error> head410Delegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Error>()
                  .registerError(Error)
                  .build(response, error);
    }

    public Error get411() throws ServiceException {
        try {
            return get411Delegate(service.get411(), null).getBody();
        } catch (RetrofitError error) {
            return get411Delegate(error.getResponse(), error).getBody();
        }
    }

    public void get411Async(final ServiceCallback<Error> serviceCallback) {
        service.get411Asyncd(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(get411Delegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Error> get411Delegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Error>()
                  .registerError(Error)
                  .build(response, error);
    }

    public Error get412() throws ServiceException {
        try {
            return get412Delegate(service.get412(), null).getBody();
        } catch (RetrofitError error) {
            return get412Delegate(error.getResponse(), error).getBody();
        }
    }

    public void get412Async(final ServiceCallback<Error> serviceCallback) {
        service.get412Asyncd(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(get412Delegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Error> get412Delegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Error>()
                  .registerError(Error)
                  .build(response, error);
    }

    public Error put413(Boolean booleanValue) throws ServiceException {
        try {
            return put413Delegate(service.put413(booleanValue), null).getBody();
        } catch (RetrofitError error) {
            return put413Delegate(error.getResponse(), error).getBody();
        }
    }

    public void put413Async(Boolean booleanValue, final ServiceCallback<Error> serviceCallback) {
        service.put413Asyncd(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(put413Delegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Error> put413Delegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Error>()
                  .registerError(Error)
                  .build(response, error);
    }

    public Error patch414(Boolean booleanValue) throws ServiceException {
        try {
            return patch414Delegate(service.patch414(booleanValue), null).getBody();
        } catch (RetrofitError error) {
            return patch414Delegate(error.getResponse(), error).getBody();
        }
    }

    public void patch414Async(Boolean booleanValue, final ServiceCallback<Error> serviceCallback) {
        service.patch414Asyncd(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(patch414Delegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Error> patch414Delegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Error>()
                  .registerError(Error)
                  .build(response, error);
    }

    public Error post415(Boolean booleanValue) throws ServiceException {
        try {
            return post415Delegate(service.post415(booleanValue), null).getBody();
        } catch (RetrofitError error) {
            return post415Delegate(error.getResponse(), error).getBody();
        }
    }

    public void post415Async(Boolean booleanValue, final ServiceCallback<Error> serviceCallback) {
        service.post415Asyncd(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(post415Delegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Error> post415Delegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Error>()
                  .registerError(Error)
                  .build(response, error);
    }

    public Error get416() throws ServiceException {
        try {
            return get416Delegate(service.get416(), null).getBody();
        } catch (RetrofitError error) {
            return get416Delegate(error.getResponse(), error).getBody();
        }
    }

    public void get416Async(final ServiceCallback<Error> serviceCallback) {
        service.get416Asyncd(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(get416Delegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Error> get416Delegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Error>()
                  .registerError(Error)
                  .build(response, error);
    }

    public Error delete417(Boolean booleanValue) throws ServiceException {
        try {
            return delete417Delegate(service.delete417(booleanValue), null).getBody();
        } catch (RetrofitError error) {
            return delete417Delegate(error.getResponse(), error).getBody();
        }
    }

    public void delete417Async(Boolean booleanValue, final ServiceCallback<Error> serviceCallback) {
        service.delete417Asyncd(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(delete417Delegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Error> delete417Delegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Error>()
                  .registerError(Error)
                  .build(response, error);
    }

    public Error head429() throws ServiceException {
        try {
            return head429Delegate(service.head429(), null).getBody();
        } catch (RetrofitError error) {
            return head429Delegate(error.getResponse(), error).getBody();
        }
    }

    public void head429Async(final ServiceCallback<Error> serviceCallback) {
        service.head429Asyncd(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(head429Delegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Error> head429Delegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Error>()
                  .registerError(Error)
                  .build(response, error);
    }

}
