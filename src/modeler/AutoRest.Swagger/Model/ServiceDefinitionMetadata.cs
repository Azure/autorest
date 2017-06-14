// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Swagger.Model
{
    /// <summary>
    /// Describes whether a service definition has already been processed and merged.
    /// This can influence ARM validation (e.g. one would not expect an operations API 
    /// on individual OpenAPI definitions).
    /// Explanation:
    /// 'Individual' state: This is the state where the json provided is considered 
    /// in isolation and the corresponding rules are applied. This is equivalent to 
    /// running validator in the  non-CompositeSwagger mode per legacy API
    /// 'Composite' state: For a given json, the AutoRest core will find 
    /// its corresponding '.md' file and construct a ServiceDefinition object. 
    /// This will be equivalent to running AutoRest in CompositeSwagger mode per 
    /// legacy cli. 
    /// </summary>
    public enum ServiceDefinitionDocumentState
    {
        Individual,
        Composed
    }

    /// <summary>
    /// Represents Service Definition Document Type 
    /// AutoRest needs this categorization to choose document type-specific 
    /// rules for execution
    /// </summary>
    [Flags]
    public enum ServiceDefinitionDocumentType
    {
        Default = 0,   // A plain regular swagger like pet store
        ARM = 1 << 0,       // An Azure Resource Management type document
        DataPlane = 1 << 1  // Data Plane specifications
    }

    /// <summary>
    /// Metadata for service definition that describes further what it represents 
    /// (e.g. single vs. merged, ARM vs non-ARM, ...).
    /// </summary>
    public class ServiceDefinitionMetadata
    {
        public ServiceDefinitionDocumentState MergeState { get; set; }

        public ServiceDefinitionDocumentType ServiceDefinitionDocumentType { get; set; }
    }
}