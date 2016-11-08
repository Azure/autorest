// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using System.Collections.Generic;
using System.Globalization;
using AutoRest.Core.Utilities;
using AutoRest.Core.Utilities.Collections;
using AutoRest.Core.Validation;
using Newtonsoft.Json;

namespace AutoRest.Core.Model
{
    [JsonObject(IsReference = true)]
    public abstract class IVariable : IChild
    {
        private IModelType _modelType;
        private bool? _isConstant;

        // Fixable<T> properties should always be readonly, 
        // since they are set via the property accessor

        private readonly Fixable<string> _defaultValue = new Fixable<string>();
        private readonly Fixable<string> _documentation = new Fixable<string>();
        private readonly Fixable<string> _name = new Fixable<string>();

        protected IVariable()
        {
            // DefaultValue 'OnGet'
            DefaultValue.OnGet += v => CodeNamer.Instance.EscapeDefaultValue(v ?? ModelType.DefaultValue , ModelType);
            
            // Documentation 'OnGet' 
            Documentation.OnGet += result =>
            {
                var extendedDocs = ModelType?.ExtendedDocumentation ?? string.Empty;
                if (string.IsNullOrWhiteSpace(result))
                {
                    return extendedDocs;
                }
                if (string.IsNullOrWhiteSpace(extendedDocs))
                {
                    return result;
                }
                if (result.IndexOf(extendedDocs, StringComparison.Ordinal) > -1)
                {
                    return result;
                }
                return $"{result.TrimEnd(' ', '.')}. {extendedDocs}";
            };

            // when the documentation is set strip out superflous characters.
            _documentation.OnSet += value => value.StripControlCharacters();
        }

        /// <summary>
        /// Gets or sets collection format for array parameters.
        /// </summary>
        public virtual CollectionFormat CollectionFormat { get; set; }

        /// <summary>
        /// Gets or sets the constraints.
        /// </summary>
        public virtual Dictionary<Constraint, string> Constraints { get; } = new Dictionary<Constraint, string>();

        public virtual bool? IsXNullable => Extensions.Get<bool>("x-nullable");

        [JsonProperty]
        public Fixable<string> DefaultValue
        {
            get { return _defaultValue; }
            set { _defaultValue.CopyFrom(value); }
        }

        /// <summary>
        /// Gets or sets the documentation.
        /// </summary>
        public Fixable<string> Documentation
        {
            get { return _documentation; }
            set { _documentation.CopyFrom(value); }
        }

        /// <summary>
        /// Gets vendor extensions dictionary.
        /// </summary>
        public virtual Dictionary<string, object> Extensions { get; } = new Dictionary<string, object>();

        /// <summary>
        /// Indicates whether this property/parameter is required.
        /// </summary>
        public virtual bool IsRequired { get; set; }

        /// <summary>
        /// Indicates whether the parameter value is constant. If true, default value can not be null.
        /// </summary>
        public virtual bool IsConstant
        {
            get { return true == (_isConstant ?? ModelType?.IsConstant); }
            set { _isConstant = value; }
        }

        /// <summary>
        /// Gets or sets the name.
        /// </summary>
        [Rule(typeof(IsIdentifier))]
        public Fixable<string> Name
        {
            get { return _name; }
            set { _name.CopyFrom(value); }
        }

        public virtual string ModelTypeName => ModelType.Name;

        /// <Summary>
        /// Backing field for <code>SerializedName</code> property. 
        /// </Summary>
        /// <remarks>This field should be marked as 'readonly' as write access to it's value is controlled thru Fixable[T].</remarks>
        private readonly Fixable<string> _serializedName = new Fixable<string>();

        /// <Summary>
        /// The name on the wire for the variable.
        /// </Summary>
        /// <remarks>
        /// The Get and Set operations for this accessor may be overridden by using the 
        /// <code>SerializedName.OnGet</code> and <code>SerializedName.OnSet</code> events in this class' constructor.
        /// (ie <code> SerializedName.OnGet += serializedName => serializedName.ToUpper();</code> )
        /// </remarks>
        public Fixable<string> SerializedName
        {
            get { return _serializedName; }
            set { _serializedName.CopyFrom(value); }
        }

        /// <summary>
        /// Gets or sets the model type.
        /// </summary>
        public virtual IModelType ModelType
        {
            get { return _modelType; }
            set { _modelType = value; }
        }

        public virtual HashSet<string> LocallyUsedNames => null;

        public virtual void Disambiguate()
        {
            // basic behavior : ask the parent for a unique name for this variable.
            var originalName = Name;
            var name = CodeNamer.Instance.GetUnique(originalName, this, Parent.IdentifiersInScope, Parent.Children.Except(this.SingleItemAsEnumerable()));
            if (name != originalName)
            {
                Name = name;
            }
        }
        [JsonIgnore]
        public abstract IParent Parent { get; set; }
        [JsonIgnore]
        public abstract string Qualifier { get; }
        [JsonIgnore]
        public virtual string QualifierType => Qualifier;
        [JsonIgnore]
        public virtual IEnumerable<string> MyReservedNames  { get { if (!string.IsNullOrEmpty(Name)) { yield return Name; } }}
    }
}
  