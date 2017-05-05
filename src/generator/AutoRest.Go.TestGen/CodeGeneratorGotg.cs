// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Go.Model;
using System.Threading.Tasks;

namespace AutoRest.Go.TestGen
{
    public class CodeGeneratorGotg : CodeGenerator
    {
        public string Name
        {
            get { return "Go"; }
        }

        public override string UsageInstructions
        {
            get { return string.Empty; }
        }

        public override string ImplementationFileExtension
        {
            get { return ".go"; }
        }

        /// <summary>
        /// Generates Go code for service client.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <returns></returns>
        public override async Task Generate(CodeModel cm)
        {
            // generate code
            var root = TestGenGoRpc.GenerateTests((CodeModelGo)cm);

            var nodeWriter = new NodeWriter(120, "    ", 1);
            root.Visit(nodeWriter);

            await Write(nodeWriter.ToString(), FormatFileName($"{cm.Namespace}tests"), false);
        }

        private string FormatFileName(string fileName)
        {
            return $"{fileName}{ImplementationFileExtension}";
        }
    }
}
