// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using AutoRest.Core.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Core.Extensibility
{
    public class Plugin<TSettings, TTransformer, TGenerator, TNamer, TCodeModel> :
            IPlugin<TSettings, ModelSerializer<TCodeModel>, TTransformer, TGenerator, TNamer, TCodeModel>
        where TSettings : IGeneratorSettings, new()
        where TTransformer : ITransformer<TCodeModel>, new()
        where TGenerator : CodeGenerator, new()
        where TNamer : CodeNamer, new()
        where TCodeModel : CodeModel
    {
        private readonly IGeneratorSettings _generatorSettings;
        private readonly CodeGenerator _generator;
        private readonly CodeNamer _namer;
        private readonly ITransformer<TCodeModel> _transformer;

        private Plugin(IGeneratorSettings generatorSettings, ITransformer<TCodeModel> transformer,
            CodeGenerator generator, CodeNamer namer)
        {
            _generatorSettings = generatorSettings;
            _transformer = transformer;
            _generator = generator;
            _namer = namer;

            // apply custom settings to the GeneratorSettings 

        }

        protected Plugin()
            : this(new TSettings(), new TTransformer(), new TGenerator(), new TNamer())
        {
            Context = new Context
            {
                () =>
                {
                    // set the singleton for the code namer.
                    Singleton<CodeNamer>.Instance = CodeNamer;
                    Singleton<TNamer>.Instance = CodeNamer;

                    // and the language specific settings
                    Singleton<TSettings>.Instance = Settings;
                    Singleton<IGeneratorSettings>.Instance = Settings;
                }
            };
        }

        public Context Context { get; protected set; }

        public TSettings Settings => (TSettings) _generatorSettings;
        public ModelSerializer<TCodeModel> Serializer => new ModelSerializer<TCodeModel>();
        public TTransformer Transformer => (TTransformer) _transformer;
        public TGenerator CodeGenerator => (TGenerator) _generator;
        public TNamer CodeNamer => (TNamer) _namer;

        public IDisposable Activate() => Context.Activate();
    }
}