// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Java.Model;
using AutoRest.Extensions;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Java
{
    public class TransformerJv : CodeModelTransformer<CodeModelJv>
    {
        public override CodeModelJv TransformCodeModel(CodeModel cs)
        {
            var codeModel = cs as CodeModelJv;
            // we're guaranteed to be in our language-specific context here.

            // todo: these should be turned into individual transformers
            SwaggerExtensions.NormalizeClientModel(codeModel);

            return codeModel;
        }
    }
}