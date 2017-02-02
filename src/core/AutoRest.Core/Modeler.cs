// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Model;
using AutoRest.Core.Validation;
using System.Collections.Generic;
using System;
using AutoRest.Core.Utilities;

namespace AutoRest.Core
{
    public abstract class Modeler
    {
        public Settings Settings => Settings.Instance;

        public abstract CodeModel Build(IFileSystem fs, string[] inputFiles);

        /// <summary>
        /// Copares two versions of the same service specification.
        /// </summary>
        /// <returns></returns>
        public abstract IEnumerable<ComparisonMessage> Compare();
    }
}
