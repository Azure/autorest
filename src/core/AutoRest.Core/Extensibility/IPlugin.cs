// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using AutoRest.Core.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Core.Extensibility
{
    public interface IPlugin<out TSettings, out TSerializer, out TTransformer, out TGenerator, out TNamer, out TCodeModel>
        where TSettings : IGeneratorSettings
        where TSerializer : IModelSerializer<TCodeModel>
        where TTransformer : ITransformer<TCodeModel>
        where TGenerator : CodeGenerator
        where TNamer : CodeNamer
        where TCodeModel : CodeModel
    {
        TGenerator CodeGenerator { get; }
        TNamer CodeNamer { get; }
        Context Context { get; }
        TTransformer Transformer { get; }
        TSerializer Serializer { get; }
        TSettings Settings { get; }

        IDisposable Activate();
    }
}