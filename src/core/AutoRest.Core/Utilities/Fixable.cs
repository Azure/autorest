// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Diagnostics;
using System.Linq;
using AutoRest.Core.Utilities.Collections;
using Newtonsoft.Json;

namespace AutoRest.Core.Utilities
{
    [DebuggerDisplay("{DebuggerValue,nq}")]
    public class Fixable<T> : ICopyFrom<T>, ICopyFrom<Fixable<T>>
    {
        [JsonProperty("fixed")]
        public bool IsFixed { get; protected set; }

        [JsonIgnore]
        private string DebuggerValue => IsFixed || (OnGet == null) ? $"\"{Value}\"" : $"\"{Value}\" (#:\"{_value}\")";

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

        [JsonIgnore]
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

        [JsonProperty("raw")]
        public T RawValue { get => _value; set => _value = value; }

        [JsonIgnore]
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