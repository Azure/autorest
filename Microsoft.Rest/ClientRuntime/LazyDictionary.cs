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
    public class LazyDictionary<TKey, TValue> : IDictionary<TKey, TValue>, ILazyCollection<KeyValuePair<TKey, TValue>>
    {        
        private IDictionary<TKey, TValue> _dictionary;

        /// <summary>
        /// Default constructor without initializing the dictionary.
        /// </summary>
        public LazyDictionary()
        {
            // Default constructor is lazy so it doesn't initialize the dictionary
        }

        /// <summary>
        /// Initializes a new instance of the LazyDictionary class that contains elements copied from the specified IDictionary 
        /// and uses the default equality comparer for the key type.      
        /// </summary>
        /// <param name="dictionary">The IDictionary whose elements are copied to the new LazyDictionary.</param>
        public LazyDictionary(IDictionary<TKey, TValue> dictionary)
        {
            InnerDictionary = new Dictionary<TKey, TValue>(dictionary);
        }

        /// <summary>
        /// Initializes a new instance of the LazyDictionary class that contains elements copied from the 
        /// specified IDictionary and uses the specified IEqualityComparer.
        /// </summary>
        /// <param name="dictionary">The IDictionary whose elements are copied to the new LazyDictionary.</param>
        /// <param name="comparer">The IEqualityComparer implementation to use when comparing keys, or null to use 
        /// the default EqualityComparer for the type of the key.</param>
        public LazyDictionary(IDictionary<TKey, TValue> dictionary, IEqualityComparer<TKey> comparer)
        {
            InnerDictionary = new Dictionary<TKey, TValue>(dictionary, comparer);
        }

        /// <summary>
        /// Initializes a new instance of the LazyDictionary class that is empty, has the default initial capacity, 
        /// and uses the specified IEqualityComparer.
        /// </summary>
        /// <param name="comparer">The IEqualityComparer implementation to use when comparing keys, 
        /// or null to use the default EqualityComparer for the type of the key.</param>
        public LazyDictionary(IEqualityComparer<TKey> comparer)
        {
            InnerDictionary = new Dictionary<TKey, TValue>(comparer);
        }

        /// <summary>
        /// Initializes a new instance of the LazyDictionary class that is empty, has the specified initial capacity, 
        /// and uses the default equality comparer for the key type.
        /// </summary>
        /// <param name="capacity">The initial number of elements that the LazyDictionary can contain.</param>
        public LazyDictionary(int capacity)
        {
            InnerDictionary = new Dictionary<TKey, TValue>(capacity);
        }

        /// <summary>
        /// Initializes a new instance of the LazyDictionary class that is empty, has the specified initial capacity, 
        /// and uses the specified IEqualityComparer.
        /// </summary>
        /// <param name="capacity">The initial number of elements that the LazyDictionary can contain.</param>
        /// <param name="comparer">The IEqualityComparer implementation to use when comparing keys, or null to use the default EqualityComparer for the type of the key.</param>
        public LazyDictionary(int capacity, IEqualityComparer<TKey> comparer)
        {
            InnerDictionary = new Dictionary<TKey, TValue>(capacity, comparer);
        }
        
        private IDictionary<TKey, TValue> InnerDictionary
        {
            get { return _dictionary ?? (_dictionary = new Dictionary<TKey, TValue>()); }

            set { _dictionary = value; }
        }

        /// <summary>
        /// Adds the specified key and value to the dictionary.
        /// </summary>
        /// <param name="key">The key of the element to add.</param>
        /// <param name="value">The value of the element to add. The value can be null for reference types.</param>
        public void Add(TKey key, TValue value)
        {
            InnerDictionary.Add(key, value);
        }

        /// <summary>
        /// Determines whether the LazyDictionary contains the specified key.
        /// </summary>
        /// <param name="key">The key to locate in the LazyDictionary.</param>
        /// <returns>True if the LazyDictionary contains an element with the specified key; otherwise, false.</returns>
        public bool ContainsKey(TKey key)
        {
            return InnerDictionary.ContainsKey(key);
        }

        /// <summary>
        /// Gets a collection containing the keys in the LazyDictionary.
        /// </summary>
        public ICollection<TKey> Keys
        {
            get { return InnerDictionary.Keys; }
        }

        /// <summary>
        /// Removes the value with the specified key from the LazyDictionary.
        /// </summary>
        /// <param name="key">The key of the element to remove.</param>
        /// <returns>True if the element is successfully found and removed; otherwise, false. This method returns false if key is 
        /// not found in the LazyDictionary.</returns>
        public bool Remove(TKey key)
        {
            return InnerDictionary.Remove(key);
        }

        /// <summary>
        /// Gets the value associated with the specified key.
        /// </summary>
        /// <param name="key">The key of the value to get.</param>
        /// <param name="value">When this method returns, contains the value associated with the specified key, if the key is found; otherwise, 
        /// the default value for the type of the value parameter. This parameter is passed uninitialized.</param>
        /// <returns>True if the Dictionary contains an element with the specified key; otherwise, false.</returns>
        public bool TryGetValue(TKey key, out TValue value)
        {
            return InnerDictionary.TryGetValue(key, out value);
        }

        /// <summary>
        /// Gets a collection containing the values in the LazyDictionary.
        /// </summary>
        public ICollection<TValue> Values
        {
            get { return InnerDictionary.Values; }
        }

        /// <summary>
        /// Gets or sets the value associated with the specified key.
        /// </summary>
        /// <param name="key">The key of the value to get or set.</param>
        /// <returns>The value associated with the specified key. If the specified key is not found, a get operation throws a KeyNotFoundException,
        /// and a set operation creates a new element with the specified key.</returns>
        public TValue this[TKey key]
        {
            get { return InnerDictionary[key]; }
            set { InnerDictionary[key] = value; }
        }

        /// <summary>
        /// Adds an item to the LazyDictionary.
        /// </summary>
        /// <param name="item">The KeyValuePair object to add to the LazyDictionary.</param>
        public void Add(KeyValuePair<TKey, TValue> item)
        {
            InnerDictionary.Add(item);
        }

        /// <summary>
        /// Removes all keys and values from the LazyDictionary.
        /// </summary>
        public void Clear()
        {
            InnerDictionary.Clear();
        }

        /// <summary>
        /// Determines whether the LazyDictionary contains a specific KeyValuePair.
        /// </summary>
        /// <param name="item">The object to locate in the LazyDictionary.</param>
        /// <returns>True if item is found in the LazyDictionary; otherwise, false.</returns>
        public bool Contains(KeyValuePair<TKey, TValue> item)
        {
            return InnerDictionary.Contains(item);
        }

        /// <summary>
        /// Copies the elements of the LazyDictionary to an Array, starting at a particular Array index.
        /// </summary>
        /// <param name="array">The one-dimensional Array that is the destination of the elements copied from LazyDictionary. 
        /// The Array must have zero-based indexing.</param>
        /// <param name="arrayIndex">The zero-based index in array at which copying begins.</param>
        public void CopyTo(KeyValuePair<TKey, TValue>[] array, int arrayIndex)
        {
            InnerDictionary.CopyTo(array, arrayIndex);
        }

        /// <summary>
        /// Gets the number of key/value pairs contained in the LazyDictionary.
        /// </summary>
        public int Count
        {
            get { return InnerDictionary.Count; }
        }

        /// <summary>
        /// Gets a value indicating whether the LazyDictionary is read-only.
        /// </summary>
        public bool IsReadOnly
        {
            get { return InnerDictionary.IsReadOnly; }
        }

        /// <summary>
        /// Removes the first occurrence of a specific object from the LazyDictionary.
        /// </summary>
        /// <param name="item">The object to remove from the LazyDictionary.</param>
        /// <returns>true if item was successfully removed from the LazyDictionary; 
        /// otherwise, false. This method also returns false if item is not found in the original LazyDictionary.</returns>
        public bool Remove(KeyValuePair<TKey, TValue> item)
        {
            return InnerDictionary.Remove(item);
        }

        /// <summary>
        /// Returns an enumerator that iterates through the LazyDictionary.
        /// </summary>
        /// <returns>A Dictionary.Enumerator for the LazyDictionary.</returns>
        public IEnumerator<KeyValuePair<TKey, TValue>> GetEnumerator()
        {
            return InnerDictionary.GetEnumerator();
        }

        /// <summary>
        /// Returns an enumerator that iterates through the LazyDictionary.
        /// </summary>
        /// <returns>A Dictionary.Enumerator for the LazyDictionary.</returns>
        IEnumerator IEnumerable.GetEnumerator()
        {
            return InnerDictionary.GetEnumerator();
        }

        /// <summary>
        /// Get a value indicating whether the dictionary is initialized.
        /// </summary>
        public bool IsInitialized
        {
            get { return _dictionary != null; }
        }
    }
}