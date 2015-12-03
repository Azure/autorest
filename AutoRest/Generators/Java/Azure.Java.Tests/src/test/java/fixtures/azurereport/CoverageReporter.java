package fixtures.azurereport;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public final class CoverageReporter {
    private static AutoRestReportServiceForAzure client = new AutoRestReportServiceForAzureImpl("http://localhost:3000");

    private CoverageReporter() { }

    public static void main(String[] args) throws Exception {
        Map<String, Integer> report = client.getReport().getBody();

        // Pending URL encoding
        report.put("AzureMethodPathUrlEncoding", 1);
        report.put("AzurePathPathUrlEncoding", 1);
        report.put("AzureSwaggerPathUrlEncoding", 1);
        report.put("AzureMethodQueryUrlEncoding", 1);
        report.put("AzurePathQueryUrlEncoding", 1);
        report.put("AzureSwaggerQueryUrlEncoding", 1);

        int total = report.size();
        int hit = 0;
        List<String> missing = new ArrayList<String>();
        for (Map.Entry<String, Integer> entry : report.entrySet()) {
            if (entry.getValue() != 0) {
                hit++;
            } else {
                missing.add(entry.getKey());
            }
        }
        System.out.println(hit + " out of " + total + " tests hit. Missing tests:");
        for (String scenario : missing) {
            System.out.println(scenario);
        }
    }
}
