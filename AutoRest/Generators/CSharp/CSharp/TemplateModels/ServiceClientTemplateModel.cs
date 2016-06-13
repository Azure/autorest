// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.CSharp
{
    public class ServiceClientTemplateModel : ServiceClient
    {
        public ServiceClientTemplateModel(ServiceClient serviceClient, bool internalConstructors)
        {
            this.LoadFrom(serviceClient);
            MethodTemplateModels = new List<MethodTemplateModel>();
            Methods.Where(m => m.Group == null)
                .ForEach(m => MethodTemplateModels.Add(new MethodTemplateModel(m, serviceClient, SyncMethodsGenerationMode.None)));
            ConstructorVisibility = internalConstructors ? "internal" : "public";
            this.IsCustomBaseUri = serviceClient.Extensions.ContainsKey(Microsoft.Rest.Generator.Extensions.ParameterizedHostExtension);
        }

        public bool IsCustomBaseUri { get; private set; }

        public List<MethodTemplateModel> MethodTemplateModels { get; private set; }

        public virtual IEnumerable<MethodGroupTemplateModel> Operations
        {
            get
            {
                return MethodGroups.Select(mg => new MethodGroupTemplateModel(this, mg));
            }
        }

        public virtual IEnumerable<string> Usings
        {
            get
            {
                if (this.ModelTypes.Any() || this.HeaderTypes.Any())
                {
                    yield return "Models";
                }
            }
        }

        public bool ContainsCredentials
        {
            get
            {
                return Properties.Any(p => p.Type.IsPrimaryType(KnownPrimaryType.Credentials));
            }
        }

        public string ConstructorVisibility { get; set; }        

        public string RequiredConstructorParameters
        {
            get
            {
                var requireParams = new List<string>();
                this.Properties.Where(p => p.IsRequired && p.IsReadOnly)
                    .ForEach(p => requireParams.Add(string.Format(CultureInfo.InvariantCulture, 
                        "{0} {1}", 
                        p.Type.Name, 
                        p.Name.ToCamelCase())));
                return string.Join(", ", requireParams);
            }
        }

        public bool NeedsTransformationConverter
        {
            get
            {
                return this.ModelTypes.Any(m => m.Properties.Any(p => p.WasFlattened()));
            }
        }
    }
}