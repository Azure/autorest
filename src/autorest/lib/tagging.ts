
interface TextLocation {
    index: number;
    row: number;
    column: number;
}

interface TextRange {
    start: TextLocation;
    end: TextLocation;
}

interface TextFileRange {
    filePath: string;
    range: TextRange;
}

interface SourceFileLocationTag {
    locKey: TextFileRange[];   // who influenced the path (property names, etc.) leading to this object?
    locValue: TextFileRange[]; // who influenced the value of this object?
}

interface SourceFileLocationTagBag {
    [relativePath: string]: SourceFileLocationTag;
}

type Tags<TTag> = { [path: string]: TTag };
//type Tagged<TObject, TTag> = { [key in keyof TObject]: Tagged<TObject[key], TTag> } & { [key in keyof TTag]: TTag[key] };
//type SourceLocationTagged<TObject> = Tagged<TObject, { _srcLocTags?: SourceFileLocationTagBag }>;

interface SourceLocationTaggedObject {
    _srcLocTags?: SourceFileLocationTagBag;
}