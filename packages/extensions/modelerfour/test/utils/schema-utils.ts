export function response(
  code: number | "default",
  contentType: string,
  schema: any,
  description = "The response.",
  extraProperties?: any,
) {
  return {
    [code]: {
      description,
      content: {
        [contentType]: {
          schema,
        },
      },
      ...extraProperties,
    },
  };
}

export function responses(...responses: Array<any>) {
  return responses.reduce((responsesDict, response) => Object.assign(responsesDict, response), {});
}
