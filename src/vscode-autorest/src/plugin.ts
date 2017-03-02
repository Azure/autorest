export interface IPluginResult {
    Registration?: any;
    Disposable: any;
}

export interface IPlugin {
    setup(options?: any): IPluginResult;
}