package fixtures.azureparametergrouping;

import com.microsoft.rest.credentials.BasicAuthenticationCredentials;
import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.azureparametergrouping.implementation.AutoRestParameterGroupingTestServiceImpl;
import fixtures.azureparametergrouping.models.FirstParameterGroup;
import fixtures.azureparametergrouping.models.ParameterGroupingPostMultiParamGroupsSecondParamGroup;
import fixtures.azureparametergrouping.models.ParameterGroupingPostOptionalParameters;
import fixtures.azureparametergrouping.models.ParameterGroupingPostRequiredParameters;

public class ParameterGroupingTests {
    private static AutoRestParameterGroupingTestServiceImpl client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestParameterGroupingTestServiceImpl("http://localhost:3000", new BasicAuthenticationCredentials(null, null));
    }

    @Test
    public void postRequired() throws Exception {
        ParameterGroupingPostRequiredParameters params = new ParameterGroupingPostRequiredParameters();
        params.withBody(1234);
        params.withPath("path");
        params.withQuery(21);
        params.withCustomHeader("header");
        client.parameterGroupings().postRequired(params);
    }

    @Test
    public void postOptional() throws Exception {
        ParameterGroupingPostOptionalParameters params = new ParameterGroupingPostOptionalParameters();
        params.withQuery(21);
        params.withCustomHeader("header");
        client.parameterGroupings().postOptional(params);
    }

    @Test
    public void postMultipleParameterGroups() throws Exception {
        FirstParameterGroup first = new FirstParameterGroup();
        first.withQueryOne(21);
        first.withHeaderOne("header");
        ParameterGroupingPostMultiParamGroupsSecondParamGroup second = new ParameterGroupingPostMultiParamGroupsSecondParamGroup();
        second.withHeaderTwo("header2");
        second.withQueryTwo(42);
        client.parameterGroupings().postMultiParamGroups(first, second);
    }

    @Test
    public void postParameterGroupWithSharedParameter() throws Exception {
        FirstParameterGroup first = new FirstParameterGroup();
        first.withQueryOne(21);
        first.withHeaderOne("header");
        client.parameterGroupings().postSharedParameterGroupObject(first);
    }
}
