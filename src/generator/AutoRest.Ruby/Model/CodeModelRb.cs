// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Extensions;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Ruby.Model
{
    /// <summary>
    /// The model for the service client template.
    /// </summary>
    public class CodeModelRb : CodeModel
    {
        /// <summary>
        /// Initializes a new instance of ServiceClientTemplateModel class.
        /// </summary>
        public CodeModelRb()
        {
        }

        /// <summary>
        /// Gets and sets the method template models.
        /// </summary>
        public IEnumerable<MethodRb> MethodTemplateModels => Methods.Cast<MethodRb>().Where(each => each.MethodGroup.IsCodeModelMethodGroup);

        /// <summary>
        /// Gets the flag indicating whether url is from x-ms-parameterized-host extension.
        /// </summary>
        public bool IsCustomBaseUri => Extensions.ContainsKey(SwaggerExtensions.ParameterizedHostExtension);

        /// <summary>
        /// Gets the list of modules/classes which need to be included.
        /// </summary>
        public virtual IEnumerable<string> Includes => Enumerable.Empty<string>();

        /// <summary>
        /// Gets the base type of the client.
        /// </summary>
        public virtual string BaseType => "MsRest::ServiceClient";

        /// <summary>
        /// Gets the serializer type of the client.
        /// </summary>
        public virtual string IncludeSerializer => "include MsRest::Serialization";

        /// <summary>
        /// Gets the operation response type to instantiate.
        /// </summary>
        public virtual string OperationResponseString => "MsRest::HttpOperationResponse";

        public virtual string MergeClientDefaultHeaders => string.Empty;

        public CodeNamerRb CodeNamer => Singleton<CodeNamer>.Instance as CodeNamerRb;

    }
}
