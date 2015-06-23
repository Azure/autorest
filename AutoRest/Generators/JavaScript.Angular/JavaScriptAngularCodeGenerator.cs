// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Threading.Tasks;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.JavaScript.Angular.Templates;

namespace Microsoft.Rest.Generator.JavaScript.Angular
{
    public class JavaScriptAngularCodeGenerator : CodeGenerator
    {
        private readonly JavaScriptAngularCodeNamingFramework _namingFramework;

        public JavaScriptAngularCodeGenerator(Settings settings)
            : base(settings)
        {
            _namingFramework = new JavaScriptAngularCodeNamingFramework();
        }

        public override string Name
        {
            get { return "Angular"; }
        }

        public override string Description
        {
            get { return "JS Angular for Http Client Libraries"; }
        }

        public override string UsageInstructions
        {
            get { return "TODO: copy"; }
        }

        public override string ImplementationFileExtension
        {
            get { return ".js"; }
        }

        /// <summary>
        /// Normalizes client model by updating names and types to be language specific.
        /// </summary>
        /// <param name="serviceClient"></param>
        public override void NormalizeClientModel(ServiceClient serviceClient)
        {
            _namingFramework.NormalizeClientModel(serviceClient);
        }

        public override async Task Generate(ServiceClient serviceClient)
        {
            var template = new ServiceClientTemplate {Model = serviceClient};
            await Write(template, serviceClient.Name + ".cs");
        }
    }
}