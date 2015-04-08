// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections;
using System.Collections.Generic;

namespace Microsoft.Rest
{
    /// <summary>
    /// Represents an object list that supports on-demand initialization.
    /// </summary>
    /// <typeparam name="T"></typeparam>
    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming",
        "CA1710:IdentifiersShouldHaveCorrectSuffix",
        Justification = "The name has been reviewed and decided. Changing it has too broad impact")]
    public class LazyList<T> : IList<T>, ILazyCollection<T>
    {       
        private IList<T> _list;

        /// <summary>
        /// Default constructor without initializing the list.
        /// </summary>
        public LazyList()
        {
            // Default constructor is lazy so it doesn't initialize the list
        }

        /// <summary>
        /// Constructor that Initializes a new instance of the LazyList that contains elements copied 
        /// from the specified collection.
        /// </summary>
        /// <param name="collection">The collection whose elements are copied to the new list.</param>
        public LazyList(IEnumerable<T> collection)
        {
            InnerList = new List<T>(collection);
        }

        /// <summary>
        /// Initializes a new instance of the LazyList that is empty and has the specified initial capacity.
        /// </summary>
        /// <param name="capacity">The number of elements that the new list can initially store.</param>
        public LazyList(int capacity)
        {
            InnerList = new List<T>(capacity);
        }
       
        private IList<T> InnerList
        {
            get { return _list ?? (_list = new List<T>()); }

            set { _list = value; }
        }

        /// <summary>
        /// Get a value indicating whether the list is initialized.
        /// </summary>
        public bool IsInitialized
        {
            get { return _list != null; }
        }

        /// <summary>
        /// Searches for the specified item and returns the zero-based index of the first occurrence within the entire list.
        /// </summary>
        /// <param name="item">The item to locate in the LazyList.</param>
        /// <returns></returns>
        public int IndexOf(T item)
        {
            return InnerList.IndexOf(item);
        }

        /// <summary>
        /// Inserts an element into the list at the specified index.
        /// </summary>
        /// <param name="index">The zero-based index at which item should be inserted.</param>
        /// <param name="item">Item to insert.</param>
        public void Insert(int index, T item)
        {
            InnerList.Insert(index, item);
        }

        /// <summary>
        /// Removes the element at the specified index of the LazyList.
        /// </summary>
        /// <param name="index">The zero-based index of the element to remove.</param>
        public void RemoveAt(int index)
        {
            InnerList.RemoveAt(index);
        }

        /// <summary>
        /// Gets or sets the element at the specified index.
        /// </summary>
        /// <param name="index">The zero-based index of the element.</param>
        /// <returns>The element at the specified index of the LazyList.</returns>
        public T this[int index]
        {
            get { return InnerList[index]; }
            set { InnerList[index] = value; }
        }

        /// <summary>
        /// Adds an object to the end of the LazyList.
        /// </summary>
        /// <param name="item">The object to be added to the end of the LazyList. The value can be null for reference types.</param>
        public void Add(T item)
        {
            InnerList.Add(item);
        }

        /// <summary>
        /// Removes all elements from the LazyList.
        /// </summary>
        public void Clear()
        {
            InnerList.Clear();
        }

        /// <summary>
        /// Determines whether an element is in the LazyList.
        /// </summary>
        /// <param name="item">The object to locate in the LazyList. The value can be null for reference types.</param>
        /// <returns></returns>
        public bool Contains(T item)
        {
            return InnerList.Contains(item);
        }

        /// <summary>
        /// Copies the entire LazyList to a compatible one-dimensional array, starting at the specified index of the target array.
        /// </summary>
        /// <param name="array">The one-dimensional Array that is the destination of the elements copied from LazyList. The Array must have zero-based indexing.</param>
        /// <param name="arrayIndex">The zero-based index in array at which copying begins.</param>
        public void CopyTo(T[] array, int arrayIndex)
        {
            InnerList.CopyTo(array, arrayIndex);
        }

        /// <summary>
        /// Gets the number of elements contained in the List.
        /// </summary>
        public int Count
        {
            get { return InnerList.Count; }
        }

        /// <summary>
        /// Gets a value indicating whether the LazyList is read-only.
        /// </summary>
        public bool IsReadOnly
        {
            get { return InnerList.IsReadOnly; }
        }

        /// <summary>
        /// Removes the first occurrence of a specific object from the LazyList.
        /// </summary>
        /// <param name="item">The object to remove from the LazyList. The value can be null for reference types.</param>
        /// <returns>true if item is successfully removed; otherwise, false. This method also returns false if item was not found in the LazyList.</returns>
        public bool Remove(T item)
        {
            return InnerList.Remove(item);
        }

        /// <summary>
        /// Returns an enumerator that iterates through the LazyList.
        /// </summary>
        /// <returns>A List.Enumerator for the LazyList.</returns>
        public IEnumerator<T> GetEnumerator()
        {
            return InnerList.GetEnumerator();
        }

        /// <summary>
        /// Returns an enumerator that iterates through the LazyList.
        /// </summary>
        /// <returns>A List.Enumerator for the LazyList.</returns>
        IEnumerator IEnumerable.GetEnumerator()
        {
            return InnerList.GetEnumerator();
        }
    }
}