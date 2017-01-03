// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Perks.Async.Collections {
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Runtime.CompilerServices;
    using System.Threading;
    using Perks.Linq;

    /// <summary>
    ///     An evolution of the <see cref="T:System.Collections.Concurrent.BlockingCollection{T}" /> class.
    ///     This implementation supports
    ///     - consuming enumerators that do not block
    ///     - blocking enumerators that do consume items from the collection.
    ///     - support for the <see cref="T:Microsoft.Perks.Async.IAwaitableEnumerable{T}" />
    /// </summary>
    /// <remarks>
    ///     <see cref="T:System.Collections.Concurrent.IProducerConsumerCollection{T}" /> represents a collection
    ///     that allows for thread-safe adding and removing of data.
    ///     <see cref="T:System.Collections.Concurrent.BlockingCollection{T}" /> is used as a wrapper
    ///     for an <see cref="T:System.Collections.Concurrent.IProducerConsumerCollection{T}" /> instance, allowing
    ///     removal attempts from the collection to block until data is available to be removed.  Similarly,
    ///     a <see cref="T:System.Collections.Concurrent.BlockingCollection{T}" /> can be created to enforce
    ///     an upper-bound on the number of data elements allowed in the
    ///     <see cref="T:System.Collections.Concurrent.IProducerConsumerCollection{T}" />; addition attempts to the
    ///     collection may then block until space is available to store the added items.  In this manner,
    ///     <see cref="T:System.Collections.Concurrent.BlockingCollection{T}" /> is similar to a traditional
    ///     blocking queue data structure, except that the underlying data storage mechanism is abstracted
    ///     away as an <see cref="T:System.Collections.Concurrent.IProducerConsumerCollection{T}" />.
    /// </remarks>
    /// <typeparam name="T">Specifies the type of elements in the collection.</typeparam>
    public class BlockingCollection<T> : System.Collections.Concurrent.BlockingCollection<T>, IAwaitableEnumerable<T> {
        private readonly ManualResetEventSlim _activity = new ManualResetEventSlim(false);
        private readonly object _lock = new object();
        private MutableEnumerable<T> _blockingEnumerable;
        private bool _isDisposed;
        private Action _onCompleted;

        public WaitHandle Ready =>
            _activity.WaitHandle;

        /// <summary>
        ///     Gets whether this <see cref="T:Microsoft.Perks.Async.Collections.BlockingCollection{T}" /> has any data
        ///     available.
        /// </summary>
        /// <value>Whether this collection has any data available.</value>
        public bool HasData =>
            Count > 0;

        /// <summary>
        ///     Schedules the continuation action that's invoked when the instance completes.
        /// </summary>
        /// <param name="continuation">The action to invoke when the operation completes.</param>
        /// <exception cref="T:System.ArgumentNullException">
        ///     The <paramref name="continuation" /> argument is null (Nothing in
        ///     Visual Basic).
        /// </exception>
        public void OnCompleted(Action continuation) {
            _onCompleted += continuation;
        }

        /// <summary>
        ///     Ends the wait for the completion of adding to the collection.
        /// </summary>
        /// <returns>
        ///     The result of the completed task (a reference to this <see cref="IAwaitableEnumerable{T}" /> ).
        /// </returns>
        public IAwaitableEnumerable<T> GetResult() => this;

        /// <summary>
        ///     Returns a blocking and consuming enumerator that iterates through the collection.
        /// </summary>
        /// <returns>
        ///     A blocking and consuming enumerator that can be used to iterate through the collection.
        /// </returns>
        public IEnumerator<T> GetEnumerator() =>
            GetBlockingEnumerable().GetEnumerator(); // make sure that iterating on this as enumerable is blocking.

        /// <summary>
        ///     Returns a blocking and consuming enumerator that iterates through the collection.
        /// </summary>
        /// <returns>
        ///     A blocking and consuming enumerator that can be used to iterate through the collection.
        /// </returns>
        IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();

        /// <summary>
        ///     Releases resources used by the <see cref="T:Microsoft.Perks.Async.Collections.BlockingCollection{T}" /> instance.
        /// </summary>
        /// <param name="isDisposing">Whether being disposed explicitly (true) or due to a finalizer (false).</param>
        protected override void Dispose(bool isDisposing) {
            if (!_isDisposed) {
                CompleteAdding();
                _blockingEnumerable = null;
                base.Dispose(isDisposing);
                _isDisposed = true;
            }
        }

        /// <summary>
        ///     Tracks when something modifies the collection (or the collection is completed)
        /// </summary>
        private void SetActivity() {
            // setting _activity to true allows consumers to Wait for data to show up or for the producer to complete.
            if (HasData || IsCompleted) {
                _activity.Set();
            } else {
                _activity.Reset();
            }
        }

        /// <summary>
        ///     Adds the item to the <see cref="T:Microsoft.Perks.Async.Collections.BlockingCollection{T}" />.
        /// </summary>
        /// <remarks>
        ///     Unlike the base class, this will *not* throw an exception if the collection has been completed; The item will be
        ///     discarded.
        ///     If a bounded capacity was specified when this instance of
        ///     <see cref="T:SystemMicrosoft.Perks.Async.Collections.BlockingCollection{T}" /> was initialized,
        ///     a call to Add may block until space is available to store the provided item.
        /// </remarks>
        /// <param name="item">The item to be added to the collection. The value can be a null reference.</param>
        public new void Add(T item) {
            lock (_lock) {
                if (!IsAddingCompleted) {
                    base.Add(item);
                }
            }
            SetActivity();
        }

        /// <summary>
        ///     Adds the item to the <see cref="T:Microsoft.Perks.Async.Collections.BlockingCollection{T}" />.
        /// </summary>
        /// <remarks>
        ///     Unlike the base class, this will *not* throw an exception if the collection has been completed; The item will be
        ///     discarded.
        ///     If a bounded capacity was specified when this instance of
        ///     <see cref="T:Microsoft.Perks.Async.Collections.BlockingCollection{T}" /> was initialized,
        ///     a call to Add may block until space is available to store the provided item.
        /// </remarks>
        /// <param name="item">The item to be added to the collection. The value can be a null reference.</param>
        /// <param name="cancellationToken">A cancellation token to observe.</param>
        public new void Add(T item, CancellationToken cancellationToken) {
            lock (_lock) {
                if (!IsAddingCompleted) {
                    base.Add(item, cancellationToken);
                }
            }
            SetActivity();
        }

        /// <summary>
        ///     Provides a consuming <see cref="T:System.Collections.Generics.IEnumerable{T}" /> for items in the collection.
        ///     Iterating thru the collection will remove the items from the collection.
        /// </summary>
        /// <remarks>
        ///     Unlike the base class, this will *not* block when the collection is empty.
        ///     (Think of this as a "Give me what you have" operation.)
        ///     For a blocking AND consuming iterator, see <see cref="GetBlockingEnumerable()">GetBlockingEnumerable</see>
        /// </remarks>
        /// <returns>
        ///     An <see cref="T:System.Collections.Generics.IEnumerable{T}" /> that removes and returns items from the
        ///     collection.
        /// </returns>
        public new IEnumerable<T> GetConsumingEnumerable() =>
            GetConsumingEnumerable(CancellationToken.None);

        /// <summary>
        ///     Provides a consuming <see cref="T:System.Collections.Generics.IEnumerable{T}" /> for items in the collection.
        ///     Iterating thru the collection will remove the items from the collection.
        /// </summary>
        /// <remarks>
        ///     Unlike the base class, this will *not* block when the collection is empty.
        ///     (Think of this as a "Give me what you have" operation.)
        ///     For a blocking AND consuming iterator, see <see cref="GetBlockingEnumerable()">GetBlockingEnumerable</see>
        /// </remarks>
        /// <param name="cancellationToken">
        ///     A cancellation token that can be used to stop consuming items and yielding them.
        ///     Upon cancellation, items remaining in the collection will not be removed.
        /// </param>
        /// <returns>
        ///     An <see cref="T:System.Collections.Generics.IEnumerable{T}" /> that removes and returns items from the
        ///     collection.
        /// </returns>
        public new IEnumerable<T> GetConsumingEnumerable(CancellationToken cancellationToken) {
            while (!IsCompleted && SafeTryTake(out var item, 0, cancellationToken)) {
                yield return item;
            }
        }

        /// <summary>
        ///     Safely consumes items from the collection.
        /// </summary>
        /// <param name="item">The item removed from the collection</param>
        /// <param name="time">The maximum time in milliseconds to wait for an item to consume</param>
        /// <param name="cancellationToken">a cancellation token to observe.</param>
        /// <returns>A boolean indicating the success (true) of returning an item or (false) indicating no item is available.</returns>
        private bool SafeTryTake(out T item, int time, CancellationToken cancellationToken) {
            try {
                if (!cancellationToken.IsCancellationRequested && HasData) {
                    return TryTake(out item, time, cancellationToken);
                }
            } catch {
                // if this throws, that just means that we're done. (ie, canceled)
            } finally {
                SetActivity();
            }
            item = default(T);
            return false;
        }

        /// <summary>
        ///     Provides a blocking AND consuming <see cref="T:System.Collections.Generics.IEnumerable{T}" /> for items in the
        ///     collection.
        ///     Iterating thru the collection will remove the items from the collection.
        /// </summary>
        /// <remarks>
        ///     This will remove items as they are returned, and iterating on the collection will block until the collection is
        ///     marked as complete.
        ///     (Think of this as a "Give me what you have" operation.)
        /// </remarks>
        /// <returns>
        ///     An <see cref="T:System.Collections.Generics.IEnumerable{T}" /> that removes and returns items from the
        ///     collection.
        /// </returns>
        public IEnumerable<T> GetBlockingEnumerable() =>
            GetBlockingEnumerable(CancellationToken.None);

        /// <summary>
        ///     Provides a blocking AND consuming <see cref="T:System.Collections.Generics.IEnumerable{T}" /> for items in the
        ///     collection.
        ///     Iterating thru the collection will remove the items from the collection.
        /// </summary>
        /// <remarks>
        ///     This will remove items as they are returned, and iterating on the collection will block until the collection is
        ///     marked as complete,
        ///     or the cancellation token is cancelled.
        ///     (Think of this as a "Give me what you have" operation.)
        /// </remarks>
        /// <param name="cancellationToken">
        ///     A cancellation token that can be used to stop consuming items and yielding them.
        ///     Upon cancellation, items remaining in the collection will not be removed.
        /// </param>
        /// <returns>
        ///     An <see cref="T:System.Collections.Generics.IEnumerable{T}" /> that removes and returns items from the
        ///     collection.
        /// </returns>
        public IEnumerable<T> GetBlockingEnumerable(CancellationToken cancellationToken) =>
            _blockingEnumerable ?? (_blockingEnumerable = SafeGetBlockingEnumerable(cancellationToken).ReEnumerable());

        /// <summary>
        ///     Implementation of the actual blocking enumeration of the collection
        /// </summary>
        /// <param name="cancellationToken">a cancellation token to observe.</param>
        /// <returns></returns>
        private IEnumerable<T> SafeGetBlockingEnumerable(CancellationToken cancellationToken) {
            while (!IsCompleted && !cancellationToken.IsCancellationRequested) {
                T item;
                if (SafeTryTake(out item, -1, cancellationToken)) {
                    yield return item;
                } else {
                    _activity.Wait(cancellationToken);
                }
            }
        }

        /// <summary>
        ///     Marks the collection as completed for adding.
        /// </summary>
        public new void CompleteAdding() {
            lock (_lock) {
                base.CompleteAdding();
                _onCompleted?.Invoke();
            }
            SetActivity();
        }

        /// <summary>
        ///     Returns the implementation of the <see cref="INotifyCompletion" /> interface to support the compiler's use of the
        ///     async/await keywords.
        /// </summary>
        /// <returns>The current object (which implements <see cref="INotifyCompletion" /> )</returns>
        public INotifyCompletion GetAwaiter() => this;
    }
}