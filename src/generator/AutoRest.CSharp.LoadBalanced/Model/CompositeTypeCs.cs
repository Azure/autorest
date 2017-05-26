// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Core.Utilities.Collections;
using AutoRest.Extensions;
using Newtonsoft.Json;

namespace AutoRest.CSharp.LoadBalanced.Model
{
    public class CompositeTypeCs : CompositeType, IExtendedModelType
    {
        private readonly ConstructorModel _constructorModel = null;

        public CompositeTypeCs()
        {
            _constructorModel = new ConstructorModel(this);
        }

        public CompositeTypeCs(string name ) : base(name)
        {
            _constructorModel = new ConstructorModel(this);
        }

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
                    if (ext != null && ext["name"] != null)
                    {
                        return ext["name"].ToString();
                    }
                }
                return Name + "Exception";
            }
        }

        public virtual IEnumerable<string> Usings => Enumerable.Empty<string>();

        /// <summary>
        /// Returns properties for this type and all ancestor types, including information on which level of ancestry
        /// the property comes from (0 for top-level base class that has properties, 1 for a class derived from that
        /// top-level class, etc.).
        /// </summary>
        private IEnumerable<InheritedPropertyInfo> AllPropertyTemplateModels
        {
            get
            {
                var baseProperties =((BaseModelType as CompositeTypeCs)?.AllPropertyTemplateModels ??
                    Enumerable.Empty<InheritedPropertyInfo>()).ReEnumerable();

                int depth = baseProperties.Any() ? baseProperties.Max(p => p.Depth) : 0;
                return baseProperties.Concat(Properties.Select(p => new InheritedPropertyInfo(p, depth)));
            }
        }

        private class InheritedPropertyInfo
        {
            public InheritedPropertyInfo(Property property, int depth)
            {
                Property = property;
                Depth = depth;
            }

            public Property Property { get; private set; }

            public int Depth { get; private set; }
        }

        private class ConstructorParameterModel
        {
            public ConstructorParameterModel(Property underlyingProperty)
            {
                UnderlyingProperty = underlyingProperty;
            }

            public Property UnderlyingProperty { get; private set; }

            public string Name => CodeNamer.Instance.CamelCase(UnderlyingProperty.Name);
        }

        private class ConstructorModel
        {
            private readonly CompositeTypeCs _model;
            public ConstructorModel(CompositeTypeCs model)
            {
                _model = model;
            }

                // TODO: this could just be the "required" parameters instead of required and all the optional ones
                // with defaults if we wanted a bit cleaner constructors
            public IEnumerable<ConstructorParameterModel> Parameters => _model.AllPropertyTemplateModels.OrderBy(p => !p.Property.IsRequired).ThenBy(p => p.Depth).Select(p => new ConstructorParameterModel(p.Property));

            public IEnumerable<string> SignatureDocumentation => CreateSignatureDocumentation(Parameters);

            public string Signature => CreateSignature(Parameters);

            public string BaseCall => CreateBaseCall(_model);

            private static string CreateSignature(IEnumerable<ConstructorParameterModel> parameters)
            {
                var declarations = new List<string>();
                foreach (var property in parameters.Where(p => !p.UnderlyingProperty.IsConstant).Select(p => p.UnderlyingProperty))
                {
                    string format = (property.IsRequired ? "{0} {1}" : "{0} {1} = default({0})");
                    declarations.Add(string.Format(CultureInfo.InvariantCulture,
                        format, property.ModelTypeName, CodeNamer.Instance.CamelCase(property.Name)));
                }

                return string.Join(", ", declarations);
            }

            private static IEnumerable<string> CreateSignatureDocumentation(IEnumerable<ConstructorParameterModel> parameters)
            {
                var declarations = new List<string>();

                IEnumerable<Property> parametersWithDocumentation =
                   parameters.Where(p => !(string.IsNullOrEmpty(p.UnderlyingProperty.Summary) &&
                   string.IsNullOrEmpty(p.UnderlyingProperty.Documentation)) &&
                   !p.UnderlyingProperty.IsConstant).Select(p => p.UnderlyingProperty);

                foreach (var property in parametersWithDocumentation)
                {
                    var documentationInnerText = string.IsNullOrEmpty(property.Summary) ? property.Documentation.EscapeXmlComment() : property.Summary.EscapeXmlComment();

                    var documentation = string.Format(
                        CultureInfo.InvariantCulture,
                        "<param name=\"{0}\">{1}</param>",
                        char.ToLower(property.Name.CharAt(0), CultureInfo.InvariantCulture) + property.Name.Substring(1),
                        documentationInnerText);

                    declarations.Add(documentation);
                }

                return declarations;
            }

            private static string CreateBaseCall(CompositeTypeCs model)
            {
                if (model.BaseModelType != null)
                {
                    IEnumerable<ConstructorParameterModel> parameters = (model.BaseModelType as CompositeTypeCs)._constructorModel.Parameters;
                    if (parameters.Any())
                    {
                        return $": base({string.Join(", ", parameters.Select(p => p.Name))})";
                    }
                }

                return string.Empty;
            }
        }

        public bool IsValueType => false;

    }
}