// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Perks.Async.Observable {
    using System.Threading;

    public class WaitableBoolean {
        private readonly ManualResetEventSlim _false = new ManualResetEventSlim(true);
        private readonly CancellationTokenSource _token;
        private readonly ManualResetEventSlim _true = new ManualResetEventSlim(false);

        public WaitableBoolean(bool initialState) : this(initialState, CancellationToken.None) {
        }

        public WaitableBoolean(bool initialState, CancellationToken token) {
            _token = CancellationTokenSource.CreateLinkedTokenSource(token);

            if (initialState) {
                Set();
            } else {
                Reset();
            }
        }

        public bool IsSet => _true.IsSet;
        public bool IsReset => _false.IsSet;

        public void Set() {
            if (!_token.IsCancellationRequested) {
                _false.Reset();
                _true.Set();
            }
        }

        public void Reset() {
            if (!_token.IsCancellationRequested) {
                _true.Reset();
                _false.Set();
            }
        }

        public void Complete() {
            _token.Cancel();
        }

        public bool WaitSet() {
            try {
                _true.Wait(_token.Token);
                return _true.IsSet;
            } catch {
                // cancelled?
            }
            return false;
        }

        public bool WaitReset() {
            try {
                _false.Wait(_token.Token);
                return _false.IsSet;
            } catch {
                // cancelled?
            }
            return false;
        }
    }
}