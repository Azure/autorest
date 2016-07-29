// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Collections;
using System.Collections.Generic;

namespace AutoRest.Core.Utilities.Collections
{
    public abstract class MutableEnumerable<T> : IEnumerable<T>
    {
        private List<T> _list;

        protected List<T> List
        {
            get
            {
                if (_list == null)
                {
                    lock (this)
                    {
                        if (_list == null)
                        {
                            _list = new List<T>();
                        }
                    }
                }
                return _list;
            }
        }

        public IEnumerable<IEnumerator<T>> GetEnumerators(int copies)
        {
            for (var i = 0; i < copies; i++)
            {
                yield return GetEnumerator();
            }
        }

        protected abstract bool ItemExists(int index);

        internal class Enumerator<TT> : IEnumerator<TT>
        {
            private MutableEnumerable<TT> _collection;
            private int _index = -1;

            internal Enumerator(MutableEnumerable<TT> collection)
            {
                _collection = collection;
            }

            #region IEnumerator<Tt> Members

            public TT Current => _collection.List[_index];

            public void Dispose()
            {
                _collection = null;
            }

            object IEnumerator.Current => Current;

            public bool MoveNext() => _collection.ItemExists(++_index);

            public void Reset()
            {
                _index = -1;
            }

            public IEnumerator<TT> Clone() => new Enumerator<TT>(_collection)
            {
                _index = _index
            };

            #endregion
        }

        #region IEnumerable<T> Members

        public IEnumerator<T> GetEnumerator() => new Enumerator<T>(this);

        IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();

        #endregion
    }
}