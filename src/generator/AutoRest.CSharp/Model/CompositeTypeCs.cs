// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;

namespace AutoRest.CSharp.TemplateModels
{
    public class ModelTemplateModel : CompositeType
    {
        private readonly IScopeProvider _scope = new ScopeProvider();
        private readonly ModelTemplateModel _baseModel = null;
        private readonly ConstructorModel _constructorModel = null;

        public ModelTemplateModel(CompositeType source)
        {
            this.LoadFrom(source);
            PropertyTemplateModels = new List<PropertyTemplateModel>();
            source.Properties.ForEach(p => PropertyTemplateModels.Add(new PropertyTemplateModel(p)));
            if (source.BaseModelType != null)
            {
                this._baseModel = new ModelTemplateModel(source.BaseModelType);
            }

            this._constructorModel = new ConstructorModel(this);
        }

        public IScopeProvider Scope
        {
            get { return _scope; }
        }

        public string MethodQualifier
        {
            get { return (BaseModelType.ShouldValidateChain()) ? "override" : "virtual"; }
        }

        public List<PropertyTemplateModel> PropertyTemplateModels { get; private set; }

        public bool NeedsPolymorphicConverter
        {
            get
            {
                return this.IsPolymorphicType && Name != SerializedName;
            }
        }

        public bool NeedsTransformationConverter
        {
            get
            {
                return this.Properties.Any(p => p.WasFlattened());
            }
        }

        public string ConstructorParameters
        {
            get
            {
                return this._constructorModel.Signature;
            }
        }

        public IEnumerable<string> ConstructorParametersDocumentation
        {
            get
            {
                return this._constructorModel.SignatureDocumentation;
            }
        }

        public string BaseConstructorCall
        {
            get
            {
                return this._constructorModel.BaseCall;
            }
        }

        public virtual string ExceptionTypeDefinitionName
        {
            get
            {
                if (this.Extensions.ContainsKey(SwaggerExtensions.NameOverrideExtension))
                {
                    var ext = this.Extensions[SwaggerExtensions.NameOverrideExtension] as Newtonsoft.Json.Linq.JContainer;
                    if (ext != null && ext["name"] != null)
                    {
                        return ext["name"].ToString();
                    }
                }
                return this.Name + "Exception";
            }
        }

        public virtual IEnumerable<string> Usings
        {
            get { return Enumerable.Empty<string>(); }
        }

        /// <summary>
        /// Returns properties for this type and all ancestor types, including information on which level of ancestry
        /// the property comes from (0 for top-level base class that has properties, 1 for a class derived from that
        /// top-level class, etc.).
        /// </summary>
        private IEnumerable<InheritedPropertyInfo> AllPropertyTemplateModels
        {
            get
            {
                IEnumerable<InheritedPropertyInfo> baseProperties =
                    this._baseModel != null ? 
                        this._baseModel.AllPropertyTemplateModels : 
                        Enumerable.Empty<InheritedPropertyInfo>();

                int depth = baseProperties.Any() ? baseProperties.Max(p => p.Depth) : 0;
                return baseProperties.Concat(
                    this.PropertyTemplateModels.Select(p => new InheritedPropertyInfo(p, depth)));
            }
        }

        private bool IsPolymorphicType
        {
            get
            {
                return !string.IsNullOrEmpty(PolymorphicDiscriminator) ||
                    (_baseModel != null && _baseModel.IsPolymorphicType);
            }
        }

        private class InheritedPropertyInfo
        {
            public InheritedPropertyInfo(PropertyTemplateModel property, int depth)
            {
                Property = property;
                Depth = depth;
            }

            public PropertyTemplateModel Property { get; private set; }

            public int Depth { get; private set; }
        }

        private class ConstructorParameterModel
        {
            public ConstructorParameterModel(PropertyTemplateModel underlyingProperty)
            {
                UnderlyingProperty = underlyingProperty;
            }

            public PropertyTemplateModel UnderlyingProperty { get; private set; }

            public string Name
            {
                get
                {
                    return CodeNamer.CamelCase(UnderlyingProperty.Name);
                }
            }
        }

        private class ConstructorModel
        {
            public ConstructorModel(ModelTemplateModel model)
            {
                // TODO: this could just be the "required" parameters instead of required and all the optional ones
                // with defaults if we wanted a bit cleaner constructors
                IEnumerable<InheritedPropertyInfo> allProperties =
                   model.AllPropertyTemplateModels.OrderBy(p => !p.Property.IsRequired).ThenBy(p => p.Depth);

                Parameters = allProperties.Select(p => new ConstructorParameterModel(p.Property));
                Signature = CreateSignature(Parameters);
                SignatureDocumentation = CreateSignatureDocumentation(Parameters);
                BaseCall = CreateBaseCall(model);
            }

            public IEnumerable<ConstructorParameterModel> Parameters { get; private set; }

            public IEnumerable<string> SignatureDocumentation { get; private set; }

            public string Signature { get; private set; }

            public string BaseCall { get; private set; }

            private static string CreateSignature(IEnumerable<ConstructorParameterModel> parameters)
            {
                var declarations = new List<string>();
                foreach (var property in parameters.Where(p => !p.UnderlyingProperty.IsConstant).Select(p => p.UnderlyingProperty))
                {
                    string format = (property.IsRequired ? "{0} {1}" : "{0} {1} = default({0})");
                    declarations.Add(string.Format(CultureInfo.InvariantCulture,
                        format, property.Type, CodeNamer.CamelCase(property.Name)));
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
                    var documentationInnerText = property.Summary ?? property.Documentation;

                    var documentation = string.Format(
                        CultureInfo.InvariantCulture,
                        "<param name=\"{0}\">{1}</param>",
                        char.ToLower(property.Name[0], CultureInfo.InvariantCulture) + property.Name.Substring(1),
                        documentationInnerText);

                    declarations.Add(documentation);
                }

                return declarations;
            }

            private static string CreateBaseCall(ModelTemplateModel model)
            {
                if (model._baseModel != null)
                {
                    IEnumerable<ConstructorParameterModel> parameters = model._baseModel._constructorModel.Parameters;
                    if (parameters.Any())
                    {
                        return string.Format(
                            CultureInfo.InvariantCulture, 
                            ": base({0})", 
                            string.Join(", ", parameters.Select(p => p.Name)));
                    }
                }

                return string.Empty;
            }
        }
    }
}