// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace Microsoft.Rest.CSharp.Compiler.Compilation
{
    public abstract class Compiler
    {
        /// <summary>
        ///     Default maximum compilation time
        /// </summary>
        public const int DefaultTimeout = 5000; //5s

        protected Compiler(Language language, IEnumerable<KeyValuePair<string, string>> sources)
        {
            Language = language;
            Parameters = new Dictionary<string, string>(StringComparer.Ordinal);
            Sources = sources ?? new Dictionary<string, string>();
            Timeout = DefaultTimeout;
        }

        /// <summary>
        ///     Supported language
        /// </summary>
        public Language Language { get; }

        /// <summary>
        ///     Named parameters used by compiler,  as appropriate
        /// </summary>
        public IDictionary<string, string> Parameters { get; }

        /// <summary>
        ///     Source code
        /// </summary>
        public IEnumerable<KeyValuePair<string, string>> Sources { get; }

        /// <summary>
        ///     Compilation timeout (in ms)
        /// </summary>
        /// <remarks>
        ///     This value represents the maximum time a compilation session can take
        ///     before being terminated.
        /// </remarks>
        public int Timeout { get; set; }

        public async Task<CompilationResult> Compile(OutputKind outputKind, string outputName = null)
        {
            var cancellationTokenSource = new CancellationTokenSource();

            try
            {
                var task = InnerCompile(outputKind, outputName, cancellationTokenSource.Token);
                cancellationTokenSource.CancelAfter(Timeout);
                return await task.ConfigureAwait(false);
            }
            catch (OperationCanceledException ocex)
            {
                if (cancellationTokenSource.IsCancellationRequested)
                {
                    // Trace.TraceInformation("{0}:InnerCompile timed-out.", GetType().Name);
                    return new CompilationResult
                    {
                        Succeeded = false,
                        Reason = ResultReasons.TimedOutError,
                        // Messages = new[] {"Maximum compilation time reached"},
                        OutputKind = outputKind
                    };
                }
                else
                {
                    // Trace.TraceWarning("{0}:InnerCompile was unexpectedly canceled. Exception: {1}", GetType().Name, ocex);
                    return new CompilationResult
                    {
                        Succeeded = false,
                        Reason = ResultReasons.CanceledError,
                        // Messages = new[] {"Compilation was canceled"},
                        OutputKind = outputKind
                    };
                }
            }
            catch (Exception ex)
            {
                // Trace.TraceError("{0}:InnerCompile failed. Exception: {1}", GetType().Name, ex);
                return new CompilationResult
                {
                    Succeeded = false,
                    Reason = ResultReasons.UnknownError,
                    // Errors = new[] {"Unknown error"},
                    OutputKind = outputKind
                };
            }
            finally
            {
                cancellationTokenSource.Dispose();
            }
        }

        protected abstract Task<CompilationResult> InnerCompile(OutputKind outputKind, string outputName,
            CancellationToken cancellationToken);
    }
}