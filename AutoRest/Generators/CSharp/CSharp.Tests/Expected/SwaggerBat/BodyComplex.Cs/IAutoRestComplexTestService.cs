namespace Fixtures.SwaggerBatBodyComplex
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    /// <summary>
    /// Test Infrastructure for AutoRest
    /// </summary>
    public partial interface IAutoRestComplexTestService
    {
        /// <summary>
        /// The base URI of the service.
        /// </summary>
        Uri BaseUri { get; set; }

        IBasicOperations BasicOperations { get; }

        IPrimitive Primitive { get; }

        IArray Array { get; }

        IDictionary Dictionary { get; }

        IInheritance Inheritance { get; }

        IPolymorphism Polymorphism { get; }

        IPolymorphicrecursive Polymorphicrecursive { get; }

        }
}
