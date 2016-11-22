// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

namespace AutoRest.Core {
    using Model;

    public interface ITransformer<in TInputModel, out TOutputModel> : ITransformer  /* where TInputModel, TOutputModel : ISomething */
    {
        int Priority {get; set;}
        Trigger Trigger {get; set;}
        TOutputModel TransformModel(TInputModel model);
    }

    public interface ITransformer
    {
    }
}