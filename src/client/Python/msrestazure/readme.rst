AutoRest: Python Client Runtime - Azure Module
===============================================


Installation
------------

To install:

.. code-block:: bash

    $ pip install msrestazure


Release History
---------------

2016-10-17 Version 0.4.4
++++++++++++++++++++++++

**Bugfixes**

- More informative and well-formed CloudError exceptions (https://github.com/Azure/autorest/issues/1460)
- Raise CustomException is defined in Swagger (https://github.com/Azure/autorest/issues/1404)

2016-09-14 Version 0.4.3
++++++++++++++++++++++++

**Bugfixes**

- Make AzureOperationPoller thread as daemon (do not block anymore a Ctrl+C) (https://github.com/Azure/autorest/pull/1379)

2016-09-01 Version 0.4.2
++++++++++++++++++++++++

**Bugfixes**

- Better exception message (https://github.com/Azure/autorest/pull/1300)

This version needs msrest >= 0.4.3

2016-06-08 Version 0.4.1
++++++++++++++++++++++++

**Bugfixes**

- Fix for LRO PUT operation https://github.com/Azure/autorest/issues/1133

2016-05-25 Version 0.4.0
++++++++++++++++++++++++

Update msrest dependency to 0.4.0

**Bugfixes**

- Fix for several AAD issues https://github.com/Azure/autorest/issues/1055
- Fix for LRO PATCH bug and refactor https://github.com/Azure/autorest/issues/993

**Behaviour changes**

- Needs Autorest > 0.17.0 Nightly 20160525


2016-04-26 Version 0.3.0
++++++++++++++++++++++++

Update msrest dependency to 0.3.0

**Bugfixes**

- Read only values are no longer in __init__ or sent to the server (https://github.com/Azure/autorest/pull/959)
- Useless kwarg removed

**Behaviour changes**

- Needs Autorest > 0.16.0 Nightly 20160426


2016-03-31 Version 0.2.1
++++++++++++++++++++++++

**Bugfixes**

- Fix AzurePollerOperation if Swagger defines provisioning status as enum type (https://github.com/Azure/autorest/pull/892)


2016-03-25 Version 0.2.0
++++++++++++++++++++++++

Update msrest dependency to 0.2.0

**Behaviour change**

- async methods called with raw=True don't return anymore AzureOperationPoller but ClientRawResponse
- Needs Autorest > 0.16.0 Nightly 20160324


2016-03-21 Version 0.1.2
++++++++++++++++++++++++

Update msrest dependency to 0.1.3

**Bugfixes**

- AzureOperationPoller.wait() failed to raise exception if query error (https://github.com/Azure/autorest/pull/856)


2016-03-04 Version 0.1.1
++++++++++++++++++++++++

**Bugfixes**

- Source package corrupted in Pypi (https://github.com/Azure/autorest/issues/799)

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
