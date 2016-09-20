// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;

namespace AutoRest.Core.Utilities.Collections
{
    /// <summary>
    /// Implements a generic IDictionary[TKey,TValue] on top of OrderedDictionary
    /// </summary>
    /// <typeparam name="TKey">The type of keys in the dictionary.</typeparam>
    /// <typeparam name="TValue">The type of values in the dictionary.</typeparam>
    public class OrderedDictionary<TKey, TValue> : OrderedDictionary, IDictionary<TKey, TValue>
    {
        public new IEnumerator<KeyValuePair<TKey, TValue>> GetEnumerator() => new KeyValuePairEnumerator(base.GetEnumerator());

        public new ICollection<TKey> Keys => new KeyCollection(this);

        public new ICollection<TValue> Values => new ValueCollection(this);

        public void Add(KeyValuePair<TKey, TValue> item)
        {
            base.Add(item.Key, item.Value);
        }

        public bool Contains(KeyValuePair<TKey, TValue> item) => base.Contains(item.Key) && item.Value.Equals(base[item.Key]);

        public void CopyTo(KeyValuePair<TKey, TValue>[] array, int arrayIndex)
        {
            if (array == null)
            {
                throw new ArgumentNullException(nameof(array));
            }
            using (var e = GetEnumerator())
            {
                while(e.MoveNext())
                {
                    array[arrayIndex++] = e.Current;
                }
            }
        }

        public bool Remove(KeyValuePair<TKey, TValue> item)
        {
            if (Contains(item))
            {
                base.Remove(item.Key);
                return true;
            }
            return false;
        }

        public bool ContainsKey(TKey key) => base.Contains(key);

        public void Add(TKey key, TValue value)
        {
            base.Add(key, value);
        }

        public bool Remove(TKey key)
        {
            if (base.Contains(key))
            {
                base.Remove(key);
                return true;
            }
            return false;
        }

        public bool TryGetValue(TKey key, out TValue value)
        {
            if (base.Contains(key))
            {
                value = (TValue) base[key];
                return true;
            }
            value = default(TValue);
            return false;
        }

        public TValue this[TKey key]
        {
            get { return (TValue) base[key]; }
            set { base[key] = value; }
        }

        internal class KeyCollection : ICollection<TKey>
        {
            private readonly OrderedDictionary _dictionary;

            public KeyCollection(OrderedDictionary dictionary)
            {
                _dictionary = dictionary;
            }
            public int Count => _dictionary.Keys.Count;

            public bool IsReadOnly => true;

            public IEnumerator<TKey> GetEnumerator() => _dictionary.Keys.Cast<TKey>().GetEnumerator();

            IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();

            public bool Contains(TKey item) => _dictionary.Contains(item);

            public void CopyTo(TKey[] array, int arrayIndex)
            {
                _dictionary.Keys.CopyTo(array, arrayIndex);
            }

            public bool Remove(TKey item)
            {
                throw new NotImplementedException();
            }
            public void Add(TKey item)
            {
                throw new NotImplementedException();
            }

            public void Clear()
            {
                throw new NotImplementedException();
            }
        }

        internal class KeyValuePairEnumerator : IEnumerator<KeyValuePair<TKey, TValue>>
        {
            private readonly IDictionaryEnumerator _enumerator;

            internal KeyValuePairEnumerator(IDictionaryEnumerator e)
            {
                _enumerator = e;
            }

            public void Dispose()
            {
            }

            public bool MoveNext() => _enumerator.MoveNext();

            public void Reset()
            {
                _enumerator.Reset();
            }

            public KeyValuePair<TKey, TValue> Current => new KeyValuePair<TKey, TValue>((TKey) _enumerator.Key, (TValue) _enumerator.Value);

            object IEnumerator.Current => Current;
        }

        internal class ValueCollection : ICollection<TValue>
        {
            private readonly OrderedDictionary _dictionary;

            public ValueCollection(OrderedDictionary dictionary)
            {
                _dictionary = dictionary;
            }

            public IEnumerator<TValue> GetEnumerator() => _dictionary.Values.Cast<TValue>().GetEnumerator();

            IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();

            public void Add(TValue item)
            {
                throw new NotImplementedException();
            }

            public void Clear()
            {
                throw new NotImplementedException();
            }

            public bool Contains(TValue item) => _dictionary.Values.Cast<TValue>().Contains(item);

            public void CopyTo(TValue[] array, int arrayIndex)
            {
                _dictionary.Values.CopyTo(array, arrayIndex);
            }

            public bool Remove(TValue item)
            {
                throw new NotImplementedException();
            }

            public int Count => _dictionary.Values.Count;

            public bool IsReadOnly => true;
        }
    }
}