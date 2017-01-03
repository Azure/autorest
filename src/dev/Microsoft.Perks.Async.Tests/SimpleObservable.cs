// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Perks.Async.Tests {
    using System;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;

    public class SimpleObservable : IObservable<string> {
        private readonly List<IObserver<string>> _observers = new List<IObserver<string>>();
        private bool _done;

        public IDisposable Subscribe(IObserver<string> observer) {
            if (!_done) {
                _observers.Add(observer);
                return new OnDispose(() => _observers?.Remove(observer));
            }

            // already done.
            observer.OnCompleted();
            return new OnDispose(() => {});
        }

        public void Start() {
            if (_done) {
                return;
            }

            Task.Factory.StartNew(() => {
                for (var x = 0; x < 10; x++) {
                    Thread.Sleep(new Random().Next(200));
                    foreach (var i in _observers) {
                        try {
                            i.OnNext($"number: {x}");
                        } catch {
                        }
                    }
                }
            }).ContinueWith(a => {Finished();});
        }

        private void Finished() {
            _done = true;
            foreach (var i in _observers) {
                try {
                    i.OnCompleted();
                } catch {
                }
            }
            _observers.Clear();
        }
    }
}