// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Diagnostics;
using System.Text.RegularExpressions;
using System.Threading;

namespace Microsoft.Rest.Generator.CSharp.Tests
{
    /// <summary>
    /// Listener for process output - displays debugging information for the service process
    /// </summary>
    public class ProcessOutputListener
    {
        public ProcessOutputListener()
        {
            EnsureDebugListeners();
            this.ProcessStarted = new ManualResetEvent(false);
        }

        public ManualResetEvent ProcessStarted { get; private set; }

        public static void EnsureDebugListeners()
        {
            if (Debug.Listeners == null || Debug.Listeners.Count < 1)
            {
                Debug.Listeners.Add(new DefaultTraceListener());
            }
        }

        public void ProcessOutput(object sendingProcess, DataReceivedEventArgs data)
        {
            ScrubAndWriteValue("SERVICE STDOUT", data.Data);
            if (data.Data!= null && data.Data.Contains("Server started"))
            {
                ProcessStarted.Set();
            }
        }

        public void ProcessError(object sendingProcess, DataReceivedEventArgs data)
        {
            ScrubAndWriteValue("SERVICE ERROR", data.Data);
        }

        private void ScrubAndWriteValue(string prefix, string data)
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