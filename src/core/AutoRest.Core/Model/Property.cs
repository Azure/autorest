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
        private string _summary;

        /// <summary>
        ///     Creates a new instance of Property class.
        /// </summary>
        protected Property()
        {
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

        [JsonIgnore]
        public override string Qualifier => "Property";

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
        public string Summary
        {
            get { return _summary; }
            set { _summary = value.StripControlCharacters(); }
        }

        [JsonIgnore]
        public virtual bool IsPolymorphicDiscriminator => true == (Parent as CompositeType)?.BasePolymorphicDiscriminator?.EqualsIgnoreCase(Name.RawValue);

        /// <summary>
        /// Represents the path for getting to this property when holding the JSON node of the parent object in your hand.
        /// </summary>
        public IEnumerable<string> RealPath { get; set; }

        /// <summary>
        /// Represents the path for getting to this property when holding the XML node of the parent object in your hand.
        /// </summary>
        [JsonIgnore]
        public IEnumerable<string> RealXmlPath
        {
            get
            {
                // special case: sequence types are usually inlined into parent
                if (ModelType is SequenceType && !XmlIsWrapped)
                {
                    yield break;
                }

                // special case: inline property (like additional properties and such)
                if (RealPath?.Any() != true)
                {
                    yield break;
                }

                yield return XmlName;
            }
        }

        public XmlProperties XmlProperties { get; set; }

        [JsonIgnore]
        public string XmlName => XmlProperties?.Name ?? RealPath.FirstOrDefault() ?? Name;
        [JsonIgnore]
        public string XmlNamespace => XmlProperties?.Namespace ?? ModelType.XmlNamespace;
        [JsonIgnore]
        public string XmlPrefix => XmlProperties?.Prefix ?? ModelType.XmlPrefix;
        [JsonIgnore]
        public bool XmlIsWrapped => XmlProperties?.Wrapped ?? ModelType.XmlIsWrapped;
        [JsonIgnore]
        public bool XmlIsAttribute => XmlProperties?.Attribute ?? ModelType.XmlIsAttribute;
    }
}