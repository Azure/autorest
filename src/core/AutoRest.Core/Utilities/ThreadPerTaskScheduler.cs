// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace AutoRest.Core.Utilities
{
    public class ThreadPerTaskScheduler : TaskScheduler
    {
        /// <summary>Gets the tasks currently scheduled to this scheduler.</summary>
        /// <remarks>This will always return an empty enumerable, as tasks are launched as soon as they're queued.</remarks>
        protected override IEnumerable<Task> GetScheduledTasks()
        {
            return Enumerable.Empty<Task>();
        }

        /// <summary>Starts a new thread to process the provided task.</summary>
        /// <param name="task">The task to be executed.</param>
        protected override void QueueTask(Task task)
        {
            new Thread(() => TryExecuteTask(task))
            {
                IsBackground = true
            }.Start();
        }

        /// <summary>Runs the provided task on the current thread.</summary>
        /// <param name="task">The task to be executed.</param>
        /// <param name="taskWasPreviouslyQueued">Ignored.</param>
        /// <returns>Whether the task could be executed on the current thread.</returns>
        protected override bool TryExecuteTaskInline(Task task, bool taskWasPreviouslyQueued)
        {
            return TryExecuteTask(task);
        }
    }
}