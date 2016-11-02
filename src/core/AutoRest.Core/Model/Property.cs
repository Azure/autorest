// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Collections.Generic;
using AutoRest.Core.Utilities;
using Newtonsoft.Json;
using System.Linq;
using Newtonsoft.Json.Linq;

namespace AutoRest.Core.Model
{
    /// <summary>
    ///     Defines model properties.
    /// </summary>
    [JsonObject(IsReference = true)]
    public class Property : IVariable
    {
        [JsonExtensionData]
#pragma warning disable 169
        private IDictionary<string, JToken> _additionalData;
#pragma warning restore 169

        private IParent _parent;

        /// <Summary>
        ///     Backing field for Summary property.
        /// </Summary>
        /// <remarks>
        ///     This field should be marked as 'readonly' as write access to it's value is controlled thru Fixable[T]
        /// </remarks>
        private readonly Fixable<string> _summary = new Fixable<string>();

        /// <summary>
        ///     Creates a new instance of Property class.
        /// </summary>
        protected Property()
        {
            // when the documentation is set strip out superflous characters.
            _summary.OnSet += value => value.StripControlCharacters();

            // Name can be overriden by x-ms-client-name
            Name.OnGet += v => CodeNamer.Instance.GetPropertyName(Extensions.GetValue<string>("x-ms-client-name").Else(v));
        }

        [JsonIgnore]
        public override IParent Parent
        {
            get { return _parent; }
            set
            {
                // when the reference to the parent is set
                // we should disambiguate the name 
                // it is imporant that this reference gets set before 
                // the item is actually added to the containing collection.

                if (!ReferenceEquals(_parent, value))
                {
                    // only perform disambiguation if this item is not already 
                    // referencing the parent 
                    _parent = value;

                    // (which implies that it's in the collection, but I can't prove that.)
                    Disambiguate();
                }
            }
        }

        public override string Qualifier => "Property";

        [JsonProperty("$actualType", Order = -99)]
        public string ActualType => GetType().FullName;

        /// <summary>
        ///     Indicates whether this property is read only.
        /// </summary>
        public virtual bool IsReadOnly { get; set; }

        /// <Summary>
        ///     Accessor for Summary
        /// </Summary>
        /// <remarks>
        ///     The Get and Set operations for this accessor may be overridden by using the
        ///     <code>Summary.OnGet</code> and <code> Summary.OnSet</code> events in this class' constructor.
        ///     (ie <code> Summary.OnGet += summary => summary.ToUpper();</code> )
        /// </remarks>
        public Fixable<string> Summary
        {
            get { return _summary; }
            set { _summary.CopyFrom(value); }
        }

        /// <summary>
        ///     Returns a string representation of the Property object.
        /// </summary>
        /// <returns>
        ///     A string representation of the Property object.
        /// </returns>
        public override string ToString() => $"{ModelTypeName} {Name} {{get;{(IsReadOnly ? "" : "set;")}}}";

        public virtual bool IsPolymorphicDiscriminator => true == (Parent as CompositeType)?.BasePolymorphicDiscriminator?.EqualsIgnoreCase(Name.RawValue);
    }
}