// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities.Collections;
using AutoRest.CSharp.LoadBalanced.Strategies;
using AutoRest.Extensions;
using Newtonsoft.Json;

namespace AutoRest.CSharp.LoadBalanced.Model
{
    public class CompositeTypeCs : CompositeType, IExtendedModelType
    {
        internal readonly ConstructorModel _constructorModel = null;

        public CompositeTypeCs()
        {
            _constructorModel = new ConstructorModel(this);
        }

        public CompositeTypeCs(string name ) : base(name)
        {
            _constructorModel = new ConstructorModel(this);
        }

        [JsonIgnore]
        public IPropertyTypeSelectionStrategy PropertyTypeSelectionStrategy { get; set; }

        [JsonIgnore]
        public string MethodQualifier => (BaseModelType.ShouldValidateChain()) ? "override" : "virtual";

        [JsonIgnore]
        public bool NeedsPolymorphicConverter => BaseIsPolymorphic && Name != SerializedName;

        [JsonIgnore]
        public bool NeedsTransformationConverter => Properties.Any(p => p.WasFlattened());

        [JsonIgnore]
        public string ConstructorParameters => _constructorModel.Signature;

        [JsonIgnore]
        public IEnumerable<string> ConstructorParametersDocumentation => _constructorModel.SignatureDocumentation;

        [JsonIgnore]
        public string BaseConstructorCall => _constructorModel.BaseCall;

        [JsonIgnore]
        public virtual string ExceptionTypeDefinitionName
        {
            get
            {
                if (Extensions.ContainsKey(SwaggerExtensions.NameOverrideExtension))
                {
                    var ext = Extensions[SwaggerExtensions.NameOverrideExtension] as Newtonsoft.Json.Linq.JContainer;
                    if (ext?["name"] != null)
                    {
                        return ext["name"].ToString();
                    }
                }
                return Name + "Exception";
            }
        }

        public virtual IEnumerable<Property> GetPropertiesWhichRequireInitialization()
        {
            return PropertyTypeSelectionStrategy.GetPropertiesWhichRequireInitialization(this);
        }

        public virtual IEnumerable<string> Usings => Enumerable.Empty<string>();

        /// <summary>
        /// Returns properties for this type and all ancestor types, including information on which level of ancestry
        /// the property comes from (0 for top-level base class that has properties, 1 for a class derived from that
        /// top-level class, etc.).
        /// </summary>
        internal IEnumerable<InheritedPropertyInfo> AllPropertyTemplateModels
        {
            get
            {
                var baseProperties =((BaseModelType as CompositeTypeCs)?.AllPropertyTemplateModels ??
                    Enumerable.Empty<InheritedPropertyInfo>()).ReEnumerable();

                int depth = baseProperties.Any() ? baseProperties.Max(p => p.Depth) : 0;
                return baseProperties.Concat(Properties.Select(p => new InheritedPropertyInfo(p, depth)));
            }
        }

        public bool IsValueType => false;

    }
}