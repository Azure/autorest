// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core.Model;
using AutoRest.CSharp.Model;

namespace AutoRest.CSharp.Azure.Model
{
    public class PrimaryTypeCsa : PrimaryTypeCs
    {
        protected PrimaryTypeCsa(KnownPrimaryType primaryType) : base(primaryType)
        {
        }

        protected PrimaryTypeCsa()
        {
        }

        public override string ImplementationName
        {
            get
            {
                switch (KnownPrimaryType)
                {
                    case KnownPrimaryType.Credentials:
                        return "Microsoft.Rest.ServiceClientCredentials";
                    default:
                        return base.ImplementationName;
                }
            }
        }
    }
}