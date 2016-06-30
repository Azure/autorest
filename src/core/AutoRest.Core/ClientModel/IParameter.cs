// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;

namespace AutoRest.Core.ClientModel
{
    public interface IParameter : ICloneable
    {
        CollectionFormat CollectionFormat { get; set; }
        Dictionary<Constraint, string> Constraints { get; }
        string DefaultValue { get; set; }
        string Documentation { get; set; }
        Dictionary<string, object> Extensions { get; }
        bool IsConstant { get; set; }
        bool IsRequired { get; set; }
        string Name { get; set; }
        string SerializedName { get; set; }
        IType Type { get; set; }
    }
}