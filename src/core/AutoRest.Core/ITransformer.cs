// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Threading.Tasks;
using ISomething = System.Object;

namespace AutoRest.Core
{
    public class ActionTransformer<TInputOutput> : Transformer<TInputOutput, TInputOutput>
        //where TInputOutput : ISomething
    {
        private readonly Func<TInputOutput, Task> action;

        public ActionTransformer(Func<TInputOutput, Task> action)
        {
            this.action = action;
        }

        public ActionTransformer(Action<TInputOutput> action) 
            : this(input =>
            {
                action(input);
                return Task.FromResult(false);
            })
        {
        }

        public override async Task<TInputOutput> Transform(TInputOutput input)
        {
            await action(input);
            return input;
        }
    }

    public class FuncTransformer<TInput, TOutput> : Transformer<TInput, TOutput>
        //where TInput : ISomething
        //where TOutput : ISomething
    {
        private readonly Func<TInput, Task<TOutput>> transform;

        public FuncTransformer(Func<TInput, Task<TOutput>> transform)
        {
            this.transform = transform;
        }

        public FuncTransformer(Func<TInput, TOutput> transform) : this(input => Task.FromResult(transform(input)))
        {
        }

        public override Task<TOutput> Transform(TInput input) => transform(input);
    }

    public abstract class Transformer<TInput, TOutput> : ITransformer<TInput, TOutput>
    //where TInput : ISomething
    //where TOutput : ISomething
    {
        public  Name { get; set; }
        public virtual Trigger Trigger { get; set; } = Trigger.AfterModelCreation;
        public virtual int Priority { get; set; } = 0;
        public abstract Task<TOutput> Transform(TInput input);

        async Task<ISomething> ITransformer.Transform(ISomething input)
        {
            return await Transform((TInput) input);
        }
    }
    public interface ITransformer<in TInput, TOutput> : ITransformer
        //where TInput : ISomething
        //where TOutput : ISomething
    {
        Task<TOutput> Transform(TInput input);
    }

    public interface ITransformer
    {
        string Name { get; set; }

        int Priority { get; set; }
        Trigger Trigger { get; set; }
        Task<ISomething> Transform(ISomething input);
    }

    //public interface ISomething
    //{
        
    //}
}