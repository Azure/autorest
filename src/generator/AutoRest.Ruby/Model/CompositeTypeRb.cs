// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Ruby.Model
{
    /// <summary>
    /// A model for the model template.
    /// </summary>
    public class CompositeTypeRb : CompositeType
    {
        /// <summary>
        /// The reference to the base object.
        /// </summary>
        private CompositeTypeRb parent => BaseModelType as CompositeTypeRb;

        /// <summary>
        /// Gets the list of own properties of the object.
        /// </summary>
        public IEnumerable<PropertyRb> PropertyTemplateModels => Properties.Cast<PropertyRb>();

        /// <summary>
        /// Gets the list of modules/classes which need to be included.
        /// </summary>
        public virtual IEnumerable<string> Includes => Enumerable.Empty<string>();

        /// <summary>
        /// Gets the list of namespaces where we look for classes that need to
        /// be instantiated dynamically due to polymorphism.
        /// </summary>
        public virtual IEnumerable<string> ClassNamespaces => Enumerable.Empty<string>();

        /// <summary>
        /// Gets the list of all model types derived directly or indirectly from this type.
        /// </summary>
        public IEnumerable<CompositeType> DerivedTypes => CodeModel.ModelTypes.Where(t => t.DerivesFrom(this));

        /// <summary>
        /// Initializes a new instance of the ModelTemplateModel class.
        /// </summary>
        protected CompositeTypeRb()
        {
        }

        protected CompositeTypeRb(string name): base(name)
        {
            
        }
        /// <summary>
        /// Gets or sets the discriminator property for polymorphic types.
        /// </summary>
        public override string PolymorphicDiscriminator
        {
            get { return base.PolymorphicDiscriminator; }
            set
            {
                base.PolymorphicDiscriminator = value;
                AddPolymorphicPropertyIfNecessary();
            }
        }

        /// <summary>
        /// If PolymorphicDiscriminator is set, makes sure we have a PolymorphicDiscriminator property.
        /// </summary>
        private void AddPolymorphicPropertyIfNecessary()
        {
            if (!string.IsNullOrEmpty(PolymorphicDiscriminator) && Properties.All(p => p.Name != PolymorphicDiscriminator))
            {
                var newProp = base.Add(New<Property>(new
                {
                    IsRequired = true,
                    Name = PolymorphicDiscriminator,
                    SerializedName = PolymorphicDiscriminator,
                    Documentation = "Polymorphic Discriminator",
                    ModelType = New<PrimaryType>(KnownPrimaryType.String)
                }));
                newProp.Name.FixedValue = newProp.Name.RawValue;
            }
        }

        public override Property Add(Property item)
        {
            var property = base.Add(item) as PropertyRb;
            AddPolymorphicPropertyIfNecessary();
            return property;
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