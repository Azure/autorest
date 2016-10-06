// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Threading.Tasks;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.CSharp;
using AutoRest.CSharp.Azure.Model;
using AutoRest.CSharp.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Extensions.Azure.Tests
{
    public class SampleAzureCodeGenerator : CodeGenerator
    {
        public SampleAzureCodeGenerator() : base(new SampleAzureTransformer())
        {
        }

        public override string Name => null;

        public override string Description => null;

        public override string UsageInstructions => null;

        public override string ImplementationFileExtension => null;

        public override Task Generate(CodeModel codeModel) => null;
    }

    public class SampleAzureTransformer : CodeModelTransformer
    {
        internal SampleAzureCodeGenerator AzureCodeGenerator { get; set; }
        protected CodeNamer NewCodeNamer => new SampleAzureCodeNamer();

        protected override Context InitializeContext()
        {
            // our instance of the codeNamer.
            var codeNamer = NewCodeNamer;

            return new Context
            {
                // inherit anything from the parent class.
                // base.InitializeContext(),

                // on activation of this context, 
                () =>
                {
                    // set the singleton for the code namer.
                    Singleton<CodeNamer>.Instance = codeNamer;
                },
            };
        }

        protected override CodeModel Transform(CodeModel codeModel)
        {
            // we're guaranteed to be in our language-specific context here.
            Settings.Instance.AddCredentials = true;

            // todo: these should be turned into individual transformers
            AzureExtensions.NormalizeAzureClientModel(codeModel);

            return codeModel;
        }
    }
}
