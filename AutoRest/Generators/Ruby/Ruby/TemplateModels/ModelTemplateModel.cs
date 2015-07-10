// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Generator.Ruby.TemplateModels;

namespace Microsoft.Rest.Generator.Ruby
{
    /// <summary>
    /// A model for the model template.
    /// </summary>
    public class ModelTemplateModel : CompositeType
    {
        /// <summary>
        /// The current scope.
        /// </summary>
        private readonly IScopeProvider scope = new ScopeProvider();

        /// <summary>
        /// The reference to the base object.
        /// </summary>
        private readonly ModelTemplateModel parent = null;

        /// <summary>
        /// Gets the list of own properties of the object.
        /// </summary>
        public List<PropertyTemplateModel> PropertyTemplateModels { get; private set; }

        /// <summary>
        /// Gets the current scope.
        /// </summary>
        public IScopeProvider Scope
        {
            get { return scope; }
        }

        /// <summary>
        /// Gets the list of properties of object including inherted ones.
        /// </summary>
        public IEnumerable<Property> ComposedProperties
        {
            get
            {
                if (this.parent != null)
                {
                    return parent.ComposedProperties.Union(this.Properties);
                }

                return this.Properties;
            }
        }

        /// <summary>
        /// Initializes a new instance of the ModelTemplateModel class.
        /// </summary>
        /// <param name="source">The object to create model from.</param>
        /// <param name="serviceClient">The service client.</param>
        public ModelTemplateModel(CompositeType source, ServiceClient serviceClient)
        {
            this.LoadFrom(source);
            PropertyTemplateModels = new List<PropertyTemplateModel>();
            source.Properties.ForEach(p => PropertyTemplateModels.Add(new PropertyTemplateModel(p)));

            if (source.BaseModelType != null)
            {
                parent = new ModelTemplateModel(source.BaseModelType, serviceClient);
            }
        }

        /// <summary>
        /// Generates code for model serialization.
        /// </summary>
        /// <param name="variableName">Variable serialize model from.</param>
        /// <param name="type">The type of the model.</param>
        /// <param name="isRequired">Is property required.</param>
        /// <param name="defaultNamespace">The namespace.</param>
        /// <returns>The code for serialization in string format.</returns>
        public string SerializeProperty(string variableName, IType type, bool isRequired, string defaultNamespace)
        {
            // TODO: handle if property required via "unless serialized_property.nil?"

            var builder = new IndentedStringBuilder("  ");

            string serializationLogic = type.SerializeType(this.Scope, variableName, defaultNamespace);

            builder.AppendLine(serializationLogic);

            return builder.ToString();
            // return builder.AppendLine("{0} = JSON.generate({0}, quirks_mode: true)", variableName).ToString();
        }

        /// <summary>
        /// Generates code for model deserialization.
        /// </summary>
        /// <param name="variableName">Variable deserialize model from.</param>
        /// <param name="type">The type of the model.</param>
        /// <param name="isRequired">Is property required.</param>
        /// <param name="defaultNamespace">The namespace.</param>
        /// <returns>The code for вуserialization in string format.</returns>
        public string DeserializeProperty(string variableName, IType type, bool isRequired, string defaultNamespace)
        {
            // TODO: handle required property via "unless deserialized_property.nil?"

            var builder = new IndentedStringBuilder("  ");

            // builder.AppendLine("{0} = JSON.load({0}) unless {0}.to_s.empty?", variableName);

            string serializationLogic = type.DeserializeType(this.Scope, variableName, defaultNamespace);
            return builder.AppendLine(serializationLogic).ToString();
        }

        /// <summary>
        /// Returns code for declaring inheritance.
        /// </summary>
        /// <returns>Code for declaring inheritance.</returns>
        public virtual string GetBaseTypeName()
        {
            return this.BaseModelType != null ? " < " + this.BaseModelType.Name : string.Empty;
        }
    }
}