// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using System.Globalization;

using AutoRest.Core.Validation;
using AutoRest.Swagger.Validation;
using System.Collections.Generic;

using Newtonsoft.Json;

namespace AutoRest.Swagger.Model
{
    /// <summary>
    /// Swagger schema object.
    /// </summary>
    [Serializable]
    [Rule(typeof(ModelTypeIncomplete))]
    public class Schema : SwaggerObject
    {
        public string Title { get; set; }

        /// <summary>
        /// Adds support for polymorphism. The discriminator is the schema 
        /// property serviceTypeName that is used to differentiate between other schemas 
        /// that inherit this schema. The property serviceTypeName used MUST be defined 
        /// at this schema and it MUST be in the required property list. When used, 
        /// the value MUST be the serviceTypeName of this schema or any schema that inherits it,
        /// or it can be overridden with the x-ms-discriminator-value extension.
        /// </summary>
        public string Discriminator { get; set; }

        /// <summary>
        /// Key is a type serviceTypeName.
        /// </summary>
        [CollectionRule(typeof(AvoidNestedProperties))]
        public Dictionary<string, Schema> Properties { get; set; }

        public bool ReadOnly { get; set; }

        public ExternalDoc ExternalDocs { get; set; }

        public object Example { get; set; }

        /// <summary>
        /// The value of this property MUST be another schema which will provide 
        /// a base schema which the current schema will inherit from.  The
        /// inheritance rules are such that any instance that is valid according
        /// to the current schema MUST be valid according to the referenced
        /// schema.  This MAY also be an array, in which case, the instance MUST
        /// be valid for all the schemas in the array.  A schema that extends
        /// another schema MAY define additional attributes, constrain existing
        /// attributes, or add other constraints.
        /// </summary>
        public string Extends { get; set; }

        //For now (till the PBI gets addressed for the refactoring work), a generic field is used
        //for the reason that SwaggerParameter inherits from this class, but per spec, it's 'IsRequired' 
        //field should be boolean, not an array.
        [CollectionRule(typeof(RequiredPropertiesMustExist))]
        public IList<string> Required { get; set; }

        /// <summary>
        /// Defines the set of schemas this shema is composed of
        /// </summary>
        public IList<Schema> AllOf { get; set; }

        [JsonIgnore]
        internal bool IsReferenced { get; set; }

        private DataDirection _compareDirection = DataDirection.None;

        /// <summary>
        /// Compare a modified document node (this) to a previous one and look for breaking as well as non-breaking changes.
        /// </summary>
        /// <param name="context">The modified document context.</param>
        /// <param name="previous">The original document model.</param>
        /// <returns>A list of messages from the comparison.</returns>
        public override IEnumerable<ComparisonMessage> Compare(ComparisonContext context, SwaggerBase previous)
        {
            var priorSchema = previous as Schema;

            if (priorSchema == null)
            {
                throw new ArgumentNullException("priorVersion");
            }
            if (context == null)
            {
                throw new ArgumentNullException("context");
            }

            int referenced = 0;

            var thisSchema = this;

            if (!string.IsNullOrWhiteSpace(thisSchema.Reference))
            {
                thisSchema = FindReferencedSchema(thisSchema.Reference, (context.CurrentRoot as ServiceDefinition).Definitions);
                referenced += 1;
            }
            if (!string.IsNullOrWhiteSpace(priorSchema.Reference))
            {
                priorSchema = FindReferencedSchema(priorSchema.Reference, (context.PreviousRoot as ServiceDefinition).Definitions);
                referenced += 1;
            }

            // Avoid doing the comparison repeatedly by marking for which direction it's already been done.

            if (context.Direction != DataDirection.None && referenced == 2)
            {
                // Comparing two referenced schemas in the context of a parameter or response -- did we already do this?

                if (thisSchema._compareDirection == context.Direction || thisSchema._compareDirection == DataDirection.Both)
                {
                    return new ComparisonMessage[0];
                }
                _compareDirection |= context.Direction;
            }

            if (thisSchema != this || priorSchema != previous)
            {
                return thisSchema.Compare(context, priorSchema);
            }

            base.Compare(context, previous);

            if (priorSchema.ReadOnly != ReadOnly)
            {
                context.LogBreakingChange(ComparisonMessages.ReadonlyPropertyChanged2, priorSchema.ReadOnly.ToString().ToLower(CultureInfo.CurrentCulture), ReadOnly.ToString().ToLower(CultureInfo.CurrentCulture));
            }

            if ((priorSchema.Discriminator == null && Discriminator != null) ||
                (priorSchema.Discriminator != null && !priorSchema.Discriminator.Equals(Discriminator)))
            {
                context.LogBreakingChange(ComparisonMessages.DifferentDiscriminator);
            }

            if ((priorSchema.Extends == null && Extends != null) ||
                (priorSchema.Extends != null && !priorSchema.Extends.Equals(Extends)))
            {
                context.LogBreakingChange(ComparisonMessages.DifferentExtends);
            }

            if ((priorSchema.AllOf == null && AllOf != null) ||
                (priorSchema.AllOf != null && AllOf == null))
            {
                context.LogBreakingChange(ComparisonMessages.DifferentAllOf);
            }
            else if (priorSchema.AllOf != null)
            {
                CompareAllOfs(context, priorSchema);
            }

            context.Push("properties");
            CompareProperties(context, priorSchema);
            context.Pop();

            return context.Messages;
        }


        private void CompareAllOfs(ComparisonContext context, Schema priorSchema)
        {
            var different = 0;
            foreach (var schema in priorSchema.AllOf)
            {
                if (!AllOf.Select(s => s.Reference).ToArray().Contains(schema.Reference))
                {
                    different += 1;
                }
            }
            foreach (var schema in AllOf)
            {
                if (!priorSchema.AllOf.Select(s => s.Reference).ToArray().Contains(schema.Reference))
                {
                    different += 1;
                }
            }

            if (different > 0)
            {
                context.LogBreakingChange(ComparisonMessages.DifferentAllOf);
            }
        }

        private void CompareProperties(ComparisonContext context, Schema priorSchema)
        {
            // Were any properties removed?

            if (priorSchema.Properties != null)
            {
                foreach (var def in priorSchema.Properties)
                {
                    Schema model = null;
                    if (Properties == null || !Properties.TryGetValue(def.Key, out model))
                    {
                        context.LogBreakingChange(ComparisonMessages.RemovedProperty1, def.Key);
                    }
                    else
                    {
                        context.Push(def.Key);
                        model.Compare(context, def.Value);
                        context.Pop();
                    }
                }
            }

            // Were any required properties added?

            if (Properties != null)
            {
                foreach (var def in Properties.Keys)
                {
                    Schema model = null;
                    if (priorSchema.Properties == null || !priorSchema.Properties.TryGetValue(def, out model) && Required.Contains(def))
                    {
                        context.LogBreakingChange(ComparisonMessages.AddedRequiredProperty1, def);
                    }
                }
            }
        }

        private static Schema FindReferencedSchema(string reference, IDictionary<string, Schema> definitions)
        {
            if (reference != null && reference.StartsWith("#", StringComparison.Ordinal))
            {
                var parts = reference.Split('/');
                if (parts.Length == 3 && parts[1].Equals("definitions"))
                {
                    Schema p = null;
                    if (definitions.TryGetValue(parts[2], out p))
                    {
                        return p;
                    }
                }
            }

            return null;
        }
    }
}