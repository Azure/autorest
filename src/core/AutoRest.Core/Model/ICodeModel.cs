// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Collections.Generic;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using Newtonsoft.Json.Serialization;

namespace AutoRest.Core.Model
{
    public interface ICodeModel : IParent, IIdentifier { 

    }

    public static class CodeModelSettings
    {
        public static JsonSerializerSettings DeserializerSettings => new JsonSerializerSettings
        {
            // this just tells the deserializer to use the Factory when restoring these types. 
            // (note, we don't have to specify what the actual end type is, the factory does that :D )
            Converters =
                {
                    new DependencyInjectionJsonConverter<CompositeType>(),
                    new DependencyInjectionJsonConverter<DictionaryType>(),
                    new DependencyInjectionJsonConverter<SequenceType>(),
                    new DependencyInjectionJsonConverter<PrimaryType>(),
                    new DependencyInjectionJsonConverter<Method>(),
                    new DependencyInjectionJsonConverter<Parameter>(),
                    new DependencyInjectionJsonConverter<Property>(),
                    new DependencyInjectionJsonConverter<EnumType>(),
                    new DependencyInjectionJsonConverter<CodeModel>(),

                    // to handle deserializing things derived from ModelType 
                    // by checking the $type
                    new TypedObjectConverter<IModelType>(),

                    new StringEnumConverter {CamelCaseText = true}
                }
                ,
            Formatting = Formatting.Indented,
            NullValueHandling = NullValueHandling.Ignore,
            DateParseHandling = DateParseHandling.None,
            ContractResolver = CodeModelContractResolver.Instance,
        };

        public static JsonSerializerSettings SerializerSettings  => 
            new JsonSerializerSettings
            {
                // this just tells the deserializer to use the Factory when restoring these types. 
                // (note, we don't have to specify what the actual end type is, the factory does that :D )
                Converters =
                {
                    new DependencyInjectionJsonConverter<CompositeType>(),
                    new DependencyInjectionJsonConverter<DictionaryType>(),
                    new DependencyInjectionJsonConverter<SequenceType>(),
                    new DependencyInjectionJsonConverter<PrimaryType>(),
                    new DependencyInjectionJsonConverter<EnumType>(),
                    new DependencyInjectionJsonConverter<Method>(),
                    new DependencyInjectionJsonConverter<Parameter>(),
                    new DependencyInjectionJsonConverter<Property>(),
                    new DependencyInjectionJsonConverter<CodeModel>(),

                    new StringEnumConverter {CamelCaseText = true}
                }
                ,
                Formatting = Formatting.Indented,
                NullValueHandling = NullValueHandling.Ignore,
                DateParseHandling = DateParseHandling.None,
                ContractResolver = CodeModelContractResolver.Instance,
            };
    }
}