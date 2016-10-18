.. _optionsforoperations:

Operation config
================

Methods on operations have extra parameters which can be provided in the kwargs. This is called `operation_config`.

The list of operation configuration is:

============================== ==== ====
Parameter name                 Type Role
============================== ==== ====
verify                         bool
cert                           str
timeout                        int
allow_redirects                bool
max_redirects                  int
proxies                        dict
use_env_proxies                bool whether to read proxy settings from local env vars
retries                        int  number of retries
long_running_operation_timeout int  the retry timeout in seconds for Long Running Operations. Default value is 30.
thread_daemon                  bool whether the operation polling thread is a daemon thread. Default value is true.
============================== ==== ====
