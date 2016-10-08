// Package Petstore implements the Azure ARM Petstore service API version
// 1.0.0.
// 
// This is a sample server Petstore server.  You can find out more about
// Swagger at http://swagger.io (http://swagger.io)
package Petstore


import (
    "github.com/Azure/go-autorest/autorest"
    "github.com/Azure/go-autorest/autorest/azure"
    "github.com/Azure/go-autorest/autorest/validation"
    "io"
    "net/http"
)

const (
    // APIVersion is the version of the Petstore
    APIVersion = "1.0.0"

    // DefaultBaseURI is the default URI used for the service Petstore
    DefaultBaseURI = "http://petstore.swagger.io/v2"
)

// ManagementClient is the base client for Petstore.
type ManagementClient struct {
    autorest.Client
    BaseURI string
    APIVersion string
}

// New creates an instance of the ManagementClient client.
func New()ManagementClient {
    return NewWithBaseURI(DefaultBaseURI, )
}

// NewWithBaseURI creates an instance of the ManagementClient client.
func NewWithBaseURI(baseURI string, ) ManagementClient {
   return ManagementClient{
        Client: autorest.NewClientWithUserAgent(UserAgent()),
        BaseURI: baseURI,
        APIVersion: APIVersion,
    }
}

// AddPet adds a new pet to the store. You may receive an HTTP invalid input
// if your pet is invalid.
//
// body is pet object that needs to be added to the store
func (client ManagementClient) AddPet(body *Pet) (result autorest.Response, err error) {
    if err := validation.Validate([]validation.Validation{
         { TargetValue: body,
          Constraints: []validation.Constraint{	{Target: "body", Name: validation.Null, Rule: false ,
         Chain: []validation.Constraint{	{Target: "body.Name", Name: validation.Null, Rule: true, Chain: nil },
         	{Target: "body.PhotoUrls", Name: validation.Null, Rule: true, Chain: nil },
         }}}}}); err != nil {
             return result, validation.NewErrorWithValidationError(err, "Petstore.ManagementClient","AddPet")
    }

    req, err := client.AddPetPreparer(body)
    if err != nil {
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "AddPet", nil , "Failure preparing request")
    }

    resp, err := client.AddPetSender(req)
    if err != nil {
        result.Response = resp
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "AddPet", resp, "Failure sending request")
    }

    result, err = client.AddPetResponder(resp)
    if err != nil {
        err = autorest.NewErrorWithError(err, "Petstore.ManagementClient", "AddPet", resp, "Failure responding to request")
    }

    return
}

// AddPetPreparer prepares the AddPet request.
func (client ManagementClient) AddPetPreparer(body *Pet) (*http.Request, error) {
    preparer := autorest.CreatePreparer(
                        autorest.AsJSON(),
                        autorest.AsPost(),
                        autorest.WithBaseURL(client.BaseURI),
                        autorest.WithPath("/pet"))
    if body != nil {
        preparer = autorest.DecoratePreparer(preparer,
                            autorest.WithJSON(body))
    }
    return preparer.Prepare(&http.Request{})
}

// AddPetSender sends the AddPet request. The method will close the
// http.Response Body if it receives an error.
func (client ManagementClient) AddPetSender(req *http.Request) (*http.Response, error) {
    return autorest.SendWithSender(client, req)
}

// AddPetResponder handles the response to the AddPet request. The method always
// closes the http.Response Body.
func (client ManagementClient) AddPetResponder(resp *http.Response) (result autorest.Response, err error) { 
    err = autorest.Respond(
            resp,
            client.ByInspecting(),
            azure.WithErrorUnlessStatusCode(http.StatusOK,http.StatusMethodNotAllowed),
            autorest.ByClosing())
    result.Response = resp
    return
}

// AddPetUsingByteArray sends the add pet using byte array request.
//
// body is pet object in the form of byte array
func (client ManagementClient) AddPetUsingByteArray(body string) (result autorest.Response, err error) {
    req, err := client.AddPetUsingByteArrayPreparer(body)
    if err != nil {
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "AddPetUsingByteArray", nil , "Failure preparing request")
    }

    resp, err := client.AddPetUsingByteArraySender(req)
    if err != nil {
        result.Response = resp
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "AddPetUsingByteArray", resp, "Failure sending request")
    }

    result, err = client.AddPetUsingByteArrayResponder(resp)
    if err != nil {
        err = autorest.NewErrorWithError(err, "Petstore.ManagementClient", "AddPetUsingByteArray", resp, "Failure responding to request")
    }

    return
}

// AddPetUsingByteArrayPreparer prepares the AddPetUsingByteArray request.
func (client ManagementClient) AddPetUsingByteArrayPreparer(body string) (*http.Request, error) {
    preparer := autorest.CreatePreparer(
                        autorest.AsJSON(),
                        autorest.AsPost(),
                        autorest.WithBaseURL(client.BaseURI),
                        autorest.WithPath("/pet"))
    if len(body) > 0 {
        preparer = autorest.DecoratePreparer(preparer,
                            autorest.WithJSON(body))
    }
    return preparer.Prepare(&http.Request{})
}

// AddPetUsingByteArraySender sends the AddPetUsingByteArray request. The method will close the
// http.Response Body if it receives an error.
func (client ManagementClient) AddPetUsingByteArraySender(req *http.Request) (*http.Response, error) {
    return autorest.SendWithSender(client, req)
}

// AddPetUsingByteArrayResponder handles the response to the AddPetUsingByteArray request. The method always
// closes the http.Response Body.
func (client ManagementClient) AddPetUsingByteArrayResponder(resp *http.Response) (result autorest.Response, err error) { 
    err = autorest.Respond(
            resp,
            client.ByInspecting(),
            azure.WithErrorUnlessStatusCode(http.StatusOK,http.StatusMethodNotAllowed),
            autorest.ByClosing())
    result.Response = resp
    return
}

