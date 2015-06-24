// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Ruby
{
    using System;

    using TemplateModels;

    public class ModelTemplateModel : CompositeType
    {
        private readonly IScopeProvider scope = new ScopeProvider();

        public ModelTemplateModel(CompositeType source)
        {
            this.LoadFrom(source);
            PropertyTemplateModels = new List<PropertyTemplateModel>();
            source.Properties.ForEach(p => PropertyTemplateModels.Add(new PropertyTemplateModel(p)));
        }

        public IScopeProvider Scope
        {
            get { return scope; }
        }

        public string SerializeProperty(string variableName, IType type, bool propertyRequired, string defaultNamespace)
        {
            // TODO: handle if property required via "unless serialized_property.nil?"

            var builder = new IndentedStringBuilder("  ");

            string serializationLogic = type.SerializeType(this.Scope, variableName, defaultNamespace);

            builder.AppendLine(serializationLogic);

            return builder.ToString();
            // return builder.AppendLine("{0} = JSON.generate({0}, quirks_mode: true)", variableName).ToString();
        }

        public string DeserializeProperty(string variableName, IType type, bool propertyRequired, string defaultNamespace)
        {
            // TODO: handle required property via "unless deserialized_property.nil?"

            var builder = new IndentedStringBuilder("  ");

            // builder.AppendLine("{0} = JSON.load({0}) unless {0}.to_s.empty?", variableName);

            string serializationLogic = type.DeserializeType(this.Scope, variableName, defaultNamespace);
            return builder.AppendLine(serializationLogic).ToString();
        }

        public List<PropertyTemplateModel> PropertyTemplateModels { get; private set; }
    }
}