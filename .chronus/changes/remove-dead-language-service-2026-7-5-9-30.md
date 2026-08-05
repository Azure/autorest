---
changeKind: breaking
packages:
  - "@autorest/core"
  - "autorest"
---

Remove the non-functional `language-service` entrypoint. Its implementation had been entirely commented out, so the published `autorest-language-service` bin and the `autorest --language-service` dispatch resolved to an empty bundle.
