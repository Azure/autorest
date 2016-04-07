package fixtures.azureparametergrouping;

import com.microsoft.rest.ServiceResponse;

import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.azureparametergrouping.implementation.api.AutoRestParameterGroupingTestServiceImpl;
import fixtures.azureparametergrouping.models.implementation.api.FirstParameterGroupInner;
import fixtures.azureparametergrouping.models.implementation.api.ParameterGroupingPostMultiParamGroupsSecondParamGroupInner;
import fixtures.azureparametergrouping.models.implementation.api.ParameterGroupingPostOptionalParametersInner;
import fixtures.azureparametergrouping.models.implementation.api.ParameterGroupingPostRequiredParametersInner;


public class ParameterGroupingTests {
    private static AutoRestParameterGroupingTestServiceImpl client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestParameterGroupingTestServiceImpl("http://localhost.:3000", null);
    }

    @Test
    public void postRequired() throws Exception {
        ParameterGroupingPostRequiredParametersInner params = new ParameterGroupingPostRequiredParametersInner();
        params.setBody(1234);
        params.setPath("path");
        params.setQuery(21);
        params.setCustomHeader("header");
        ServiceResponse<Void> group = client.parameterGroupings().postRequired(params);
    }

    @Test
    public void postOptional() throws Exception {
        ParameterGroupingPostOptionalParametersInner params = new ParameterGroupingPostOptionalParametersInner();
        params.setQuery(21);
        params.setCustomHeader("header");
        ServiceResponse<Void> group = client.parameterGroupings().postOptional(params);
    }

    @Test
    public void postMultipleParameterGroups() throws Exception {
        FirstParameterGroupInner first = new FirstParameterGroupInner();
        first.setQueryOne(21);
        first.setHeaderOne("header");
        ParameterGroupingPostMultiParamGroupsSecondParamGroupInner second = new ParameterGroupingPostMultiParamGroupsSecondParamGroupInner();
        second.setHeaderTwo("header2");
        second.setQueryTwo(42);
        ServiceResponse<Void> group = client.parameterGroupings().postMultiParamGroups(first, second);
    }

    @Test
    public void postParameterGroupWithSharedParameter() throws Exception {
        FirstParameterGroupInner first = new FirstParameterGroupInner();
        first.setQueryOne(21);
        first.setHeaderOne("header");
        ServiceResponse<Void> group = client.parameterGroupings().postSharedParameterGroupObject(first);
    }
}
