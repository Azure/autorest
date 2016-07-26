// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Core.Utilities.Collections
{
    /// <summary>
    ///     A Enumerable wrapper that optimistically caches elements when enumerated
    ///     Permits the re-enumeration without re-running the original query.
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public class ReEnumerable<T> : MutableEnumerable<T>
    {
        private readonly IEnumerable<T> _source;
        private IEnumerator<T> _sourceIterator;

        /// <summary>
        /// </summary>
        /// <param name="source"></param>
        public ReEnumerable(IEnumerable<T> source)
        {
            _source = source ?? new T[0];
        }

        /// <summary>
        /// </summary>
        /// <param name="sourceIterator"></param>
        public ReEnumerable(IEnumerator<T> sourceIterator)
        {
            _source = null;
            _sourceIterator = sourceIterator;
        }

        /// <summary>
        /// </summary>
        /// <param name="index"></param>
        public T this[int index] => ItemExists(index) ? List[index] : default(T);

        /// <summary>
        /// </summary>
        public int Count => this.Count();

        /// <summary>
        /// </summary>
        /// <param name="index"></param>
        /// <returns></returns>
        protected override bool ItemExists(int index)
        {
            if (index < List.Count)
            {
                return true;
            }

            lock (this)
            {
                if (_sourceIterator == null)
                {
                    _sourceIterator = _source.GetEnumerator();
                }

                try
                {
                    while (_sourceIterator.MoveNext())
                    {
                        List.Add(_sourceIterator.Current);
                        if (index < List.Count)
                        {
                            return true;
                        }
                    }
                }
                catch
                {
                    // if the _sourceIterator is cancelled
                    // then MoveNext() will throw; that's ok
                    // that just means we're done
                }
            }
            return false;
        }

        /// <summary>
        /// </summary>
        /// <param name="additionalItems"></param>
        /// <returns></returns>
        public MutableEnumerable<T> Concat(IEnumerable<T> additionalItems)
        {
            return Enumerable.Concat(this, additionalItems).ReEnumerable();
        }
    }
}