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
        /// List of all model types.
        /// </summary>
        private readonly ISet<CompositeType> allTypes;

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
        /// Gets the list of modules/classes which need to be included.
        /// </summary>
        public virtual List<string> Includes
        {
            get
            {
                return new List<string>();
            }
        }

        /// <summary>
        /// Gets the list of namespaces where we look for classes that need to
        /// be instantiated dynamically due to polymorphism.
        /// </summary>
        public virtual List<string> ClassNamespaces
        {
            get
            {
                return new List<string> {};
            }
        }

        /// <summary>
        /// Gets the value indicating whether current object is polymorhic.
        /// </summary>
        public bool IsPolymorphic
        {
            get
            {
                if (!string.IsNullOrEmpty(this.PolymorphicDiscriminator))
                {
                    return true;
                }

                if (this.parent != null)
                {
                    return parent.IsPolymorphic;
                }

                return false;
            }
        }

        /// <summary>
        /// Gets the polymorphic discriminator to use for the current object, or its parent's if it doesn't have one.
        /// </summary>
        public string PolymorphicDiscriminatorProperty
        {
            get 
            {
                if (string.IsNullOrEmpty(this.PolymorphicDiscriminator) && this.parent != null)
                {
                    return this.parent.PolymorphicDiscriminatorProperty;
                }

                return this.PolymorphicDiscriminator;
            }
        }

        /// <summary>
        /// Gets the list of all model types derived directly or indirectly from this type.
        /// </summary>
        public IList<CompositeType> DerivedTypes
        {
            get
            {
                return allTypes.Where(t => t.DerivesFrom(this)).ToList();
            }
        }

        /// <summary>
        /// Initializes a new instance of the ModelTemplateModel class.
        /// </summary>
        /// <param name="source">The object to create model from.</param>
        /// <param name="allTypes">The list of all model types; Used to implement polymorphism.</param>
        public ModelTemplateModel(CompositeType source, ISet<CompositeType> allTypes)
        {
            this.LoadFrom(source);
            PropertyTemplateModels = new List<PropertyTemplateModel>();
            source.Properties.ForEach(p => PropertyTemplateModels.Add(new PropertyTemplateModel(p)));

            if (source.BaseModelType != null)
            {
                this.parent = new ModelTemplateModel(source.BaseModelType, allTypes);
            }

            this.allTypes = allTypes;
        }

        /// <summary>
        /// Generates code for model serialization.
        /// </summary>
        /// <param name="variableName">Variable serialize model from.</param>
        /// <param name="type">The type of the model.</param>
        /// <returns>The code for serialization in string format.</returns>
        public virtual string SerializeProperty(string variableName, IType type)
        {
            var builder = new IndentedStringBuilder("  ");

            string serializationLogic = type.SerializeType(this.Scope, variableName);
            builder.AppendLine(serializationLogic);

            return builder.ToString();
        }

        /// <summary>
        /// Generates code for model deserialization.
        /// </summary>
        /// <param name="variableName">Variable deserialize model from.</param>
        /// <param name="type">The type of the model.</param>
        /// <returns>The code for вуserialization in string format.</returns>
        public virtual string DeserializeProperty(string variableName, IType type)
        {
            var builder = new IndentedStringBuilder("  ");

            string serializationLogic = type.DeserializeType(this.Scope, variableName);
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