/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

/**
 * Creates an intersection object from two source objects.
 *
 * Typescript nicely supports defining intersection types (ie, Foo & Bar )
 * But if you have two seperate *instances*, and you want to use them as the implementation
 * of that intersection, the language doesn't solve that for you.
 *
 * This function creates a strongly typed proxy type around the two objects,
 * and returns members for the intersection of them.
 *
 * This works well for properties and member functions the same.
 *
 * Members in the primary object will take precedence over members in the secondary object if names conflict.
 *
 * This can also be used to "add" arbitrary members to an existing type (without mutating the original object)
 *
 * @example
 * const combined = intersect( new Foo(), { test: () => { console.log('testing'); } });
 * combined.test(); // writes out 'testing' to console
 *
 * @param primary primary object - members from this will have precedence.
 * @param secondary secondary object - members from this will be used if primary does not have a member
 */
export function intersect<T extends object, T2 extends object>(primary: T, secondary: T2): T & T2 {
  return <T & T2>(<any>new Proxy(
    { primary, secondary },
    {
      // member get proxy handler
      get(target, property, receiver) {
        // check for properties on the objects first
        const propertyName = property.toString();
        if (Object.getOwnPropertyNames(target.primary).indexOf(propertyName) > -1) {
          return (<any>target.primary)[property];
        }
        if (Object.getOwnPropertyNames(target.secondary).indexOf(propertyName) > -1) {
          return (<any>target.secondary)[property];
        }

        // try binding member function
        if (typeof (<any>target.primary)[property] === "function") {
          return (<any>target.primary)[property].bind(primary);
        }
        if (typeof (<any>target.secondary)[property] === "function") {
          return (<any>target.secondary)[property].bind(secondary);
        }

        return (<any>target.primary)[property] || (<any>target.secondary)[property];
      },

      // member set proxy handler
      set(target, property, value) {
        const propertyName = property.toString();

        if (Object.getOwnPropertyNames(target.primary).indexOf(propertyName) > -1) {
          return ((<any>target.primary)[property] = value);
        }
        if (Object.getOwnPropertyNames(target.secondary).indexOf(propertyName) > -1) {
          return ((<any>target.secondary)[property] = value);
        }
        return undefined;
      },
    },
  ));
}
