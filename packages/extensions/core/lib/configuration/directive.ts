export interface Directive {
  from?: Array<string> | string;
  where?: Array<string> | string;
  reason?: string;

  // one of:
  suppress?: Array<string> | string;
  set?: Array<string> | string;
  transform?: Array<string> | string;
  test?: Array<string> | string;
}