// CreateUser this can only be done by the logged in user.
//
// body is created user object
func (client ManagementClient) CreateUser(body *User) (result autorest.Response, err error) {
    req, err := client.CreateUserPreparer(body)
    if err != nil {
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "CreateUser", nil , "Failure preparing request")
    }

    resp, err := client.CreateUserSender(req)
    if err != nil {
        result.Response = resp
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "CreateUser", resp, "Failure sending request")
    }

    result, err = client.CreateUserResponder(resp)
    if err != nil {
        err = autorest.NewErrorWithError(err, "Petstore.ManagementClient", "CreateUser", resp, "Failure responding to request")
    }

    return
}

// CreateUserPreparer prepares the CreateUser request.
func (client ManagementClient) CreateUserPreparer(body *User) (*http.Request, error) {
    preparer := autorest.CreatePreparer(
                        autorest.AsJSON(),
                        autorest.AsPost(),
                        autorest.WithBaseURL(client.BaseURI),
                        autorest.WithPath("/user"))
    if body != nil {
        preparer = autorest.DecoratePreparer(preparer,
                            autorest.WithJSON(body))
    }
    return preparer.Prepare(&http.Request{})
}

// CreateUserSender sends the CreateUser request. The method will close the
// http.Response Body if it receives an error.
func (client ManagementClient) CreateUserSender(req *http.Request) (*http.Response, error) {
    return autorest.SendWithSender(client, req)
}

// CreateUserResponder handles the response to the CreateUser request. The method always
// closes the http.Response Body.
func (client ManagementClient) CreateUserResponder(resp *http.Response) (result autorest.Response, err error) { 
    err = autorest.Respond(
            resp,
            client.ByInspecting(),
            azure.WithErrorUnlessStatusCode(http.StatusOK),
            autorest.ByClosing())
    result.Response = resp
    return
}

// CreateUsersWithArrayInput sends the create users with array input request.
//
// body is list of user object
func (client ManagementClient) CreateUsersWithArrayInput(body []User) (result autorest.Response, err error) {
    req, err := client.CreateUsersWithArrayInputPreparer(body)
    if err != nil {
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "CreateUsersWithArrayInput", nil , "Failure preparing request")
    }

    resp, err := client.CreateUsersWithArrayInputSender(req)
    if err != nil {
        result.Response = resp
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "CreateUsersWithArrayInput", resp, "Failure sending request")
    }

    result, err = client.CreateUsersWithArrayInputResponder(resp)
    if err != nil {
        err = autorest.NewErrorWithError(err, "Petstore.ManagementClient", "CreateUsersWithArrayInput", resp, "Failure responding to request")
    }

    return
}

// CreateUsersWithArrayInputPreparer prepares the CreateUsersWithArrayInput request.
func (client ManagementClient) CreateUsersWithArrayInputPreparer(body []User) (*http.Request, error) {
    preparer := autorest.CreatePreparer(
                        autorest.AsJSON(),
                        autorest.AsPost(),
                        autorest.WithBaseURL(client.BaseURI),
                        autorest.WithPath("/user/createWithArray"))
    if body != nil && len(body) > 0 {
        preparer = autorest.DecoratePreparer(preparer,
                            autorest.WithJSON(body))
    }
    return preparer.Prepare(&http.Request{})
}

// CreateUsersWithArrayInputSender sends the CreateUsersWithArrayInput request. The method will close the
// http.Response Body if it receives an error.
func (client ManagementClient) CreateUsersWithArrayInputSender(req *http.Request) (*http.Response, error) {
    return autorest.SendWithSender(client, req)
}

// CreateUsersWithArrayInputResponder handles the response to the CreateUsersWithArrayInput request. The method always
// closes the http.Response Body.
func (client ManagementClient) CreateUsersWithArrayInputResponder(resp *http.Response) (result autorest.Response, err error) { 
    err = autorest.Respond(
            resp,
            client.ByInspecting(),
            azure.WithErrorUnlessStatusCode(http.StatusOK),
            autorest.ByClosing())
    result.Response = resp
    return
}

// CreateUsersWithListInput sends the create users with list input request.
//
// body is list of user object
func (client ManagementClient) CreateUsersWithListInput(body []User) (result autorest.Response, err error) {
    req, err := client.CreateUsersWithListInputPreparer(body)
    if err != nil {
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "CreateUsersWithListInput", nil , "Failure preparing request")
    }

    resp, err := client.CreateUsersWithListInputSender(req)
    if err != nil {
        result.Response = resp
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "CreateUsersWithListInput", resp, "Failure sending request")
    }

    result, err = client.CreateUsersWithListInputResponder(resp)
    if err != nil {
        err = autorest.NewErrorWithError(err, "Petstore.ManagementClient", "CreateUsersWithListInput", resp, "Failure responding to request")
    }

    return
}

// CreateUsersWithListInputPreparer prepares the CreateUsersWithListInput request.
func (client ManagementClient) CreateUsersWithListInputPreparer(body []User) (*http.Request, error) {
    preparer := autorest.CreatePreparer(
                        autorest.AsJSON(),
                        autorest.AsPost(),
                        autorest.WithBaseURL(client.BaseURI),
                        autorest.WithPath("/user/createWithList"))
    if body != nil && len(body) > 0 {
        preparer = autorest.DecoratePreparer(preparer,
                            autorest.WithJSON(body))
    }
    return preparer.Prepare(&http.Request{})
}

// CreateUsersWithListInputSender sends the CreateUsersWithListInput request. The method will close the
// http.Response Body if it receives an error.
func (client ManagementClient) CreateUsersWithListInputSender(req *http.Request) (*http.Response, error) {
    return autorest.SendWithSender(client, req)
}

// CreateUsersWithListInputResponder handles the response to the CreateUsersWithListInput request. The method always
// closes the http.Response Body.
func (client ManagementClient) CreateUsersWithListInputResponder(resp *http.Response) (result autorest.Response, err error) { 
    err = autorest.Respond(
            resp,
            client.ByInspecting(),
            azure.WithErrorUnlessStatusCode(http.StatusOK),
            autorest.ByClosing())
    result.Response = resp
    return
}

