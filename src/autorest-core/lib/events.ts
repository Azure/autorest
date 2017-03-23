import * as events from 'events';

export interface IEvent<TSender extends events.EventEmitter, TArgs> {
  Subscribe(fn: (sender: TSender, args: TArgs) => void): () => void;
  Unsubscribe(fn: (sender: TSender, args: TArgs) => void): void;
  /* @internal */ Dispatch(args: TArgs): void;
}

export class EventDispatcher<TSender extends EventEmitter, TArgs> implements IEvent<TSender, TArgs> {
  private _instance: TSender;
  private _name: string;
  private _subscriptions = new Array<() => void>();

  constructor(instance: TSender, name: string) {
    this._instance = instance;
    this._name = name;
  }

  UnsubscribeAll() {
    // call all the unsubscribes 
    for (let each of this._subscriptions) {
      each();
    }
    // and clear the subscriptions.
    this._subscriptions.length = 0;
  }

  Subscribe(fn: (sender: TSender, args: TArgs) => void): () => void {
    if (fn) {
      this._instance.addListener(this._name, fn);
    }
    let unsub = () => { this.Unsubscribe(fn) };
    this._subscriptions.push(unsub);
    return unsub;
  }

  Unsubscribe(fn: (sender: TSender, args: TArgs) => void): void {
    if (fn) {
      this._instance.removeListener(this._name, fn)
    }
  }

  Dispatch(args: TArgs): void {
    this._instance.emit(this._name, this._instance, args)
  }
}

export class EventEmitter extends events.EventEmitter {
  private _subscriptions: Map<string, any> = new Map();

  constructor() {
    super();
    this._init(this);
  }

  protected static Event<TSender extends EventEmitter, TArgs>(target: TSender, propertyKey: string) {
    var init = target._init;
    target._init = (instance: TSender) => {
      let i = instance;
      // call previous init
      init.bind(instance)(instance);

      instance._subscriptions.set(propertyKey, new EventDispatcher<TSender, TArgs>(instance, propertyKey));

      var prop: PropertyDescriptor = {
        enumerable: true,
        get: () => {
          return instance._subscriptions.get(propertyKey);
        }
      };
      Object.defineProperty(instance, propertyKey, prop);
    }
  };

  protected _init(t: EventEmitter) {
  }
}