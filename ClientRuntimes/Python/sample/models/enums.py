
from enum import Enum


class PoolState(Enum):

    invalid = "invalid"
    active = "active"
    deleting = "deleting"
    upgrading = "upgrading"
    unmapped = "unmapped"


class AllocationState(Enum):

    invalid = "invalid"
    steady = "steady"
    resizing = "resizing"
    stopping = "stopping"
    unmapped = "unmapped"


class CertificateState(Enum):

    invalid = "invalid"
    active = "active"
    deleting = "deleting"
    delete_failed = "deleteFailed"
    unmapped = "unmapped"


class CertificateFormat(Enum):

    pfx = "Pfx"
    cer = "Cer"
    unmapped = "Unmapped"