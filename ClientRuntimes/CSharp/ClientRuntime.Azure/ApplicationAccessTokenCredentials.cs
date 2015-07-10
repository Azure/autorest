// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Microsoft.Azure
{
    /// <summary>
    /// Credential object for authenticating as an application, using a servicePrincipal and se cret
    /// </summary>
    public class ApplicationAccessTokenCredentials : AccessTokenCredentials
    {
        public ApplicationAccessTokenCredentials(ITokenProvider tokenProvider) : base(tokenProvider)
        {
            
        }
   }
}
