package fixtures.azureparametergrouping;

import com.microsoft.rest.ServiceResponse;
import fixtures.azureparametergrouping.models.ParameterGroupingPostRequiredParameters;
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
    public void getSampleResourceGroup() throws Exception {
        ServiceResponse<Void> group = client.getParameterGrouping().postRequired(new ParameterGroupingPostRequiredParameters());
    }
}
