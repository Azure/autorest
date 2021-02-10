// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

import path from "path";
import { AutoRestGenerateResult } from "./runner";
import * as Diff from "diff";

/**
 * A function which compares two items and returns a CompareResult.
 */
export type Comparer<TItem extends NamedItem> = (oldItem: TItem, newItem: TItem) => CompareResult;

/**
 * An item with a name.  The name is typically used to compare lists
 * of similar items to determine whether one exists in both lists.
 */
export interface NamedItem {
  name: string;
}

/**
 * An item with an order identifier.  This is used when an item should have
 * its list order taken into consideration when being compared.
 */
export interface OrderedItem extends NamedItem {
  ordinal: number;
}

/**
 * Describes details of a specific file, particularly its name (relative path
 * and file name) and the base path from which relative paths can be resolved.
 */
export interface FileDetails {
  name: string;
  basePath: string;
}

/**
 * Enumerates the types of messages that may be emitted.
 */
export enum MessageType {
  /**
   * An outline message for organizational purposes.
   */
  Outline,

  /**
   * A plain string, used mainly for output messages.
   */
  Plain,

  /**
   * A message that indicates an item was added.
   */
  Added,

  /**
   * A message that indicates an item was removed.
   */
  Removed,

  /**
   * A message that indicates an item has changed.
   */
  Changed,
}

/**
 * Describes a message that is emitted from a comparison of two semantic
 * elements in the generated source.  The total comparison output is treated as
 * an outline where nodes can have children which report differences
 * recursively.
 */
export type CompareMessage = {
  /**
   * The message describing this
   */
  message: string;

  /**
   * The MessageType that indicates what kind of message is conveyed.
   */
  type: MessageType;

  /**
   * The child messages that provide futher comparison granularity.
   */
  children?: CompareMessage[];
};

export type CompareResult = CompareMessage | undefined;

/**
 * Simplifies the creation of a `CompareResult` which only needs to be returned
 * when there are child messages for a comparison output.
 */
export function prepareResult(message: string, messageType: MessageType, results: CompareResult[]): CompareResult {
  const children = results.filter((r) => r !== undefined);
  return children.length > 0
    ? {
        message,
        type: messageType,
        children: children as CompareMessage[],
      }
    : undefined;
}

/**
 * Compares two lists of items, reporting on any items that are added or removed
 * in the new list and the differences between items with the same name that
 * exist in both lists.  If `isOrderSignificant` is passed, items with an
 * `ordinal` property have their list order compared so that reorderings can be
 * reported.
 *
 * @param resultMessage The message for the CompareResult that is returned from
 *                      this comparison.
 * @param messageType   The type of message returned from this comparison.
 * @param oldItems      The array of "old" items to compare against.
 * @param newItems      The array of "new" items to compare from.
 * @param compareFunc   The Comparer to use when comparing items that exist in both arrays.
 * @param isOrderSignificant When true, the `ordinal` field of two items is also
                             considered during comparisons.
 */
export function compareItems<TItem extends NamedItem>(
  resultMessage: string,
  messageType: MessageType,
  oldItems: TItem[],
  newItems: TItem[],
  compareFunc: Comparer<TItem>,
  isOrderSignificant?: boolean,
): CompareResult {
  const messages: CompareMessage[] = [];
  let orderChanged = false;

  // Build an index of the new items
  const oldItemIndex: any = {};
  for (const oldItem of oldItems) {
    oldItemIndex[oldItem.name] = oldItem;
  }

  for (const newItem of newItems) {
    if (newItem.name in oldItemIndex) {
      // Delete the item from the index because it exists in both
      const oldItem = oldItemIndex[newItem.name];
      delete oldItemIndex[newItem.name];

      // If the items are ordered, compare the order
      if (isOrderSignificant && orderChanged === false) {
        const oldOrder: number | undefined = (oldItem as any).ordinal;
        const newOrder: number | undefined = (newItem as any).ordinal;

        orderChanged = oldOrder !== undefined && newOrder !== undefined && oldOrder !== newOrder;

        if (orderChanged) {
          messages.push({
            message: "Order Changed",
            type: MessageType.Outline,
            children: [
              {
                message: oldItems.map((i) => i.name).join(", "),
                type: MessageType.Removed,
              },
              {
                message: newItems.map((i) => i.name).join(", "),
                type: MessageType.Added,
              },
            ],
          });
        }
      }

      // Compare the two items and store the result if one was
      // returned because this indicates a difference
      const result = compareFunc(oldItem, newItem);
      if (result) {
        messages.push(result);
      }
    } else {
      messages.push({
        message: newItem.name,
        type: MessageType.Added,
      });
    }
  }

  // If there are any items left in oldItemIndex it means they
  // were not present in newItems
  for (const oldItemName of Object.keys(oldItemIndex)) {
    // Insert removed items at the front of the list
    messages.unshift({
      message: oldItemName,
      type: MessageType.Removed,
    });
  }

  return prepareResult(resultMessage, messageType, messages);
}

