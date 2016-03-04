AutoRest: Python Client Runtime - Azure Module
===============================================


Installation
------------

To install:

.. code-block:: bash

    $ pip install msrestazure


Release History
---------------

2016-03-04 Version 0.1.0
++++++++++++++++++++++++

**Behaviour change**

- Replaced _required attribute in CloudErrorData class with _validation dict.

2016-02-29 Version 0.0.2
++++++++++++++++++++++++

**Bugfixes**

- Fixed AAD bug to include connection verification in UserPassCredentials. (https://github.com/Azure/autorest/pull/725)
- Source package corrupted in Pypi (https://github.com/Azure/autorest/issues/718)

2016-02-19 Version 0.0.1
++++++++++++++++++++++++

- Initial release.
