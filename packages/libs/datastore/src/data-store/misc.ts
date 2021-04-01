export interface PipeState {
  skipping?: boolean;
  excludeFromCache?: boolean;
}

export function mergePipeStates(result: PipeState, ...pipeStates: Array<PipeState>) {
  for (const each of pipeStates) {
    result.skipping === undefined ? each.skipping : result.skipping && each.skipping;
    result.excludeFromCache === undefined ? each.excludeFromCache : result.excludeFromCache || each.excludeFromCache;
  }
  return result;
}
