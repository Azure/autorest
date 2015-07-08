using System;
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Rest;

namespace Microsoft.Azure
{
    public class TokenCredentials : ServiceClientCredentials
    {
        protected ITokenProvider TokenProvider { get; set; }
    }
}
