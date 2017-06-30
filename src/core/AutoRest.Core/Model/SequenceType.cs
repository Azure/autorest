// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Globalization;
using Newtonsoft.Json;
using AutoRest.Core.Utilities;

namespace AutoRest.Core.Model
{
    /// <summary>
    /// Defines a collection data type.
    /// </summary>
    [JsonObject(IsReference = true)]
    public class SequenceType : ModelType
    {
        protected SequenceType()
        {
            Name.OnGet+= v=> $"IList<{ElementType.Name}>";
        }

        [JsonIgnore]
        public override string Qualifier => "Dictionary";

        public override void Disambiguate()
        {
            // not needed, right?
        }

        /// <summary>
        /// Gets or sets the element type of the collection.
        /// </summary>
        public virtual IModelType ElementType { get; set; }

        /// <summary>
        ///  Xml Properties...
        /// </summary>
        public XmlProperties ElementXmlProperties { get; set; }

        [JsonIgnore]
        public override string XmlName => base.XmlName.Else(ElementType.XmlName);

        [JsonIgnore]
        public string ElementXmlName => ElementXmlProperties?.Name ?? XmlName;
        [JsonIgnore]
        public string ElementXmlNamespace => ElementXmlProperties?.Namespace ?? ElementType.XmlNamespace;
        [JsonIgnore]
        public string ElementXmlPrefix => ElementXmlProperties?.Prefix ?? ElementType.XmlPrefix;
        [JsonIgnore]
        public bool ElementXmlIsWrapped => ElementXmlProperties?.Wrapped ?? ElementType.XmlIsWrapped;
    }
}