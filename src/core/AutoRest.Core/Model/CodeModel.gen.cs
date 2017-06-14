// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 
// This file was generated from a template on: 09/28/2016 12:04:25

using System;
using System.Linq;
using System.Collections.Generic;
using AutoRest.Core.Utilities;
using AutoRest.Core.Utilities.Collections;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace AutoRest.Core.Model
{
    public partial class CodeModel
    {
        [JsonExtensionData]
#pragma warning disable 169
        private IDictionary<string, JToken> _additionalData;
#pragma warning restore 169


        [JsonProperty(Order = -1 )]
        [JsonConverter(typeof(GeneratedCollectionConverter<Property>))]
        public virtual IEnumerableWithIndex<Property> Properties => _properties;
        private readonly ListEx<Property> _properties = new ListEx<Property>();
        // IEnumerator<Property> IEnumerable<Property>.GetEnumerator() => Properties.GetEnumerator();
        
        public virtual Property Add(Property item)
        {
            if( !_properties.Contains( item )  )
            {
                // disambiguation is performed when the item's parent reference is changed
                item.Parent = this;
                _properties.Add(item);
            }
            return item;
        }
        public virtual Property Insert(Property item)
        {
            if( !_properties.Contains(item))
            {
                // disambiguation is performed when the item's parent reference is changed
                item.Parent = this;
                _properties.Insert(0, item);
            }
            return item;
        }
        public virtual void Remove(Property item)
        {
            _properties.Remove(item);
        }
        

        [JsonProperty(Order = -1 )]
        [JsonConverter(typeof(GeneratedCollectionConverter<MethodGroup>))]
        public virtual IEnumerableWithIndex<MethodGroup> Operations => _operations;
        private readonly ListEx<MethodGroup> _operations = new ListEx<MethodGroup>();
        // IEnumerator<MethodGroup> IEnumerable<MethodGroup>.GetEnumerator() => Operations.GetEnumerator();
        
        public virtual MethodGroup Add(MethodGroup item)
        {
            if( !_operations.Contains( item )  )
            {
                // disambiguation is performed when the item's parent reference is changed
                item.CodeModel = this;
                _operations.Add(item);
            }
            return item;
        }

        [JsonProperty(Order = -3 )]
        [JsonConverter(typeof(GeneratedCollectionConverter<EnumType>))]
        public virtual IEnumerableWithIndex<EnumType> EnumTypes => _enumtypes;
        private readonly ListEx<EnumType> _enumtypes = new ListEx<EnumType>();
        // IEnumerator<EnumType> IEnumerable<EnumType>.GetEnumerator() => EnumTypes.GetEnumerator();
        
        public virtual EnumType Add(EnumType item)
        {
            if( !_enumtypes.Contains( item )  )
            {
                // disambiguation is performed when the item's parent reference is changed
                item.CodeModel = this;
                _enumtypes.Add(item);
            }
            return item;
        }
        

        [JsonProperty(Order = -6 )]
        [JsonConverter(typeof(GeneratedCollectionConverter<CompositeType>))]
        public virtual IEnumerableWithIndex<CompositeType> ModelTypes => _modeltypes;
        private readonly ListEx<CompositeType> _modeltypes = new ListEx<CompositeType>();
        // IEnumerator<CompositeType> IEnumerable<CompositeType>.GetEnumerator() => ModelTypes.GetEnumerator();

        partial void BeforeAdd(CompositeType item);
        public virtual CompositeType Add(CompositeType item)
        {
            if( !_modeltypes.Contains( item )  )
            {
                BeforeAdd(item);
                // disambiguation is performed when the item's parent reference is changed
                item.CodeModel = this;
                _modeltypes.Add(item);
            }
            return item;
        }
        public virtual void Remove(CompositeType item)
        {
            _modeltypes.Remove(item);
        }
        

        [JsonProperty(Order = -5 )]
        [JsonConverter(typeof(GeneratedCollectionConverter<CompositeType>))]
        public virtual IEnumerableWithIndex<CompositeType> ErrorTypes => _errortypes;
        private readonly ListEx<CompositeType> _errortypes = new ListEx<CompositeType>();

        partial void BeforeAddError(CompositeType item);
        public virtual CompositeType AddError(CompositeType item)
        {
            if( !_errortypes.Contains( item )  )
            {
                BeforeAddError(item);
                // disambiguation is performed when the item's parent reference is changed
                item.CodeModel = this;
                _errortypes.Add(item);
            }
            return item;
        }        

        [JsonProperty(Order = -4 )]
        [JsonConverter(typeof(GeneratedCollectionConverter<CompositeType>))]
        public virtual IEnumerableWithIndex<CompositeType> HeaderTypes => _headertypes;
        private readonly ListEx<CompositeType> _headertypes = new ListEx<CompositeType>();
		
        public virtual CompositeType AddHeader(CompositeType item)
        {
            if( !_headertypes.Contains( item ) && !_modeltypes.Contains( item ) )
            {
                // disambiguation is performed when the item's parent reference is changed
                item.CodeModel = this;
                _headertypes.Add(item);
            }
            return item;
        }
        
        partial void InitializeCollections() 
        {
            _headertypes.AddMethod = AddHeader;
            _errortypes.AddMethod = AddError;
            _modeltypes.AddMethod = Add;
            _enumtypes.AddMethod = Add;
            _operations.AddMethod = Add;
            _properties.AddMethod = Add;
        }
    }

    public partial class MethodGroup : IParent
    {
        [JsonExtensionData]
#pragma warning disable 169
        private IDictionary<string, JToken> _additionalData;
#pragma warning restore 169


        [JsonProperty(Order = -1 )]
        [JsonConverter(typeof(GeneratedCollectionConverter<Method>))]
        public virtual IEnumerableWithIndex<Method> Methods => _methods;
        private readonly ListEx<Method> _methods = new ListEx<Method>();
        // IEnumerator<Method> IEnumerable<Method>.GetEnumerator() => Methods.GetEnumerator();
		
        public virtual void ClearMethods()
        {
            Remove(each => true);
        }
        
        public virtual Method Add(Method item)
        {
            if( !_methods.Contains( item )  )
            {
                // disambiguation is performed when the item's parent reference is changed
                item.MethodGroup = this;
                _methods.Add(item);
            }
            return item;
        }
        public virtual void Remove(Method item)
        {
            _methods.Remove(item);
        }
        public int Remove(Predicate<Method> match) {
            var i = 0;
            foreach (var each in _methods.Where(each => match(each)).ToArray())
            {
                Remove(each);
                i++;
            }
            return i;			
        }
        
        partial void InitializeCollections() 
        {
            _methods.AddMethod = Add;
        }
    }

    public partial class CompositeType : IParent
    {
        [JsonExtensionData]
#pragma warning disable 169
        private IDictionary<string, JToken> _additionalData;
#pragma warning restore 169


        [JsonProperty(Order = -1 )]
        [JsonConverter(typeof(GeneratedCollectionConverter<Property>))]
        public virtual IEnumerableWithIndex<Property> Properties => _properties;
        private readonly ListEx<Property> _properties = new ListEx<Property>();
        // IEnumerator<Property> IEnumerable<Property>.GetEnumerator() => Properties.GetEnumerator();
		
        public virtual void ClearProperties()
        {
            Remove(each => true);
        }
        
        public virtual Property Add(Property item)
        {
            if( !_properties.Contains( item )  )
            {
                // disambiguation is performed when the item's parent reference is changed
                item.Parent = this;
                _properties.Add(item);
            }
            return item;
        }
        public virtual void Remove(Property item)
        {
            _properties.Remove(item);
        }
        public int Remove(Predicate<Property> match) {
            var i = 0;
            foreach (var each in _properties.Where(each => match(each)).ToArray())
            {
                Remove(each);
                i++;
            }
            return i;			
        }
        
        partial void InitializeCollections() 
        {
            _properties.AddMethod = Add;
        }
    }

    public partial class Method : IParent
    {
        [JsonExtensionData]
#pragma warning disable 169
        private IDictionary<string, JToken> _additionalData;
#pragma warning restore 169


        [JsonProperty(Order = -1 )]
        [JsonConverter(typeof(GeneratedCollectionConverter<Parameter>))]
        public virtual IEnumerableWithIndex<Parameter> Parameters => _parameters;
        private readonly ListEx<Parameter> _parameters = new ListEx<Parameter>();
        // IEnumerator<Parameter> IEnumerable<Parameter>.GetEnumerator() => Parameters.GetEnumerator();
		
        public virtual void ClearParameters()
        {
            Remove(each => true);
        }
        
        public virtual Parameter Add(Parameter item)
        {
            if( !_parameters.Contains( item )  )
            {
                // disambiguation is performed when the item's parent reference is changed
                item.Method = this;
                _parameters.Add(item);
            }
            return item;
        }
        public virtual void AddRange(IEnumerable<Parameter> items)
        {
            foreach(var item in items) 
            {
                Add(item);
            }
        }
        public virtual Parameter Insert(Parameter item)
        {
            if( !_parameters.Contains(item))
            {
                // disambiguation is performed when the item's parent reference is changed
                item.Method = this;
                _parameters.Insert(0, item);
            }
            return item;
        }
        public virtual void InsertRange(IEnumerable<Parameter> items)
        {
            foreach(var item in items) 
            {
                Insert(item);
            }
        }
        public virtual void Remove(Parameter item)
        {
            _parameters.Remove(item);
        }
        public int Remove(Predicate<Parameter> match) {
            var i = 0;
            foreach (var each in _parameters.Where(each => match(each)).ToArray())
            {
                Remove(each);
                i++;
            }
            return i;			
        }
        
        partial void InitializeCollections() 
        {
            _parameters.AddMethod = Add;
        }
    }
}
