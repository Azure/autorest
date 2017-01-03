// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Perks.Async.Observable {
    using System;

    public class ObservableAwaiter<T> : IAwaitable<ObservableAwaiter<T>>, IObserver<T>, IDisposable {
        private Action _onCompleted;
        private IDisposable _subscription;

        public ObservableAwaiter(IObservable<T> instance) {
            _subscription = instance.Subscribe(this);
        }

        public void OnCompleted(Action continuation) {
            _onCompleted += continuation;
        }

        public bool IsCompleted {get; private set;}

        public ObservableAwaiter<T> GetResult() => this;

        public void Dispose() {
            _subscription?.Dispose();
            _subscription = null;
        }

        public void OnNext(T value) {
        }

        public void OnError(Exception error) {
        }

        public void OnCompleted() {
            IsCompleted = true;
            _onCompleted?.Invoke();
        }
    }
}