// DeleteOrder for valid response try integer IDs with value < 1000. Anything
// above 1000 or nonintegers will generate API errors
//
// orderID is iD of the order that needs to be deleted
func (client ManagementClient) DeleteOrder(orderID string) (result autorest.Response, err error) {
    req, err := client.DeleteOrderPreparer(orderID)
    if err != nil {
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "DeleteOrder", nil , "Failure preparing request")
    }

    resp, err := client.DeleteOrderSender(req)
    if err != nil {
        result.Response = resp
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "DeleteOrder", resp, "Failure sending request")
    }

    result, err = client.DeleteOrderResponder(resp)
    if err != nil {
        err = autorest.NewErrorWithError(err, "Petstore.ManagementClient", "DeleteOrder", resp, "Failure responding to request")
    }

    return
}

// DeleteOrderPreparer prepares the DeleteOrder request.
func (client ManagementClient) DeleteOrderPreparer(orderID string) (*http.Request, error) {
    pathParameters := map[string]interface{} {
    "orderId": autorest.Encode("path",orderID),
    }

    preparer := autorest.CreatePreparer(
                        autorest.AsDelete(),
                        autorest.WithBaseURL(client.BaseURI),
                        autorest.WithPathParameters("/store/order/{orderId}",pathParameters))
    return preparer.Prepare(&http.Request{})
}

// DeleteOrderSender sends the DeleteOrder request. The method will close the
// http.Response Body if it receives an error.
func (client ManagementClient) DeleteOrderSender(req *http.Request) (*http.Response, error) {
    return autorest.SendWithSender(client, req)
}

// DeleteOrderResponder handles the response to the DeleteOrder request. The method always
// closes the http.Response Body.
func (client ManagementClient) DeleteOrderResponder(resp *http.Response) (result autorest.Response, err error) { 
    err = autorest.Respond(
            resp,
            client.ByInspecting(),
            azure.WithErrorUnlessStatusCode(http.StatusOK,http.StatusNotFound,http.StatusBadRequest),
            autorest.ByClosing())
    result.Response = resp
    return
}

// DeletePet sends the delete pet request.
//
// petID is pet id to delete
func (client ManagementClient) DeletePet(petID int64, apiKey string) (result autorest.Response, err error) {
    req, err := client.DeletePetPreparer(petID, apiKey)
    if err != nil {
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "DeletePet", nil , "Failure preparing request")
    }

    resp, err := client.DeletePetSender(req)
    if err != nil {
        result.Response = resp
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "DeletePet", resp, "Failure sending request")
    }

    result, err = client.DeletePetResponder(resp)
    if err != nil {
        err = autorest.NewErrorWithError(err, "Petstore.ManagementClient", "DeletePet", resp, "Failure responding to request")
    }

    return
}

// DeletePetPreparer prepares the DeletePet request.
func (client ManagementClient) DeletePetPreparer(petID int64, apiKey string) (*http.Request, error) {
    pathParameters := map[string]interface{} {
    "petId": autorest.Encode("path",petID),
    }

    preparer := autorest.CreatePreparer(
                        autorest.AsDelete(),
                        autorest.WithBaseURL(client.BaseURI),
                        autorest.WithPathParameters("/pet/{petId}",pathParameters))
    if len(apiKey) > 0 {
        preparer = autorest.DecoratePreparer(preparer,
                            autorest.WithHeader("api_key",autorest.String(apiKey)))
    }
    return preparer.Prepare(&http.Request{})
}

// DeletePetSender sends the DeletePet request. The method will close the
// http.Response Body if it receives an error.
func (client ManagementClient) DeletePetSender(req *http.Request) (*http.Response, error) {
    return autorest.SendWithSender(client, req)
}

// DeletePetResponder handles the response to the DeletePet request. The method always
// closes the http.Response Body.
func (client ManagementClient) DeletePetResponder(resp *http.Response) (result autorest.Response, err error) { 
    err = autorest.Respond(
            resp,
            client.ByInspecting(),
            azure.WithErrorUnlessStatusCode(http.StatusOK,http.StatusBadRequest),
            autorest.ByClosing())
    result.Response = resp
    return
}

// DeleteUser this can only be done by the logged in user.
//
// username is the name that needs to be deleted
func (client ManagementClient) DeleteUser(username string) (result autorest.Response, err error) {
    req, err := client.DeleteUserPreparer(username)
    if err != nil {
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "DeleteUser", nil , "Failure preparing request")
    }

    resp, err := client.DeleteUserSender(req)
    if err != nil {
        result.Response = resp
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "DeleteUser", resp, "Failure sending request")
    }

    result, err = client.DeleteUserResponder(resp)
    if err != nil {
        err = autorest.NewErrorWithError(err, "Petstore.ManagementClient", "DeleteUser", resp, "Failure responding to request")
    }

    return
}

// DeleteUserPreparer prepares the DeleteUser request.
func (client ManagementClient) DeleteUserPreparer(username string) (*http.Request, error) {
    pathParameters := map[string]interface{} {
    "username": autorest.Encode("path",username),
    }

    preparer := autorest.CreatePreparer(
                        autorest.AsDelete(),
                        autorest.WithBaseURL(client.BaseURI),
                        autorest.WithPathParameters("/user/{username}",pathParameters))
    return preparer.Prepare(&http.Request{})
}

// DeleteUserSender sends the DeleteUser request. The method will close the
// http.Response Body if it receives an error.
func (client ManagementClient) DeleteUserSender(req *http.Request) (*http.Response, error) {
    return autorest.SendWithSender(client, req)
}

// DeleteUserResponder handles the response to the DeleteUser request. The method always
// closes the http.Response Body.
func (client ManagementClient) DeleteUserResponder(resp *http.Response) (result autorest.Response, err error) { 
    err = autorest.Respond(
            resp,
            client.ByInspecting(),
            azure.WithErrorUnlessStatusCode(http.StatusOK,http.StatusNotFound,http.StatusBadRequest),
            autorest.ByClosing())
    result.Response = resp
    return
}

