// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

namespace Microsoft.Rest.CSharp.Compiler.Compilation
{
    internal static class ResultReasons
    {
        public const string CanceledError = "General.Canceled";
        public const string TimedOutError = "General.TimedOut";
        public const string UnknownError = "General.UnknownError";
        public const string Failed = "General.Failed";

        public static class Compilation
        {
            public const string Failed = ResultReasons.Failed;
        }

        public static class Execution
        {
            public const string MaximumOutput = "Executor.MaxOutput";
            public const string Failed = ResultReasons.Failed;
            public const string MaximumCpuError = "Executor.MaxCPU";
            public const string Terminated = "Executor.Terminated";
        }
    }
}