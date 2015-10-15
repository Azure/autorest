package fixtures.azurereport;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class CoverageReporter {
    static AutoRestReportServiceForAzure client = new AutoRestReportServiceForAzureImpl("http://localhost:3000");

    public static void main(String[] args) throws Exception {
        Map<String, Integer> report = client.getReport();

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
