// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Perks.Linq {
    using System;
    using System.Collections;
    using System.Collections.Generic;

    /// <summary>
    ///     An interface for an IEnumerable that is disposable.
    ///     Must also implement a sane variant of Any();
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public interface IEnumerableDisposable<out T> : IEnumerable<T>, IDisposable {
        bool Any();
    }

    /// <summary>
    ///     An IEnumerable wrapper that will call Dispose() (if the item is IDisposeable)
    ///     on items in the collection once they are done.
    ///     Also supports adding another IDisposable to call once the enumeration is completed.
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public class DisposeAsYouGoEnumerable<T> : IEnumerableDisposable<T>, IEnumerator<T> {
        private T _current;
        private IDisposable _disposeOnComplete;
        private IEnumerable<T> _enumerable;
        private IEnumerator<T> _enumerator;
        private T[] _peek;

        /// <summary>
        ///     Creates an DAYGE from an IEnumerable
        /// </summary>
        /// <param name="enumerable">an enumeration to wrap</param>
        public DisposeAsYouGoEnumerable(IEnumerable<T> enumerable) {
            if (enumerable == null) {
                throw new ArgumentNullException(nameof(enumerable));
            }
            _enumerable = enumerable;
        }

        /// <summary>
        ///     Creates an DAYGE from an IEnumerable
        /// </summary>
        /// <param name="enumerable">an enumeration to wrap</param>
        /// <param name="disposeOnComplete">an IDisposable to dispose when this is disposed.</param>
        public DisposeAsYouGoEnumerable(IEnumerable<T> enumerable, IDisposable disposeOnComplete) {
            if (enumerable == null) {
                throw new ArgumentNullException(nameof(enumerable));
            }

            _enumerable = enumerable;
            _disposeOnComplete = disposeOnComplete;
        }

        /// <summary>
        ///     Returns an enumerator that iterates through the collection.
        /// </summary>
        /// <returns>
        ///     An enumerator that can be used to iterate through the collection.
        /// </returns>
        public IEnumerator<T> GetEnumerator() {
            AssertNotDisposed();

            // if we have peeked, we can return the enumerator that we have.
            if (_peek != null && _enumerator != null) {
                return this;
            }

            AssertEnumeratorNotStarted();

            // make sure we haven't peeked into the enumerable.
            if (_peek == null) {
                _enumerator = _enumerable.GetEnumerator();
            }

            return this;
        }

        /// <summary>
        ///     Returns an enumerator that iterates through a collection.
        /// </summary>
        /// <returns>
        ///     An <see cref="T:System.Collections.IEnumerator" /> object that can be used to iterate through the collection.
        /// </returns>
        IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();

        /// <summary>
        ///     Performs application-defined tasks associated with freeing, releasing, or resetting unmanaged resources.
        /// </summary>
        public void Dispose() {
            Current = default(T);
            _disposeOnComplete?.Dispose();
            _disposeOnComplete = null;
            _enumerable = null;
            _enumerator?.Dispose();
            _enumerator = null;
            if (_peek != null && _peek.Length > 0) {
                (_peek[0] as IDisposable)?.Dispose();
            }
            _peek = null;
        }

        /// <summary>
        ///     This peeks at the underlying enumerable to see if there are any items.
        ///     This does technically create the enumerable, and caches the first element if it exists.
        ///     Calling <see cref="GetEnumerator()" /> after this is ok.
        /// </summary>
        /// <returns></returns>
        public bool Any() {
            AssertNotDisposed();

            if (_peek == null) {
                if (_enumerator == null) {
                    // not started yet, start it.
                    _enumerator = _enumerable.GetEnumerator();
                }
                // grab the next element, store it.
                _peek = _enumerator.MoveNext() ? new[] {_enumerator.Current} : new T[0];
            }

            return _peek.Length > 0;
        }

        /// <summary>
        ///     Advances the enumerator to the next element of the collection.
        /// </summary>
        /// <returns>
        ///     true if the enumerator was successfully advanced to the next element; false if the enumerator has passed the end of
        ///     the collection.
        /// </returns>
        /// <exception cref="T:System.InvalidOperationException">The collection was modified after the enumerator was created. </exception>
        public bool MoveNext() {
            AssertNotDisposed();
            AssertEnumeratorIsActive();

            if (_peek == null && _enumerator.MoveNext()) {
                // nothing waiting that we peeked at.
                // and we got one from the enumerator.
                Current = _enumerator.Current;
                return true;
            }

            if (_peek?.Length > 0) {
                // we have an item that's been peeked at, waiting to be used
                Current = _peek[0];
                _peek = null;
                return true;
            }

            // nothing left, nothing in the peek buffer
            Current = default(T);
            return false;
        }

        /// <summary>
        ///     Sets the enumerator to its initial position, which is before the first element in the collection.
        /// </summary>
        /// <exception cref="T:System.InvalidOperationException">The collection was modified after the enumerator was created. </exception>
        public void Reset() {
            AssertNotDisposed();
            AssertEnumeratorIsActive();
            throw new InvalidOperationException($"DisposeAsYouGoEnumerable<{typeof(T).Name}> may only be enumerated once.");
        }

        /// <summary>
        ///     Gets the element in the collection at the current position of the enumerator.
        /// </summary>
        /// <returns>
        ///     The element in the collection at the current position of the enumerator.
        /// </returns>
        public T Current {
            get {
                AssertNotDisposed();
                AssertEnumeratorIsActive();
                return _current;
            }
            private set {
                (_current as IDisposable)?.Dispose();
                _current = value;
            }
        }

        /// <summary>
        ///     Gets the current element in the collection.
        /// </summary>
        /// <returns>
        ///     The current element in the collection.
        /// </returns>
        object IEnumerator.Current => Current;

        private void AssertEnumeratorIsActive() {
            if (_enumerator == null) {
                throw new InvalidOperationException("Enumerator has not been intialized, or has already been disposed.");
            }
        }

        private void AssertEnumeratorNotStarted() {
            if (_enumerator != null) {
                throw new InvalidOperationException($"DisposeAsYouGoEnumerable<{typeof(T).Name}> may only be enumerated once.");
            }
        }

        private void AssertNotDisposed() {
            if (_enumerable == null) {
                throw new ObjectDisposedException($"This DisposeAsYouGoEnumerable<{typeof(T).Name}> has already been disposed.");
            }
        }
    }
}