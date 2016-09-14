package fixtures.bodycomplex;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.HashMap;
import java.util.Map;

import fixtures.bodycomplex.implementation.AutoRestComplexTestServiceImpl;
import fixtures.bodycomplex.models.DictionaryWrapper;

public class DictionaryTests {
    private static AutoRestComplexTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestComplexTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getValid() throws Exception {
        DictionaryWrapper result = client.dictionarys().getValid();
        Assert.assertEquals(5, result.defaultProgram().size());
        Assert.assertEquals("", result.defaultProgram().get("exe"));
        Assert.assertEquals(null, result.defaultProgram().get(""));
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
        body.withDefaultProgram(programs);
        client.dictionarys().putValid(body);
    }

    @Test
    public void getEmpty() throws Exception {
        DictionaryWrapper result = client.dictionarys().getEmpty();
        Assert.assertEquals(0, result.defaultProgram().size());
    }

    @Test
    public void putEmpty() throws Exception {
        DictionaryWrapper body = new DictionaryWrapper();
        body.withDefaultProgram(new HashMap<String, String>());
        client.dictionarys().putEmpty(body);
    }

    @Test
    public void getNull() throws Exception {
        DictionaryWrapper result = client.dictionarys().getNull();
        Assert.assertNull(result.defaultProgram());
    }

    @Test
    public void getNotProvided() throws Exception {
        DictionaryWrapper result = client.dictionarys().getNotProvided();
        Assert.assertNull(result.defaultProgram());
    }
}
