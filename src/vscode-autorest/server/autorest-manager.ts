import { AutoRest } from '../../autorest';

import { DocumentContext } from './file-system';
import * as a from '../lib/ref/async'
import { EventEmitter, IEvent, IFileSystem, DocumentType, DocumentExtension } from "autorest";
import { IConnection, TextDocumentIdentifier, TextDocumentChangeEvent, TextDocuments, DidChangeWatchedFilesParams } from "vscode-languageserver";
import { From } from '../lib/ref/linq'
import * as vfs from 'vinyl-fs';
import * as path from 'path';
import * as crypto from 'crypto'
const md5 = (content: string) => content ? crypto.createHash('md5').update(content).digest("hex") : null;

export class File extends EventEmitter {
  private _content: string | null;
  private _checksum: string | null;
  public IsActive: boolean = false;

  @EventEmitter.Event public Changed: IEvent<File, boolean>;

  public get content(): Promise<string | null> {
    if (this._content) {
      return Promise.resolve<string>(this._content);
    }

    // need to reload the content.
    return new Promise<string>(async (r, j) => {
      try {
        // acquire the content and set the checksum.
        this.SetContent(await a.readFile(this.fullPath));
      } catch (exception) {
        // failed! well, set the content to null. it'll try again later. 
        this.SetContent(null);
      }
      return this._content;
    });
  };

  public SetContent(text: string | null) {
    const ck = md5(text);
    if (ck == this._checksum) {
      // no change!
      return;
    }
    this._content = text;
    this._checksum = null;
    this.Changed.Dispatch(text == null);
  };

  public get checksum(): Promise<string> {
    return (async () => this._checksum ? this._checksum : (this._checksum = md5(await this.content)))();
  }

  constructor(public readonly fullPath: string) {
    super();
  }
}

export class AutoRestManager extends TextDocuments {
  private trackedFiles = new Map<string, File>();
  private activeContexts = new Map<string, DocumentContext>();

  private _rootUri: string | null = null;

  public get RootUri(): string {
    return this._rootUri;
  }

  public async SetRootUri(uri: string): Promise<void> {
    // when we set the RootURI we look to see if we have a configuration file 
    // there, and then we automatically start validating that folder.

    if (this._rootUri) {
      // I'm assuming that this doesn't happen...
      throw new Error("BAD ASSUMPTION DUDE.")
    }

    let ctx = this.activeContexts.get(uri);
    if (ctx) {
      // we already have this as an active context. That's ok
    } else {
      // not an active context -- this is the expectation.
      try {
        ctx = new DocumentContext(uri);
        this.activeContexts.set(uri, ctx);
        ctx.Activate();
      } catch (exception) {
        // that's not good. 

      }
    }
  }

  constructor(private connection: IConnection) {
    super();

    // ask vscode to track 
    this.onDidOpen((open) => this.opened(open));
    this.onDidChangeContent((change) => this.changed(change));
    this.onDidClose((close) => this.closed(close));

    // we also get change notifications of files on disk:
    connection.onDidChangeWatchedFiles((changes) => this.changedOnDisk(changes));

    this.listen(connection);
  }

  private changedOnDisk(changes: DidChangeWatchedFilesParams) {
    // files on disk changed in the workspace. Let's see if we care.
    // changes.changes[0].type 1/2/3 == created/changed/deleted
    // changes.changes[0].uri
    for (const each of changes.changes) {
      let doc = this.trackedFiles.get(each.uri);
      if (doc) {
        // we are currently tracking this file already.
        if (doc.IsActive) {
          // the document is active, which means that we take orders from VSCode, not the disk.
          // (the file may be modified on the disk, but from our perspective, vscode owns the file until its closed.)
        } else {
          // lets reset the content, and it'll reload it at some other time.
          doc.SetContent(null);
        }
      }
      // we didn't track this file before, so unless something asks for it, we're not going to do anything.
    }
  }

  private async AcquireTrackedFile(documentUri: string): Promise<File> {
    let doc = this.trackedFiles.get(documentUri);
    if (doc) {
      return doc;
    }
    // not tracked yet, let's do that now.
    return new File(documentUri);
  }

  private async GetDocumentContextForDocument(documentUri: string): Promise<DocumentContext> {
    // get the folder for this documentUri
    let folder = path.dirname;

    // :CHECK FOLDER:    
    // is there a root at that folder 
    a.readdir()

    //   yes -- is it still valid ? (is it without configuration?)
    //     yes -- cool, that's it.

    //     no -- it's not valid anymore. continue searching.

    //   no -- lets go up a folder and try again  (:CHECK FOLDER:)

    // did not find a configuration folder
    // we will assume that folder for this document is the right one.
    // and create a 'root' without configuration 

    return null;
  }

  private async opened(open: TextDocumentChangeEvent): Promise<void> {
    if (!DocumentType[open.document.languageId]) {
      // we don't do anything with files that aren't one of our concerned types.
      return;
    }

    let doc = this.trackedFiles.get(open.document.uri);
    // are we tracking this file?
    if (doc) {
      // yes we are. 
      doc.SetContent(open.document.getText());
      doc.IsActive = true;
      return;
    }

    // not before this, but now we should
    let root = await this.GetDocumentContextForDocument(open.document.uri);
    // hey garrett -- make sure that the event dispatch in vscode doesn't wait for this method or makes this bad for some reason.
    let file = new File(open.document.uri);
    file.Changed.Subscribe(root.ChangedFile)
  }

  private changed(change: TextDocumentChangeEvent) {
    if (!DocumentType[change.document.languageId]) {
      // we don't do anything with files that aren't one of our concerned types.
      return;
    }
    let doc = this.trackedFiles.get(change.document.uri);
    if (doc) {
      // set the document content.
      doc.SetContent(change.document.getText());
    }
  }

  private closed(close: TextDocumentChangeEvent) {
    // if we have this document, we can mark it 
    let doc = this.trackedFiles.get(close.document.uri);
    if (doc) {
      // we're not tracking this from vscode anymore.
      doc.IsActive = false;
    }
  }

}