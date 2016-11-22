// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Threading.Tasks;
using AutoRest.Core.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Core
{
    public class CodeModelTransformer<TCodeModel> : Transformer<CodeModel, TCodeModel> where TCodeModel : CodeModel
    {
        /// <summary>
        /// A type-specific method for code model tranformation.
        /// Note: This is the method you want to override.
        /// </summary>
        /// <param name="codeModel"></param>
        /// <returns></returns>
        public override Task<TCodeModel> TransformAsync(CodeModel codeModel)
        {
            return Task.FromResult(codeModel as TCodeModel);
        }
    }

    public class CodeModelTransformer<TCodeModel, TBaseTransformer> : CodeModelTransformer<TCodeModel> where TCodeModel : CodeModel where TBaseTransformer : class, ITransformer
    {
        protected TBaseTransformer Base = New<TBaseTransformer>();
    }

}