package petstore


import (
    "bytes"
    "fmt"
    "strings"
)

const (
    major = "0"
    minor = "0"
    patch = "0"
    tag   = ""
    userAgentFormat = "Azure-SDK-For-Go/%s arm-%s/%s"
)
// cached results of UserAgent and Version to prevent repeated operations.
var (
    userAgent string
    version string
)

// UserAgent returns the UserAgent string to use when sending http.Requests.
func UserAgent() string {
    if userAgent == "" {
        userAgent = fmt.Sprintf(userAgentFormat, Version(), "petstore", "1.0.0")
    }
    return userAgent
}

// Version returns the semantic version (see http://semver.org) of the client.
func Version() string {
    if version == "" {
        versionBuilder := bytes.NewBufferString(fmt.Sprintf("%d.%d.%d", major, minor, patch))
        if tag != "" {
            versionBuilder.WriteRune('-')
            versionBuilder.WriteString(strings.TrimPrefix(tag, "-"))
        }
        version = string(versionBuilder.Bytes())
    }
    return version
}
