// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.IO;

namespace AutoRest.Core.Utilities
{
    public interface IFileSystem
    {
        void WriteAllText(string path, string contents);

        string ReadAllText(string path);

        TextWriter GetTextWriter(string path);

        bool FileExists(string path);

        bool DirectoryExists(string path);

        void CreateDirectory(string path);

        string[] GetDirectories(string startDirectory, string filePattern, SearchOption options);

        string[] GetFiles(string startDirectory, string filePattern, SearchOption options);

        Uri GetParentDir(string path);

        bool IsCompletePath(string path);

        string MakePathRooted(Uri rootPath, string relativePath);
    }
}