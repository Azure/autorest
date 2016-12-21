// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core;
using AutoRest.Core.Model;

namespace AutoRest.Extensions.Azure.Tests
{
    public class SampleAzureCodeNamer : CodeNamer
    {
        public SampleAzureCodeNamer()
        {
        }

        public override string EscapeDefaultValue(string defaultValue, IModelType type)
        {
            return defaultValue;
        }
    }
}
