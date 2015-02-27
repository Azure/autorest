// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections;
using System.Collections.Generic;

namespace Microsoft.Rest
{
    /// <summary>
    /// Represents an IDictionary that supports ILazyCollection on-demand initialization.
    /// </summary>
    /// <typeparam name="TKey">Type parameter for Key.</typeparam>
    /// <typeparam name="TValue">Type parameter for Value.</typeparam>
    public class LazyDictionary<TKey, TValue> : IDictionary<TKey, TValue>, ILazyCollectionInitialized
    {
        private IDictionary<TKey, TValue> _dictionary;

        public LazyDictionary()
        {
            // Default constructor is lazy so it doesn't initialize the dictionary
        }

        public LazyDictionary(IDictionary<TKey, TValue> dictionary)
        {
            InnerDictionary = new Dictionary<TKey, TValue>(dictionary);
        }

        public LazyDictionary(IDictionary<TKey, TValue> dictionary, IEqualityComparer<TKey> comparer)
        {
            InnerDictionary = new Dictionary<TKey, TValue>(dictionary, comparer);
        }

        public LazyDictionary(IEqualityComparer<TKey> comparer)
        {
            InnerDictionary = new Dictionary<TKey, TValue>(comparer);
        }

        public LazyDictionary(int capacity)
        {
            InnerDictionary = new Dictionary<TKey, TValue>(capacity);
        }

        public LazyDictionary(int capacity, IEqualityComparer<TKey> comparer)
        {
            InnerDictionary = new Dictionary<TKey, TValue>(capacity, comparer);
        }

        private IDictionary<TKey, TValue> InnerDictionary
        {
            get
            {
                if (_dictionary == null)
                {
                    _dictionary = new Dictionary<TKey, TValue>();
                }

                return _dictionary;
            }

            set { _dictionary = value; }
        }

        public void Add(TKey key, TValue value)
        {
            InnerDictionary.Add(key, value);
        }

        public bool ContainsKey(TKey key)
        {
            return InnerDictionary.ContainsKey(key);
        }

        public ICollection<TKey> Keys
        {
            get { return InnerDictionary.Keys; }
        }

        public bool Remove(TKey key)
        {
            return InnerDictionary.Remove(key);
        }

        public bool TryGetValue(TKey key, out TValue value)
        {
            return InnerDictionary.TryGetValue(key, out value);
        }

        public ICollection<TValue> Values
        {
            get { return InnerDictionary.Values; }
        }

        public TValue this[TKey key]
        {
            get { return InnerDictionary[key]; }
            set { InnerDictionary[key] = value; }
        }

        public void Add(KeyValuePair<TKey, TValue> item)
        {
            InnerDictionary.Add(item);
        }

        public void Clear()
        {
            InnerDictionary.Clear();
        }

        public bool Contains(KeyValuePair<TKey, TValue> item)
        {
            return InnerDictionary.Contains(item);
        }

        public void CopyTo(KeyValuePair<TKey, TValue>[] array, int arrayIndex)
        {
            InnerDictionary.CopyTo(array, arrayIndex);
        }

        public int Count
        {
            get { return InnerDictionary.Count; }
        }

        public bool IsReadOnly
        {
            get { return InnerDictionary.IsReadOnly; }
        }

        public bool Remove(KeyValuePair<TKey, TValue> item)
        {
            return InnerDictionary.Remove(item);
        }

        public IEnumerator<KeyValuePair<TKey, TValue>> GetEnumerator()
        {
            return InnerDictionary.GetEnumerator();
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return InnerDictionary.GetEnumerator();
        }

        public bool IsInitialized
        {
            get { return _dictionary != null; }
        }
    }
}