// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace Microsoft.Rest.RazorCompiler
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length == 0)
            {
                Console.WriteLine(@"Microsoft Copyright 2015
Usage: dotnet-razor <directory path> [<namespace>]");
            }
            else
            {
                var compiler = new Compiler();
                string directory = args[0];
                if (args.Length == 2)
                {
                    compiler.Namespace = args[1];
                }
                compiler.Compile(directory);
            }
        }
    }
}
