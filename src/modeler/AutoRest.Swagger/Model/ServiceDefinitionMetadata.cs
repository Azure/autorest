// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Utilities;
using System;
using System.Collections.Generic;

namespace AutoRest.Swagger.Model
{
    /// <summary>
    /// Describes whether a service definition has already been processed and merged.
    /// This can influence ARM validation (e.g. one would not expect an operations API on individual OpenAPI definitions).
    /// </summary>
    public enum ServiceDefinitionMergeState
    {
        Before,
        After
    }

    /// <summary>
    /// Represents categories for OpenAPI definitions that are associated with special treatment with regards to validation.
    /// </summary>
    [Flags]
    public enum ServiceDefinitionCategory
    {
        Regular = 0,
        ARM = 1 << 0
    }

    /// <summary>
    /// Metadata for service definition that describes further what it represents (e.g. single vs. merged, ARM vs non-ARM, ...).
    /// </summary>
    public class ServiceDefinitionMetadata
    {
        public ServiceDefinitionMergeState MergeState { get; set; }

        public ServiceDefinitionCategory Categories { get; set; }
    }
}