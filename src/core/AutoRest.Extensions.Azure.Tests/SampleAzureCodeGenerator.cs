// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Threading.Tasks;
using AutoRest.Core;
using AutoRest.Core.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Extensions.Azure.Tests
{
    public class SampleAzureCodeGenerator : CodeGenerator
    {
        public SampleAzureCodeGenerator() 
        {
        }
        public override string UsageInstructions => null;

        public override string ImplementationFileExtension => null;

        public override Task Generate(CodeModel codeModel) => null;
    }

    public class SampleAzureTransformer : CodeModelTransformer<CodeModel>
    {
        public override CodeModel TransformCodeModel(CodeModel codeModel)
        {
            // we're guaranteed to be in our language-specific context here.
            Settings.Instance.AddCredentials = true;

            // todo: these should be turned into individual transformers
            AzureExtensions.NormalizeAzureClientModel(codeModel);

            return codeModel;
        }
    }
}
