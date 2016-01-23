package fixtures.azureparametergrouping;

import com.microsoft.rest.ServiceResponse;
import fixtures.azureparametergrouping.models.FirstParameterGroup;
import fixtures.azureparametergrouping.models.ParameterGroupingPostMultipleParameterGroupsSecondParameterGroup;
import fixtures.azureparametergrouping.models.ParameterGroupingPostOptionalParameters;
import fixtures.azureparametergrouping.models.ParameterGroupingPostRequiredParameters;
import org.junit.BeforeClass;
import org.junit.Test;

public class ParameterGroupingTests {
    private static AutoRestParameterGroupingTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestParameterGroupingTestServiceImpl("http://localhost.:3000");
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
        ParameterGroupingPostMultipleParameterGroupsSecondParameterGroup second = new ParameterGroupingPostMultipleParameterGroupsSecondParameterGroup();
        second.setHeaderTwo("header2");
        second.setQueryTwo(42);
        ServiceResponse<Void> group = client.getParameterGroupingOperations().postMultipleParameterGroups(first, second);
    }

    @Test
    public void postParameterGroupWithSharedParameter() throws Exception {
        FirstParameterGroup first = new FirstParameterGroup();
        first.setQueryOne(21);
        first.setHeaderOne("header");
        ServiceResponse<Void> group = client.getParameterGroupingOperations().postSharedParameterGroupObject(first);
    }
}
