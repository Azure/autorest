// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Collections.Generic;
using Newtonsoft.Json;

namespace AutoRest.Core.Model
{
    public interface IIdentifier
    {
        [JsonIgnore]
        HashSet<string> LocallyUsedNames { get; }

        /// <summary>
        ///     Returns the list of names that this element is reserving
        ///     (most of the time, this is just 'this.Name' )
        /// </summary>
        [JsonIgnore]
        IEnumerable<string> MyReservedNames { get; }

        /// <summary>
        ///     The text to use for the type of this identifier when qualifying it further
        ///     (ie, 'Model', 'Property', 'Operations' ...)
        /// </summary>
        [JsonIgnore]
        string Qualifier { get; }

        /// <summary>
        ///     The natural language type of this Identifier
        ///     (ie "Client Name" , "Client Operation" ...etc)
        /// </summary>
        [JsonIgnore]
        string QualifierType { get; }
    }
}