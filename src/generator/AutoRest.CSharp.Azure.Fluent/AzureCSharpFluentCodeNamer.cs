// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.ClientModel;
using AutoRest.Extensions;
using AutoRest.Extensions.Azure;

namespace AutoRest.CSharp.Azure.Fluent
{
    public class AzureCSharpFluentCodeNamer : AzureCSharpCodeNamer
    {
        public AzureCSharpFluentCodeNamer(Settings settings)
            :base(settings)
        {
        }
    }
}
