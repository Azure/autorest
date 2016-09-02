.. _optionsforoperations:

Operation config
================

Methods on operations have extra parameters which can be provided in the kwargs. This is called `operation_config`.

The list of operation configuration is:

=============== ==== ====
Parameter name  Type Role
=============== ==== ====
verify          bool
cert            str
timeout         int
allow_redirects bool
max_redirects   int
proxies         dict
use_env_proxies bool whether to read proxy settings from local env vars
retries         int  number of retries
=============== ==== ====
