// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Perks.Async.Observable {
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;

    public class EnumerableObserver<T> : IEnumerable<T>, IObserver<T>, IDisposable, IEnumerator<T> {
        private readonly WaitableBoolean _available;
        private readonly IDisposable _subscription;
        private readonly CancellationTokenSource _token;

        private T _in;
        private object _lock = new object();

        public EnumerableObserver(IObservable<T> observable, CancellationToken token) {
            if (observable == null) {
                throw new ArgumentNullException(nameof(observable));
            }
            _available = new WaitableBoolean(true);
            _token = CancellationTokenSource.CreateLinkedTokenSource(token);
            _subscription = observable.Subscribe(this);
        }

        public EnumerableObserver(IObservable<T> observable) : this(observable, CancellationToken.None) {
        }

        public void Dispose() {
            _subscription.Dispose();
        }

        public IEnumerator<T> GetEnumerator() => this;

        /// <summary>
        ///     Returns an enumerator that iterates through a collection.
        /// </summary>
        /// <returns>
        ///     An <see cref="T:System.Collections.IEnumerator" /> object that can be used to iterate through the collection.
        /// </returns>
        IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();

        /// <summary>
        ///     Advances the enumerator to the next element of the collection.
        /// </summary>
        /// <returns>
        ///     true if the enumerator was successfully advanced to the next element; false if the enumerator has passed the end of
        ///     the collection.
        /// </returns>
        /// <exception cref="T:System.InvalidOperationException">The collection was modified after the enumerator was created. </exception>
        public bool MoveNext() {
            if (_available.WaitReset()) {
                Current = _in;
                _available.Set();
                return true;
            }
            return false;
        }

        /// <summary>
        ///     Sets the enumerator to its initial position, which is before the first element in the collection.
        /// </summary>
        /// <exception cref="T:System.InvalidOperationException">The collection was modified after the enumerator was created. </exception>
        public void Reset() {
            // not really appropriate in this case.
            Current = default(T);
            _available.Set();
        }

        /// <summary>
        ///     Gets the current element in the collection.
        /// </summary>
        /// <returns>
        ///     The current element in the collection.
        /// </returns>
        object IEnumerator.Current => Current;

        /// <summary>
        ///     Gets the element in the collection at the current position of the enumerator.
        /// </summary>
        /// <returns>
        ///     The element in the collection at the current position of the enumerator.
        /// </returns>
        public T Current {get; private set;}

        /// <summary>
        ///     Provides the observer with new data.
        /// </summary>
        /// <param name="value">The current notification information.</param>
        public void OnNext(T value) {
            try {
                // only allow one setter in at a time.
                lock (_lock) {
                    if (_available.WaitSet()) {
                        _in = value;
                        _available.Reset();
                    }
                }
            } catch {
                // cancelled. 
            }
        }

        /// <summary>
        ///     Notifies the observer that the provider has experienced an error condition.
        /// </summary>
        /// <param name="error">An object that provides additional information about the error.</param>
        public void OnError(Exception error) {
            _available.Complete();
        }

        /// <summary>
        ///     Notifies the observer that the provider has finished sending push-based notifications.
        /// </summary>
        public void OnCompleted() {
            _available.Complete();
        }
    }
}