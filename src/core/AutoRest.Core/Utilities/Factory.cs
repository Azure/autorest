// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using AutoRest.Core.Utilities.Collections;

namespace AutoRest.Core.Utilities
{
    public class Factory
    {
        /// <summary>
        /// The generic Expression.Lambda<> Method; needed to programatically create strongly-typed expressions at runtime.
        /// </summary>
        private static MethodInfo LambdaMethodInfo = typeof(Expression)
            .GetMethods(BindingFlags.Static |BindingFlags.FlattenHierarchy | BindingFlags.Public)
            .First(each =>
                each.Name == "Lambda" && each.IsGenericMethodDefinition &&
                each.ParameterTypes()
                    .SequenceEqual(new[] {typeof(Expression), typeof(IEnumerable<ParameterExpression>)}));

        protected internal readonly Dictionary<Type[], Delegate> Constructors = new Dictionary<Type[], Delegate>();
        public readonly Type TargetType;

        protected internal const BindingFlags AllConstructorsFlags =
            BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance;

        protected internal IEnumerable<ConstructorInfo> TargetTypeConstructors => TargetType.GetConstructors(AllConstructorsFlags);

        protected internal Factory(Type t)
        {
            TargetType = t;
        }

        internal Delegate GetConstructorImplementation(Type[] args)
        {
            var signatures = Constructors.Keys.Where(each => each.Length == args.Length).ToArray();

            if (!signatures.Any())
            {
                return null;
            }

            if (signatures.Length == 1)
            {
                // quick match : if there is only one match, let's just try that.
                return Constructors[signatures[0]];
            }

            // look for an exact match, or failing that, an acceptable match.
            var s = signatures.FirstOrDefault(signature => signature.SequenceEqual(args)) ?? 
                signatures.SingleOrDefault(each => AreAssignableFrom(each, args));

            if (s != null)
            {
                return Constructors[s];
            }

            return null;

#if future_garrett_add_dynamic_casting
            // (for now, just cast the value yourself!)
            // last ditch effort - if there is a combination that supports casting, try that.
            foreach (var sig in signatures)
            {
                
            }
#endif
        }

#if future_garrett_add_dynamic_casting
        private static BindingFlags StaticPublic = BindingFlags.Static | BindingFlags.Public;

        private static Dictionary<Tuple<Type,Type>, MethodInfo> CastOperators = new Dictionary<Tuple<Type, Type>, MethodInfo>();
        private static MethodInfo GetCastOperator(Type srcType,Type destType )
        {
            return CastOperators.GetOrAdd( new Tuple<Type, Type>(srcType,destType),() => destType.GetMethods(StaticPublic)
                    .Union(srcType.GetMethods(StaticPublic))
                    .Where(mi => mi.Name == "op_Explicit" || mi.Name == "op_Implicit")
                    .Where(mi => {
                        var pars = mi.GetParameters();
                        return pars.Length == 1 && pars[0].ParameterType == srcType;
                    })
                    .FirstOrDefault(mi => mi.ReturnType == destType));
        }
        private static bool DynamicCast(object source, Type destType, out object result)
        {
            var srcType = source.GetType();
            if (srcType == destType)
            {
                result = source;
                return true;
            }
            result = null;
            
            var castOperator =GetCastOperator(srcType,destType);

            if (castOperator != null)
            {
                result = castOperator.Invoke(null, new object[] {source});
                return true;
            }
            
            return false;
        }
#endif 
        private static bool AreAssignableFrom(Type[] signature, Type[] argTypes)
        {
            for (var i = 0; i < signature.Length; i++)
            {
                // if the argument is null, but the signature can take a null, it's a match.
                if (argTypes[i] == null && !signature[i].IsValueType)
                {
                    continue;
                }

                // if the object type isn't assignable, it's not a match.
                if (!signature[i].IsAssignableFrom(argTypes[i]))
                {
                    return false;
                }
            }
            return true;
        }
        /// <summary>
        ///     This generates a Delegate for a constructor that is strongly typed to the constructor type itself
        ///     It does this by dynamically creating a call via reflection to a constructor and then casting that to the type
        ///     created.
        /// </summary>
        /// <param name="ctorInfo">the constructor info for a constructor.</param>
        /// <returns>A strongly typed delegate for creating new objects of a given type</returns>
        public static Delegate CreateDelegateForConstructor(ConstructorInfo ctorInfo)
        {
            if (ctorInfo == null || ctorInfo.DeclaringType == null)
            {
                throw new ArgumentNullException(nameof(ctorInfo));
            }

            // Get the parameter types for the constructor
            var parameterTypes = ctorInfo.ParameterTypes();

            // Create a set of parameters for the expression
            Expression[] pars = parameterTypes.Select(Expression.Parameter).ToArray();

            // create the call to the constructor 
            Expression expression = Expression.Call(Expression.Constant(ctorInfo),
                typeof(ConstructorInfo).GetMethod("Invoke", new[] {typeof(object[])}),
                Expression.NewArrayInit(typeof(object), pars.Select(each => Expression.TypeAs(each, typeof(object)))));

            // wrap the return type to return the actual declaring type.
            expression = Expression.TypeAs(expression, ctorInfo.DeclaringType);

            // create a Func<...> delegate type for the lambda that we actually want to create
            var funcType = Expression.GetFuncType(parameterTypes.ConcatSingleItem(ctorInfo.DeclaringType).ToArray());

            // dynamically call Lambda<Func<...>> to create a type specific lambda expression 
            //Expression.Lambda<Func<object>>()
            var lambda = (LambdaExpression)LambdaMethodInfo.MakeGenericMethod(funcType).Invoke(null, new object[] {expression, pars});

            // return the compiled lambda
            return lambda.Compile();
        }
    }

