// Code generated by Microsoft (R) AutoRest Code Generator 1.2.1.0
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Tiny
{
    using Models;
    using Newtonsoft.Json;

    /// <summary>
    /// This is a sample.
    /// </summary>
    public partial interface ICowbellFactory : System.IDisposable
    {
        /// <summary>
        /// The base URI of the service.
        /// </summary>
        System.Uri BaseUri { get; set; }

        /// <summary>
        /// Gets or sets json serialization settings.
        /// </summary>
        JsonSerializerSettings SerializationSettings { get; }

        /// <summary>
        /// Gets or sets json deserialization settings.
        /// </summary>
        JsonSerializerSettings DeserializationSettings { get; }


        /// <summary>
        /// Gets the ICowbellOperations.
        /// </summary>
        ICowbellOperations Cowbell { get; }

    }
}
