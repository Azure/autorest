// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest
{
    internal class Program
    {
        private static int Main(string[] args)
        {
            if(args != null && args.Length > 0 && args[0] == "--server") {
                return new AutoRestAsAsService().Run().Result;
            }

            Console.WriteLine("This is not the AutoRest entry point.");
            Console.WriteLine("Please use the 'autorest' command provided by the AutoRest npm package which points to our NodeJS based entry point.");
            return 1;
        }
    }
}