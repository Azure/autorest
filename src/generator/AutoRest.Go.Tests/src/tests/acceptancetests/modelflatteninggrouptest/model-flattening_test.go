package modelflatteninggrouptest

import (
	"encoding/json"
	"testing"

	chk "gopkg.in/check.v1"

	"tests/acceptancetests/utils"
	. "tests/generated/model-flattening"
)

func Test(t *testing.T) { chk.TestingT(t) }

type ModelFlatteningSuite struct{}

var _ = chk.Suite(&ModelFlatteningSuite{})

var modelflatteningClient = getmodelflatteningClient()

func getmodelflatteningClient() ManagementClient {
	c := New()
	c.BaseURI = utils.GetBaseURI()
	return c
}

func (s *ModelFlatteningSuite) TestGetArray(c *chk.C) {
	res, err := modelflatteningClient.GetArray()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.HasLen, 3)

	id, loc, name, typ := "1", "Building 44", "Resource1", "Microsoft.Web/sites"
	tag1, tag2 := "value1", "value3"
	provisioningState, pname, propty := "Succeeded", "Product1", "Flat"
	id1, loc1, name1 := "2", "Building 44", "Resource2"
	id2, name2 := "3", "Resource3"

	c.Assert(*res.Value, chk.DeepEquals, []FlattenedProduct{
		FlattenedProduct{
			ID:       &id,
			Location: &loc,
			Tags:     &map[string]*string{"tag1": &tag1, "tag2": &tag2},
			Name:     &name,
			Type:     &typ,
			Properties: &FlattenedProductProperties{
				ProvisioningState:       &provisioningState,
				ProvisioningStateValues: "OK",
				Pname: &pname,
				Type:  &propty,
			},
		},
		FlattenedProduct{
			ID:       &id1,
			Location: &loc1,
			Name:     &name1,
		},
		FlattenedProduct{
			ID:   &id2,
			Name: &name2,
		},
	})
}

func (s *ModelFlatteningSuite) TestGetDictionary(c *chk.C) {
	res, err := modelflatteningClient.GetDictionary()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.HasLen, 3)

	id, loc, name, typ := "1", "Building 44", "Resource1", "Microsoft.Web/sites"
	tag1, tag2 := "value1", "value3"
	provisioningState, pname, propty := "Succeeded", "Product1", "Flat"
	id1, loc1, name1 := "2", "Building 44", "Resource2"
	id2, name2 := "3", "Resource3"

	c.Assert(*res.Value, chk.DeepEquals, map[string]*FlattenedProduct{
		"Product1": &FlattenedProduct{
			ID:       &id,
			Location: &loc,
			Tags:     &map[string]*string{"tag1": &tag1, "tag2": &tag2},
			Name:     &name,
			Type:     &typ,
			Properties: &FlattenedProductProperties{
				ProvisioningState:       &provisioningState,
				ProvisioningStateValues: "OK",
				Pname: &pname,
				Type:  &propty,
			},
		},
		"Product2": &FlattenedProduct{
			ID:       &id1,
			Location: &loc1,
			Name:     &name1,
		},
		"Product3": &FlattenedProduct{
			ID:   &id2,
			Name: &name2,
		},
	})
}

func (s *ModelFlatteningSuite) TestGetResourceCollection(c *chk.C) {
	res, err := modelflatteningClient.GetResourceCollection()
	c.Assert(err, chk.IsNil)

	tag1, tag2 := "value1", "value3"

	id, loc, name, typ := "1", "Building 44", "Resource1", "Microsoft.Web/sites"
	provisioningState, pname, propty := "Succeeded", "Product1", "Flat"
	id1, loc1, name1 := "2", "Building 44", "Resource2"
	id2, name2 := "3", "Resource3"

	dictionaryOfResources := map[string]*FlattenedProduct{
		"Product1": &FlattenedProduct{
			ID:       &id,
			Location: &loc,
			Tags:     &map[string]*string{"tag1": &tag1, "tag2": &tag2},
			Name:     &name,
			Type:     &typ,
			Properties: &FlattenedProductProperties{
				ProvisioningState:       &provisioningState,
				ProvisioningStateValues: "OK",
				Pname: &pname,
				Type:  &propty,
			},
		},
		"Product2": &FlattenedProduct{
			ID:       &id1,
			Location: &loc1,
			Name:     &name1,
		},
		"Product3": &FlattenedProduct{
			ID:   &id2,
			Name: &name2,
		},
	}

	c.Assert(*res.Dictionaryofresources, chk.DeepEquals, dictionaryOfResources)

	id4, loc4, name4, typ4 := "4", "Building 44", "Resource4", "Microsoft.Web/sites"
	provisioningState4, pname4, propty4 := "Succeeded", "Product4", "Flat"
	id5, loc5, name5 := "5", "Building 44", "Resource5"
	id6, name6 := "6", "Resource6"

	arrayOfResources := []FlattenedProduct{
		FlattenedProduct{
			ID:       &id4,
			Location: &loc4,
			Tags:     &map[string]*string{"tag1": &tag1, "tag2": &tag2},
			Name:     &name4,
			Type:     &typ4,
			Properties: &FlattenedProductProperties{
				ProvisioningState:       &provisioningState4,
				ProvisioningStateValues: "OK",
				Pname: &pname4,
				Type:  &propty4,
			},
		},
		FlattenedProduct{
			ID:       &id5,
			Location: &loc5,
			Name:     &name5,
		},
		FlattenedProduct{
			ID:   &id6,
			Name: &name6,
		},
	}

	c.Assert(*res.Arrayofresources, chk.DeepEquals, arrayOfResources)

	id7, loc7, name7 := "7", "Building 44", "Resource7"

	productresource := FlattenedProduct{
		ID:       &id7,
		Location: &loc7,
		Name:     &name7,
	}

	c.Assert(*res.Productresource, chk.DeepEquals, productresource)
}

