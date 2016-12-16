﻿// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;
using AutoRest.Core.Model;
using Newtonsoft.Json;

namespace AutoRest.Java.Model
{
    public class CodeModelJv : CodeModel
    {
        public override string BaseUrl
        {
            get
            {
                if (!base.BaseUrl.Contains("://"))
                {
                    return $"https://{base.BaseUrl}";
                }
                return base.BaseUrl;
            }
            set
            {
                base.BaseUrl = value;
            }
        }

        [JsonIgnore]
        public IEnumerable<MethodGroupJv> AllOperations => Operations.Where(operation => !operation.Name.IsNullOrEmpty()).Cast<MethodGroupJv>();

        public bool IsCustomBaseUri => Extensions.ContainsKey(SwaggerExtensions.ParameterizedHostExtension);
        
        public string ServiceClientServiceType
        {
            get
            {
                return CodeNamerJv.GetServiceName(Name.ToPascalCase());
            }
        }

        public virtual string ImplPackage => "implementation";

        public string ModelsPackage => ".models";

        public IEnumerable<MethodJv> RootMethods => Methods.Where(m => m.Group.IsNullOrEmpty()).OfType<MethodJv>();

        public virtual IEnumerable<string> ImplImports
        {
            get
            {
                HashSet<string> classes = new HashSet<string>();
                classes.Add(Namespace.ToLower(CultureInfo.InvariantCulture) + "." + this.Name);
                foreach(var methodGroupFullType in this.AllOperations.Select(op => op.MethodGroupFullType).Distinct())
                {
                    classes.Add(methodGroupFullType);
                }
                if (this.Properties.Any(p => p.ModelType.IsPrimaryType(KnownPrimaryType.Credentials)))
                {
                    classes.Add("com.microsoft.rest.credentials.ServiceClientCredentials");
                }
                classes.AddRange(new[]{
                        "com.microsoft.rest.ServiceClient",
                        "okhttp3.OkHttpClient",
                        "retrofit2.Retrofit"
                    });

                classes.AddRange(RootMethods
                    .SelectMany(m => m.ImplImports)
                    .OrderBy(i => i));

                return classes.AsEnumerable();
            }
        }

        public virtual List<string> InterfaceImports
        {
            get
            {
                HashSet<string> classes = new HashSet<string>();
                
                classes.AddRange(RootMethods
                    .SelectMany(m => m.InterfaceImports)
                    .OrderBy(i => i).Distinct());

                return classes.ToList();
            }
        }
    }
}