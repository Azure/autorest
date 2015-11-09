package fixtures.azureparametergrouping;

import com.microsoft.rest.ServiceResponse;
import fixtures.azureparametergrouping.models.FirstParameterGroup;
import fixtures.azureparametergrouping.models.ParameterGroupingPostOptionalParameters;
import fixtures.azureparametergrouping.models.ParameterGroupingPostRequiredParameters;
import fixtures.azureparametergrouping.models.SecondParameterGroup;
import fixtures.subscriptionidapiversion.models.SampleResourceGroup;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.UUID;

public class ParameterGroupingTests {
    static AutoRestParameterGroupingTestService client;

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
        ServiceResponse<Void> group = client.getParameterGrouping().postRequired(params);
    }

    @Test
    public void postOptional() throws Exception {
        ParameterGroupingPostOptionalParameters params = new ParameterGroupingPostOptionalParameters();
        params.setQuery(21);
        params.setCustomHeader("header");
        ServiceResponse<Void> group = client.getParameterGrouping().postOptional(params);
    }

    @Test
    public void postMultipleParameterGroups() throws Exception {
        FirstParameterGroup first = new FirstParameterGroup();
        first.setQueryOne(21);
        first.setHeaderOne("header");
        SecondParameterGroup second = new SecondParameterGroup();
        second.setHeaderTwo("header2");
        second.setQueryTwo(42);
        ServiceResponse<Void> group = client.getParameterGrouping().postMultipleParameterGroups(first, second);
    }
}
