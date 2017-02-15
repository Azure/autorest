// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
// using System.Configuration;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using Microsoft.Extensions.Logging;
#if PORTABLE

#endif

namespace AutoRest.CSharp.Unit.Tests
{
    using System.Text.RegularExpressions;
    using System.Threading;

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
            if (data.Data != null && data.Data.Contains("Server started"))
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
        private static void ScrubAndWriteValue(string prefix, string data)
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

    /// <summary>
    /// Control creation and execution of node.js deserialization service
    /// </summary>
    public class ServiceController : IDisposable
    {
        private const string NpmCommand = "npm.cmd";
        private const string NpmArgument = "install";
        private const string NodeCommand = "node.exe";
        private const string NodeArgument = "./startup/www";

        private ProcessOutputListener _listener;

        private object _sync = new object();
        public ServiceController(int? portNumber = null)
        {
            Port = portNumber?? GetRandomPortNumber();
            EnsureService();
        }

#if PORTABLE
        private static readonly ILogger _logger;
        static ServiceController()
        {
            var factory = new LoggerFactory();
            _logger = factory.CreateLogger<ServiceController>();
            factory.AddConsole();
        }
#endif
        /// <summary>
        /// Directory containing the acceptance test files.
        /// </summary>
        private static string AcceptanceTestsPath
        {
            get {
                var serverPath = Path.Combine(Environment.GetEnvironmentVariable("AUTOREST_TEST_SERVER_PATH") ?? Directory.GetCurrentDirectory(), "server");

                if (!Directory.Exists(serverPath))
                {
                    // otherwise walk up the path till we find a folder 
                    serverPath = FindFolderByWalkingUpPath(Path.Combine("dev", "TestServer", "server"));
                    if (serverPath == null)
                    {
                        throw new Exception("Unable to find TestServerPath.\r\n");
                    }
                }

                return serverPath;
            }
        }

        public static string FindFolderByWalkingUpPath(string folderName, string currentDirectory = null)
        {
            try
            {
                currentDirectory = currentDirectory ?? System.IO.Directory.GetCurrentDirectory();
                if (!string.IsNullOrEmpty(currentDirectory))
                {
                    try
                    {
                        currentDirectory = Path.GetFullPath(currentDirectory);
                    }
                    catch
                    {
                    }

                    while (!string.IsNullOrEmpty(currentDirectory))
                    {
                        var chkPath = Path.Combine(currentDirectory, folderName);
                        if (Directory.Exists(chkPath))
                        {
                            return chkPath;
                        }
                        currentDirectory = Path.GetDirectoryName(currentDirectory);
                    }
                }
            }
            catch
            {
            }
            return null;
        }

        /// <summary>
        /// Teardown action
        /// </summary>
        public Action TearDown { get; set; }

        /// <summary>
        /// Port number the service is listening on.
        /// </summary>
        public int Port { get; set; }

        public Uri Uri => new Uri(string.Format(CultureInfo.InvariantCulture, "http://localhost:{0}", Port));

        /// <summary>
        /// The process running the service.
        /// </summary>
        private Process ServiceProcess { get; set; }

        public void Dispose()
        {
            try {
                TearDown?.Invoke();
            }
            finally
            {
                Dispose(true);
                GC.SuppressFinalize(this);
            }
        }

        protected virtual void Dispose(bool disposing)
        {
            if (disposing && ServiceProcess != null && !ServiceProcess.HasExited)
            {
                EndServiceProcess(ServiceProcess);
                ServiceProcess = null;
            }
        }

        /// <summary>
        /// Ensure that the node service is running - either create it, or track it if it is already running.
        /// </summary>
        public void EnsureService()
        {
            lock (_sync)
            {
                if (ServiceProcess == null)
                {
                    StartServiceProcess();
                }
            }
        }

        public static string GetPathToExecutable(string executableName)
        {
            var paths = Environment.GetEnvironmentVariable("PATH");
            foreach (var path in paths.Split(new[] { Path.PathSeparator }, StringSplitOptions.RemoveEmptyEntries))
            {
                var fullPath = Path.Combine(path, Path.GetFileName(executableName));
                if (File.Exists(fullPath))
                {
                    return fullPath;
                }

                var ext = Path.GetExtension(executableName);
                var exec = (ext == ".cmd" || ext == ".exe") ? Path.GetFileNameWithoutExtension(executableName) : executableName;
                fullPath = Path.Combine(path, exec);
                if (File.Exists(fullPath))
                {
                    return fullPath;
                }
            }

            return null;
        }

        private static int GetRandomPortNumber()
        {
            var rand = new Random();
            return rand.Next(3000, 3999);
        }

        public void StartServiceProcess()
        {
            var npmPath = GetPathToExecutable(NpmCommand);
            if (npmPath == null)
            {
                throw new InvalidOperationException("Could not find path to " + NpmCommand);
            }

            using (var prepareProcess = StartServiceProcess(npmPath, NpmArgument, AcceptanceTestsPath,
                    waitForServerStart: false))
            {
                // Wait for maximum of two minutes; One-time preparation.
                if (prepareProcess.WaitForExit(120000))
                {
                    var nodePath = GetPathToExecutable(NodeCommand);
                    if (nodePath == null)
                    {
                        throw new InvalidOperationException("Could not find path to " + NodeCommand);
                    }

                    ServiceProcess = StartServiceProcess(nodePath, NodeArgument, AcceptanceTestsPath);
                }
                else
                {
                    throw new InvalidOperationException(string.Format(CultureInfo.CurrentCulture,
                        "Failed to start {0} {1} '{2}'.",
                        npmPath, NpmArgument, AcceptanceTestsPath));
                }
            }
        }

        /// <summary>
        /// Run the given command with arguments. Return the result in standard output.
        /// </summary>
        /// <param name="path">The path to the command to execute.</param>
        /// <param name="arguments">The arguments to pass to the command.</param>
        /// <param name="workingDirectory">The working directory for the process being launched.</param>
        /// <param name="waitForServerStart">Wait for the service to print a start message</param>
        /// <returns>The process</returns>
        private Process StartServiceProcess(
            string path,
            string arguments,
            string workingDirectory,
            bool waitForServerStart = true)
        {
            _listener = new ProcessOutputListener();
            var process = new Process();
            var startInfo = process.StartInfo;
            startInfo.CreateNoWindow = false;
            startInfo.RedirectStandardOutput = true;
            startInfo.RedirectStandardError = true;
            startInfo.WorkingDirectory = workingDirectory;
            startInfo.UseShellExecute = false;
            startInfo.FileName = path;
            startInfo.Arguments = arguments;
            startInfo.Environment["PORT"] = Port.ToString(CultureInfo.InvariantCulture);
            process.OutputDataReceived += _listener.ProcessOutput;
            process.ErrorDataReceived += _listener.ProcessError;
            process.Start();
            process.BeginOutputReadLine();
            if (waitForServerStart)
            {
                _listener.ProcessStarted.WaitOne(TimeSpan.FromSeconds(30));
            }
            return process;
        }

        private static void EndServiceProcess(Process process)
        {
            //_logger.LogInformation("Begin killing process...");
            process.Kill();
            process.WaitForExit(2000);
            process.Dispose();
            //_logger.LogInformation("Process killed...");
        }
    }
}
