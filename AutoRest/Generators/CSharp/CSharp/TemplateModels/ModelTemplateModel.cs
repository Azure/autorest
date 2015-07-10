// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.CSharp.TemplateModels;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.CSharp
{
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
            get { return (BaseModelType.ShouldValidate()) ? "override" : "virtual"; }
        }

        public List<PropertyTemplateModel> PropertyTemplateModels { get; private set; }

        public bool NeedsPolymorphicConverter
        {
            get
            {
                return (!string.IsNullOrEmpty(PolymorphicDiscriminator) && Name != SerializedName) ||
                       (_baseModel != null && _baseModel.NeedsPolymorphicConverter);
            }
        }

        public virtual IEnumerable<string> Usings
        {
            get { return Enumerable.Empty<string>(); }
        }
    }
}