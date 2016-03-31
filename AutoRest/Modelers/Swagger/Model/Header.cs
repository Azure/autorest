// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using Microsoft.Rest.Generator.Logging;

namespace Microsoft.Rest.Modeler.Swagger.Model
{
    /// <summary>
    /// Swagger header object.
    /// </summary>
    [Serializable]
    public class Header : SwaggerObject
    {

        public override bool Validate(List<LogEntry> validationErrors)
        {
            var errorCount = validationErrors.Count;

            base.Validate(validationErrors);

            return validationErrors.Count == errorCount;
        }
    }
}