// FindPetsByStatus multiple status values can be provided with comma
// seperated strings
//
// status is status values that need to be considered for filter
func (client ManagementClient) FindPetsByStatus(status []string) (result ListPet, err error) {
    req, err := client.FindPetsByStatusPreparer(status)
    if err != nil {
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "FindPetsByStatus", nil , "Failure preparing request")
    }

    resp, err := client.FindPetsByStatusSender(req)
    if err != nil {
        result.Response = autorest.Response{Response: resp}
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "FindPetsByStatus", resp, "Failure sending request")
    }

    result, err = client.FindPetsByStatusResponder(resp)
    if err != nil {
        err = autorest.NewErrorWithError(err, "Petstore.ManagementClient", "FindPetsByStatus", resp, "Failure responding to request")
    }

    return
}

// FindPetsByStatusPreparer prepares the FindPetsByStatus request.
func (client ManagementClient) FindPetsByStatusPreparer(status []string) (*http.Request, error) {
    queryParameters := map[string]interface{} {
    }
    if status != nil && len(status) > 0 {
        queryParameters["status"] = autorest.Encode("query",status,",")
    }

    preparer := autorest.CreatePreparer(
                        autorest.AsGet(),
                        autorest.WithBaseURL(client.BaseURI),
                        autorest.WithPath("/pet/findByStatus"),
                        autorest.WithQueryParameters(queryParameters))
    return preparer.Prepare(&http.Request{})
}

// FindPetsByStatusSender sends the FindPetsByStatus request. The method will close the
// http.Response Body if it receives an error.
func (client ManagementClient) FindPetsByStatusSender(req *http.Request) (*http.Response, error) {
    return autorest.SendWithSender(client, req)
}

// FindPetsByStatusResponder handles the response to the FindPetsByStatus request. The method always
// closes the http.Response Body.
func (client ManagementClient) FindPetsByStatusResponder(resp *http.Response) (result ListPet, err error) { 
    err = autorest.Respond(
            resp,
            client.ByInspecting(),
            azure.WithErrorUnlessStatusCode(http.StatusOK,http.StatusBadRequest),
            autorest.ByUnmarshallingJSON(&result.Value),
            autorest.ByClosing())
    result.Response = autorest.Response{Response: resp}
    return
}

// FindPetsByTags muliple tags can be provided with comma seperated strings.
// Use tag1, tag2, tag3 for testing.
//
// tags is tags to filter by
func (client ManagementClient) FindPetsByTags(tags []string) (result ListPet, err error) {
    req, err := client.FindPetsByTagsPreparer(tags)
    if err != nil {
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "FindPetsByTags", nil , "Failure preparing request")
    }

    resp, err := client.FindPetsByTagsSender(req)
    if err != nil {
        result.Response = autorest.Response{Response: resp}
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "FindPetsByTags", resp, "Failure sending request")
    }

    result, err = client.FindPetsByTagsResponder(resp)
    if err != nil {
        err = autorest.NewErrorWithError(err, "Petstore.ManagementClient", "FindPetsByTags", resp, "Failure responding to request")
    }

    return
}

// FindPetsByTagsPreparer prepares the FindPetsByTags request.
func (client ManagementClient) FindPetsByTagsPreparer(tags []string) (*http.Request, error) {
    queryParameters := map[string]interface{} {
    }
    if tags != nil && len(tags) > 0 {
        queryParameters["tags"] = autorest.Encode("query",tags,",")
    }

    preparer := autorest.CreatePreparer(
                        autorest.AsGet(),
                        autorest.WithBaseURL(client.BaseURI),
                        autorest.WithPath("/pet/findByTags"),
                        autorest.WithQueryParameters(queryParameters))
    return preparer.Prepare(&http.Request{})
}

// FindPetsByTagsSender sends the FindPetsByTags request. The method will close the
// http.Response Body if it receives an error.
func (client ManagementClient) FindPetsByTagsSender(req *http.Request) (*http.Response, error) {
    return autorest.SendWithSender(client, req)
}

// FindPetsByTagsResponder handles the response to the FindPetsByTags request. The method always
// closes the http.Response Body.
func (client ManagementClient) FindPetsByTagsResponder(resp *http.Response) (result ListPet, err error) { 
    err = autorest.Respond(
            resp,
            client.ByInspecting(),
            azure.WithErrorUnlessStatusCode(http.StatusOK,http.StatusBadRequest),
            autorest.ByUnmarshallingJSON(&result.Value),
            autorest.ByClosing())
    result.Response = autorest.Response{Response: resp}
    return
}

// FindPetsWithByteArray returns a pet when ID < 10.  ID > 10 or nonintegers
// will simulate API error conditions
//
// petID is iD of pet that needs to be fetched
func (client ManagementClient) FindPetsWithByteArray(petID int64) (result String, err error) {
    req, err := client.FindPetsWithByteArrayPreparer(petID)
    if err != nil {
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "FindPetsWithByteArray", nil , "Failure preparing request")
    }

    resp, err := client.FindPetsWithByteArraySender(req)
    if err != nil {
        result.Response = autorest.Response{Response: resp}
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "FindPetsWithByteArray", resp, "Failure sending request")
    }

    result, err = client.FindPetsWithByteArrayResponder(resp)
    if err != nil {
        err = autorest.NewErrorWithError(err, "Petstore.ManagementClient", "FindPetsWithByteArray", resp, "Failure responding to request")
    }

    return
}

// FindPetsWithByteArrayPreparer prepares the FindPetsWithByteArray request.
func (client ManagementClient) FindPetsWithByteArrayPreparer(petID int64) (*http.Request, error) {
    pathParameters := map[string]interface{} {
    "petId": autorest.Encode("path",petID),
    }

    preparer := autorest.CreatePreparer(
                        autorest.AsGet(),
                        autorest.WithBaseURL(client.BaseURI),
                        autorest.WithPathParameters("/pet/{petId}",pathParameters))
    return preparer.Prepare(&http.Request{})
}

// FindPetsWithByteArraySender sends the FindPetsWithByteArray request. The method will close the
// http.Response Body if it receives an error.
func (client ManagementClient) FindPetsWithByteArraySender(req *http.Request) (*http.Response, error) {
    return autorest.SendWithSender(client, req)
}

