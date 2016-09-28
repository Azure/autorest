// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities.Collections;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using YamlDotNet.Serialization.TypeInspectors;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Core.Utilities
{
    public class CodeModelContractResolver : CamelCaseContractResolver
    {
        public static CodeModelContractResolver Instance => new CodeModelContractResolver();

        protected override JsonConverter ResolveContractConverter(Type objectType)
        {
            // if the target property has a LODIS factory, craete a DependencyInjectJsonConverter for that type
            // this should only ever really matter if we have a factory set, but the jsonserializersettings didn't get 
            // it incldued. (which may mean this is not very necessary)
            if (Context.HasFactory(objectType))
            {
                return (JsonConverter) Activator.CreateInstance(typeof(DependencyInjectionJsonConverter<>).MakeGenericType(objectType));
            }

            // make sure all Fixable<T> types have a converter.
            if (objectType.IsConstructedGenericType && objectType.GetGenericTypeDefinition() == typeof(Fixable<>))
            {
                return Fixable.Converters[objectType];
            }

            // otherwise, use the default.
            return base.ResolveContractConverter(objectType);
        }

        /// <summary>
        ///     Overridden to do some tweaking to the serialization process.
        /// </summary>
        /// <param name="objectType"></param>
        /// <returns></returns>
        protected override JsonContract CreateContract(Type objectType)
        {
            var contract = base.CreateContract(objectType);
            var objContract = contract as JsonObjectContract;
            
            // remove properties that we don't want to serialize 
            FilterJsonExtensionData(objContract);

            // set the sort order so that we get nicer objects :D
            SortUnsortedProperties(objContract);

            return contract;
        }

        private void SortUnsortedProperties(JsonObjectContract objContract)
        {
            if (objContract != null)
            {
                var order = 1;
                foreach (var property in objContract.Properties.Where(each => (each.Order == null) || (each.Order > 0)))
                {
                    if (property.PropertyName == "name" || property.PropertyName == "#name")
                    {
                        property.Order = -50;
                    }
                    else
                    {
                        property.Order = order++;
                    }
                }
            }
        }

        /// <summary>
        ///     Make sure that JsonExtensionData doesn't serialize
        ///     $metadata fields or properties that are in the actual object.
        /// </summary>
        /// <param name="objContract">the Json object contract to tweak.</param>
        private static void FilterJsonExtensionData(JsonObjectContract objContract)
        {
            var orig = objContract?.ExtensionDataGetter;
            if (orig != null)
            {
                objContract.ExtensionDataGetter = o =>
                {
                    return orig(o)?.Where(each =>
                    {
                        var key = each.Key.ToString();
                        return !key.StartsWith("$") && objContract.Properties.All(p => p.PropertyName != key);
                    });
                };
            }
        }


        protected override IList<JsonProperty> CreateProperties(Type type, MemberSerialization memberSerialization)
        {
            var properties = base.CreateProperties(type, memberSerialization);

            foreach (var p in properties.ToArray())
            {
                // ICopyFrom properties are always Writable, and should not attempt to set the value directly. 
                if (typeof(ICopyFrom).IsAssignableFrom(p.PropertyType))
                {
                    p.Writable = true;
                    p.ValueProvider = new DeserializeToExistingValueProvider(p.ValueProvider);
                    p.ObjectCreationHandling = ObjectCreationHandling.Reuse;
                }

                // Fixable properties need to have a second 'virtual' property to support #prefix.
                if (p.PropertyType.IsConstructedGenericType &&
                    p.PropertyType.GetGenericTypeDefinition() == typeof(Fixable<>))
                {

                    // ShouldSerialize for Fixable<> properties is smuggled in via the 
                    // ShouldDeserialize delegate. (trying to think of a workaround)

                    var newp = new JsonProperty();
                    newp.LoadFrom(p);
                    newp.PropertyName = $"#{p.PropertyName}";
                    newp.ShouldSerialize = p.ShouldDeserialize;
                    
                    // should always deserialize  (fix smuggling)
                    newp.ShouldDeserialize = o => true;
                    p.ShouldDeserialize = o=>true;

                    // add the virtual property
                    properties.Add(newp);
                }
            }
            return properties;
        }

        /// <summary>
        ///     Overriden to suppress serialization of IEnumerables that are empty.
        /// </summary>
        /// <param name="member"></param>
        /// <param name="memberSerialization"></param>
        /// <returns></returns>
        protected override JsonProperty CreateProperty(MemberInfo member, MemberSerialization memberSerialization)
        {
            var property = base.CreateProperty(member, memberSerialization);

            if (typeof(IModelType).IsAssignableFrom(property.PropertyType) || property.PropertyType.IsGenericOf(typeof(IEnumerableWithIndex<>)))
            {
                property.ReferenceLoopHandling = ReferenceLoopHandling.Serialize;
                property.IsReference = true;
            }

            // if the property is marked as a JsonObject, it should never be treated as a collection
            // and hence, doesn't need our ShouldSerialize overload.
            if (property.PropertyType.CustomAttributes.Any(each => each.AttributeType == typeof(JsonObjectAttribute)))
            {
                return property;
            }

            if (property.PropertyType.IsConstructedGenericType &&
                property.PropertyType.GetGenericTypeDefinition() == typeof(Fixable<>))
            {
                // gotta stick this in here for a bit. 
                property.ShouldDeserialize = property.ShouldSerialize = instance =>
                {
                    
                    Fixable f = null;
                    var m = instance.GetType().GetMember(member.Name)[0];
                    if (m is PropertyInfo)
                    {
                        f = instance
                               .GetType()
                               .GetProperty(member.Name)
                               .GetValue(instance, null) as Fixable;
                    }
                    else
                    {
                        f = instance
                                 .GetType()
                                 .GetField(member.Name)
                                 .GetValue(instance) as Fixable;
                    }

                    if (f == null)
                    {
                        return false;
                    }

                    return f.ShouldSerialize && !f.IsFixed;
                };

                property.ShouldSerialize = instance =>
                {
                    Fixable f = null;
                    var m = instance.GetType().GetMember(member.Name)[0];
                    if (m is PropertyInfo)
                    {
                        f = instance
                               .GetType()
                               .GetProperty(member.Name)
                               .GetValue(instance, null) as Fixable;
                    }
                    else
                    {
                        f = instance
                                 .GetType()
                                 .GetField(member.Name)
                                 .GetValue(instance) as Fixable;
                    }

                    if (f == null)
                    {
                        return false;
                    }

                    return f.ShouldSerialize && f.IsFixed;
                };
            }

            // if the property is an IEnumerable, put a ShouldSerialize delegate on it to check if it's empty before we bother serializing
            if ((property.PropertyType != typeof(string)) && typeof(IEnumerable).IsAssignableFrom(property.PropertyType))
            {
                property.ShouldSerialize = instance =>
                {
                    IEnumerable enumerable = null;

                    // this value could be in a public field or public property
                    switch (member.MemberType)
                    {
                        case MemberTypes.Property:
                            enumerable = instance
                                .GetType()
                                .GetProperty(member.Name)
                                .GetValue(instance, null) as IEnumerable;
                            break;
                        case MemberTypes.Field:
                            enumerable = instance
                                .GetType()
                                .GetField(member.Name)
                                .GetValue(instance) as IEnumerable;
                            break;
                    }

                    return (enumerable == null) || enumerable.GetEnumerator().MoveNext();
                };
            }
            return property;
        }
    }
}