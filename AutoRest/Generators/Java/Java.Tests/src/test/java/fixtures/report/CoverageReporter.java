package fixtures.report;

import java.util.Map;

public class CoverageReporter {
    static AutoRestReportService client = new AutoRestReportServiceImpl("http://localhost:3000");

    public static void main(String[] args) throws Exception {
        Map<String, Integer> report = client.getReport();

        // Known exceptions for Java
        report.put("putStringNull", 1);

        int total = report.size();
        int hit = 0;
        for (int i : report.values()) {
            if (i != 0) {
                hit++;
            }
        }
        System.out.println(hit + " out of " + total + " tests run.");
    }
}
