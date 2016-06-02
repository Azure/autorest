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


/**
 * The Dog model.
 */
public class Dog extends Pet {
    /**
     * The food property.
     */
    private String food;

    /**
     * Get the food value.
     *
     * @return the food value
     */
    public String food() {
        return this.food;
    }

    /**
     * Set the food value.
     *
     * @param food the food value to set
     * @return the Dog object itself.
     */
    public Dog withFood(String food) {
        this.food = food;
        return this;
    }

}
