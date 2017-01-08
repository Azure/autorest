// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Perks.Async.Observable {
    using System;
    using Collections;

    public class BlockingCollectionObserver<T> : BlockingCollection<T>, IObserver<T> {
        private readonly IDisposable _subscription;

        public BlockingCollectionObserver(IObservable<T> observable) {
            _subscription = observable.Subscribe(this);
        }

        /// <summary>
        ///     Provides the observer with new data.
        /// </summary>
        /// <param name="value">The current notification information.</param>
        public void OnNext(T value) {
            Add(value);
        }

        /// <summary>
        ///     Notifies the observer that the provider has experienced an error condition.
        /// </summary>
        /// <param name="error">An object that provides additional information about the error.</param>
        public void OnError(Exception error) {
            CompleteAdding();
        }

        /// <summary>
        ///     Notifies the observer that the provider has finished sending push-based notifications.
        /// </summary>
        public void OnCompleted() {
            CompleteAdding();
        }

        /// <summary>
        ///     Releases resources used by the <see cref="T:Microsoft.Perks.Async.Collections.BlockingCollection{T}" /> instance.
        /// </summary>
        /// <param name="isDisposing">Whether being disposed explicitly (true) or due to a finalizer (false).</param>
        protected override void Dispose(bool isDisposing) {
            if (isDisposing) {
                _subscription.Dispose();
            }
            base.Dispose(isDisposing);
        }
    }
}