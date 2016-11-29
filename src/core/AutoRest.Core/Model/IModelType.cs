// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using AutoRest.Core.Utilities;
using AutoRest.Core.Utilities.Collections;
using AutoRest.Core.Validation;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace AutoRest.Core.Model
{
    /// <summary>
    /// Defines an interface for client model types.
    /// </summary>
    [JsonObject(IsReference = true)]
    public interface IModelType : IParent, IChild
    {
        /// <summary>
        /// Gets or sets the IModelType name.
        /// </summary>
        [Rule(typeof(IsIdentifier))]
        Fixable<string> Name { get; }

        /// <summary>
        /// Allows a type to append extra documentation on a property
        /// </summary>
        string ExtendedDocumentation { get; }

        /// <summary>
        /// Allows a type to specify what the default value looks like.
        /// </summary>
        string DefaultValue { get; }

        /// <summary>
        /// Allows a type to specify that it is a constant value
        /// </summary>
        bool IsConstant { get; }

        string DeclarationName { get; }

        string ClassName { get; }

        /// <summary>
        /// Determines whether the specified model type is structurally equal to this object.
        /// </summary>
        /// <param name="other">The object to compare with this object.</param>
        /// <returns>true if the specified object is functionally equal to this object; otherwise, false.</returns>
        bool StructurallyEquals(IModelType other);
    }

    /// <summary>
    /// Base implementation for all ModelTypes
    /// </summary>
    [JsonObject(IsReference = true)]
    public abstract class ModelType : IModelType
    {
        private CodeModel _codeModel;
        private readonly Fixable<string> _name = new Fixable<string>();

        /// <summary>
        /// Gets or sets the IModelType name.
        /// </summary>
        public Fixable<string> Name
        {
            get{ return _name;}
            protected set { _name.CopyFrom(value); }
        }

        public virtual string ClassName => Name.Value;

        public virtual string DeclarationName => Name.Value;

        /// <summary>
        /// Allows a type to append extra documentation on a property
        /// </summary>
        public virtual string ExtendedDocumentation => null;

        /// <summary>
        /// Allows a type to specify what the default value looks like.
        /// </summary>
        public virtual string DefaultValue => null;

        /// <summary>
        /// Allows a type to specify that it is a constant value
        /// </summary>
        public virtual bool IsConstant => false;

        /// <summary>
        /// Reference to the container of this type.
        /// </summary>
        [JsonIgnore]
        public CodeModel CodeModel
        {
            get { return _codeModel; }
            set
            {
                // when the reference to the parent is set
                // we should disambiguate the name 
                // it is imporant that this reference gets set before 
                // the item is actually added to the containing collection.

                if (!ReferenceEquals(_codeModel, value))
                {
                    // only perform disambiguation if this item is not already 
                    // referencing the parent 
                    _codeModel = value;

                    // (which implies that it's in the collection, but I can't prove that.)
                    Disambiguate();

                    // and if we're adding ourselves to a new parent, better make sure 
                    // our children are disambiguated too.
                    Children.Disambiguate();

                }
            }
        }
        public virtual HashSet<string> LocallyUsedNames { get; } = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        public IParent Parent => CodeModel;

        public virtual void Disambiguate()
        {
            // basic behavior : ensure that my name is unique.
            var originalName = Name;
            var name = CodeNamer.Instance.GetUnique(originalName, this, Parent.IdentifiersInScope.Except(this.SingleItemAsEnumerable()), Parent.Children.Except(this.SingleItemAsEnumerable()));
            if (name != originalName)
            {
                Name = name;
            }
        }

        /// <summary>
        /// Determines whether the specified model type is structurally equal to this object.
        /// </summary>
        /// <param name="other">The object to compare with this object.</param>
        /// <returns>true if the specified object is functionally equal to this object; otherwise, false.</returns>
        public virtual bool StructurallyEquals(IModelType other)
        {
            if (ReferenceEquals(other, null))
            {
                return false;
            }

            return GetType() == other.GetType() && Name.Equals(other.Name);
        }

        /// <summary>
        /// Gets a dictionary of x-vendor extensions defined for the CompositeType.
        /// </summary>
        public Dictionary<string, object> Extensions { get; } = new Dictionary<string, object>();

        [JsonProperty("$type", Order = -100)]
        public abstract string RefName { get; }

        [JsonProperty("$actualType", Order = -99)]
        public string ActualType => this.GetType().FullName;


        [JsonIgnore]
        public abstract string Qualifier { get; }

        [JsonIgnore]
        public virtual string QualifierType => Qualifier;
        [JsonIgnore]
        public virtual IEnumerable<string> MyReservedNames { get { if (!string.IsNullOrEmpty(Name)) { yield return Name; } }}
        [JsonIgnore]
        public virtual IEnumerable<IIdentifier> IdentifiersInScope => this.SingleItemConcat(Parent?.IdentifiersInScope);
        [JsonIgnore]
        public virtual IEnumerable<IChild> Children => Enumerable.Empty<IChild>();

    }

}