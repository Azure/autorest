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
        private readonly Func<TInputOutput, Task> actionAsync;

        public ActionTransformer(string name, Func<TInputOutput, Task> actionAsync)
        {
            this.Name = name;
            this.actionAsync = actionAsync;
        }

        public ActionTransformer(string name, Action<TInputOutput> action) 
            : this(name, input =>
            {
                action(input);
                return Task.FromResult(false);
            })
        {
        }

        public override string Name { get; }

        public override async Task<TInputOutput> TransformAsync(TInputOutput input)
        {
            await actionAsync(input);
            return input;
        }
    }

    public class FuncTransformer<TInput, TOutput> : Transformer<TInput, TOutput>
    //where TInput : ISomething
    //where TOutput : ISomething
    {
        private readonly Func<TInput, Task<TOutput>> transformAsync;

        public FuncTransformer(string name, Func<TInput, Task<TOutput>> transformAsync)
        {
            this.Name = name;
            this.transformAsync = transformAsync;
        }

        public FuncTransformer(string name, Func<TInput, TOutput> transform)
            : this(name, input => Task.FromResult(transform(input)))
        {
        }
        
        public override string Name { get; }

        public override Task<TOutput> TransformAsync(TInput input) => transformAsync(input);
    }

    public abstract class Transformer<TInput, TOutput> : ITransformer<TInput, TOutput>
    //where TInput : ISomething
    //where TOutput : ISomething
    {
        public virtual string Name => GetType().Name;
        public virtual Trigger Trigger { get; } = Trigger.AfterModelCreation;
        public virtual int Priority { get; } = 0;
        public abstract Task<TOutput> TransformAsync(TInput input);

        async Task<ISomething> ITransformer.TransformAsync(ISomething input)
        {
            return await TransformAsync((TInput) input);
        }
    }
    public interface ITransformer<in TInput, TOutput> : ITransformer
        //where TInput : ISomething
        //where TOutput : ISomething
    {
        Task<TOutput> TransformAsync(TInput input);
    }

    public interface ITransformer
    {
        string Name { get; }

        int Priority { get; }
        Trigger Trigger { get; }
        Task<ISomething> TransformAsync(ISomething input);
    }

    //public interface ISomething
    //{
        
    //}
}