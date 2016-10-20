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

import java.util.List;

/**
 * The Cat model.
 */
public class Cat extends Pet {
    /**
     * The color property.
     */
    private String color;

    /**
     * The hates property.
     */
    private List<Dog> hates;

    /**
     * Get the color value.
     *
     * @return the color value
     */
    public String color() {
        return this.color;
    }

    /**
     * Set the color value.
     *
     * @param color the color value to set
     * @return the Cat object itself.
     */
    public Cat withColor(String color) {
        this.color = color;
        return this;
    }

    /**
     * Get the hates value.
     *
     * @return the hates value
     */
    public List<Dog> hates() {
        return this.hates;
    }

    /**
     * Set the hates value.
     *
     * @param hates the hates value to set
     * @return the Cat object itself.
     */
    public Cat withHates(List<Dog> hates) {
        this.hates = hates;
        return this;
    }

}
