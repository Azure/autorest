package fixtures.azureparametergrouping;

import com.microsoft.rest.ServiceResponse;

import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.azureparametergrouping.implementation.api.AutoRestParameterGroupingTestServiceImpl;
import fixtures.azureparametergrouping.models.implementation.api.FirstParameterGroupImpl;
import fixtures.azureparametergrouping.models.implementation.api.ParameterGroupingPostMultiParamGroupsSecondParamGroupImpl;
import fixtures.azureparametergrouping.models.implementation.api.ParameterGroupingPostOptionalParametersImpl;
import fixtures.azureparametergrouping.models.implementation.api.ParameterGroupingPostRequiredParametersImpl;


public class ParameterGroupingTests {
    private static AutoRestParameterGroupingTestServiceImpl client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestParameterGroupingTestServiceImpl("http://localhost.:3000", null);
    }

    @Test
    public void postRequired() throws Exception {
        ParameterGroupingPostRequiredParametersImpl params = new ParameterGroupingPostRequiredParametersImpl();
        params.setBody(1234);
        params.setPath("path");
        params.setQuery(21);
        params.setCustomHeader("header");
        ServiceResponse<Void> group = client.parameterGroupings().postRequired(params);
    }

    @Test
    public void postOptional() throws Exception {
        ParameterGroupingPostOptionalParametersImpl params = new ParameterGroupingPostOptionalParametersImpl();
        params.setQuery(21);
        params.setCustomHeader("header");
        ServiceResponse<Void> group = client.parameterGroupings().postOptional(params);
    }

    @Test
    public void postMultipleParameterGroups() throws Exception {
        FirstParameterGroupImpl first = new FirstParameterGroupImpl();
        first.setQueryOne(21);
        first.setHeaderOne("header");
        ParameterGroupingPostMultiParamGroupsSecondParamGroupImpl second = new ParameterGroupingPostMultiParamGroupsSecondParamGroupImpl();
        second.setHeaderTwo("header2");
        second.setQueryTwo(42);
        ServiceResponse<Void> group = client.parameterGroupings().postMultiParamGroups(first, second);
    }

    @Test
    public void postParameterGroupWithSharedParameter() throws Exception {
        FirstParameterGroupImpl first = new FirstParameterGroupImpl();
        first.setQueryOne(21);
        first.setHeaderOne("header");
        ServiceResponse<Void> group = client.parameterGroupings().postSharedParameterGroupObject(first);
    }
}
