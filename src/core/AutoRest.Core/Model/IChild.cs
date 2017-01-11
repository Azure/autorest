// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using Newtonsoft.Json;

namespace AutoRest.Core.Model
{
    public interface IChild : IIdentifier
    {
        [JsonIgnore]
        IParent Parent { get; }

        void Disambiguate();
    }
}