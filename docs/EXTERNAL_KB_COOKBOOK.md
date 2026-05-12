# External Knowledge Surface Cookbook

> **Purpose**: tool-specific best-practice reference for external knowledge surfaces integrated via AGENTS.md §10b governance. This document is **reference, not mandate** — users adapt to their actual tool features, team size, and workflow. The governance core (§10b) stays tool-agnostic; this cookbook records patterns observed across common tools so new users have a starting point.
>
> **Scope**: covers Notion, Obsidian, Google Drive / Dropbox, Apple Notes, Logseq, Roam, Anytype. Each section ends with a "this is reference, not mandate" reminder.

---

## How to use this cookbook

1. Pick the section matching your actual tool.
2. Read the patterns and consider which apply to your scope.
3. Adapt — do not copy wholesale. Your tool features, team size, and workflow differ.
4. When you set up `dev/EXTERNAL_KB.md` via the wizard, the wizard may suggest patterns from this cookbook; you remain free to override.

---

## Notion

### Common patterns observed in advanced setups

- **Database-driven knowledge**: one or more Notion databases as the primary knowledge container; each database row is one page.
- **Status property workflow**: each row has a `Status` property with values like "to-do", "in-progress", "complete" — drives task / project progression.
- **Hub-and-Spoke multi-database structure**: a main database (e.g., a knowledge hub) connects via relation properties to specialized databases (areas, topics, notes, tasks).
- **Self-relation for hierarchy**: `Parent item` / `Sub-item` relations on the same database build page hierarchy without nesting in URL paths.
- **Bi-directional cross-reference**: `Related to X` / `X relates to` paired relations form a knowledge graph.
- **Source-of-entry tracking**: a multi-select property records where each entry originated (Original / Imported / Auto-generated / Migrated).
- **Audit Log text property**: free-text property tracking change history per row.
- **URL property linking to local files**: a URL property points from the Notion page to a local file path (e.g., `D:\projects\foo\bar.md`), enabling cross-referencing without uploading the file.
- **Multi-tag dimension**: pair a broad `Tags` (multi-select) with a domain-specific `Resource Tags` (multi-select) for two-axis classification.

### Suggested AGENTS.md §10b configuration

- **Access mode**: Bridge (Notion is source of truth) or Mixed (Bridge for the main knowledge hub, Mirror for transient daily notes).
- **AI access variant**: Direct, if Notion MCP server is installed and authenticated. Otherwise Paste-only.
- **Scope recording in `dev/EXTERNAL_KB.md`**: record each database URL or ID that belongs to this project. Use Notion's "Copy link to view" or the database URL.
- **Permission scope self-limit**: if AI's access token covers the entire workspace, self-limit to the recorded databases only. Treat all other workspace content as out of scope.
- **Sync expectation**: typically "Every PERSIST" for active databases, "Weekly batch" for archive databases.

### Schema verification before write

When AI writes to a Notion database row, verify the database schema first (property names, types, relation targets) to avoid breaking existing relations. The Notion MCP `fetch` tool returns full schema; use it before constructing the write payload.

### Pattern observed in highly structured PKM setups (illustrative, not required)

Some advanced users build PKM systems with: status workflow, hierarchical self-relation, bi-directional cross-reference, hub-and-spoke multi-database, multi-tag dimensions, source tracking, audit log, and URL property linking to local files all combined. This is **illustrative complexity, not a target**. Most users will use a far simpler subset. Match your scope to your actual needs.

> *Reference, not mandate. Users adapt to actual tool features and scope.*

---

## Obsidian

### Common patterns observed in advanced setups

- **Vault structure**: top-level folders for major areas (e.g., `00-Inbox`, `10-Projects`, `20-Areas`, `30-Resources`, `40-Archive` — the PARA method, or similar).
- **Daily notes**: dated notes capturing per-day context, often with a template.
- **Wiki links for cross-reference**: `[[Note Name]]` syntax creates bi-directional links without manual back-references.
- **Tags for classification**: inline `#tag` or YAML frontmatter `tags:` field; some users layer multiple tag dimensions.
- **YAML frontmatter for metadata**: `created`, `tags`, `status`, `area`, `source`, `related` fields formalize per-note metadata.
- **MOC (Map of Content) pages**: index notes that link to related notes, forming a navigation structure.
- **Graph view as a feature**: heavy use of bi-directional links produces a meaningful graph visualization.
- **Plugins for extension**: Dataview (query notes as a database), Templater (templated note creation), Kanban (task board view), etc.

### Suggested AGENTS.md §10b configuration

- **Access mode**: Mirror (Obsidian vault mirrors a local subfolder) or Bridge (Obsidian is the source of truth, especially when shared across devices via Obsidian Sync, Git, or iCloud).
- **AI access variant**: Direct, via file system. Obsidian vault is a folder of markdown files; AI reads / writes via standard file tools. No MCP is strictly needed — though some users install Obsidian-specific MCP for richer operations.
- **Scope recording in `dev/EXTERNAL_KB.md`**: record the vault root path. Optionally narrow scope to specific subfolders if the vault is large and only part of it belongs to this project.
- **Permission scope self-limit**: limit writes to the recorded subfolder(s); never touch outside the recorded scope even when the vault root is readable.
- **Sync expectation**: typically "Every PERSIST" since file writes are local and fast.

### Subfolder for governance integration

If a user wants AI-managed content to live in the Obsidian vault but separate from manual notes, a convention is to use a `.governance/` or `AI/` subfolder within the vault. This isolates AI writes and makes diffing / review easier.

### Wiki-link maintenance

