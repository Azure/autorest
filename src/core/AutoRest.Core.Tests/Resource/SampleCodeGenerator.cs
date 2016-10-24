// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.IO;
using System.Threading.Tasks;
using AutoRest.Core.Model;
using AutoRest.Core.Tests.Templates;

namespace AutoRest.Core.Tests.Resource
{
    public class SampleCodeGenerator : CodeGenerator
    {
        public override bool IsSingleFileGenerationSupported => true;

        public override string UsageInstructions => "TODO: copy";

        public override string ImplementationFileExtension => ".cs";

        public override async Task Generate(CodeModel codeModel)
        {
            var viewModel = new SampleViewModel();
            var model = new SampleModel();
            model.Model = viewModel;
            await Write(model, Path.Combine(Settings.Instance.ModelsName, "Pet.cs"));
        }
    }
}
