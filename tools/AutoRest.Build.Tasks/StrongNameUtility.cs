// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Diagnostics;
using System.IO;
using System.Linq;

namespace Microsoft.Rest.Common.Build.Tasks
{
    /// <summary>
    ///     Utility class for managing the Process used to work with the sn.exe
    ///     tool in the Windows SDK.
    /// </summary>
    internal class StrongNameUtility
    {
        /// <summary>
        /// Path to sn.exe.
        /// </summary>
        private string _snPath;

        /// <summary>
        /// Recursively search for a file.
        /// </summary>
        /// <param name="path"></param>
        /// <param name="fileToFind"></param>
        /// <returns>File, if found; otherwise, null.</returns>
        private static string FindFile(string path, string fileToFind)
        {
            foreach (string d in Directory.GetDirectories(path))
            {
                string result = Directory.GetFiles(d, fileToFind).FirstOrDefault();
                if (result != null)
                {
                    return result;
                }

                return FindFile(d, fileToFind);
            }
            return null;
        }

        /// <summary>
        /// Execute StrongName Verification.
        /// </summary>
        /// <param name="arguments"></param>
        /// <param name="output"></param>
        /// <returns>0 for success, 1 for error.</returns>
        public bool Execute(string arguments, out string output)
        {
            int exitCode;
            output = null;

            var processInfo = new ProcessStartInfo(_snPath)
            {
                Arguments = arguments,
                UseShellExecute = false,
                RedirectStandardOutput = true,
            };

            using (Process process = Process.Start(processInfo))
            {
                output = process.StandardOutput.ReadToEnd();
                process.WaitForExit();

                exitCode = process.ExitCode;
            }
            return exitCode == 0;
        }

        /// <summary>
        /// Validates StrongName signature on a file.
        /// </summary>
        /// <param name="sdkPath"></param>
        /// <returns></returns>
        public bool ValidateStrongNameToolExistance(string sdkPath)
        {
            // Location the .NET strong name signing utility
            _snPath = FindFile(sdkPath, "sn.exe");
            if (_snPath == null)
            {
                return false;
            }
            return true;
        }
    }
}