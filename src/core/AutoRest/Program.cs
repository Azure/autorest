// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest
{
    internal class Program
    {
        private static int Main(string[] args)
        {
            if (args[0] == "--server")
            {
                return new AutoRestAsAsService().Run().Result;
            }
            throw new ArgumentException("run me with --server");
        }
    }
}