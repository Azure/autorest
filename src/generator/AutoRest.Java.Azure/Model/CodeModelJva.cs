// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Java.Model;
using System.Globalization;
using AutoRest.Core.Utilities.Collections;

namespace AutoRest.Java.Azure.Model
{
    public class CodeModelJva : CodeModelJv
    {
        public IDictionary<KeyValuePair<string, string>, string> pageClasses =
            new Dictionary<KeyValuePair<string, string>, string>();

        public const string ExternalExtension = "x-ms-external";

        // public override IEnumerableWithIndex<Property> Properties => new ReEnumerable<Property>(base.Properties.Where(p => p.ModelType.Name != "ServiceClientCredentials"));

        public virtual string ParentDeclaration
        {
            get
            {
                return " extends AzureServiceClient implements " + Name;
            }
        }

        public override List<string> InterfaceImports
        {
            get
            {
                var imports = base.InterfaceImports;
                imports.Add("com.microsoft.azure.AzureClient");
                imports.Add("com.microsoft.azure.RestClient");
                return imports.OrderBy(i => i).ToList();
            }
        }

        public override IEnumerable<string> ImplImports
        {
            get
            {
                var imports = base.ImplImports.ToList();
                imports.Add("com.microsoft.azure.AzureClient");
                imports.Add("com.microsoft.azure.RestClient");
                imports.Add("com.microsoft.rest.credentials.ServiceClientCredentials");
                imports.Remove("com.microsoft.rest.ServiceClient");
                imports.Remove("okhttp3.OkHttpClient");
                imports.Remove("retrofit2.Retrofit");
                imports.Add("com.microsoft.azure.AzureServiceClient");
                return imports.OrderBy(i => i).ToList();
            }
        }

        public string SetDefaultHeaders
        {
            get
            {
                return "";
            }
        }
    }
}