/**
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 *
 * Code generated by Microsoft (R) AutoRest Code Generator.
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

package fixtures.bodycomplex.models;

import org.joda.time.DateTime;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.fasterxml.jackson.annotation.JsonTypeName;
import com.fasterxml.jackson.annotation.JsonSubTypes;

/**
 * The Shark model.
 */
@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, include = JsonTypeInfo.As.PROPERTY, property = "fishtype")
@JsonTypeName("shark")
@JsonSubTypes({
    @JsonSubTypes.Type(name = "sawshark", value = Sawshark.class),
    @JsonSubTypes.Type(name = "goblin", value = Goblinshark.class),
    @JsonSubTypes.Type(name = "cookiecuttershark", value = Cookiecuttershark.class)
})
public class Shark extends Fish {
    /**
     * The age property.
     */
    private Integer age;

    /**
     * The birthday property.
     */
    @JsonProperty(required = true)
    private DateTime birthday;

    /**
     * Get the age value.
     *
     * @return the age value
     */
    public Integer age() {
        return this.age;
    }

    /**
     * Set the age value.
     *
     * @param age the age value to set
     * @return the Shark object itself.
     */
    public Shark withAge(Integer age) {
        this.age = age;
        return this;
    }

    /**
     * Get the birthday value.
     *
     * @return the birthday value
     */
    public DateTime birthday() {
        return this.birthday;
    }

    /**
     * Set the birthday value.
     *
     * @param birthday the birthday value to set
     * @return the Shark object itself.
     */
    public Shark withBirthday(DateTime birthday) {
        this.birthday = birthday;
        return this;
    }

}
