// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using Microsoft.Build.Framework;
using Microsoft.Build.Utilities;

namespace Microsoft.Rest.Common.Build.Tasks
{
    /// <summary>
    ///     A Microsoft Build task to validate the strong name signature of a .NET assembly.
    /// </summary>
    public class ValidateStrongNameSignatureTask : Task
    {
        /// <summary>
        ///     The path to the Windows SDK on the machine.
        /// </summary>
        [Required]
        public string WindowsSdkPath { get; set; }

        /// <summary>
        ///     The assembly to verify.
        /// </summary>
        [Required]
        public ITaskItem Assembly { get; set; }

        /// <summary>
        ///     The strong name token expected for validation. 
        /// </summary>
        [Required]
        public string ExpectedTokenSignature { get; set; }

        /// <summary>
        ///     Expected state of delay signing for validation. 
        /// </summary>
        public bool ExpectedDelaySigned { get; set; }

        /// <summary>
        ///     Executes the task to validate expected strong name values. 
        /// </summary>
        /// <returns>
        ///     True if validation succeeded. False if validation failed.
        /// </returns>
        public override bool Execute()
        {
            try
            {
                var utility = new StrongNameUtility();
                if (!utility.ValidateStrongNameToolExistance(WindowsSdkPath))
                {
                    Log.LogError(
                        "The strong name tool (sn.exe) could not be located within the Windows SDK directory structure ({0})).",
                        WindowsSdkPath);
                    return false;
                }

                string path = Assembly.ItemSpec;

                // Check the public key token of the assembly.
                // -q -T: Display token for public key.
                string output;
                string arguments = "-q -T \"" + path + "\"";
                bool success = utility.Execute(arguments, out output);

                if (!success)
                {
                    Log.LogError("The assembly \"" + path + "\" has not been strong named signed.");
                    Log.LogError(output);

                    return false;
                }

                // Read the public key token.
                int lastSpace = output.LastIndexOf(' ');
                if (lastSpace >= 0)
                {
                    output = output.Substring(lastSpace + 1).Trim();
                }

                if (output != ExpectedTokenSignature)
                {
                    Log.LogError(
                        "The assembly \"{0}\" had the strong name token of \"{1}\", but was expected to have the token \"{2}\"",
                        path,
                        output,
                        ExpectedTokenSignature);
                    return false;
                }

                Log.LogMessage("The assembly \"{0}\" had the expected strong name token of \"{1}\"",
                    path,
                    output);

                // Validate that it is or is not delay signed.
                // -q -v[f]: Verify <assembly> for strong name signature self 
                // consistency. If -vf is specified, force verification even if
                // disabled in the registry.
                output = null;
                arguments = "-q -vf \"" + path + "\"";
                success = utility.Execute(arguments, out output);

                success = (success == (!ExpectedDelaySigned));

                string message;
                if (ExpectedDelaySigned && success || !ExpectedDelaySigned && !success)
                {
                    message = "The assembly \"{0}\" was delay signed.";
                }
                else if (ExpectedDelaySigned && !success)
                {
                    message = "The assembly \"{0}\" was not delay signed.";
                }
                else
                {
                    message = "The assembly \"{0}\" has been fully signed.";
                }

                if (success)
                {
                    Log.LogMessage(MessageImportance.High, message, path);
                }
                else
                {
                    Log.LogError(message, path);
                }

                return success;
            }
            catch (Exception ex)
            {
                Log.LogErrorFromException(ex);
                return false;
            }
        }
    }
}