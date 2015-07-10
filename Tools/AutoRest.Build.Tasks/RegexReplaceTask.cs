// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using Microsoft.Build.Framework;
using Microsoft.Build.Utilities;

namespace Microsoft.Rest.Common.Build.Tasks
{
    /// <summary>
    /// Build task to apply RegularExpression to file[s].
    /// </summary>
    public class RegexReplaceTask : Task
    {
        /// <summary>
        /// The files to search for a match.
        /// </summary>
        [Required]
        public ITaskItem[] Files { get; set; }

        /// <summary>
        /// True/False to log Replace actions.
        /// </summary>
        public bool LogTask { get; set; }

        /// <summary>
        /// If provided, results of applying the Regex are written to the OutputDirectory.  
        /// </summary>
        public string OutputDirectory { get; set; }

        /// <summary>
        /// The regular expression pattern to match.
        /// </summary>
        [Required]
        public string Pattern { get; set; }

        /// <summary>
        /// The replacement string.
        /// </summary>
        [Required]
        public string Replacement { get; set; }

        /// <summary>
        /// Executes the Regex.Replace task.
        /// </summary>
        /// <returns>True if the task succeeded; otherwise, false.</returns>
        public override bool Execute()
        {
            try
            {
                foreach (string fileName in Files.Select(f => f.GetMetadata("FullPath")))
                {
                    FileAttributes oldAttributes = File.GetAttributes(fileName);
                    File.SetAttributes(fileName, oldAttributes & ~FileAttributes.ReadOnly);

                    string content = Regex.Replace(
                        File.ReadAllText(fileName),
                        Pattern,
                        Replacement);

                    string outputFileName = fileName;
                    string message = null;
                    if (!string.IsNullOrEmpty(OutputDirectory))
                    {
                        string path = Path.GetFullPath(OutputDirectory);
                        outputFileName = Path.Combine(path, Path.GetFileName(fileName));
                        message = " saved as " + outputFileName;
                    }

                    File.WriteAllText(outputFileName, content, Encoding.UTF8);
                    File.SetAttributes(outputFileName, oldAttributes);

                    if (LogTask)
                    {
                        Log.LogMessage("Processed regular expression replacement in file {0}{1}", fileName, message);
                    }
                }

                return true;
            }
            catch (Exception ex)
            {
                Log.LogErrorFromException(ex);
                return false;
            }
        }
    }
}