func (s *ModelFlatteningSuite) TestPostFlattenedSimpleProduct(c *chk.C) {
	id, description, displayName, capacity, odata := "123", "product description", "max name", "Large", "http://foo"
	arg := SimpleProduct{
		BaseProductID:          &id,
		BaseProductDescription: &description,
		Details: &SimpleProductProperties{
			MaxProductDisplayName: &displayName,
			MaxProductCapacity:    &capacity,
			MaxProductImage: &ProductURL{
				Odatavalue: &odata,
			},
		},
	}

	res, err := modelflatteningClient.PostFlattenedSimpleProduct(&arg)
	c.Assert(err, chk.IsNil)
	arg.Response = res.Response
	c.Assert(res, chk.DeepEquals, arg)
}

func (s *ModelFlatteningSuite) TestPutArray(c *chk.C) {
	loc1, loc2, tag1, tag2 := "West US", "Building 44", "value1", "value3"
	_, err := modelflatteningClient.PutArray([]Resource{
		Resource{
			Tags:     &map[string]*string{"tag1": &tag1, "tag2": &tag2},
			Location: &loc1,
		},
		Resource{
			Location: &loc2,
		},
	})
	c.Assert(err, chk.IsNil)
}

func (s *ModelFlatteningSuite) TestPutDictionary(c *chk.C) {
	jsonBlob := `{"Resource1":{"location":"West US", "tags":{"tag1":"value1", "tag2":"value3"},"properties":{"p.name":"Product1","type":"Flat"}},
					"Resource2":{"location":"Building 44", "properties":{"p.name":"Product2","type":"Flat"}}}`
	type resourceDictionary map[string]FlattenedProduct
	var r resourceDictionary

	_ = json.Unmarshal([]byte(jsonBlob), &r)
	_, err := modelflatteningClient.PutDictionary(r)
	c.Assert(err, chk.IsNil)
}

func (s *ModelFlatteningSuite) TestPutResourceCollection(c *chk.C) {
	dictionaryBlob := `{"Resource1":{"location":"West US", "tags":{"tag1":"value1", "tag2":"value3"},"properties":{"p.name":"Product1","type":"Flat"}},
					"Resource2":{"location":"Building 44", "properties":{"p.name":"Product2","type":"Flat"}}}`
	jsonBlob := `{"arrayofresources":[{"location":"West US", "tags":{"tag1":"value1", "tag2":"value3"}, "properties":{"p.name":"Product1","type":"Flat"}},
                            {"location":"East US", "properties":{"p.name":"Product2","type":"Flat"}}],
                            "dictionaryofresources": ` + dictionaryBlob + `,"productresource":{"location":"India", "properties":{"p.name":"Azure","type":"Flat"}}}`
	var r ResourceCollection

	err := json.Unmarshal([]byte(jsonBlob), &r)
	_, err = modelflatteningClient.PutResourceCollection(&r)
	c.Assert(err, chk.IsNil)
}

func (s *ModelFlatteningSuite) TestPutSimpleProduct(c *chk.C) {
	id, description, displayName, capacity, odata, genericValue := "123", "product description",
		"max name", "Large", "http://foo", "https://generic"
	arg := &SimpleProduct{
		BaseProductID:          &id,
		BaseProductDescription: &description,
		Details: &SimpleProductProperties{
			MaxProductDisplayName: &displayName,
			MaxProductCapacity:    &capacity,
			MaxProductImage: &ProductURL{
				Odatavalue:   &odata,
				GenericValue: &genericValue,
			},
		},
	}

	res, err := modelflatteningClient.PutSimpleProduct(arg)
	c.Assert(err, chk.IsNil)
	arg.Response = res.Response
	c.Assert(res, chk.DeepEquals, *arg)
}

func (s *ModelFlatteningSuite) TestPutSimpleProductWithGrouping(c *chk.C) {
	id, description, displayName, capacity, odata := "123", "product description",
		"max name", "Large", "http://foo"
	arg := &SimpleProduct{
		BaseProductID:          &id,
		BaseProductDescription: &description,
		Details: &SimpleProductProperties{
			MaxProductDisplayName: &displayName,
			MaxProductCapacity:    &capacity,
			MaxProductImage: &ProductURL{
				Odatavalue: &odata,
			},
		},
	}
	res, err := modelflatteningClient.PutSimpleProductWithGrouping("groupproduct", arg)
	c.Assert(err, chk.IsNil)
	arg.Response = res.Response
	c.Assert(res, chk.DeepEquals, *arg)
}