/**
 * Compares two arrays of strings using `compareItems` as the underlying
 * algorithm.
 */
export function compareStrings(
  resultMessage: string,
  oldItems: string[] | undefined,
  newItems: string[] | undefined,
): CompareResult {
  return compareItems(
    resultMessage,
    MessageType.Outline,
    (oldItems || []).map((name) => ({ name })),
    (newItems || []).map((name) => ({ name })),
    (o, n) => undefined,
  );
}

/**
 * Performs a strict comparison of two values and returns a message
 * reporting the difference, if any.
 */
export function compareValue(message: string, oldValue: any, newValue: any): CompareResult {
  return oldValue !== newValue
    ? {
        message,
        type: MessageType.Outline,
        children: [
          { message: `${oldValue}`, type: MessageType.Removed },
          { message: `${newValue}`, type: MessageType.Added },
        ],
      }
    : undefined;
}

const maxPlainDiffLines = 5;
function getDiffMessage(diffChange: Diff.Change): CompareMessage {
  let message = diffChange.value;
  let messageType = MessageType.Plain;

  if (diffChange.added) {
    messageType = MessageType.Added;
  } else if (diffChange.removed) {
    messageType = MessageType.Removed;
  } else {
    // Trim plain messages so that they don't take up too much space
    const messageLines = message.split("\n");
    if (messageLines.length > maxPlainDiffLines) {
      message = `${messageLines.slice(0, maxPlainDiffLines).join("\n")}\n... [trimmed for brevity] ...`;
    }
  }

  return {
    message,
    type: messageType,
  };
}

/**
 * Compares the textual contents of two strings and produces a line-by-line
 * diff.
 */
export function compareText(
  message: string,
  oldString: string | undefined,
  newString: string | undefined,
): CompareResult {
  const wrapperMessage = {
    message,
    type: MessageType.Outline,
  };

  if (oldString === undefined && newString === undefined) {
    return undefined;
  } else if (oldString === undefined || newString === undefined) {
    return {
      ...wrapperMessage,
      children: [
        {
          message: oldString ?? newString ?? "",
          type: oldString === undefined ? MessageType.Added : MessageType.Removed,
        },
      ],
    };
  } else {
    const diff = Diff.diffLines(oldString, newString);
    return diff.length > 0 && !(diff.length === 1 && diff[0].value.length === newString.length)
      ? {
          ...wrapperMessage,
          children: diff.map(getDiffMessage),
        }
      : undefined;
  }
}

/**
 * Represents an object with file extensions ("ts", "json", etc) as keys and
 * file comparer functions as the associated values.
 */
export interface ComparerIndex {
  [key: string]: Comparer<FileDetails>;
}

/**
 * Specifies options for comparing source files.
 */
export interface CompareSourceOptions {
  comparersByType: ComparerIndex;
}

/**
 * Compares two files which are considered to be the same (having the same file
 * path) using a comparer that is selected based on the file's extension.
 */
export function compareFile(oldFile: FileDetails, newFile: FileDetails, options: CompareSourceOptions): CompareResult {
  const extension = path.extname(oldFile.name).substr(1);
  const comparer = options.comparersByType[extension];
  return comparer ? comparer(oldFile, newFile) : undefined;
}

/**
 * Compares the set of output files for two AutoRest runs.
 */
export function compareOutputFiles(
  baseResult: AutoRestGenerateResult,
  nextResult: AutoRestGenerateResult,
  options: CompareSourceOptions,
): CompareResult {
  return compareItems(
    "Generated Output Files",
    MessageType.Outline,
    baseResult.outputFiles.map((file) => ({
      name: file,
      basePath: baseResult.outputPath,
    })),
    nextResult.outputFiles.map((file) => ({
      name: file,
      basePath: nextResult.outputPath,
    })),
    (oldFile, newFile) => compareFile(oldFile, newFile, options),
  );
}

/**
 * Compares the timeElapsed of two AutoRestResults to see if the AutoRest
 * runtime has improved or degraded between the two runs.
 */
export async function compareDuration(
  baseResult: AutoRestGenerateResult,
  nextResult: AutoRestGenerateResult,
): Promise<void> {
  // TODO: Write some logic for this
}
