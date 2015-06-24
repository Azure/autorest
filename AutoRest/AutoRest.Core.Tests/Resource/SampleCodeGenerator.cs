// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Threading.Tasks;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Test.Templates;

namespace Microsoft.Rest.Generator.Test.Resource
{
    public class SampleCodeGenerator : CodeGenerator
    {
        public SampleCodeGenerator(Settings settings)
            : base(settings)
        {
        }

        public override string Name
        {
            get { return "CSharp"; }
        }

        public override string Description
        {
            get { return "C# for Http Client Libraries"; }
        }

        public override string UsageInstructions
        {
            get { return "TODO: copy"; }
        }

        public override string ImplementationFileExtension
        {
            get { return ".cs"; }
        }

        public override async Task Generate(ServiceClient serviceClient)
        {
            var viewModel = new SampleViewModel();
            var model = new SampleModel();
            model.Model = viewModel;
            await Write(model, "Models\\Pet.cs");
        }

        public override void NormalizeClientModel(ServiceClient serviceClient)
        {
        }
    }
}
