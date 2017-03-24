package petstore



// UserAgent returns the UserAgent string to use when sending http.Requests.
func UserAgent() string {
    return "Azure-SDK-For-Go/0.0.0 arm-petstore/1.0.0"
}

// Version returns the semantic version (see http://semver.org) of the client.
func Version() string {
  return "0.0.0"
}
