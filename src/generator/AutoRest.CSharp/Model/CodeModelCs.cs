// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Core.Utilities.Collections;
using AutoRest.Extensions;
using Newtonsoft.Json;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.CSharp.Model
{
    public class CodeModelCs : CodeModel
    {
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

        [JsonIgnore]
        public string ConstructorVisibility
            => Singleton<GeneratorSettingsCs>.Instance.InternalConstructors ? "internal" : "public";

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

        /// <summary>
        /// Returns the list of names that this element is reserving
        /// (most of the time, this is just 'this.Name' )
        /// </summary>
        public override IEnumerable<string> MyReservedNames
            => base.MyReservedNames.ConcatSingleItem(Namespace.Else("").Substring(Namespace.Else("").LastIndexOf('.') + 1)).Where( each => !each.IsNullOrEmpty());
    }
}