    public class Factory<TType, TOverride> : Factory<TType> where TType : class where TOverride : TType
    {
        public Factory()
        {
            AddConstructors<TOverride>();
        }
    }

    public class Factory<TType> : Factory, IEnumerable<Delegate> where TType : class
    {
        public Factory() : base(typeof(TType))
        {
        }

        internal void AddConstructors<TOverride>()
        {
            foreach (var ctor in typeof(TOverride).GetConstructors(AllConstructorsFlags))
            {
                Constructors.Add(ctor.ParameterTypes(),
                    CreateDelegateForConstructor(ctor));
            }
        }


        internal TType Invoke()
        {
            var ctor = Constructors.Keys.FirstOrDefault(each => each.Length == 0);
            if (ctor == null)
            {
                throw new Exception($"No default constructor for type {TargetType}");
            }
            return Constructors[ctor].DynamicInvoke() as TType;
        }

        internal TType Invoke(IEnumerable<object> arguments)
        {
            var args = arguments.ToArray();
            var types = args.Select(each => each?.GetType()).ToArray();
            var ctor = GetConstructorImplementation(types);
            if (ctor == null)
            {
                throw new Exception($"No constructor for type {TargetType} that takes {args.Length} arguments matching ({types.ToTypesString()}).");
            }
            return ctor.DynamicInvoke(args) as TType;
        }

        public IEnumerator<Delegate> GetEnumerator()
        {
            throw new NotImplementedException();
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }

        public void Add<T>(Func<T> func)
        {
            // Constructors.Add(func.Method.GetParameters().Select(each => each.ParameterType).ToArray(), func);
            Constructors.Add(new Type[0],func );
        }

        public void Add<TParam1>(Func<TParam1, TType> func)
        {
            Constructors.Add(new[] {typeof(TParam1)}, func);
        }

        public void Add<TParam1, TParam2>(Func<TParam1, TParam2, TType> func)
        {
            Constructors.Add(new[] {typeof(TParam1), typeof(TParam2)}, func);
        }

        public void Add<TParam1, TParam2, TParam3>(Func<TParam1, TParam2, TParam3, TType> func)
        {
            Constructors.Add(new[] {typeof(TParam1), typeof(TParam2), typeof(TParam3)}, func);
        }

        public void Add<TParam1, TParam2, TParam3, TParam4>(Func<TParam1, TParam2, TParam3, TParam4, TType> func)
        {
            Constructors.Add(new[] {typeof(TParam1), typeof(TParam2), typeof(TParam3), typeof(TParam4)}, func);
        }
    }
}