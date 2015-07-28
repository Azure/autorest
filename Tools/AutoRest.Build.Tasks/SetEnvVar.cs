// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using Microsoft.Build.Framework;
using Microsoft.Build.Utilities;

namespace Microsoft.Rest.Common.Build.Tasks
{
    /// <summary>
    /// Build task to set environment vars in the build.
    /// </summary>
    public class SetEnvVar : Task
    {

        [Required]
        public string Variable { get; set; }

        [Required]
        public string Value { get; set; }

        public override bool Execute()
        {
            Environment.SetEnvironmentVariable(Variable, Value);
            return true;
        }
    }
}
