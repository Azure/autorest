/**
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 *
 * Code generated by Microsoft (R) AutoRest Code Generator.
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

package fixtures.bodycomplex.implementation;

import fixtures.bodycomplex.AutoRestComplexTestService;
import fixtures.bodycomplex.BasicOperations;
import fixtures.bodycomplex.Primitives;
import fixtures.bodycomplex.Arrays;
import fixtures.bodycomplex.Dictionarys;
import fixtures.bodycomplex.Inheritances;
import fixtures.bodycomplex.Polymorphisms;
import fixtures.bodycomplex.Polymorphicrecursives;
import fixtures.bodycomplex.Readonlypropertys;
import com.microsoft.rest.ServiceClient;
import okhttp3.OkHttpClient;
import retrofit2.Retrofit;

/**
 * Initializes a new instance of the AutoRestComplexTestService class.
 */
public final class AutoRestComplexTestServiceImpl extends ServiceClient implements AutoRestComplexTestService {

    /** API ID. */
    private String apiVersion;

    /**
     * Gets API ID.
     *
     * @return the apiVersion value.
     */
    public String apiVersion() {
        return this.apiVersion;
    }

    /**
     * Sets API ID.
     *
     * @param apiVersion the apiVersion value.
     * @return the service client itself
     */
    public AutoRestComplexTestServiceImpl withApiVersion(String apiVersion) {
        this.apiVersion = apiVersion;
        return this;
    }

    /**
     * The BasicOperations object to access its operations.
     */
    private BasicOperations basics;

    /**
     * Gets the BasicOperations object to access its operations.
     * @return the BasicOperations object.
     */
    public BasicOperations basics() {
        return this.basics;
    }

    /**
     * The Primitives object to access its operations.
     */
    private Primitives primitives;

    /**
     * Gets the Primitives object to access its operations.
     * @return the Primitives object.
     */
    public Primitives primitives() {
        return this.primitives;
    }

    /**
     * The Arrays object to access its operations.
     */
    private Arrays arrays;

    /**
     * Gets the Arrays object to access its operations.
     * @return the Arrays object.
     */
    public Arrays arrays() {
        return this.arrays;
    }

    /**
     * The Dictionarys object to access its operations.
     */
    private Dictionarys dictionarys;

    /**
     * Gets the Dictionarys object to access its operations.
     * @return the Dictionarys object.
     */
    public Dictionarys dictionarys() {
        return this.dictionarys;
    }

    /**
     * The Inheritances object to access its operations.
     */
    private Inheritances inheritances;

    /**
     * Gets the Inheritances object to access its operations.
     * @return the Inheritances object.
     */
    public Inheritances inheritances() {
        return this.inheritances;
    }

    /**
     * The Polymorphisms object to access its operations.
     */
    private Polymorphisms polymorphisms;

    /**
     * Gets the Polymorphisms object to access its operations.
     * @return the Polymorphisms object.
     */
    public Polymorphisms polymorphisms() {
        return this.polymorphisms;
    }

    /**
     * The Polymorphicrecursives object to access its operations.
     */
    private Polymorphicrecursives polymorphicrecursives;

    /**
     * Gets the Polymorphicrecursives object to access its operations.
     * @return the Polymorphicrecursives object.
     */
    public Polymorphicrecursives polymorphicrecursives() {
        return this.polymorphicrecursives;
    }

    /**
     * The Readonlypropertys object to access its operations.
     */
    private Readonlypropertys readonlypropertys;

    /**
     * Gets the Readonlypropertys object to access its operations.
     * @return the Readonlypropertys object.
     */
    public Readonlypropertys readonlypropertys() {
        return this.readonlypropertys;
    }

    /**
     * Initializes an instance of AutoRestComplexTestService client.
     */
    public AutoRestComplexTestServiceImpl() {
        this("http://localhost");
    }

    /**
     * Initializes an instance of AutoRestComplexTestService client.
     *
     * @param baseUrl the base URL of the host
     */
    public AutoRestComplexTestServiceImpl(String baseUrl) {
        super(baseUrl);
        initialize();
    }

    /**
     * Initializes an instance of AutoRestComplexTestService client.
     *
     * @param clientBuilder the builder for building an OkHttp client, bundled with user configurations
     * @param restBuilder the builder for building an Retrofit client, bundled with user configurations
     */
    public AutoRestComplexTestServiceImpl(OkHttpClient.Builder clientBuilder, Retrofit.Builder restBuilder) {
        this("http://localhost", clientBuilder, restBuilder);
        initialize();
    }

    /**
     * Initializes an instance of AutoRestComplexTestService client.
     *
     * @param baseUrl the base URL of the host
     * @param clientBuilder the builder for building an OkHttp client, bundled with user configurations
     * @param restBuilder the builder for building an Retrofit client, bundled with user configurations
     */
    public AutoRestComplexTestServiceImpl(String baseUrl, OkHttpClient.Builder clientBuilder, Retrofit.Builder restBuilder) {
        super(baseUrl, clientBuilder, restBuilder);
        initialize();
    }

    private void initialize() {
        this.apiVersion = "2014-04-01-preview";
        this.basics = new BasicOperationsImpl(retrofit(), this);
        this.primitives = new PrimitivesImpl(retrofit(), this);
        this.arrays = new ArraysImpl(retrofit(), this);
        this.dictionarys = new DictionarysImpl(retrofit(), this);
        this.inheritances = new InheritancesImpl(retrofit(), this);
        this.polymorphisms = new PolymorphismsImpl(retrofit(), this);
        this.polymorphicrecursives = new PolymorphicrecursivesImpl(retrofit(), this);
        this.readonlypropertys = new ReadonlypropertysImpl(retrofit(), this);
    }
}
