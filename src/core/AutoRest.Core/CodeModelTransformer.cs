// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

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
        public override TCodeModel Transform(CodeModel codeModel)
        {
            return codeModel as TCodeModel;
        }
    }

    public class CodeModelTransformer<TCodeModel, TBaseTransformer> : CodeModelTransformer<TCodeModel> where TCodeModel : CodeModel where TBaseTransformer : class, ITransformer<CodeModel, CodeModel>
    {
        protected TBaseTransformer Base = New<TBaseTransformer>();
    }

}