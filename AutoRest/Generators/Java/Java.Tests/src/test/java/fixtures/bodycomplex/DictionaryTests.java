package fixtures.bodycomplex;

import fixtures.bodycomplex.models.ArrayWrapper;
import fixtures.bodycomplex.models.DictionaryWrapper;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

public class DictionaryTests {
    static AutoRestComplexTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestComplexTestServiceImpl("http://localhost.:3000");
    }

    @Test
    public void getValid() throws Exception {
        DictionaryWrapper result = client.getDictionary().getValid();
        Assert.assertEquals(5, result.getDefaultProgram().size());
        Assert.assertEquals("", result.getDefaultProgram().get("exe"));
        Assert.assertEquals(null, result.getDefaultProgram().get(""));
    }

    @Test
    public void putValid() throws Exception {
        DictionaryWrapper body = new DictionaryWrapper();
        Map<String, String> programs = new HashMap<String, String>();
        programs.put("txt", "notepad");
        programs.put("bmp", "mspaint");
        programs.put("xls", "excel");
        programs.put("exe", "");
        programs.put("", null);
        body.setDefaultProgram(programs);
        client.getDictionary().putValid(body);
    }

    @Test
    public void getEmpty() throws Exception {
        DictionaryWrapper result = client.getDictionary().getEmpty();
        Assert.assertEquals(0, result.getDefaultProgram().size());
    }

    @Test
    public void putEmpty() throws Exception {
        DictionaryWrapper body = new DictionaryWrapper();
        body.setDefaultProgram(new HashMap<String, String>());
        client.getDictionary().putEmpty(body);
    }

    @Test
    public void getNull() throws Exception {
        DictionaryWrapper result = client.getDictionary().getNull();
        Assert.assertNull(result.getDefaultProgram());
    }

    @Test
    public void getNotProvided() throws Exception {
        DictionaryWrapper result = client.getDictionary().getNotProvided();
        Assert.assertNull(result.getDefaultProgram());
    }
}
