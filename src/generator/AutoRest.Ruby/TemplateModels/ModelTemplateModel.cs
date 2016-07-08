// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.Ruby.TemplateModels
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
                return new List<string> { };
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

            if (!string.IsNullOrEmpty(source.PolymorphicDiscriminator))
            {
                if (!source.Properties.Any(p => p.Name == source.PolymorphicDiscriminator))
                {
                    var polymorphicProperty = new Property
                    {
                        IsRequired = true,
                        Name = source.PolymorphicDiscriminator,
                        SerializedName = source.PolymorphicDiscriminator,
                        Documentation = "Polymorhpic Discriminator",
                        Type = new PrimaryType(KnownPrimaryType.String)
                    };
                    source.Properties.Add(polymorphicProperty);
                }
            }

            if (source.BaseModelType != null)
            {
                this.parent = new ModelTemplateModel(source.BaseModelType, allTypes);
            }

            this.allTypes = allTypes;
        }

        /// <summary>
        /// Returns code for declaring inheritance.
        /// </summary>
        /// <returns>Code for declaring inheritance.</returns>
        public virtual string GetBaseTypeName()
        {
            return this.BaseModelType != null ? " < " + this.BaseModelType.Name : string.Empty;
        }

        /// <summary>
        /// Constructs mapper for the model class.
        /// </summary>
        /// <returns>Mapper as string for this model class.</returns>
        public virtual string ConstructModelMapper()
        {
            var modelMapper = this.ConstructMapper(SerializedName, null, true);
            var builder = new IndentedStringBuilder("  ");
            builder.AppendLine("{{{0}}}", modelMapper);
            return builder.ToString();
        }

        public string BuildSummaryAndDescriptionString()
        {
            string summaryString = string.IsNullOrWhiteSpace(this.Summary) &&
                                   string.IsNullOrWhiteSpace(this.Documentation)
                ? "Model object."
                : this.Summary;

            StringBuilder builder = new StringBuilder();
            if (!string.IsNullOrEmpty(summaryString))
            {
                builder.AppendLine(summaryString);
            }

            if (!string.IsNullOrEmpty(summaryString) && !string.IsNullOrEmpty(this.Documentation))
            {
                builder.AppendLine(TemplateConstants.EmptyLine);
            }

            if (!string.IsNullOrEmpty(this.Documentation))
            {
                builder.Append(this.Documentation);
            }

            return builder.ToString();
        }

        /// <summary>
        /// Provides the property documentation string.
        /// </summary>
        /// <param name="property">Parameter to be documented</param>
        /// <returns>Parameter documentation string.</returns>
        public static string GetPropertyDocumentationString(Property property)
        {
            if (property == null)
            {
                throw new ArgumentNullException("property");
            }

            string summary = property.Summary;

            if (!string.IsNullOrWhiteSpace(summary) && !summary.EndsWith(".", StringComparison.OrdinalIgnoreCase))
            {
                summary += ".";
            }

            string documentation = property.Documentation;
            if (!string.IsNullOrWhiteSpace(property.DefaultValue))
            {
                if (documentation != null && !documentation.EndsWith(".", StringComparison.OrdinalIgnoreCase))
                {
                    documentation += ".";
                }
                documentation += " Default value: " + property.DefaultValue + " .";
            }

            string docString = string.Join(" ", new[] { summary, documentation }.Where(s => !string.IsNullOrEmpty(s)));
            return docString;
        }
    }
}