When AI writes new notes that reference existing notes, use the exact note title in `[[wiki link]]` syntax. If the referenced note does not exist, Obsidian will create a placeholder on first click — typically OK, but flag this in the SESSION_LOG to avoid silent broken-link accumulation.

> *Reference, not mandate. Users adapt to actual tool features and scope.*

---

## Google Drive / Dropbox

### Common patterns observed in advanced setups

- **Folder hierarchy for organization**: top-level folders by area (e.g., `Projects/`, `Clients/`, `Reference/`, `Archive/`), with sub-folders per project.
- **Document templates**: shared templates (Google Docs, Slides, Sheets) instantiated per project.
- **File / asset storage rather than structured knowledge**: Drive and Dropbox typically hold unstructured content (PDFs, images, video, large data files) rather than wiki-style linked knowledge.
- **Sync folder for local access**: Drive / Dropbox sync clients keep a local mirror of the cloud folder, enabling AI file-tool access without API.
- **Sharing and permission scopes**: per-file or per-folder sharing; collaboration via comments and version history.

### Suggested AGENTS.md §10b configuration

- **Access mode**: Mirror (sync folder is the local view; cloud is the canonical store) is the typical setup. Bridge mode is possible for project sources that live only in the cloud.
- **AI access variant**: Direct, via sync folder file system access (most common) or via Drive / Dropbox MCP if available. Paste-only when neither is configured.
- **Scope recording in `dev/EXTERNAL_KB.md`**: record the local sync folder path and the cloud folder URL. List specific sub-folders or files that belong to this project's scope.
- **Permission scope self-limit**: writes restricted to the recorded sub-folders; do not modify files outside the recorded scope even when the sync folder root is writable.
- **Sync expectation**: usually "Every PERSIST" via sync folder; cloud sync runs asynchronously in the background.

### Large-file handling

If the scope includes large binary files (PDFs, video), AI typically should not modify them programmatically. Limit AI writes to metadata (file rename, folder move, sidecar text files) and surface large-file changes for user manual handling.

### Version history awareness

Both Drive and Dropbox maintain version history for edited files. Destructive operations (delete, overwrite) are recoverable for a window — but governance §10b Cloud-side destructive op safety still applies: AI must request confirmation before destructive operations regardless of recoverability.

> *Reference, not mandate. Users adapt to actual tool features and scope.*

---

## Apple Notes

### Common patterns

- **Folder-based organization**: top-level folders contain notes; folder nesting is one level typically.
- **Tagging via inline hashtags**: `#tag` syntax in note body creates clickable tags.
- **Smart folders for filtered views**: rules-based folders that auto-populate matching notes.
- **Rich content support**: photos, sketches, attachments, audio inline.

### Suggested AGENTS.md §10b configuration

- **Access mode**: typically Bridge (Apple Notes is the source of truth) since programmatic access is limited.
- **AI access variant**: typically Paste-only — Apple Notes lacks a public API for third-party AI; AppleScript automation possible but fragile.
- **Scope recording**: record the folder name(s) belonging to this project's scope; entry URLs are not generally accessible.
- **Sync expectation**: typically "Manual only" given the paste-based workflow.

> *Reference, not mandate. Users adapt to actual tool features and scope.*

---

## Logseq / Roam / Anytype

### Common patterns

- **Outliner-style notes**: bullet-based hierarchical content; each bullet is a first-class node.
- **Block-level references**: blocks (bullets) can be referenced and embedded across pages.
- **Daily notes as primary capture**: most input flows through a dated daily note, with cross-references emerging organically.
- **Graph-first**: knowledge structure emerges from cross-references, less from explicit folders.
- **Plugin ecosystems**: each tool has plugins for queries, templates, extensions.

### Suggested AGENTS.md §10b configuration

- **Access mode**:
  - *Logseq*: typically Mirror via local markdown / `.edn` files (Logseq stores notes in a folder of files).
  - *Roam*: typically Bridge via Paste-only (Roam's API is limited and tied to its hosted service).
  - *Anytype*: typically Bridge; local-first architecture with a sync layer.
- **AI access variant**: Logseq supports Direct via file system; Roam and Anytype typically Paste-only unless a community MCP is installed.
- **Scope recording**: record vault / workspace path or graph name and the sub-scope.
- **Sync expectation**: depends on access variant.

> *Reference, not mandate. Users adapt to actual tool features and scope.*

---

## General principles across all tools

1. **Tool neutrality at governance level**: AGENTS.md §10b speaks of "external knowledge surface" generically; this cookbook only adds tool-specific texture. Your `dev/EXTERNAL_KB.md` can mix tools, modes, and access variants per scope.
2. **Scope discipline**: record explicit in-scope items per tool. AI's permission scope often exceeds project scope; self-limit is mandatory.
3. **Sync timing matches workflow**: choose sync expectation (every PERSIST / per session / weekly batch / manual) based on your actual activity rhythm, not theoretical ideals.
4. **Schema verification before write**: AI must read existing structure before writing into structured content. Avoid breaking user-established schemas or relations.
5. **Destructive op safety**: §10b Cloud-side destructive op safety always applies — confirmation before delete / overwrite / bulk modify / schema change, regardless of tool.
6. **Mode switching is a deliberate event**: changing access mode (Mirror to Bridge or vice versa) requires the §10b mode switch protocol — cleanup of stale state, user confirmation, updated pointer file.

> *This cookbook is reference, not mandate. The governance core (AGENTS.md §10b) is the actual rule; this document records tool-specific patterns observed across common setups so new users have a starting point. Users adapt freely to their actual workflows.*
