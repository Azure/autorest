// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using AutoRest.Core.Utilities.Collections;

namespace AutoRest.Core.Utilities
{
    public class DeepCopier
    {
        public void Copy(object source, object destination)
        {
            // get the destination properties
            // get the source properties
            
        }
    }

    public class Accessor
    {
        public string Name;
        public Type Type;
        public Delegate GetMethod;
        public Delegate SetMethod;

        public object GetValue(object instance) => GetMethod.DynamicInvoke(instance);
        public void SetValue(object instance, object value) => SetMethod.DynamicInvoke(instance, value);
    }
    
    public static class PropertyExtensions
    {
        private const BindingFlags AnyPropertyFlags =
            BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.FlattenHierarchy | BindingFlags.GetProperty |
            BindingFlags.Instance;

        private const BindingFlags AnyFieldFlags =
            BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.FlattenHierarchy | BindingFlags.GetField |
            BindingFlags.Instance;

        private static readonly MethodInfo _createSetField =
            typeof(PropertyExtensions).GetMethods()
                .FirstOrDefault(each =>
                        (each.Name == nameof(CreateSet)) && each.IsGenericMethod &&
                        (each.GetParameters()[0].ParameterType == typeof(FieldInfo)));

        private static readonly MethodInfo _createSetProperty =
            typeof(PropertyExtensions).GetMethods()
                .FirstOrDefault(each =>
                        (each.Name == nameof(CreateSet)) && each.IsGenericMethod &&
                        (each.GetParameters()[0].ParameterType == typeof(PropertyInfo)));

        public static Dictionary<string, Accessor> GetPropertyAccessors(Type t)
        {
            return t.GetProperties(AnyPropertyFlags).ToDictionaryNicely(property => property.Name, property => new Accessor
            {
                Name = t.Name,
                Type = t,
                GetMethod = GetReadableProp(t, property.Name).CreateGet(),
                SetMethod = GetWritableProp(t, property.Name).CreateSet(),
            });
        }
        
        public static PropertyInfo GetReadableProp(this Type type, string propertyName)
        {
            if (type == null)
            {
                return null;
            }

            var pi = type.GetProperty(propertyName, AnyPropertyFlags);
            return true == pi?.CanRead ? pi : GetReadableProp(type.BaseType, propertyName);
        }

        public static PropertyInfo GetWritableProp(this Type type, string propertyName)
        {
            if (type == null)
            {
                return null;
            }

            var pi = type.GetProperty(propertyName, AnyPropertyFlags);
            return true == pi?.CanWrite ? pi : GetReadableProp(type.BaseType, propertyName);
        }

        public static IEnumerable<PropertyInfo> DoGetProperties(this Type type) => type.GetProperties(AnyPropertyFlags).Select(each => GetReadableProp(type, each.Name)).WhereNotNull();

        public static IEnumerable<FieldInfo> DoGetFields(this Type type) => type.GetFields(AnyFieldFlags).Select(each => DoGetField(type, each.Name)).WhereNotNull();

        public static FieldInfo DoGetField(this Type type, string fieldName)
        {
            return type == null
                ? null
                : (type.GetField(fieldName, AnyFieldFlags) ?? DoGetField(type.BaseType, fieldName));
        }

        public static Func<T, object> CreateGet<T>(this PropertyInfo propertyInfo)
            => (Func<T, object>) propertyInfo.CreateGet();

        public static Delegate CreateGet(this PropertyInfo propertyInfo)
        {
            if ((propertyInfo == null) || (propertyInfo.DeclaringType == null))
            {
                throw new ArgumentNullException(nameof(propertyInfo));
            }

            var parameterExpression = Expression.Parameter(propertyInfo.DeclaringType, "instance");
            var getMethod = propertyInfo.GetGetMethod(true);

            Expression resultExpression = Expression.MakeMemberAccess(
                getMethod.IsStatic ? null : parameterExpression.CastTo(propertyInfo.DeclaringType),
                propertyInfo);

            resultExpression = resultExpression.CastTo(typeof(object));

            return
                Expression.Lambda(Expression.GetFuncType(propertyInfo.DeclaringType, typeof(object)), resultExpression,
                    parameterExpression).Compile();
        }

