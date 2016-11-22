// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;

namespace AutoRest.Core {
    public class FuncTransformer<TInput, TOutput> : Transformer<TInput, TOutput>
    {
        private readonly Func<TInput, TOutput> transform;

        public FuncTransformer(Func<TInput, TOutput> transform)
        {
            this.transform = transform;
        }

        public override TOutput Transform(TInput model) => transform(model);
    }

    public abstract class Transformer<TInput, TOutput> : ITransformer<TInput, TOutput>
    {
        public virtual Trigger Trigger { get; set; } = Trigger.AfterModelCreation;
        public virtual int Priority { get; set; } = 0;
        public abstract TOutput Transform(TInput input);

        object ITransformer.Transform(object input)
            => Transform((TInput)input);
    }
    public interface ITransformer<in TInput, out TOutput> : ITransformer
        /* where TInputModel, TOutputModel : ISomething */
    {
        TOutput Transform(TInput input);
    }

    public interface ITransformer
    {
        int Priority { get; set; }
        Trigger Trigger { get; set; }
        object/*ISomething*/ Transform(object/*ISomething*/ input);
    }
}