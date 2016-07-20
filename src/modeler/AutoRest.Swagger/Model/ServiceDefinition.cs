// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using Newtonsoft.Json;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Validation;

namespace AutoRest.Swagger.Model
{
    /// <summary>
    /// Class that represents Swagger 2.0 schema
    /// http://json.schemastore.org/swagger-2.0
    /// Swagger Object - https://github.com/wordnik/swagger-spec/blob/master/versions/2.0.md#swagger-object- 
    /// </summary>
    [Serializable]
    [Rule(typeof(XmsPathsMustOverloadPaths))]
    public class ServiceDefinition : SpecObject
    {
        public ServiceDefinition()
        {
            Definitions = new Dictionary<string, Schema>();
            Schemes = new List<TransferProtocolScheme>();
            Consumes = new List<string>();
            Produces = new List<string>();
            Paths = new Dictionary<string, Dictionary<string, Operation>>();
            CustomPaths = new Dictionary<string, Dictionary<string, Operation>>();
            Parameters = new Dictionary<string, SwaggerParameter>();
            Responses = new Dictionary<string, OperationResponse>();
            SecurityDefinitions = new Dictionary<string, SecurityDefinition>();
            Security = new List<Dictionary<string, List<string>>>();
            Tags = new List<Tag>();
            ExternalReferences = new List<string>();
        }

        /// <summary>
        /// Specifies the Swagger Specification version being used. 
        /// </summary>
        public string Swagger { get; set; }

        /// <summary>
        /// Provides metadata about the API. The metadata can be used by the clients if needed.
        /// </summary>
        public Info Info { get; set; }

        /// <summary>
        /// The host (serviceTypeName or ip) serving the API.
        /// </summary>
        public string Host { get; set; }

        /// <summary>
        /// The base path on which the API is served, which is relative to the host.
        /// </summary>
        public string BasePath { get; set; }

        /// <summary>
        /// The transfer protocol of the API.
        /// </summary>
        public IList<TransferProtocolScheme> Schemes { get; set; }

        /// <summary>
        /// A list of MIME types the service can consume.
        /// </summary>
        public IList<string> Consumes { get; set; }

        /// <summary>
        /// A list of MIME types the APIs can produce.
        /// </summary>
        public IList<string> Produces { get; set; }

        /// <summary>
        /// Key is actual path and the value is serializationProperty of http operations and operation objects.
        /// </summary>
        public Dictionary<string, Dictionary<string, Operation>> Paths { get; set; }

        /// <summary>
        /// Key is actual path and the value is serializationProperty of http operations and operation objects.
        /// </summary>
        [JsonProperty("x-ms-paths")]
        public Dictionary<string, Dictionary<string, Operation>> CustomPaths { get; set; }

        /// <summary>
        /// Key is the object serviceTypeName and the value is swagger definition.
        /// </summary>
        public Dictionary<string, Schema> Definitions { get; set; }

        /// <summary>
        /// Dictionary of parameters that can be used across operations.
        /// This property does not define global parameters for all operations.
        /// </summary>
        [CollectionRule(typeof(AnonymousParameterTypes))]
        public Dictionary<string, SwaggerParameter> Parameters { get; set; }

        /// <summary>
        /// Dictionary of responses that can be used across operations. The key indicates status code.
        /// </summary>
        public Dictionary<string, OperationResponse> Responses { get; set; }

        /// <summary>
        /// Key is the object serviceTypeName and the value is swagger security definition.
        /// </summary>
        public Dictionary<string, SecurityDefinition> SecurityDefinitions { get; set; }

        /// <summary>
        /// A declaration of which security schemes are applied for the API as a whole. 
        /// The list of values describes alternative security schemes that can be used 
        /// (that is, there is a logical OR between the security requirements). Individual 
        /// operations can override this definition.
        /// </summary>
        public IList<Dictionary<string, List<string>>> Security { get; set; }

        /// <summary>
        /// A list of tags used by the specification with additional metadata. The order 
        /// of the tags can be used to reflect on their order by the parsing tools. Not all 
        /// tags that are used by the Operation Object must be declared. The tags that are 
        /// not declared may be organized randomly or based on the tools' logic. Each 
        /// tag name in the list MUST be unique.
        /// </summary>
        public IList<Tag> Tags { get; set; }

        /// <summary>
        /// Additional external documentation
        /// </summary>
        public ExternalDoc ExternalDocs { get; set; }

        /// <summary>
        /// A list of all external references listed in the service.
        /// </summary>
        public IList<string> ExternalReferences { get; set; }
    }
}