// FindPetsWithByteArrayResponder handles the response to the FindPetsWithByteArray request. The method always
// closes the http.Response Body.
func (client ManagementClient) FindPetsWithByteArrayResponder(resp *http.Response) (result String, err error) { 
    err = autorest.Respond(
            resp,
            client.ByInspecting(),
            azure.WithErrorUnlessStatusCode(http.StatusNotFound,http.StatusOK,http.StatusBadRequest),
            autorest.ByUnmarshallingJSON(&result.Value),
            autorest.ByClosing())
    result.Response = autorest.Response{Response: resp}
    return
}

// GetInventory returns a map of status codes to quantities
func (client ManagementClient) GetInventory() (result SetInt32, err error) {
    req, err := client.GetInventoryPreparer()
    if err != nil {
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "GetInventory", nil , "Failure preparing request")
    }

    resp, err := client.GetInventorySender(req)
    if err != nil {
        result.Response = autorest.Response{Response: resp}
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "GetInventory", resp, "Failure sending request")
    }

    result, err = client.GetInventoryResponder(resp)
    if err != nil {
        err = autorest.NewErrorWithError(err, "Petstore.ManagementClient", "GetInventory", resp, "Failure responding to request")
    }

    return
}

// GetInventoryPreparer prepares the GetInventory request.
func (client ManagementClient) GetInventoryPreparer() (*http.Request, error) {
    preparer := autorest.CreatePreparer(
                        autorest.AsGet(),
                        autorest.WithBaseURL(client.BaseURI),
                        autorest.WithPath("/store/inventory"))
    return preparer.Prepare(&http.Request{})
}

// GetInventorySender sends the GetInventory request. The method will close the
// http.Response Body if it receives an error.
func (client ManagementClient) GetInventorySender(req *http.Request) (*http.Response, error) {
    return autorest.SendWithSender(client, req)
}

// GetInventoryResponder handles the response to the GetInventory request. The method always
// closes the http.Response Body.
func (client ManagementClient) GetInventoryResponder(resp *http.Response) (result SetInt32, err error) { 
    err = autorest.Respond(
            resp,
            client.ByInspecting(),
            azure.WithErrorUnlessStatusCode(http.StatusOK),
            autorest.ByUnmarshallingJSON(&result.Value),
            autorest.ByClosing())
    result.Response = autorest.Response{Response: resp}
    return
}

// GetOrderByID for valid response try integer IDs with value <= 5 or > 10.
// Other values will generated exceptions
//
// orderID is iD of pet that needs to be fetched
func (client ManagementClient) GetOrderByID(orderID string) (result Order, err error) {
    req, err := client.GetOrderByIDPreparer(orderID)
    if err != nil {
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "GetOrderByID", nil , "Failure preparing request")
    }

    resp, err := client.GetOrderByIDSender(req)
    if err != nil {
        result.Response = autorest.Response{Response: resp}
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "GetOrderByID", resp, "Failure sending request")
    }

    result, err = client.GetOrderByIDResponder(resp)
    if err != nil {
        err = autorest.NewErrorWithError(err, "Petstore.ManagementClient", "GetOrderByID", resp, "Failure responding to request")
    }

    return
}

// GetOrderByIDPreparer prepares the GetOrderByID request.
func (client ManagementClient) GetOrderByIDPreparer(orderID string) (*http.Request, error) {
    pathParameters := map[string]interface{} {
    "orderId": autorest.Encode("path",orderID),
    }

    preparer := autorest.CreatePreparer(
                        autorest.AsGet(),
                        autorest.WithBaseURL(client.BaseURI),
                        autorest.WithPathParameters("/store/order/{orderId}",pathParameters))
    return preparer.Prepare(&http.Request{})
}

// GetOrderByIDSender sends the GetOrderByID request. The method will close the
// http.Response Body if it receives an error.
func (client ManagementClient) GetOrderByIDSender(req *http.Request) (*http.Response, error) {
    return autorest.SendWithSender(client, req)
}

// GetOrderByIDResponder handles the response to the GetOrderByID request. The method always
// closes the http.Response Body.
func (client ManagementClient) GetOrderByIDResponder(resp *http.Response) (result Order, err error) { 
    err = autorest.Respond(
            resp,
            client.ByInspecting(),
            azure.WithErrorUnlessStatusCode(http.StatusNotFound,http.StatusOK,http.StatusBadRequest),
            autorest.ByUnmarshallingJSON(&result),
            autorest.ByClosing())
    result.Response = autorest.Response{Response: resp}
    return
}

// GetPetByID returns a pet when ID < 10.  ID > 10 or nonintegers will
// simulate API error conditions
//
// petID is iD of pet that needs to be fetched
func (client ManagementClient) GetPetByID(petID int64) (result Pet, err error) {
    req, err := client.GetPetByIDPreparer(petID)
    if err != nil {
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "GetPetByID", nil , "Failure preparing request")
    }

    resp, err := client.GetPetByIDSender(req)
    if err != nil {
        result.Response = autorest.Response{Response: resp}
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "GetPetByID", resp, "Failure sending request")
    }

    result, err = client.GetPetByIDResponder(resp)
    if err != nil {
        err = autorest.NewErrorWithError(err, "Petstore.ManagementClient", "GetPetByID", resp, "Failure responding to request")
    }

    return
}

// GetPetByIDPreparer prepares the GetPetByID request.
func (client ManagementClient) GetPetByIDPreparer(petID int64) (*http.Request, error) {
    pathParameters := map[string]interface{} {
    "petId": autorest.Encode("path",petID),
    }

    preparer := autorest.CreatePreparer(
                        autorest.AsGet(),
                        autorest.WithBaseURL(client.BaseURI),
                        autorest.WithPathParameters("/pet/{petId}",pathParameters))
    return preparer.Prepare(&http.Request{})
}

// GetPetByIDSender sends the GetPetByID request. The method will close the
// http.Response Body if it receives an error.
func (client ManagementClient) GetPetByIDSender(req *http.Request) (*http.Response, error) {
    return autorest.SendWithSender(client, req)
}

