// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Diagnostics;
using System.Text.RegularExpressions;
using System.Threading;

namespace AutoRest.CSharp.Tests.Utilities
{
    /// <summary>
    /// Listener for process output - displays debugging information for the service process
    /// </summary>
    public class ProcessOutputListener
    {
        public ProcessOutputListener()
        {
            this.ProcessStarted = new ManualResetEvent(false);
        }

        public ManualResetEvent ProcessStarted { get; private set; }

        public void ProcessOutput(object sendingProcess, DataReceivedEventArgs data)
        {
            if (data == null)
            {
                throw new ArgumentNullException("data");
            }

            ScrubAndWriteValue("SERVICE STDOUT", data.Data);
            if (data.Data!= null && data.Data.Contains("Server started"))
            {
                ProcessStarted.Set();
            }
        }

        public void ProcessError(object sendingProcess, DataReceivedEventArgs data)
        {
            if (data == null)
            {
                throw new ArgumentNullException("data");
            }

            ScrubAndWriteValue("SERVICE ERROR", data.Data);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", 
            "CA1801:ReviewUnusedParameters", 
            MessageId = "prefix",
            Justification = "To avoid the warning when build under Release")]
        private static  void ScrubAndWriteValue(string prefix, string data)
        {
            if (!string.IsNullOrEmpty(data))
            {
                string scrubbed = Regex.Replace(data, @"[^\u0000-\u007F]", string.Empty);
                scrubbed = Regex.Replace(scrubbed, @"\x1b\[\d+m", " ");
                if (!string.IsNullOrWhiteSpace(scrubbed))
                {
                    Debug.WriteLine("{0}: {1}", prefix, scrubbed);
                }
            }
        }
    }
}