
from enum import Enum


class PoolState(Enum):

    invalid = "Invalid"
    active = "Active"
    deleting = "Deleting"
    upgrading = "Upgrading"
    unmapped = "Unmapped"


class AllocationState(Enum):

    invalid = "Invalid"
    steady = "Steady"
    resizing = "Resizing"
    stopping = "Stopping"
    unmapped = "Unmapped"


class CertificateState(Enum):

    invalid = "Invalid"
    active = "Active"
    deleting = "Deleting"
    delete_failed = "DeleteFailed"
    unmapped = "Unmapped"


class CertificateFormat(Enum):

    pfx = "Pfx"
    cer = "Cer"
    unmapped = "Unmapped"