// GetPetByIDResponder handles the response to the GetPetByID request. The method always
// closes the http.Response Body.
func (client ManagementClient) GetPetByIDResponder(resp *http.Response) (result Pet, err error) { 
    err = autorest.Respond(
            resp,
            client.ByInspecting(),
            azure.WithErrorUnlessStatusCode(http.StatusNotFound,http.StatusOK,http.StatusBadRequest),
            autorest.ByUnmarshallingJSON(&result),
            autorest.ByClosing())
    result.Response = autorest.Response{Response: resp}
    return
}

// GetUserByName sends the get user by name request.
//
// username is the name that needs to be fetched. Use user1 for testing.
func (client ManagementClient) GetUserByName(username string) (result User, err error) {
    req, err := client.GetUserByNamePreparer(username)
    if err != nil {
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "GetUserByName", nil , "Failure preparing request")
    }

    resp, err := client.GetUserByNameSender(req)
    if err != nil {
        result.Response = autorest.Response{Response: resp}
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "GetUserByName", resp, "Failure sending request")
    }

    result, err = client.GetUserByNameResponder(resp)
    if err != nil {
        err = autorest.NewErrorWithError(err, "Petstore.ManagementClient", "GetUserByName", resp, "Failure responding to request")
    }

    return
}

// GetUserByNamePreparer prepares the GetUserByName request.
func (client ManagementClient) GetUserByNamePreparer(username string) (*http.Request, error) {
    pathParameters := map[string]interface{} {
    "username": autorest.Encode("path",username),
    }

    preparer := autorest.CreatePreparer(
                        autorest.AsGet(),
                        autorest.WithBaseURL(client.BaseURI),
                        autorest.WithPathParameters("/user/{username}",pathParameters))
    return preparer.Prepare(&http.Request{})
}

// GetUserByNameSender sends the GetUserByName request. The method will close the
// http.Response Body if it receives an error.
func (client ManagementClient) GetUserByNameSender(req *http.Request) (*http.Response, error) {
    return autorest.SendWithSender(client, req)
}

// GetUserByNameResponder handles the response to the GetUserByName request. The method always
// closes the http.Response Body.
func (client ManagementClient) GetUserByNameResponder(resp *http.Response) (result User, err error) { 
    err = autorest.Respond(
            resp,
            client.ByInspecting(),
            azure.WithErrorUnlessStatusCode(http.StatusNotFound,http.StatusOK,http.StatusBadRequest),
            autorest.ByUnmarshallingJSON(&result),
            autorest.ByClosing())
    result.Response = autorest.Response{Response: resp}
    return
}

// LoginUser sends the login user request.
//
// username is the user name for login password is the password for login in
// clear text
func (client ManagementClient) LoginUser(username string, password string) (result String, err error) {
    req, err := client.LoginUserPreparer(username, password)
    if err != nil {
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "LoginUser", nil , "Failure preparing request")
    }

    resp, err := client.LoginUserSender(req)
    if err != nil {
        result.Response = autorest.Response{Response: resp}
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "LoginUser", resp, "Failure sending request")
    }

    result, err = client.LoginUserResponder(resp)
    if err != nil {
        err = autorest.NewErrorWithError(err, "Petstore.ManagementClient", "LoginUser", resp, "Failure responding to request")
    }

    return
}

// LoginUserPreparer prepares the LoginUser request.
func (client ManagementClient) LoginUserPreparer(username string, password string) (*http.Request, error) {
    queryParameters := map[string]interface{} {
    }
    if len(username) > 0 {
        queryParameters["username"] = autorest.Encode("query",username)
    }
    if len(password) > 0 {
        queryParameters["password"] = autorest.Encode("query",password)
    }

    preparer := autorest.CreatePreparer(
                        autorest.AsGet(),
                        autorest.WithBaseURL(client.BaseURI),
                        autorest.WithPath("/user/login"),
                        autorest.WithQueryParameters(queryParameters))
    return preparer.Prepare(&http.Request{})
}

// LoginUserSender sends the LoginUser request. The method will close the
// http.Response Body if it receives an error.
func (client ManagementClient) LoginUserSender(req *http.Request) (*http.Response, error) {
    return autorest.SendWithSender(client, req)
}

// LoginUserResponder handles the response to the LoginUser request. The method always
// closes the http.Response Body.
func (client ManagementClient) LoginUserResponder(resp *http.Response) (result String, err error) { 
    err = autorest.Respond(
            resp,
            client.ByInspecting(),
            azure.WithErrorUnlessStatusCode(http.StatusOK,http.StatusBadRequest),
            autorest.ByUnmarshallingJSON(&result.Value),
            autorest.ByClosing())
    result.Response = autorest.Response{Response: resp}
    return
}

// LogoutUser sends the logout user request.
func (client ManagementClient) LogoutUser() (result autorest.Response, err error) {
    req, err := client.LogoutUserPreparer()
    if err != nil {
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "LogoutUser", nil , "Failure preparing request")
    }

    resp, err := client.LogoutUserSender(req)
    if err != nil {
        result.Response = resp
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "LogoutUser", resp, "Failure sending request")
    }

    result, err = client.LogoutUserResponder(resp)
    if err != nil {
        err = autorest.NewErrorWithError(err, "Petstore.ManagementClient", "LogoutUser", resp, "Failure responding to request")
    }

    return
}

// LogoutUserPreparer prepares the LogoutUser request.
func (client ManagementClient) LogoutUserPreparer() (*http.Request, error) {
    preparer := autorest.CreatePreparer(
                        autorest.AsGet(),
                        autorest.WithBaseURL(client.BaseURI),
                        autorest.WithPath("/user/logout"))
    return preparer.Prepare(&http.Request{})
}

// LogoutUserSender sends the LogoutUser request. The method will close the
// http.Response Body if it receives an error.
func (client ManagementClient) LogoutUserSender(req *http.Request) (*http.Response, error) {
    return autorest.SendWithSender(client, req)
}

