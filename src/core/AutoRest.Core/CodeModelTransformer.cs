// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Core
{
    public class CodeModelTransformer<TCodeModel> : ITransformer<TCodeModel> where TCodeModel : CodeModel
    {
        public virtual Trigger Trigger { get; set; } = Trigger.AfterModelCreation;
        public virtual int Priority { get; set; } = 0;

        /// <summary>
        /// A type-specific method for code model tranformation.
        /// Note: This is the method you want to override.
        /// </summary>
        /// <param name="codeModel"></param>
        /// <returns></returns>
        public virtual TCodeModel TransformCodeModel(CodeModel codeModel)
        {
            return codeModel as TCodeModel;
        }
    }

    public class CodeModelTransformer<TCodeModel, TBaseTransformer> : CodeModelTransformer<TCodeModel> where TCodeModel : CodeModel where TBaseTransformer : class, ITransformer<CodeModel>
    {
        protected TBaseTransformer Base = New<TBaseTransformer>();
    }

}