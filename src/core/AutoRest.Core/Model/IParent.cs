// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Collections.Generic;
using Newtonsoft.Json;

namespace AutoRest.Core.Model
{
    public interface IParent
    {
        [JsonIgnore]
        IEnumerable<IChild> Children { get; }

        /// <summary>
        ///     Reference to the container of this type.
        /// </summary>
        [JsonIgnore]
        CodeModel CodeModel { get; }

        /// <summary>
        ///     Returns the list of IIdentifiers that are used in this scope
        ///     and in any parent's scope.
        /// </summary>
        [JsonIgnore]
        IEnumerable<IIdentifier> IdentifiersInScope { get; }
    }
}