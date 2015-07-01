// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Diagnostics;
using System.Text;
using System.Threading;

namespace Microsoft.Rest.Generator.Ruby.Tests
{
    public class ProcessSync
    {
        private Process process;
        private StringBuilder outputBuilder = new StringBuilder();
        private StringBuilder errorBuilder = new StringBuilder();
        private AutoResetEvent outputWaitHandle = new AutoResetEvent(false);
        private AutoResetEvent errorWaitHandle = new AutoResetEvent(false);

        public string Output 
        {
            get { return outputBuilder.ToString(); }
        }

        public string Error
        {
            get { return errorBuilder.ToString(); }
        }

        public string CombinedOutput
        {
            get { return Output + Error; }
        }

        public int ExitCode
        {
            get { return process.ExitCode; }
        }

        public ProcessSync(ProcessStartInfo startInfo)
        {
            process = new Process();

            startInfo.UseShellExecute = false;
            startInfo.RedirectStandardOutput = true;
            startInfo.RedirectStandardError = true;

            process.StartInfo = startInfo;
        }

        public void Start() 
        {
            process.OutputDataReceived += (sender, e) =>
            {
                if (e.Data == null)
                {
                    outputWaitHandle.Set();
                }
                else
                {
                    outputBuilder.AppendLine(e.Data);
                }
            };
            process.ErrorDataReceived += (sender, e) =>
            {
                if (e.Data == null)
                {
                    errorWaitHandle.Set();
                }
                else
                {
                    errorBuilder.AppendLine(e.Data);
                }
            };

            process.Start();

            process.BeginOutputReadLine();
            process.BeginErrorReadLine();
        }

        public bool WaitForExit(int miliseconds)
        {
            return process.WaitForExit(miliseconds) &&
                outputWaitHandle.WaitOne(miliseconds) &&
                errorWaitHandle.WaitOne(miliseconds);
        }
    }
}
