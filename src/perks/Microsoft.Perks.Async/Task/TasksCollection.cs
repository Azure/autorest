// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Perks.Async.Task {
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Linq;
    using System.Runtime.CompilerServices;
    using System.Threading.Tasks;

    public class TasksCollection {
        private ConcurrentBag<Task> _tasks = new ConcurrentBag<Task>();

        public TaskAwaiter GetAwaiter() =>
            Task.WhenAll(_tasks).GetAwaiter();

        public static TasksCollection operator +(TasksCollection tasks, Task task) {
            tasks._tasks.Add(task);
            tasks.Collect();
            return tasks;
        }

        public static TasksCollection operator +(TasksCollection tasks, IEnumerable<Task> manytasks) {
            foreach (var t in manytasks) {
                tasks._tasks.Add(t);
            }
            tasks.Collect();
            return tasks;
        }

        public static TasksCollection operator +(TasksCollection tasks, Action action) {
            tasks._tasks.Add(Task.Run(action));
            tasks.Collect();
            return tasks;
        }

        private void Collect() {
            // if there are more than 10 tasks, let's clean it up.
            if (_tasks.Count > 10) {
                // create a new bag.
                var newtasks = new ConcurrentBag<Task>();
                var oldTasks = _tasks;
                newtasks.Add(Task.Run(() => {
                    // copy items over from the old bag that are still running.
                    foreach (var t in oldTasks.Where(each => !each.IsCompleted)) {
                        newtasks.Add(t);
                    }
                }));
                // use the new bag from here on.
                _tasks = newtasks;
            }
        }
    }
}