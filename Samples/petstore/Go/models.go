package Petstore


import (
    "github.com/Azure/go-autorest/autorest"
    "github.com/Azure/go-autorest/autorest/date"
)    

// Status enumerates the values for status.
type Status string

const (
    // Available specifies the available state for status.
    Available Status = "available"
    // Pending specifies the pending state for status.
    Pending Status = "pending"
    // Sold specifies the sold state for status.
    Sold Status = "sold"
)


// Status enumerates the values for status.
type Status string

const (
    // Approved specifies the approved state for status.
    Approved Status = "approved"
    // Delivered specifies the delivered state for status.
    Delivered Status = "delivered"
    // Placed specifies the placed state for status.
    Placed Status = "placed"
)


// Category is
type Category struct {
    ID *int64 `json:"id,omitempty"`
    Name *string `json:"name,omitempty"`
}

// ListPet is
type ListPet struct {
    autorest.Response `json:"-"`
    Value *[]Pet `json:"value,omitempty"`
}

// Order is
type Order struct {
    autorest.Response `json:"-"`
    ID *int64 `json:"id,omitempty"`
    PetID *int64 `json:"petId,omitempty"`
    Quantity *int32 `json:"quantity,omitempty"`
    ShipDate *date.Time `json:"shipDate,omitempty"`
    Status Status `json:"status,omitempty"`
    Complete *bool `json:"complete,omitempty"`
}

// Pet is a group of properties representing a pet.
type Pet struct {
    autorest.Response `json:"-"`
    ID *int64 `json:"id,omitempty"`
    Category *Category `json:"category,omitempty"`
    Name *string `json:"name,omitempty"`
    PhotoUrls *[]string `json:"photoUrls,omitempty"`
    Tags *[]Tag `json:"tags,omitempty"`
    Status Status `json:"status,omitempty"`
}

// SetInt32 is
type SetInt32 struct {
    autorest.Response `json:"-"`
    Value *map[string]*int32 `json:"value,omitempty"`
}

// String is
type String struct {
    autorest.Response `json:"-"`
    Value *string `json:"value,omitempty"`
}

// Tag is
type Tag struct {
    ID *int64 `json:"id,omitempty"`
    Name *string `json:"name,omitempty"`
}

// User is
type User struct {
    autorest.Response `json:"-"`
    ID *int64 `json:"id,omitempty"`
    Username *string `json:"username,omitempty"`
    FirstName *string `json:"firstName,omitempty"`
    LastName *string `json:"lastName,omitempty"`
    Email *string `json:"email,omitempty"`
    Password *string `json:"password,omitempty"`
    Phone *string `json:"phone,omitempty"`
    UserStatus *int32 `json:"userStatus,omitempty"`
}