// LogoutUserResponder handles the response to the LogoutUser request. The method always
// closes the http.Response Body.
func (client ManagementClient) LogoutUserResponder(resp *http.Response) (result autorest.Response, err error) { 
    err = autorest.Respond(
            resp,
            client.ByInspecting(),
            azure.WithErrorUnlessStatusCode(http.StatusOK),
            autorest.ByClosing())
    result.Response = resp
    return
}

// PlaceOrder sends the place order request.
//
// body is order placed for purchasing the pet
func (client ManagementClient) PlaceOrder(body *Order) (result Order, err error) {
    if err := validation.Validate([]validation.Validation{
         { TargetValue: body,
          Constraints: []validation.Constraint{	{Target: "body", Name: validation.Null, Rule: false ,
         Chain: []validation.Constraint{	{Target: "body.ID", Name: validation.ReadOnly, Rule: true, Chain: nil },
         }}}}}); err != nil {
             return result, validation.NewErrorWithValidationError(err, "Petstore.ManagementClient","PlaceOrder")
    }

    req, err := client.PlaceOrderPreparer(body)
    if err != nil {
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "PlaceOrder", nil , "Failure preparing request")
    }

    resp, err := client.PlaceOrderSender(req)
    if err != nil {
        result.Response = autorest.Response{Response: resp}
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "PlaceOrder", resp, "Failure sending request")
    }

    result, err = client.PlaceOrderResponder(resp)
    if err != nil {
        err = autorest.NewErrorWithError(err, "Petstore.ManagementClient", "PlaceOrder", resp, "Failure responding to request")
    }

    return
}

// PlaceOrderPreparer prepares the PlaceOrder request.
func (client ManagementClient) PlaceOrderPreparer(body *Order) (*http.Request, error) {
    preparer := autorest.CreatePreparer(
                        autorest.AsJSON(),
                        autorest.AsPost(),
                        autorest.WithBaseURL(client.BaseURI),
                        autorest.WithPath("/store/order"))
    if body != nil {
        preparer = autorest.DecoratePreparer(preparer,
                            autorest.WithJSON(body))
    }
    return preparer.Prepare(&http.Request{})
}

// PlaceOrderSender sends the PlaceOrder request. The method will close the
// http.Response Body if it receives an error.
func (client ManagementClient) PlaceOrderSender(req *http.Request) (*http.Response, error) {
    return autorest.SendWithSender(client, req)
}

// PlaceOrderResponder handles the response to the PlaceOrder request. The method always
// closes the http.Response Body.
func (client ManagementClient) PlaceOrderResponder(resp *http.Response) (result Order, err error) { 
    err = autorest.Respond(
            resp,
            client.ByInspecting(),
            azure.WithErrorUnlessStatusCode(http.StatusOK,http.StatusBadRequest),
            autorest.ByUnmarshallingJSON(&result),
            autorest.ByClosing())
    result.Response = autorest.Response{Response: resp}
    return
}

// UpdatePet sends the update pet request.
//
// body is pet object that needs to be added to the store
func (client ManagementClient) UpdatePet(body *Pet) (result autorest.Response, err error) {
    if err := validation.Validate([]validation.Validation{
         { TargetValue: body,
          Constraints: []validation.Constraint{	{Target: "body", Name: validation.Null, Rule: false ,
         Chain: []validation.Constraint{	{Target: "body.Name", Name: validation.Null, Rule: true, Chain: nil },
         	{Target: "body.PhotoUrls", Name: validation.Null, Rule: true, Chain: nil },
         }}}}}); err != nil {
             return result, validation.NewErrorWithValidationError(err, "Petstore.ManagementClient","UpdatePet")
    }

    req, err := client.UpdatePetPreparer(body)
    if err != nil {
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "UpdatePet", nil , "Failure preparing request")
    }

    resp, err := client.UpdatePetSender(req)
    if err != nil {
        result.Response = resp
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "UpdatePet", resp, "Failure sending request")
    }

    result, err = client.UpdatePetResponder(resp)
    if err != nil {
        err = autorest.NewErrorWithError(err, "Petstore.ManagementClient", "UpdatePet", resp, "Failure responding to request")
    }

    return
}

// UpdatePetPreparer prepares the UpdatePet request.
func (client ManagementClient) UpdatePetPreparer(body *Pet) (*http.Request, error) {
    preparer := autorest.CreatePreparer(
                        autorest.AsJSON(),
                        autorest.AsPut(),
                        autorest.WithBaseURL(client.BaseURI),
                        autorest.WithPath("/pet"))
    if body != nil {
        preparer = autorest.DecoratePreparer(preparer,
                            autorest.WithJSON(body))
    }
    return preparer.Prepare(&http.Request{})
}

// UpdatePetSender sends the UpdatePet request. The method will close the
// http.Response Body if it receives an error.
func (client ManagementClient) UpdatePetSender(req *http.Request) (*http.Response, error) {
    return autorest.SendWithSender(client, req)
}

// UpdatePetResponder handles the response to the UpdatePet request. The method always
// closes the http.Response Body.
func (client ManagementClient) UpdatePetResponder(resp *http.Response) (result autorest.Response, err error) { 
    err = autorest.Respond(
            resp,
            client.ByInspecting(),
            azure.WithErrorUnlessStatusCode(http.StatusOK,http.StatusMethodNotAllowed,http.StatusNotFound,http.StatusBadRequest),
            autorest.ByClosing())
    result.Response = resp
    return
}

// UpdatePetWithForm sends the update pet with form request.
//
// petID is iD of pet that needs to be updated name is updated name of the pet
// status is updated status of the pet
func (client ManagementClient) UpdatePetWithForm(petID string, name string, status string) (result autorest.Response, err error) {
    req, err := client.UpdatePetWithFormPreparer(petID, name, status)
    if err != nil {
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "UpdatePetWithForm", nil , "Failure preparing request")
    }

    resp, err := client.UpdatePetWithFormSender(req)
    if err != nil {
        result.Response = resp
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "UpdatePetWithForm", resp, "Failure sending request")
    }

    result, err = client.UpdatePetWithFormResponder(resp)
    if err != nil {
        err = autorest.NewErrorWithError(err, "Petstore.ManagementClient", "UpdatePetWithForm", resp, "Failure responding to request")
    }

    return
}

