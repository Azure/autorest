// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

namespace AutoRest.Core {
    using Model;

    public abstract class Transformer<TInput, TOutput> : ITransformer<TInput, TOutput>
    {
        public virtual Trigger Trigger { get; set; } = Trigger.AfterModelCreation;
        public virtual int Priority { get; set; } = 0;
        public abstract TOutput Transform(TInput model);
    }
    public interface ITransformer<in TInput, out TOutput> : ITransformer
        /* where TInputModel, TOutputModel : ISomething */
    {
        TOutput Transform(TInput model);
    }

    public interface ITransformer
    {
        int Priority { get; set; }
        Trigger Trigger { get; set; }
    }
}