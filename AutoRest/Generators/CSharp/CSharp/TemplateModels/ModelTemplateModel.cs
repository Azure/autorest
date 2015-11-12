// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.CSharp.TemplateModels;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.CSharp
{
    using System.Globalization;

    public class ModelTemplateModel : CompositeType
    {
        private readonly IScopeProvider _scope = new ScopeProvider();


        public ModelTemplateModel(CompositeType source)
        {
            this.LoadFrom(source);
            PropertyTemplateModels = new List<PropertyTemplateModel>();
            source.Properties.ForEach(p => PropertyTemplateModels.Add(new PropertyTemplateModel(p)));
            if (source.BaseModelType != null)
            {
                this._baseModel = new ModelTemplateModel(source.BaseModelType);
            }
        }

        ModelTemplateModel _baseModel= null;
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

        //TODO: this could just be the "required" parameters instead of required and all the optional ones with defaults if we wanted a bit cleaner constructors
        public string ConstructorParameters
        {
            get
            {
                List<string> declarations = new List<string>();
                foreach (var property in this.PropertyTemplateModels.OrderBy(p => !p.IsRequired))
                {
                    string format = (property.IsRequired ? "{0} {1}" : "{0} {1} = default({0})");
                    declarations.Add(string.Format(CultureInfo.InvariantCulture,
                        format, property.Type, CodeNamer.CamelCase(property.Name)));
                }

                return string.Join(", ", declarations);
            }
        }


        public virtual IEnumerable<string> Usings
        {
            get { return Enumerable.Empty<string>(); }
        }

        private bool IsPolymorphicType
        {
            get
            {
                return !string.IsNullOrEmpty(PolymorphicDiscriminator) ||
                    (_baseModel != null && _baseModel.IsPolymorphicType);
            }
        }
    }
}