// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using AutoRest.Core.Utilities.Collections;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace AutoRest.Core.Utilities
{
    public class Fixable
    {
        internal static Dictionary<Type, JsonConverter> Converters = new Dictionary<Type, JsonConverter>();

        public bool IsFixed { get; protected set; }
        internal virtual bool ShouldSerialize => false;
    }

    [DebuggerDisplay("{DebuggerValue,nq}")]
    public class Fixable<T> : Fixable, ICopyFrom<T>, ICopyFrom<Fixable<T>>
    {
        private string DebuggerValue => IsFixed || (OnGet == null) ? $"\"{Value}\"" : $"\"{Value}\" (#:\"{_value}\")";

        static Fixable()
        {
            // make sure there is a JSON converter for this Fixable<T>
            Converters.Add(typeof(Fixable<T>), new Converter());
        }

        internal override bool ShouldSerialize => null != _value;


        public class Converter : JsonConverter
        {
            public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
            {
                var v = value as Fixable<T>;
                (ReferenceEquals(v, null) ? new JObject() : JToken.FromObject(v._value)).WriteTo(writer);
            }

            public override object ReadJson(JsonReader reader, Type objectType, object existingValue,
                JsonSerializer serializer)
            {
                if (reader.TokenType == JsonToken.Null)
                {
                    return null;
                }

                var jtoken = JToken.Load(reader);

                if (jtoken == null)
                {
                    return null;
                }
                var target = existingValue as Fixable<T>;
                if (!ReferenceEquals(target, null))
                {
                    if (reader.Path[0] != '#')
                    {
                        target.FixedValue = jtoken.Value<T>();
                    }
                    else
                    {
                        target.Value = jtoken.Value<T>();
                    }
                }
                return existingValue;
            }

            public override bool CanConvert(Type objectType) => typeof(Fixable<T>).IsAssignableFrom(objectType);
        }

        private T _value;
        public event Func<T, T> OnGet;
        public event Func<T, T> OnSet;

        public static implicit operator T(Fixable<T> d) => d.Value;
        public static implicit operator Fixable<T>(T d) => new Fixable<T> {_value = d};

        public bool CopyFrom(T source)
        {
            Value = source;
            return true;
        }

        public bool CopyFrom(Fixable<T> value)
        {
            if (!ReferenceEquals(value,null))
            {
                _value = Invoke(OnSet, value._value);
                IsFixed = value.IsFixed;
                return true;
            }
            return false;
        }

        public bool CopyFrom(object source)
        {
            if (ReferenceEquals(source,null))
            {
                _value = default(T);
                IsFixed = false;
                return true;
            }

            if (source is Fixable<T>)
            {
                return CopyFrom((Fixable<T>) source);
            }

            if (source is T)
            {
                return CopyFrom((T) source);
            }

            return false;
        }

        public override string ToString() => Value?.ToString();

        public static bool operator ==(T y, Fixable<T> x)
        {
            if (ReferenceEquals(null, y))
            {
                return ReferenceEquals(x, null) || (ReferenceEquals(null,x.Value));
            }
            return !ReferenceEquals(x, null) && Equals(y, x.Value);
        }

        public static bool operator !=(T y, Fixable<T> x) => !(y == x);


        public static bool operator ==(Fixable<T> x, Fixable<T> y)
        {
            if (ReferenceEquals(x, y))
            {
                return true;
            }
            if (ReferenceEquals(x, null))
            {
                return ReferenceEquals(null,y.Value);
            }
            if (ReferenceEquals(y, null))
            {
                return ReferenceEquals(null,x.Value);
            }
            if (x.Value == null && y.Value == null)
            {
                return true;
            }
            if (x.Value == null )
            {
                return false;
            }
            return x.Value.Equals(y.Value);
        }

        public static bool operator !=(Fixable<T> x, Fixable<T> y)
        {
            return !(x == y);
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(obj,null))
            {
                return ReferenceEquals(null,Value);
            }

            var fixable = obj as Fixable<T>;
            if (!ReferenceEquals(fixable,null))
            {
                return Equals(fixable.Value, Value);
            }
            if (obj is T)
            {
                return Equals(obj, _value);
            }
            return false;
        }

        public override int GetHashCode() => Value.GetHashCode();


        public Fixable()
        {
        }

        public Fixable(T value)
        {
            _value = value;
        }

        public Fixable(Func<T, T> onGet)
        {
            OnGet += onGet;
        }

        public Fixable(Func<T, T> onGet, Func<T, T> onSet)
        {
            OnGet += onGet;
            OnSet += onSet;
        }

        private static T Invoke(MulticastDelegate dlg, T value)
        {
            foreach (Func<T, T> evnt in dlg?.GetInvocationList() ?? Enumerable.Empty<Delegate>())
            {
                value = evnt(value);
            }
            return value;
        }

        public T Value
        {
            get
            {
                if (!IsFixed && (OnGet != null))
                {
                    return Invoke(OnGet, _value);
                }
                return _value;
            }
            set
            {
                IsFixed = false;
                _value = Invoke(OnSet, value);
            }
        }

        public T RawValue => _value;

        public T FixedValue
        {
            get { return _value; }
            set
            {
                IsFixed = true;
                _value = Invoke(OnSet, value);
            }
        }
    }
}