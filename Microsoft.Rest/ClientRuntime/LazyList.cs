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

        public LazyList()
        {
            // Default constructor is lazy so it doesn't initialize the list
        }

        public LazyList(IEnumerable<T> collection)
        {
            InnerList = new List<T>(collection);
        }

        public LazyList(int capacity)
        {
            InnerList = new List<T>(capacity);
        }

        private IList<T> InnerList
        {
            get
            {
                if (_list == null)
                {
                    _list = new List<T>();
                }

                return _list;
            }

            set { _list = value; }
        }

        public bool IsInitialized
        {
            get { return _list != null; }
        }

        public int IndexOf(T item)
        {
            return InnerList.IndexOf(item);
        }

        public void Insert(int index, T item)
        {
            InnerList.Insert(index, item);
        }

        public void RemoveAt(int index)
        {
            InnerList.RemoveAt(index);
        }

        public T this[int index]
        {
            get { return InnerList[index]; }
            set { InnerList[index] = value; }
        }

        public void Add(T item)
        {
            InnerList.Add(item);
        }

        public void Clear()
        {
            InnerList.Clear();
        }

        public bool Contains(T item)
        {
            return InnerList.Contains(item);
        }

        public void CopyTo(T[] array, int arrayIndex)
        {
            InnerList.CopyTo(array, arrayIndex);
        }

        public int Count
        {
            get { return InnerList.Count; }
        }

        public bool IsReadOnly
        {
            get { return InnerList.IsReadOnly; }
        }

        public bool Remove(T item)
        {
            return InnerList.Remove(item);
        }

        public IEnumerator<T> GetEnumerator()
        {
            return InnerList.GetEnumerator();
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return InnerList.GetEnumerator();
        }
    }
}