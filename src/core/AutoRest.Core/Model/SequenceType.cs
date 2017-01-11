// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Globalization;
using Newtonsoft.Json;

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

        public override string Qualifier => "Dictionary";
        public override string RefName => $"AutoRest.Core.Model.SequenceType, AutoRest.Core";
        public override void Disambiguate()
        {
            // not needed, right?
        }

        /// <summary>
        /// Gets or sets the element type of the collection.
        /// </summary>
        public virtual IModelType ElementType { get; set; }
    }
}