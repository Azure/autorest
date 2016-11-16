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
            Name.OnGet+= v=> $"IList<{ElementType}>";
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

       

        /// <summary>
        /// Returns a string representation of the SequenceType object.
        /// </summary>
        /// <returns>
        /// A string representation of the SequenceType object.
        /// </returns>
        public override string ToString()
        {
            return Name;
        }

        ///// <summary>
        ///// Determines whether the specified object is equal to this object based on the ElementType.
        ///// </summary>
        ///// <param name="obj">The object to compare with this object.</param>
        ///// <returns>true if the specified object is equal to this object; otherwise, false.</returns>
        //public override bool Equals(object obj)
        //{
        //    var sequenceType = obj as SequenceType;

        //    if (sequenceType != null)
        //    {
        //        return sequenceType.ElementType == ElementType;
        //    }

        //    return false;
        //}

        /// <summary>
        /// Determines whether the specified model type is structurally equal to this object.
        /// </summary>
        /// <param name="other">The object to compare with this object.</param>
        /// <returns>true if the specified object is functionally equal to this object; otherwise, false.</returns>
        public override bool StructurallyEquals(IModelType other)
        {
            if (ReferenceEquals(other as SequenceType, null))
            {
                return false;
            }

            return base.StructurallyEquals(other) && 
                ElementType.StructurallyEquals((other as SequenceType).ElementType);
        }

        ///// <summary>
        ///// Serves as a hash function based on ElementType.
        ///// </summary>
        ///// <returns>
        ///// A hash code for the current object.
        ///// </returns>
        //public override int GetHashCode()
        //{
        //    return ElementType.GetHashCode();
        //}
    }
}