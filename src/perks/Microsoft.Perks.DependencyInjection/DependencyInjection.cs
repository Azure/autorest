// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Perks {
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading;
    using Linq;

    public static class DependencyInjection
    {
        public static IDisposable NewContext => new Context().Activate();

        /// <summary>
        ///     An overridable means to create a new instance of a given type,
        ///     and pass an initializer to it.
        /// </summary>
        /// <typeparam name="T">The desired type (or subclass) to create</typeparam>
        /// <returns>An instance of the type (or a subclass)</returns>
        public static T New<T>() where T : class {
            try {
                return Context.GetFactory<T>().Invoke();
            } catch (Exception e) {
                // Logger.Instance.Log(Category.Fatal, $"New<{typeof(T)}() threw exception {e.GetType().Name} - {e.Message}");
                throw;
            }
        }

        /// <summary>
        ///     A means to clone an object (and still use DI)
        /// </summary>
        /// <param name="original">the original object to make a copy from</param>
        /// <typeparam name="T">The desired type (or subclass) to create</typeparam>
        /// <returns>An instance of the type (or a subclass) that has been copied from the original</returns>
        public static T Duplicate<T>(T original) where T : class {
            return New<T>().LoadFrom(original);
        }

        /// <summary>
        ///     An overridable means to create a new instance of a given type,
        ///     and pass an initializer to it.
        /// </summary>
        /// <param name="arguments">
        ///     The arguments to the constructor.
        ///     If the last argument is an anonymous object, it will not be passed to the
        ///     constructor, rather it will be used as an object initializer for the object
        ///     once it has been constructed.
        /// </param>
        /// <typeparam name="T">The desired type (or subclass) to create</typeparam>
        /// <returns>An instance of the type (or a subclass)</returns>
        public static T New<T>(params object[] arguments) where T : class {
            try {
                var ctor = Context.GetFactory<T>();
                if (arguments.Length == 0) {
                    return ctor.Invoke();
                }

                // if the last parameter is an anonymous object, 
                // we'll treat that as an initializer.
                var last = arguments[arguments.Length - 1];
                if (last.IsAnonymous()) {
                    return ctor.Invoke(arguments.Take(arguments.Length - 1)).LoadFrom(last);
                }

                // otherwise, just inwvoke with all the arguments.
                return ctor.Invoke(arguments);
            } catch (Exception e) {
                // Logger.Instance.Log(Category.Fatal, $"New<{typeof(T)}({arguments.Select(each => each?.ToString()).Aggregate((cur, each) => $"{cur}, {each}")}) threw exception {e.GetType().Name} - {e.Message}");
                throw;
            }
        }

        public static bool IsAnonymous(this object instance)
            => instance != null && instance.GetType().Namespace == null;

        internal class Activation : IDisposable {
            private const string Slot = "LODIS-CurrentContext";

#if !LEGACY
            private static AsyncLocal<Guid?> LodisContext = new AsyncLocal<Guid?>();
#endif
            internal static Dictionary<Guid, Activation> Activations = new Dictionary<Guid, Activation>();

            internal readonly Guid Id = Guid.NewGuid();
            internal readonly Activation Parent;
            private bool _disposed;

            // upon activation, we start at count 1
            private int _refcount = 1;
            protected internal Context Context;
            protected internal Dictionary<Type, object> Singletons = new Dictionary<Type, object>();

            public Activation(Context contextToActivate) {
                Parent = Current;
                Parent?.Increment();
                Context = contextToActivate;
                lock (typeof(Activation)) {
                    Activations.Add(Id, this);
                }
                Current = this;
                Context.PerformOnActivate();
#if DEBUG
                // Let's verify that the Context's factories have 
                // correctly implemented constructors of the base 
                // class.
                foreach (var factory in Context) {
                    // For each of the actual constructors for the actual target type,
                    // do each of the constructors of the target type have an 
                    // implementation in factory?
                    foreach (var missingConstructor in factory.TargetTypeConstructors.Where(each => factory.GetConstructorImplementation(each.ParameterTypes()) == null)) {
                        // Logger.Instance.Log(Category.Warning, $"Factory for type {factory.TargetType.FullName} does not have a constructor for parameters ({missingConstructor.ParameterTypes().ToTypesString()})");
                    }
                }
#endif
            }

            protected internal static Activation Current {
                get {
#if LEGACY
                    var id = CallContext.LogicalGetData(Slot);
#else
                    var id = LodisContext.Value;
#endif
                    lock (typeof(Activation)) {
                        return id != null ? Activations[(Guid)id] : null;
                    }
                }
                set {
#if LEGACY
                    CallContext.LogicalSetData( Slot,value?.Id);
#else
                    LodisContext.Value = value?.Id;
#endif
                }
            }

            protected internal static Activation Default {
                get {
                    var activation = Current;
                    if (activation == null) {
                        new Context().Activate();
                    }
                    return Current;
                }
            }

            public void Dispose() {
                if (!_disposed) {
                    _disposed = true;
                    Decrement();
                }
            }

            private void Increment() {
                Interlocked.Increment(ref _refcount);
            }

            private void Decrement() {
                if (Context != null) {
                    Interlocked.Decrement(ref _refcount);
                    if (_refcount == 0) {
                        // ok, cleanup.
                        // unhook ourself
                        Current = Parent;

                        // remove ourselves from the Activations collection
                        lock (typeof(Activation)) {
                            Activations.Remove(Id);
                        }

                        // drop the reference to the DI factories.
                        Context = null;

                        // drop the singletons
                        Singletons = null;

                        // remove the reference to the parent. (which can cause them to disappear if they are done)
                        Parent?.Decrement();
                    }
                }
            }
        }

        public class IsSingleton<T> {
            public static T Instance => Singleton<T>.Instance;
        }

        public class Singleton<T> {
            public static bool HasInstanceInCurrentActivation => Activation.Current.Singletons.ContainsKey(typeof(T));

            public static bool HasInstance {
                get {
                    for (var c = Activation.Current; c != null; c = c.Parent) {
                        if (c.Singletons.ContainsKey(typeof(T))) {
                            return true;
                        }
                    }
                    return false;
                }
            }

            public static T Instance {
                get {
                    // check for the exact match
                    for (var c = Activation.Current; c != null; c = c.Parent) {
                        if (c.Singletons.ContainsKey(typeof(T))) {
                            return (T)c.Singletons[typeof(T)];
                        }
                    }

                    // check for anything that is inherited
                    for (var c = Activation.Current; c != null; c = c.Parent) {
                        foreach (var item in c.Singletons.Values) {
                            if (item is T) {
                                return (T)item;
                            }
                        }
                    }
                    return default(T);
                }
                set {Activation.Default.Singletons.AddOrSet(typeof(T), value);}
            }

            /// <summary>
            ///     Retrieves the singleton of this but also the parent contexts, if existing.
            /// </summary>
            public static IEnumerable<T> RecursiveInstances {
                get {
                    var key = typeof(T);
                    for (var c = Activation.Current; c != null; c = c.Parent) {
                        if (c.Singletons.ContainsKey(key)) {
                            yield return (T)c.Singletons[key];
                        }
                    }
                }
            }
        }

        /// <summary>
        ///     Convenience methods for singletons that are of type IEnumerable&lt;T&gt;
        /// </summary>
        public class SingletonList<T> {
            /// <summary>
            ///     For retrieving singletons that are lists while also considering the list items of parent contexts.
            /// </summary>
            public static IEnumerable<T> RecursiveInstances {get {return Singleton<IEnumerable<T>>.RecursiveInstances.SelectMany(list => list);}}

            /// <summary>
            ///     Adds given item to the current context.
            /// </summary>
            public static void Add(T item) {
                if (!Activation.Current.Singletons.ContainsKey(typeof(IEnumerable<T>))) {
                    Activation.Current.Singletons[typeof(IEnumerable<T>)] = Enumerable.Empty<T>();
                }
                Activation.Current.Singletons[typeof(IEnumerable<T>)] = (Activation.Current.Singletons[typeof(IEnumerable<T>)] as IEnumerable<T>).Concat(new[] {item});
            }
        }

        public class Context : IEnumerable<Factory> {
            private readonly Dictionary<Type, Factory> _factories = new Dictionary<Type, Factory>();

            public static bool IsActive => Activation.Current != null;

            /// <summary>
            ///     Returns the currently active context. If there is no active context,
            ///     it creates an anonymous one, activates it and returs that.
            ///     (fyi, that will hang around until the process ends)
            /// </summary>
            public static Context Active => Activation.Default.Context;

            public IEnumerator<Factory> GetEnumerator() => _factories.Values.GetEnumerator();

            IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
            private event Action OnActivate;

            public Context Add(Factory factory) {
                _factories.AddOrSet(factory.TargetType, factory);
                return this;
            }

            public Context Add(IEnumerable<Factory> factories) {
                foreach (var factory in factories) {
                    _factories.AddOrSet(factory.TargetType, factory);
                }
                return this;
            }

            public Context Add(Context parent) {
                if (parent.OnActivate != null) {
                    OnActivate += parent.OnActivate;
                }
                return Add((IEnumerable<Factory>)parent);
            }

            public IDisposable Activate() => new Activation(this);

            public static bool HasFactory(Type t) {
                for (var c = Activation.Current; c != null; c = c.Parent) {
                    if (c.Context._factories.ContainsKey(t)) {
                        return true;
                    }
                }
                return false;
            }

            internal static Factory<T> GetFactory<T>() where T : class {
                // walk the tree of contexts
                for (var c = Activation.Current; c != null; c = c.Parent) {
                    if (true == c.Context?._factories.ContainsKey(typeof(T))) {
                        return c.Context._factories[typeof(T)] as Factory<T>;
                    }
                }

                // didn't find it? create a default one
                // (yes, this may create an anonymous context and activate it. that's ok)
                return Active.AddDefault<T>();
            }

            private Factory<T> AddDefault<T>() where T : class {
                var fact = new Factory<T, T>();

                //add it to the context 
                Add(fact);

                // return what we just added.
                return fact;
            }

            public void Add(Action onActivate) {
                OnActivate += onActivate;
            }

            protected internal void PerformOnActivate() {
                OnActivate?.Invoke();
            }
        }
    }
}