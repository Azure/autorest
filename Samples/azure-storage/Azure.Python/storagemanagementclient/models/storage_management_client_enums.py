# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from enum import Enum


class Reason(Enum):

    account_name_invalid = "AccountNameInvalid"
    already_exists = "AlreadyExists"


class AccountType(Enum):

    standard_lrs = "Standard_LRS"
    standard_zrs = "Standard_ZRS"
    standard_grs = "Standard_GRS"
    standard_ragrs = "Standard_RAGRS"
    premium_lrs = "Premium_LRS"


class ProvisioningState(Enum):

    creating = "Creating"
    resolving_dns = "ResolvingDNS"
    succeeded = "Succeeded"


class AccountStatus(Enum):

    available = "Available"
    unavailable = "Unavailable"


class UsageUnit(Enum):

    count = "Count"
    bytes = "Bytes"
    seconds = "Seconds"
    percent = "Percent"
    counts_per_second = "CountsPerSecond"
    bytes_per_second = "BytesPerSecond"
