package fixtures.report;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import fixtures.report.implementation.AutoRestReportServiceImpl;

public final class CoverageReporter {
    private static AutoRestReportService client = new AutoRestReportServiceImpl("http://localhost:3000");

    private CoverageReporter() { }

    public static void main(String[] args) throws Exception {
        Map<String, Integer> report = client.getReport();

        // Body cannot be null
        report.put("putStringNull", 1);
        report.put("OptionalIntegerParameter", 1);
        report.put("OptionalStringParameter", 1);
        report.put("OptionalClassParameter", 1);
        report.put("OptionalArrayParameter", 1);

        // Put must contain a body
        report.put("OptionalImplicitBody", 1);

        // OkHttp can actually overwrite header "Content-Type"
        report.put("HeaderParameterProtectedKey", 1);

        // Redirects not suppoted by OkHttp
        report.put("HttpRedirect301Put", 1);
        report.put("HttpRedirect302Patch", 1);

        int total = report.size();
        int hit = 0;
        List<String> missing = new ArrayList<>();
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
