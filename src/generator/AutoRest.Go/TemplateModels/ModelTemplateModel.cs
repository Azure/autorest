// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;

using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.Go.TemplateModels
{
    public class ModelTemplateModel : CompositeType
    {
        private readonly IScopeProvider _scope = new VariableScopeProvider();

        // True if the type is returned by a method
        public bool IsResponseType;

        // Name of the field containing the URL used to retrieve the next result set
        // (null or empty if the model is not paged).
        public string NextLink;

        public ModelTemplateModel(CompositeType source)
        {
            this.LoadFrom(source);

            PropertyTemplateModels = new List<PropertyTemplateModel>();
            source.Properties.ForEach(p => PropertyTemplateModels.Add(new PropertyTemplateModel(p)));
        }

        public IScopeProvider Scope
        {
            get { return _scope; }
        }

        public virtual IEnumerable<string> Imports
        {
            get
            {
                var imports = new HashSet<string>();
                (this as CompositeType).AddImports(imports);
                return imports;
            }
        }

        public List<PropertyTemplateModel> PropertyTemplateModels { get; private set; }
    }
}