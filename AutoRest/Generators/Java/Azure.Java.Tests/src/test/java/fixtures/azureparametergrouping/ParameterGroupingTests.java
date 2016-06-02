package fixtures.azureparametergrouping;

import com.microsoft.rest.ServiceResponse;

import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.azureparametergrouping.models.FirstParameterGroup;
import fixtures.azureparametergrouping.models.ParameterGroupingPostMultiParamGroupsSecondParamGroup;
import fixtures.azureparametergrouping.models.ParameterGroupingPostOptionalParameters;
import fixtures.azureparametergrouping.models.ParameterGroupingPostRequiredParameters;

public class ParameterGroupingTests {
    private static AutoRestParameterGroupingTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestParameterGroupingTestServiceImpl("http://localhost:3000", null);
    }

    @Test
    public void postRequired() throws Exception {
        ParameterGroupingPostRequiredParameters params = new ParameterGroupingPostRequiredParameters();
        params.setBody(1234);
        params.setPath("path");
        params.setQuery(21);
        params.setCustomHeader("header");
        ServiceResponse<Void> group = client.getParameterGroupingOperations().postRequired(params);
    }

    @Test
    public void postOptional() throws Exception {
        ParameterGroupingPostOptionalParameters params = new ParameterGroupingPostOptionalParameters();
        params.setQuery(21);
        params.setCustomHeader("header");
        ServiceResponse<Void> group = client.getParameterGroupingOperations().postOptional(params);
    }

    @Test
    public void postMultipleParameterGroups() throws Exception {
        FirstParameterGroup first = new FirstParameterGroup();
        first.setQueryOne(21);
        first.setHeaderOne("header");
        ParameterGroupingPostMultiParamGroupsSecondParamGroup second = new ParameterGroupingPostMultiParamGroupsSecondParamGroup();
        second.setHeaderTwo("header2");
        second.setQueryTwo(42);
        ServiceResponse<Void> group = client.getParameterGroupingOperations().postMultiParamGroups(first, second);
    }

    @Test
    public void postParameterGroupWithSharedParameter() throws Exception {
        FirstParameterGroup first = new FirstParameterGroup();
        first.setQueryOne(21);
        first.setHeaderOne("header");
        ServiceResponse<Void> group = client.getParameterGroupingOperations().postSharedParameterGroupObject(first);
    }
}
