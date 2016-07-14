// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Collections;
using System.Diagnostics;
using System.Dynamic;
using System.Linq;
using System.Reflection;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using Newtonsoft.Json.Serialization;

namespace AutoRest.CSharp.Unit.Tests
{
    /// <summary>
    ///     This is a class that creates a dynamic wrapper around any object and can allow
    ///     deep inspection of anything (private or otherwise).
    ///     Handy for testing.
    /// </summary>
    public class AutoDynamic : DynamicObject
    {
        /// <summary>
        ///     Specify the flags for accessing members
        /// </summary>
        private static readonly BindingFlags flags = BindingFlags.NonPublic | BindingFlags.Instance
                                                     | BindingFlags.Static | BindingFlags.Public
                                                     | BindingFlags.IgnoreCase;

        /// <summary>
        ///     The object we are going to wrap
        /// </summary>
        private readonly object _wrapped;

        /// <summary>
        ///     Create a simple private wrapper
        /// </summary>
        public AutoDynamic(object o)
        {
            _wrapped = o;
        }

        /// <summary>
        ///     Returns a JSON representation.
        /// </summary>
        /// <returns>a JSON string</returns>
        public string ToJson()
        {
            return JsonConvert.SerializeObject(
                _wrapped,
                Formatting.Indented,
                new JsonSerializerSettings
                {
                    Converters = new JsonConverter[] {new StringEnumConverter()},
                    ContractResolver = new CamelCasePropertyNamesContractResolver(),
                    NullValueHandling = NullValueHandling.Ignore,
                    ObjectCreationHandling = ObjectCreationHandling.Reuse
                });
        }

        private bool CheckResult(object result, out object outresult)
        {
            if (result == null || result.GetType().GetTypeInfo().IsPrimitive
                || result.GetType().GetTypeInfo().IsValueType || result is string)
            {
                outresult = result;
            }
            else
            {
                outresult = result.ToDynamic();
            }

            return true;
        }

        /// <summary>
        ///     Try invoking a method
        /// </summary>
        public override bool TryInvokeMember(InvokeMemberBinder binder, object[] args, out object result)
        {
            if (_wrapped == null)
            {
                result = null;
                return true;
            }
            var types = args.Select(a => a != null ? a.GetType() : typeof(object));

            var method = _wrapped.GetType().GetMethod(binder.Name, types.ToArray())
                         ?? _wrapped.GetType().GetMethod(binder.Name, flags);

            if (method == null)
            {
                return base.TryInvokeMember(binder, args, out result);
            }

            return CheckResult(method.Invoke(_wrapped, args), out result);
        }

        public override bool TryConvert(ConvertBinder binder, out object result)
        {
            if (_wrapped == null)
            {
                result = null;
                return false;
            }

            if (binder.ReturnType.IsInstanceOfType(_wrapped))
            {
                result = _wrapped;
                return true;
            }
            return base.TryConvert(binder, out result);
        }

        public override bool TryGetIndex(GetIndexBinder binder, object[] indexes, out object result)
        {
            if (_wrapped == null)
            {
                result = null;
                return false;
            }

            if (indexes.Length == 1 && indexes[0] is int)
            {
                var index = (int) indexes[0];
                try
                {
                    var arr = _wrapped as Array;
                    if (arr != null)
                    {
                        return CheckResult(arr.GetValue(index), out result);
                    }
                }
                catch
                {
                    // nope...
                }
            }

            // is it asking for a property as a field
            foreach (
                var prop in _wrapped.GetType().GetProperties(flags).Where(each => each.GetIndexParameters().Any()))
            {
                try
                {
                    result = prop.GetValue(_wrapped, indexes);
                    return true;
                }
                catch (TargetParameterCountException)
                {
                }
                catch (TargetInvocationException)
                {
                }
            }

            if (indexes.Length == 1 && indexes[0] is int)
            {
                var index = (int) indexes[0];
                try
                {
                    var ie = _wrapped as IEnumerable;
                    if (ie != null)
                    {
                        var e = ie.GetEnumerator();

                        while (index > 0 && e.MoveNext())
                        {
                            --index;
                        }
                        if (index == 0)
                        {
                            if (e.MoveNext())
                            {
                                return CheckResult(e.Current, out result);
                            }
                        }
                    }
                }
                catch
                {
                }
            }
            return base.TryGetIndex(binder, indexes, out result);
        }

        /// <summary>
        ///     Tries to get a property or field with the given name
        /// </summary>
        public override bool TryGetMember(GetMemberBinder binder, out object result)
        {
            if (_wrapped == null)
            {
                result = null;
                return true;
            }

            try
            {
                //Try getting a property of that name
                var prop = _wrapped.GetType().GetProperty(binder.Name, flags);

                if (prop == null)
                {
                    //Try getting a field of that name
                    var fld = _wrapped.GetType().GetField(binder.Name, flags);

                    if (fld != null)
                    {
                        return CheckResult(fld.GetValue(_wrapped), out result);
                    }

                    // check if this is an index into the 
                    if (TryGetIndex(null, new[] {binder.Name}, out result))
                    {
                        return true;
                    }

                    return base.TryGetMember(binder, out result);
                }
                return CheckResult(prop.GetValue(_wrapped, null), out result);
            }
            catch (Exception e)
            {
                Debug.WriteLine($"{e.Message}/{e.StackTrace}");
                result = null;
                return true;
            }
        }

        /// <summary>
        ///     Tries to set a property or field with the given name
        /// </summary>
        public override bool TrySetMember(SetMemberBinder binder, object value)
        {
            if (_wrapped == null)
            {
                return false;
            }

            var prop = _wrapped.GetType().GetProperty(binder.Name, flags);
            if (prop == null)
            {
                var fld = _wrapped.GetType().GetField(binder.Name, flags);
                if (fld != null)
                {
                    fld.SetValue(_wrapped, value);
                    return true;
                }
                return base.TrySetMember(binder, value);
            }

            prop.SetValue(_wrapped, value, null);
            return true;
        }
    }
}