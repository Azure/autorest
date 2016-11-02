// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Utilities;
using AutoRest.Core.Utilities.Collections;
using Newtonsoft.Json;

namespace AutoRest.Core.Model
{
    public partial class MethodGroup : IChild
    {
        private CodeModel _codeModel;

        /// <Summary>
        ///     Backing field for <code>Name</code> property.
        /// </Summary>
        /// <remarks>This field should be marked as 'readonly' as write access to it's value is controlled thru Fixable[T].</remarks>
        private readonly Fixable<string> _name = new Fixable<string>();

        /// <Summary>
        ///     Backing field for <code>TypeName</code> property.
        /// </Summary>
        /// <remarks>This field should be marked as 'readonly' as write access to it's value is controlled thru Fixable[T].</remarks>
        private readonly Fixable<string> _typeName = new Fixable<string>();


        protected MethodGroup()
        {
            InitializeCollections();
            InitializeProperties();
        }

        private void InitializeProperties()
        {
            Name.OnGet += value => CodeNamer.Instance.GetMethodGroupName(value.Else(string.Empty));
            NameForProperty.OnGet += value => CodeNamer.Instance.GetPropertyName(value.Else(value.Else(IsCodeModelMethodGroup ? CodeModel?.Name : Name.Value)));
            NameForParameter.OnGet += value => CodeNamer.Instance.GetParameterName(value.Else(IsCodeModelMethodGroup ? CodeModel?.Name : Name.Value));    
            NameForVariable.OnGet += value => CodeNamer.Instance.GetVariableName(value.Else(IsCodeModelMethodGroup ? CodeModel?.Name : Name.Value));

            TypeName.OnGet += value => CodeNamer.Instance.GetTypeName(value.Else( IsCodeModelMethodGroup ? CodeModel?.Name : Name.Value));
        }

        protected MethodGroup(string name) : this()
        {
            Name = name;
        }
        public bool IsCodeModelMethodGroup => Name.IsNullOrEmpty() || Name.EqualsIgnoreCase(CodeModel?.Name);
        /// <Summary>
        ///     The 'raw' name of the method group.
        /// </Summary>
        /// <remarks>
        ///     The Get and Set operations for this accessor may be overridden by using the
        ///     <code>MethodGroupName.OnGet</code> and <code>MethodGroupName.OnSet</code> events in this class' constructor.
        ///     (ie <code> MethodGroupName.OnGet += methodGroupName => methodGroupName.ToUpper();</code> )
        /// </remarks>
        public Fixable<string> Name
        {
            get { return _name; }
            set { _name.CopyFrom(value); }
        }

        /// <Summary>
        ///     The name that the generated type should be called.
        /// </Summary>
        /// <remarks>
        ///     The Get and Set operations for this accessor may be overridden by using the
        ///     <code>TypeName.OnGet</code> and <code>TypeName.OnSet</code> events in this class' constructor.
        ///     (ie <code> TypeName.OnGet += typeName => typeName.ToUpper();</code> )
        /// </remarks>
        public Fixable<string> TypeName
        {
            get { return _typeName; }
            set { _typeName.CopyFrom(value); }
        }

        /// <Summary>
        /// Backing field for <code>NameForParameter</code> property. 
        /// </Summary>
        /// <remarks>This field should be marked as 'readonly' as write access to it's value is controlled thru Fixable[T].</remarks>
        private readonly Fixable<string> _nameForParameter = new Fixable<string>();

        /// <Summary>
        /// Accessor for <code>NameForParameter</code>
        /// </Summary>
        /// <remarks>
        /// The Get and Set operations for this accessor may be overridden by using the 
        /// <code>NameForParameter.OnGet</code> and <code>NameForParameter.OnSet</code> events in this class' constructor.
        /// (ie <code> NameForParameter.OnGet += nameForParameter => nameForParameter.ToUpper();</code> )
        /// </remarks>
        public Fixable<string> NameForParameter
        {
            get { return _nameForParameter; }
            set { _nameForParameter.CopyFrom(value); }
        }
        public virtual HashSet<string> LocallyUsedNames => null;
        /// <Summary>
        /// Backing field for <code>NameForVariable</code> property. 
        /// </Summary>
        /// <remarks>This field should be marked as 'readonly' as write access to it's value is controlled thru Fixable[T].</remarks>
        private readonly Fixable<string> _nameForVariable = new Fixable<string>();

        /// <Summary>
        /// Accessor for <code>NameForVariable</code>
        /// </Summary>
        /// <remarks>
        /// The Get and Set operations for this accessor may be overridden by using the 
        /// <code>NameForVariable.OnGet</code> and <code>NameForVariable.OnSet</code> events in this class' constructor.
        /// (ie <code> NameForVariable.OnGet += nameForVariable => nameForVariable.ToUpper();</code> )
        /// </remarks>
        public Fixable<string> NameForVariable
        {
            get { return _nameForVariable; }
            set { _nameForVariable.CopyFrom(value); }
        }

        /// <Summary>
        /// Backing field for <code>InstanceName</code> property. 
        /// </Summary>
        /// <remarks>This field should be marked as 'readonly' as write access to it's value is controlled thru Fixable[T].</remarks>
        private readonly Fixable<string> _nameForProperty = new Fixable<string>();

        /// <Summary>
        /// The name that an instance of the generated class should be called.
        /// </Summary>
        /// <remarks>
        /// The Get and Set operations for this accessor may be overridden by using the 
        /// <code>InstanceName.OnGet</code> and <code>InstanceName.OnSet</code> events in this class' constructor.
        /// (ie <code> InstanceName.OnGet += instanceName => instanceName.ToUpper();</code> )
        /// </remarks>
        public Fixable<string> NameForProperty
        {
            get { return _nameForProperty; }
            set { _nameForProperty.CopyFrom(value); }
        }

        public virtual IEnumerable<string> Usings
        {
            get
            {
                if (CodeModel.ModelTypes.Any() || CodeModel.HeaderTypes.Any())
                {
                    yield return CodeModel.ModelsName;
                }
            }
        }

        [JsonIgnore]
        public string Qualifier => "Operations";

        [JsonIgnore]
        public string QualifierType => "Operation Group";

        [JsonIgnore]
        public virtual IEnumerable<string> MyReservedNames
        {
            get
            {
                if (!string.IsNullOrEmpty(TypeName))
                {
                    yield return TypeName;
                }
            }
        }

        [JsonIgnore]
        public IParent Parent => CodeModel;

        public virtual void Disambiguate()
        {
            if (IsCodeModelMethodGroup)
            {
                return;
            }

            // we disambiguate the generated Type Name (not the internal 'group name') 
            var originalName = TypeName;
            var t = CodeNamer.Instance.GetUnique(originalName, this,
                Parent.IdentifiersInScope,
                Enumerable.Empty<IIdentifier>());
            if (t != originalName)
            {
                TypeName = t;
            }
        }

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

        [JsonIgnore]
        public virtual IEnumerable<IIdentifier> IdentifiersInScope => this.SingleItemConcat(Parent?.IdentifiersInScope);

        [JsonIgnore]
        public IEnumerable<IChild> Children => Methods;

        partial void InitializeCollections();
    }
}