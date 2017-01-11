// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using AutoRest.Core.Model;

namespace AutoRest.NodeJS.Model
{
    public class PrimaryTypeJs : Core.Model.PrimaryType
    {
        public PrimaryTypeJs(KnownPrimaryType primaryType) : base(primaryType)
        {
            Name.OnGet += v => ImplementationName;
        }

        protected PrimaryTypeJs()
        {
            Name.OnGet += v => ImplementationName;
        }

        public virtual string ImplementationName
        {
            get
            {
                switch (KnownPrimaryType)
                {
                    case KnownPrimaryType.Base64Url:
                    case KnownPrimaryType.ByteArray:
                        return "Buffer";

                    case KnownPrimaryType.Boolean:
                        return "Boolean";

                    case KnownPrimaryType.Date:
                    case KnownPrimaryType.DateTime:
                    case KnownPrimaryType.DateTimeRfc1123:
                    case KnownPrimaryType.UnixTime:
                        return "Date";

                    case KnownPrimaryType.Double:
                    case KnownPrimaryType.Decimal:
                    case KnownPrimaryType.Int:
                    case KnownPrimaryType.Long:
                        return "Number";

                    case KnownPrimaryType.Stream:
                        return "Object";

                    case KnownPrimaryType.String:
                        return "String";

                    case KnownPrimaryType.TimeSpan:
                        return "moment.duration";

                    case KnownPrimaryType.Object:
                        return "Object";

                    case KnownPrimaryType.Credentials:
                        return "credentials";

                    case KnownPrimaryType.Uuid:
                        return "Uuid";
                }
                throw new NotImplementedException($"Primary type {KnownPrimaryType} is not implemented in {GetType().Name}");
            }
        }
    }
}