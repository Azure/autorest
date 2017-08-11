// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Logging;
using AutoRest.Core.Utilities;
using AutoRest.Properties;
using AutoRest.Simplify;
using static AutoRest.Core.Utilities.DependencyInjection;
using System.IO;
using AutoRest.Core.Parsing;
using YamlDotNet.RepresentationModel;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace AutoRest
{
    internal class Program
    {
        private static int Main(string[] args)
        {
            if(args != null && args.Length > 0)
            {
                switch (args[0])
                {
                    case "--server": return new AutoRestAsAsService().Run().Result;
                    case "--test": return new AutoRestAsAsService().Run(File.OpenRead(args[1])).Result;
                }
            }

            Console.WriteLine("This is not the AutoRest entry point.");
            Console.WriteLine("Please use the 'autorest' command provided by the AutoRest npm package which points to our NodeJS based entry point.");
            return 1;
        }
    }
}