        public static Func<T, object> CreateGet<T>(this FieldInfo fieldInfo)
            => (Func<T, object>) fieldInfo.CreateGet();

        public static Delegate CreateGet(this FieldInfo fieldInfo)
        {
            if ((fieldInfo == null) || (fieldInfo.DeclaringType == null))
            {
                throw new ArgumentNullException(nameof(fieldInfo));
            }

            var sourceParameter = Expression.Parameter(fieldInfo.DeclaringType, "source");

            Expression fieldExpression = Expression.Field(fieldInfo.IsStatic ? null : 
                sourceParameter.CastTo(fieldInfo.DeclaringType), fieldInfo);

            fieldExpression = fieldExpression.CastTo(typeof(object));

            return Expression.Lambda(Expression.GetFuncType(fieldInfo.DeclaringType, typeof(object)), fieldExpression,
                    sourceParameter).Compile();
        }

        public static Delegate CreateSet(this FieldInfo fieldInfo)
        {
            return (Delegate) _createSetField.MakeGenericMethod(fieldInfo.DeclaringType)
                .Invoke(null, new[] {fieldInfo});
        }

        public static Action<T, object> CreateSet<T>(this FieldInfo fieldInfo)
        {
            if ((fieldInfo == null) || (fieldInfo.DeclaringType == null))
            {
                throw new ArgumentNullException(nameof(fieldInfo));
            }

            // properties on valuetypes are kinda funny.
            if (fieldInfo.DeclaringType.IsValueType || fieldInfo.IsInitOnly)
            {
                return (o, v) => fieldInfo.SetValue(o, v);
            }

            var sourceParameterExpression = Expression.Parameter(typeof(T), "source");
            var valueParameterExpression = Expression.Parameter(typeof(object), "value");

            Expression fieldExpression =Expression.Field(fieldInfo.IsStatic ? null : 
                sourceParameterExpression.CastTo(fieldInfo.DeclaringType),fieldInfo);

            var valueExpression = valueParameterExpression.CastTo(fieldExpression.Type);

            var assignExpression = Expression.Assign(fieldExpression, valueExpression);

            return (Action<T, object>) Expression.Lambda(typeof(Action<T, object>), assignExpression,
                sourceParameterExpression, valueParameterExpression).Compile();
        }

        public static Delegate CreateSet(this PropertyInfo propertyInfo)
        {
            return (Delegate)_createSetProperty.MakeGenericMethod(propertyInfo.DeclaringType)
                .Invoke(null, new[] {propertyInfo});
        }

        public static Action<T, object> CreateSet<T>(this PropertyInfo propertyInfo)
        {
            if ((propertyInfo == null) || (propertyInfo.DeclaringType == null))
            {
                throw new ArgumentNullException(nameof(propertyInfo));
            }

            // properties on valuetypes are kinda funny.
            if (propertyInfo.DeclaringType.IsValueType)
            {
                return (o, v) => propertyInfo.SetValue(o, v, null);
            }

            var instanceParameter = Expression.Parameter(typeof(T), "instance");
            var valueParameter = Expression.Parameter(typeof(object), "value");
            var readValueParameter = valueParameter.CastTo(propertyInfo.PropertyType);

            var setMethod = propertyInfo.GetSetMethod(true);

            Expression setExpression = setMethod.IsStatic
                ? Expression.Call(setMethod, readValueParameter)
                : Expression.Call(instanceParameter.CastTo(propertyInfo.DeclaringType), setMethod,
                    readValueParameter);

            return (Action<T, object>) Expression.Lambda(typeof(Action<T, object>), setExpression, instanceParameter,
                valueParameter).Compile();
        }

        // Ensures that a given expression casts to a particular Type
        private static Expression CastTo(this Expression expression, Type targetType) => 
            (expression.Type == targetType) ||(!expression.Type.IsValueType && targetType.IsAssignableFrom(expression.Type))
                ? expression
                : Expression.Convert(expression, targetType);
    }
}