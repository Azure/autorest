// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Java.Model;
using AutoRest.Core.Utilities.Collections;
using Newtonsoft.Json;
using System.Text.RegularExpressions;

namespace AutoRest.Java.Azure.Model
{
    public class CodeModelJva : CodeModelJv
    {
        public IDictionary<KeyValuePair<string, string>, string> pageClasses =
            new Dictionary<KeyValuePair<string, string>, string>();

        public const string ExternalExtension = "x-ms-external";

        [JsonIgnore]
        public IEnumerable<Property> PropertiesEx => Properties.Where(p => p.ModelType.Name != "ServiceClientCredentials");

        [JsonIgnore]
        public virtual string ParentDeclaration
        {
            get
            {
                return " extends AzureServiceClient implements " + Name;
            }
        }

        [JsonIgnore]
        public override List<string> InterfaceImports
        {
            get
            {
                var imports = base.InterfaceImports;
                imports.Add("com.microsoft.azure.AzureClient");
                return imports.OrderBy(i => i).ToList();
            }
        }

        [JsonIgnore]
        public override IEnumerable<string> ImplImports
        {
            get
            {
                var imports = base.ImplImports.ToList();
                imports.Add("com.microsoft.azure.AzureClient");
                imports.Remove("com.microsoft.rest.ServiceClient");
                imports.Remove("okhttp3.OkHttpClient");
                imports.Remove("retrofit2.Retrofit");
                imports.Add("com.microsoft.azure.AzureServiceClient");
                return imports.OrderBy(i => i).ToList();
            }
        }

        [JsonIgnore]
        public string SetDefaultHeaders
        {
            get
            {
                return "";
            }
        }

        /// <summary>
        /// Attempts to infer the name of the service referenced by this CodeModel.
        /// </summary>
        [JsonIgnore]
        public string ServiceName
        {
            get
            {
                var method = Methods[0];
                var match = Regex.Match(input: method.Url, pattern: @"/providers/microsoft\.(\w+)/", options: RegexOptions.IgnoreCase);
                var serviceName = match.Groups[1].Value;
                return serviceName;
            }
        }
    }
}