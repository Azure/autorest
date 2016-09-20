// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;
using Newtonsoft.Json;

namespace AutoRest.CSharp.Model
{
    public class CodeModelCs : Core.Model.CodeModel
    {
        public CodeModelCs( bool internalConstructors)
        {
            ConstructorVisibility = internalConstructors ? "internal" : "public";
        }
        
        [JsonIgnore]
        public IEnumerable<MethodGroupCs> AllOperations => Operations.Where( operation => !operation.Name.IsNullOrEmpty()).Cast<MethodGroupCs>();

        public bool IsCustomBaseUri => Extensions.ContainsKey(SwaggerExtensions.ParameterizedHostExtension);
      
        public virtual IEnumerable<string> Usings
        {
            get
            {
                if (ModelTypes.Any() || HeaderTypes.Any())
                {
                    yield return ModelsName;
                }
            }
        }

        [JsonIgnore]
        public bool ContainsCredentials => Properties.Any(p => p.ModelType.IsPrimaryType(KnownPrimaryType.Credentials));

        public string ConstructorVisibility { get; set; }        

        [JsonIgnore]
        public string RequiredConstructorParameters
        {
            get
            {
                var requireParams = new List<string>();
                Properties.Where(p => p.IsRequired && p.IsReadOnly)
                    .ForEach(p => requireParams.Add(string.Format(CultureInfo.InvariantCulture, 
                        "{0} {1}", 
                        p.ModelType.Name, 
                        p.Name.ToCamelCase())));
                return string.Join(", ", requireParams);
            }
        }

        [JsonIgnore]
        public bool NeedsTransformationConverter => ModelTypes.Any(m => m.Properties.Any(p => p.WasFlattened()));
    }
}