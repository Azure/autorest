package fixtures.azureparametergrouping;

import com.microsoft.rest.credentials.BasicAuthenticationCredentials;
import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.azureparametergrouping.implementation.AutoRestParameterGroupingTestServiceImpl;
import fixtures.azureparametergrouping.implementation.FirstParameterGroupInner;
import fixtures.azureparametergrouping.implementation.ParameterGroupingPostMultiParamGroupsSecondParamGroupInner;
import fixtures.azureparametergrouping.implementation.ParameterGroupingPostOptionalParametersInner;
import fixtures.azureparametergrouping.implementation.ParameterGroupingPostRequiredParametersInner;


public class ParameterGroupingTests {
    private static AutoRestParameterGroupingTestServiceImpl client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestParameterGroupingTestServiceImpl("http://localhost:3000", new BasicAuthenticationCredentials(null, null));
    }

    @Test
    public void postRequired() throws Exception {
        ParameterGroupingPostRequiredParametersInner params = new ParameterGroupingPostRequiredParametersInner();
        params.withBody(1234);
        params.withPath("path");
        params.withQuery(21);
        params.withCustomHeader("header");
        client.parameterGroupings().postRequired(params);
    }

    @Test
    public void postOptional() throws Exception {
        ParameterGroupingPostOptionalParametersInner params = new ParameterGroupingPostOptionalParametersInner();
        params.withQuery(21);
        params.withCustomHeader("header");
        client.parameterGroupings().postOptional(params);
    }

    @Test
    public void postMultipleParameterGroups() throws Exception {
        FirstParameterGroupInner first = new FirstParameterGroupInner();
        first.withQueryOne(21);
        first.withHeaderOne("header");
        ParameterGroupingPostMultiParamGroupsSecondParamGroupInner second = new ParameterGroupingPostMultiParamGroupsSecondParamGroupInner();
        second.withHeaderTwo("header2");
        second.withQueryTwo(42);
        client.parameterGroupings().postMultiParamGroups(first, second);
    }

    @Test
    public void postParameterGroupWithSharedParameter() throws Exception {
        FirstParameterGroupInner first = new FirstParameterGroupInner();
        first.withQueryOne(21);
        first.withHeaderOne("header");
        client.parameterGroupings().postSharedParameterGroupObject(first);
    }
}
