package fixtures.bodycomplex;

import fixtures.bodycomplex.implementation.AutoRestComplexTestServiceImpl;
import fixtures.bodycomplex.models.Dog;
import fixtures.bodycomplex.models.Siamese;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.ArrayList;

public class InheritanceTests {
    private static AutoRestComplexTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestComplexTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getValid() throws Exception {
        Siamese result = client.inheritances().getValid();
        Assert.assertEquals("persian", result.breed());
        Assert.assertEquals("green", result.color());
        Assert.assertEquals(2, result.id().intValue());
        Assert.assertEquals("Siameeee", result.name());
        Assert.assertEquals("french fries", result.hates().get(1).food());
    }

    @Test
    public void putValid() throws Exception {
        Siamese body = new Siamese();
        body.withBreed("persian");
        body.withColor("green");
        body.withId(2);
        body.withName("Siameeee");
        body.withHates(new ArrayList<Dog>());
        Dog dog1 = new Dog();
        dog1.withName("Potato");
        dog1.withId(1);
        dog1.withFood("tomato");
        body.hates().add(dog1);
        Dog dog2 = new Dog();
        dog2.withFood("french fries");
        dog2.withId(-1);
        dog2.withName("Tomato");
        body.hates().add(dog2);
        client.inheritances().putValid(body);
    }
}
