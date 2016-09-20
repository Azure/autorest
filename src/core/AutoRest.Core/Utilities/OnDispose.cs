// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;

namespace AutoRest.Core.Utilities
{
    public class OnDispose : IDisposable
    {
        private Action _action;

        public OnDispose(Action action)
        {
            _action = action;
        }

        public void Dispose()
        {
            Action a;

            lock (this)
            {
                a = _action;
                _action = null;
            }

            try
            {
                a?.Invoke();
            }
            catch
            {
            }
        }
    }
}