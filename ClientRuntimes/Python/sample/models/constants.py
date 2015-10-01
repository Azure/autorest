


class PoolState(object):
    invalid = "Invalid"
    active = "Active"
    deleting = "Deleting"
    upgrading = "Upgrading"
    unmapped = "Unmapped"

class AllocationState(object):
    invalid = "Invalid"
    steady = "Steady"
    resizing = "Resizing"
    stopping = "Stopping"
    unmapped = "Unmapped"

class CertificateState(object):
    invalid = "Invalid"
    active = "Active"
    deleting = "Deleting"
    delete_failed = "DeleteFailed"
    unmapped = "Unmapped"

class CertificateFormat(object):
    pfx = "Pfx"
    cer = "Cer"
    unmapped = "Unmapped"