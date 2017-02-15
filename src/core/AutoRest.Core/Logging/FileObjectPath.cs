// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using YamlDotNet.RepresentationModel;

namespace AutoRest.Core.Logging
{
    /// <summary>
    /// Represents a path into an object stored in a file.
    /// </summary>
    public class FileObjectPath
    {
        public FileObjectPath(Uri filePath, ObjectPath objectPath)
        {
            FilePath = filePath;
            ObjectPath = objectPath;
        }

        public Uri FilePath { get; }

        public ObjectPath ObjectPath { get; }

        // https://tools.ietf.org/id/draft-pbryan-zyp-json-ref-03.html
        public string JsonReference => $"{FilePath}#{ObjectPath.JsonPointer}";

        public string ReadablePath => $"{FilePath}#{ObjectPath.ReadablePath}";
    }
}
