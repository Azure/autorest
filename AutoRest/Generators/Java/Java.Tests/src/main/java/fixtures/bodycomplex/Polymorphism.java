// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator 0.11.0.0
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.


package fixtures.bodycomplex;

import com.google.gson.reflect.TypeToken;
import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceException;
import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.ServiceResponseBuilder;
import com.microsoft.rest.ServiceResponseCallback;
import retrofit.client.Response;
import retrofit.RestAdapter;
import retrofit.RetrofitError;
import fixtures.bodycomplex.models.Fish;
import retrofit.http.GET;
import retrofit.http.PUT;
import retrofit.http.Body;

public class Polymorphism {
    private PolymorphismService service;

    public Polymorphism(RestAdapter restAdapter) {
        service = restAdapter.create(PolymorphismService.class);
    }

    public interface PolymorphismService {
        @GET("/complex/polymorphism/valid")
        Response getValid() throws ServiceException;

        @GET("/complex/polymorphism/valid")
        void getValidAsync(ServiceResponseCallback cb);

        @PUT("/complex/polymorphism/valid")
        Response putValid(@Body Fish complexBody) throws ServiceException;

        @PUT("/complex/polymorphism/valid")
        void putValidAsync(@Body Fish complexBody, ServiceResponseCallback cb);

        @PUT("/complex/polymorphism/missingrequired/invalid")
        Response putValidMissingRequired(@Body Fish complexBody) throws ServiceException;

        @PUT("/complex/polymorphism/missingrequired/invalid")
        void putValidMissingRequiredAsync(@Body Fish complexBody, ServiceResponseCallback cb);

    }
    public Fish getValid() throws ServiceException {
        try {
            return getValidDelegate(service.getValid(), null).getBody();
        } catch (RetrofitError error) {
            return getValidDelegate(error.getResponse(), error).getBody();
        }
    }

    public void getValidAsync(final ServiceCallback<Fish> serviceCallback) {
        service.getValidAsync(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(getValidDelegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Fish> getValidDelegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Fish>()
                .register(200, new TypeToken<Fish>(){}.getType())
                .registerError(new TypeToken<Error>(){}.getType())
                .build(response, error);
    }

    public void putValid(Fish complexBody) throws ServiceException {
        try {
            putValidDelegate(service.putValid(complexBody), null).getBody();
        } catch (RetrofitError error) {
            putValidDelegate(error.getResponse(), error).getBody();
        }
    }

    public void putValidAsync(Fish complexBody, final ServiceCallback<Void> serviceCallback) {
        service.putValidAsync(complexBody, new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(putValidDelegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Void> putValidDelegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Void>()
                .register(200, new TypeToken<Void>(){}.getType())
                .registerError(new TypeToken<Error>(){}.getType())
                .build(response, error);
    }

    public void putValidMissingRequired(Fish complexBody) throws ServiceException {
        try {
            putValidMissingRequiredDelegate(service.putValidMissingRequired(complexBody), null).getBody();
        } catch (RetrofitError error) {
            putValidMissingRequiredDelegate(error.getResponse(), error).getBody();
        }
    }

    public void putValidMissingRequiredAsync(Fish complexBody, final ServiceCallback<Void> serviceCallback) {
        service.putValidMissingRequiredAsync(complexBody, new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(putValidMissingRequiredDelegate(response, error));
                } catch (ServiceException exception) {
                    serviceCallback.failure(exception);
                }
            }
        });
    }

    private ServiceResponse<Void> putValidMissingRequiredDelegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Void>()
                .register(200, new TypeToken<Void>(){}.getType())
                .registerError(new TypeToken<Error>(){}.getType())
                .build(response, error);
    }

}
