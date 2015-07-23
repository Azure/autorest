// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Rest;
using Microsoft.Azure;
using Microsoft.Rest.Azure.Authentication;
using System.Collections.Generic;
using Microsoft.IdentityModel.Clients.ActiveDirectory;

namespace Microsoft.Rest.ClientRuntime.Azure.Test.Fakes
{
    public class InMemoryTokenStore : ActiveDirectoryTokenStore
    {
        private List<Tuple<string, string, string, string>> _beginAccess =
            new List<Tuple<string, string, string, string>>();
        private List<Tuple<string, string, string, string>> _endAccess =
            new List<Tuple<string, string, string, string>>();
        private List<Tuple<string, string, string, string>> _beginWrite =
            new List<Tuple<string, string, string, string>>();
        public List<Tuple<string, string, string, string>> BeginAccessNotifications { get { return _beginAccess; } }
        public List<Tuple<string, string, string, string>> EndAccessNotifications { get { return _endAccess; } }
        public List<Tuple<string, string, string, string>> BeginWriteNotifications { get { return _beginWrite; } }

        public InMemoryTokenStore()
            : base()
        {

        }
        
        public InMemoryTokenStore(TokenCache cache)
            : base(cache)
        {

        }

        protected override void BeginAccessToken(string clientId, string audience, string uniqueId, string userId)
        {
            BeginAccessNotifications.Add(
                new Tuple<string, string, string, string>(clientId, audience, uniqueId, userId)
            );
        }

        protected override void EndAccessToken(string clientId, string audience, string uniqueId, string userId)
        {
            EndAccessNotifications.Add(
                new Tuple<string, string, string, string>(clientId, audience, uniqueId, userId)
            );
        }

        protected override void BeginWriteToken(string clientId, string audience, string uniqueId, string userId)
        {
            BeginWriteNotifications.Add(
                new Tuple<string, string, string, string>(clientId, audience, uniqueId, userId)
            );
        }
    }
}