// UpdatePetWithFormPreparer prepares the UpdatePetWithForm request.
func (client ManagementClient) UpdatePetWithFormPreparer(petID string, name string, status string) (*http.Request, error) {
    pathParameters := map[string]interface{} {
    "petId": autorest.Encode("path",petID),
    }

    formDataParameters := map[string]interface{} {
    }

    preparer := autorest.CreatePreparer(
                        autorest.AsPost(),
                        autorest.WithBaseURL(client.BaseURI),
                        autorest.WithPathParameters("/pet/{petId}",pathParameters),
                        autorest.WithFormData(autorest.MapToValues(formDataParameters)))
    return preparer.Prepare(&http.Request{})
}

// UpdatePetWithFormSender sends the UpdatePetWithForm request. The method will close the
// http.Response Body if it receives an error.
func (client ManagementClient) UpdatePetWithFormSender(req *http.Request) (*http.Response, error) {
    return autorest.SendWithSender(client, req)
}

// UpdatePetWithFormResponder handles the response to the UpdatePetWithForm request. The method always
// closes the http.Response Body.
func (client ManagementClient) UpdatePetWithFormResponder(resp *http.Response) (result autorest.Response, err error) { 
    err = autorest.Respond(
            resp,
            client.ByInspecting(),
            azure.WithErrorUnlessStatusCode(http.StatusOK,http.StatusMethodNotAllowed),
            autorest.ByClosing())
    result.Response = resp
    return
}

// UpdateUser this can only be done by the logged in user.
//
// username is name that need to be deleted body is updated user object
func (client ManagementClient) UpdateUser(username string, body *User) (result autorest.Response, err error) {
    req, err := client.UpdateUserPreparer(username, body)
    if err != nil {
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "UpdateUser", nil , "Failure preparing request")
    }

    resp, err := client.UpdateUserSender(req)
    if err != nil {
        result.Response = resp
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "UpdateUser", resp, "Failure sending request")
    }

    result, err = client.UpdateUserResponder(resp)
    if err != nil {
        err = autorest.NewErrorWithError(err, "Petstore.ManagementClient", "UpdateUser", resp, "Failure responding to request")
    }

    return
}

// UpdateUserPreparer prepares the UpdateUser request.
func (client ManagementClient) UpdateUserPreparer(username string, body *User) (*http.Request, error) {
    pathParameters := map[string]interface{} {
    "username": autorest.Encode("path",username),
    }

    preparer := autorest.CreatePreparer(
                        autorest.AsJSON(),
                        autorest.AsPut(),
                        autorest.WithBaseURL(client.BaseURI),
                        autorest.WithPathParameters("/user/{username}",pathParameters))
    if body != nil {
        preparer = autorest.DecoratePreparer(preparer,
                            autorest.WithJSON(body))
    }
    return preparer.Prepare(&http.Request{})
}

// UpdateUserSender sends the UpdateUser request. The method will close the
// http.Response Body if it receives an error.
func (client ManagementClient) UpdateUserSender(req *http.Request) (*http.Response, error) {
    return autorest.SendWithSender(client, req)
}

// UpdateUserResponder handles the response to the UpdateUser request. The method always
// closes the http.Response Body.
func (client ManagementClient) UpdateUserResponder(resp *http.Response) (result autorest.Response, err error) { 
    err = autorest.Respond(
            resp,
            client.ByInspecting(),
            azure.WithErrorUnlessStatusCode(http.StatusOK,http.StatusNotFound,http.StatusBadRequest),
            autorest.ByClosing())
    result.Response = resp
    return
}

// UploadFile sends the upload file request.
//
// petID is iD of pet to update additionalMetadata is additional data to pass
// to server file is file to upload file will be closed upon successful
// return. Callers should ensure closure when receiving an error.
func (client ManagementClient) UploadFile(petID int64, additionalMetadata string, file io.ReadCloser) (result autorest.Response, err error) {
    req, err := client.UploadFilePreparer(petID, additionalMetadata, file)
    if err != nil {
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "UploadFile", nil , "Failure preparing request")
    }

    resp, err := client.UploadFileSender(req)
    if err != nil {
        result.Response = resp
        return result, autorest.NewErrorWithError(err, "Petstore.ManagementClient", "UploadFile", resp, "Failure sending request")
    }

    result, err = client.UploadFileResponder(resp)
    if err != nil {
        err = autorest.NewErrorWithError(err, "Petstore.ManagementClient", "UploadFile", resp, "Failure responding to request")
    }

    return
}

// UploadFilePreparer prepares the UploadFile request.
func (client ManagementClient) UploadFilePreparer(petID int64, additionalMetadata string, file io.ReadCloser) (*http.Request, error) {
    pathParameters := map[string]interface{} {
    "petId": autorest.Encode("path",petID),
    }

    formDataParameters := map[string]interface{} {
    }

    preparer := autorest.CreatePreparer(
                        autorest.AsPost(),
                        autorest.WithBaseURL(client.BaseURI),
                        autorest.WithPathParameters("/pet/{petId}/uploadImage",pathParameters),
                        autorest.WithMultiPartFormData(formDataParameters))
    return preparer.Prepare(&http.Request{})
}

// UploadFileSender sends the UploadFile request. The method will close the
// http.Response Body if it receives an error.
func (client ManagementClient) UploadFileSender(req *http.Request) (*http.Response, error) {
    return autorest.SendWithSender(client, req)
}

// UploadFileResponder handles the response to the UploadFile request. The method always
// closes the http.Response Body.
func (client ManagementClient) UploadFileResponder(resp *http.Response) (result autorest.Response, err error) { 
    err = autorest.Respond(
            resp,
            client.ByInspecting(),
            azure.WithErrorUnlessStatusCode(http.StatusOK),
            autorest.ByClosing())
    result.Response = resp
    return
}

