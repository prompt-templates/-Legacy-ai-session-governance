# External Knowledge Surface Pointer

Created: <date> (via guided wizard, AI-assisted)
Governance: AGENTS.md §10b External Knowledge Surface

> This file declares the project's external knowledge surface(s) so that AI sessions know what to read at startup, what to sync during PERSIST, and what to verify at closeout. Multiple tools and scopes are supported — list each scope as a separate block below.

---

## Scope 1

**Tool**: <Notion | Obsidian | Google Drive | Dropbox Paper | Apple Notes | Logseq | Roam | Anytype | other — specify name>

**Entry URL or identifier**: <e.g. https://www.notion.so/workspace/Database-ID, vault path, drive folder URL, etc.>

**Access mode**: <Mirror | Bridge | Mixed>
- *Mirror* — local repo is source of truth; external tool is a view / consume copy.
- *Bridge* — external tool is source of truth; local repo holds this pointer only.
- *Mixed* — combine per sub-scope (specify in Notes).

**AI access variant**: <Direct (MCP / API / sync-folder) | Paste-only>
- *Direct* — AI may read / write programmatically; subject to §10b Cloud-side destructive op safety.
- *Paste-only* — AI relies on user to paste content; AI cannot write back automatically.

**In-scope items** (URLs, IDs, vault paths, or folder paths that belong to this project's external surface):
- <item 1>
- <item 2>
- <item 3>

**Sync expectation**: <Every PERSIST | Per session | Weekly batch | Manual only>
- *Every PERSIST* — sync immediately after every PERSIST phase.
- *Per session* — sync once per session at closeout.
- *Weekly batch* — collect changes; user runs sync manually weekly.
- *Manual only* — AI does not auto-sync; user controls all sync timing.

**Permission scope note**: <if AI's access token has wider permission than this scope, record self-limit rule here — e.g. "only this database; ignore other workspace pages">

**Notes**: <free text — special handling, edge cases, history of mode changes, etc.>

---

## Scope 2 (optional — add more blocks as needed)

<repeat the Scope 1 structure for additional tools or sub-scopes>

---

## Change Log

| Date (UTC) | Session ID | Change |
|---|---|---|
| <YYYY-MM-DD> | <session-id> | Initial setup via wizard |
