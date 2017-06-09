// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.Core.Model
{
    /// <summary>
    /// Defines a key-value dictionary type with string key data type.
    /// </summary>
    public class DictionaryType : ModelType
    {
        protected DictionaryType()
        {
            Name.OnGet += value => $"Dictionary<string,{ValueType.Name}>";
        }

        /// <summary>
        /// Gets or sets the value type of the dictionary type.
        /// </summary>        
        public virtual IModelType ValueType { get; set; }

        /// <summary>
        /// Indicates that the class should deserialize properties with no matching class member into this collection.
        /// </summary>
        public virtual bool SupportsAdditionalProperties { get; set; }

        public override string RefName => "AutoRest.Core.Model.DictionaryType, AutoRest.Core";
        public override string Qualifier => "Dictionary";
        public override void Disambiguate()
        {
            // not needed, right?
        }
    }
}