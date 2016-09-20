// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Linq.Expressions;
using AutoRest.Core.Utilities;
using AutoRest.Core.Utilities.Collections;
using Newtonsoft.Json;

namespace AutoRest.Core.Model
{
    public interface ILiteralType
    {
        
    }

    /// <summary>
    /// Defines model data type.
    /// </summary>
    [JsonObject(IsReference = true)]
    public partial class CompositeType : ModelType, ILiteralType
    {
        private string _summary;
        private string _documentation;
        private CompositeType _baseModelType;

        public override string RefName => $"AutoRest.Core.Model.CompositeType, AutoRest.Core";


        partial void InitializeCollections();
        /// <summary>
        /// Initializes a new instance of CompositeType class.
        /// </summary>
        protected CompositeType()
        {
            InitializeCollections();
            Name.OnGet += value => CodeNamer.Instance.GetTypeName(value);
        }

        protected CompositeType(string name) : this()
        {
            Name = name;
        }

        /// <summary>
        /// Gets or sets the model type name used in on the wire.
        /// </summary>
        public virtual string SerializedName { get; set; }

        /// <summary>
        /// Gets the union of Parent and current type properties
        /// </summary>
        [JsonIgnore]
        public virtual IEnumerable<Property> ComposedProperties
        {
            get
            {
                if (BaseModelType != null)
                {
                    return BaseModelType.ComposedProperties.Union(Properties);
                }

                return this.Properties;
            }
        }

        /// <summary>
        /// Gets or sets the base model type.
        /// </summary>
        public virtual CompositeType BaseModelType
        {
            get { return _baseModelType; }
            set { _baseModelType = value; }
        }

        /// <summary>
        /// Gets or sets the discriminator property for polymorphic types.
        /// </summary>
        public virtual string PolymorphicDiscriminator { get; set; }

        /// <summary>
        /// Gets or sets the summary.
        /// </summary>
        public virtual string Summary
        {
            get { return _summary; }
            set { _summary = value.StripControlCharacters(); }
        }

        /// <summary>
        /// Gets or sets the CompositeType documentation.
        /// </summary>
        [BackingField(nameof(_documentation))]
        public string Documentation
        {
            get { return _documentation; }
            set { _documentation = value.StripControlCharacters(); }
        }

        /// <summary>
        /// Gets or sets a URL pointing to related external documentation.
        /// </summary>
        [SuppressMessage("Microsoft.Design", "CA1056:UriPropertiesShouldNotBeStrings",
            Justification = "May not parse as a valid URI.")]
        public virtual string ExternalDocsUrl { get; set; }

        /// <summary>
        /// Returns true if any of the properties is a Constant or is 
        /// a CompositeType which ContainsConstantProperties set to true.
        /// </summary>
        public virtual bool ContainsConstantProperties { get; set; }

        /// <summary>
        /// Gets a dictionary of x-vendor extensions defined for the CompositeType.
        /// </summary>
        public Dictionary<string, object> Extensions { get; } = new Dictionary<string, object>();

        /// <summary>
        /// Gets the union of Parent and current type properties
        /// </summary>
        [JsonIgnore]
        public Dictionary<string, object> ComposedExtensions
        {
            get
            {
                if (BaseModelType != null)
                {
                    return Extensions.Concat(BaseModelType.ComposedExtensions
                        .Where(pair => !Extensions.Keys.Contains(pair.Key)))
                        .ToDictionary(pair => pair.Key, pair => pair.Value);
                }

                return this.Extensions;
            }
        }

        public override string DefaultValue => IsConstant ? "{}" : null;

        public override bool IsConstant => ComposedProperties.Any() && ComposedProperties.All(p => p.IsConstant);

        /// <summary>
        /// Returns a string representation of the CompositeType object.
        /// </summary>
        /// <returns>
        /// A string representation of the CompositeType object.
        /// </returns>
        public override string ToString()
        {
            return Name;
        }

        /// <summary>
        /// Determines whether the specified object is equal to this object based on the Name.
        /// </summary>
        /// <param name="obj">The object to compare with this object.</param>
        /// <returns>true if the specified object is equal to this object; otherwise, false.</returns>
        public override bool Equals(object obj)
        {
            var modelType = obj as CompositeType;

            if (modelType != null)
            {
                return modelType.Name == Name;
            }

            return false;
        }

        /// <summary>
        /// Serves as a hash function based on Name.
        /// </summary>
        /// <returns>
        /// A hash code for the current object.
        /// </returns>
        public override int GetHashCode()
        {
            return Name == null ? 0 : Name.GetHashCode();
        }
       
        [JsonIgnore]
        public override IEnumerable<IChild> Children => Properties;

        [JsonIgnore]
        public override string Qualifier => "Type";

        [JsonIgnore]
        public override string QualifierType => "Model Type";
    }

    
    public class NoCopyAttribute : Attribute
    {
        public NoCopyAttribute()
        {
        }
    }

    public class BackingFieldAttribute : Attribute
    {
        public readonly string Name;
        public BackingFieldAttribute(string propertyName)
        {
            Name = propertyName;
        }
    }

}