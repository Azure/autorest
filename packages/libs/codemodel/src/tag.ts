export function SetType<U extends new (...args: any) => any>(prototype: U, instance: any): InstanceType<U> {
  return instance && (<any>prototype).prototype
    ? Object.setPrototypeOf(instance, (<any>prototype).prototype)
    : instance;
}
