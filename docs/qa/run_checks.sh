#!/usr/bin/env bash
# QA Regression Check Runner for ai-session-governance (main harness)
# Usage: bash docs/qa/run_checks.sh  (run from project root)
# Auto-chains docs/qa/legacy_checks.sh (89 historical drift checks) by default.
# To skip legacy explicitly: LEGACY_SKIP=1 bash docs/qa/run_checks.sh
# Output: only failures + summary line

set -euo pipefail

PASS=0; FAIL=0; TOTAL=0; FAILURES=""

# --- Helpers ---
check() {
  local id="$1" desc="$2" expected="$3" actual="$4"
  TOTAL=$((TOTAL+1))
  if [ "$actual" = "$expected" ]; then
    PASS=$((PASS+1))
  else
    FAIL=$((FAIL+1))
    FAILURES="${FAILURES}\n  FAIL [${id}] ${desc} — expected: ${expected}, got: ${actual}"
  fi
}

check_gte() {
  local id="$1" desc="$2" min="$3" actual="$4"
  TOTAL=$((TOTAL+1))
  if [ "$actual" -ge "$min" ] 2>/dev/null; then
    PASS=$((PASS+1))
  else
    FAIL=$((FAIL+1))
    FAILURES="${FAILURES}\n  FAIL [${id}] ${desc} — expected: >=${min}, got: ${actual}"
  fi
}

A="AGENTS.md"
I="INIT.md"

# ============================================================
# Category 1: Fence Counts & File Structure
# ============================================================
check "S01" "Fence count AGENTS.md = 16" "16" "$(grep -c '^```' $A)"
check "S02" "Fence count INIT.md = 30" "30" "$(grep -c '^```' $I)"
check "S03" "Section count AGENTS.md = 29" "29" "$(grep -c '^## ' $A)"
check "S04" "AGENTS.md fences even" "0" "$(( $(grep -c '^```' $A) % 2 ))"
check "S05" "INIT.md fences even" "0" "$(( $(grep -c '^```' $I) % 2 ))"

# ============================================================
# Category 2: Section Ordering & Position
# ============================================================
s0=$(grep -n "^## 0)" $A | head -1 | cut -d: -f1)
s0a=$(grep -n "^## 0a)" $A | head -1 | cut -d: -f1)
s1=$(grep -n "^## 1)" $A | head -1 | cut -d: -f1)
s2=$(grep -n "^## 2)" $A | head -1 | cut -d: -f1)
s2b=$(grep -n "^## 2b)" $A | head -1 | cut -d: -f1)
s3=$(grep -n "^## 3)" $A | head -1 | cut -d: -f1)
s4=$(grep -n "^## 4)" $A | head -1 | cut -d: -f1)
s4a=$(grep -n "^## 4a)" $A | head -1 | cut -d: -f1)
s0b=$(grep -n "^## 0b)" $A | head -1 | cut -d: -f1)
s5=$(grep -n "^## 5)" $A | head -1 | cut -d: -f1)

check "O01" "§0 before §0a" "1" "$([ $s0 -lt $s0a ] && echo 1 || echo 0)"
check "O02" "§0a before §1" "1" "$([ $s0a -lt $s1 ] && echo 1 || echo 0)"
check "O03" "§1 before §2" "1" "$([ $s1 -lt $s2 ] && echo 1 || echo 0)"
check "O04" "§2 before §2b" "1" "$([ $s2 -lt $s2b ] && echo 1 || echo 0)"
check "O05" "§2b before §3" "1" "$([ $s2b -lt $s3 ] && echo 1 || echo 0)"
check "O06" "§3 before §4" "1" "$([ $s3 -lt $s4 ] && echo 1 || echo 0)"
check "O07" "§4 before §4a" "1" "$([ $s4 -lt $s4a ] && echo 1 || echo 0)"
check "O08" "§0b after §4a (CONDITIONAL zone)" "1" "$([ $s0b -gt $s4a ] && echo 1 || echo 0)"
check "O09" "§0b before §5" "1" "$([ $s0b -lt $s5 ] && echo 1 || echo 0)"
check "O10" "All MANDATORY before §0b" "1" "$([ $s3 -lt $s0b ] && echo 1 || echo 0)"

# ============================================================
# Category 3: Cross-Reference Integrity
# ============================================================
check "X01" "No dead §2c references in AGENTS.md" "0" "$(grep -c '§2c' $A)"
check "X02" "No dead §2c references in INIT.md" "0" "$(grep -c '§2c' $I)"
check "X03" "§3d referenced and exists" "1" "$(grep -c '^## 3d)' $A)"
check "X04" "§4a referenced and exists" "1" "$(grep -c '^## 4a)' $A)"
check "X05" "§3b referenced and exists" "1" "$(grep -c '^## 3b)' $A)"
check "X06" "§8b referenced and exists" "1" "$(grep -c '^## 8b)' $A)"

# ============================================================
# Category 4: Startup & Entry (§0, §0a, §1)
# ============================================================
check "030" "External API Code Safety in AGENTS.md (heading + scope ref)" "2" "$(grep -c 'External API Code Safety' $A)"
check "031" "External API Code Safety in INIT.md (heading + scope ref)" "2" "$(grep -c 'External API Code Safety' $I)"
check "032" "Doc-reviewed field in AGENTS.md" "1" "$(grep -c '^- Doc-reviewed:' $A)"
check "033" "Test-verified field in AGENTS.md" "1" "$(grep -c 'Test-verified:' $A)"
check "036" "Cannot-fetch-docs rule in AGENTS.md" "1" "$(grep -c 'Do not write API-calling code' $A)"
check "037" "§0b parity: External Platform heading" "1" "$([ "$(grep -c 'External Platform Alignment' $A)" = "$(grep -c 'External Platform Alignment' $I)" ] && echo 1 || echo 0)"
check "038" "§1 startup sequence order (anchored to §4 verbatim arrow line)" "1" "$(grep -c 'SESSION_HANDOFF.md → dev/SESSION_LOG.md → dev/CODEBASE_CONTEXT.md' $A)"
check "039" "§10 intent-based trigger" "1" "$(grep -c 'architecture decisions.*tech stack\|tech stack choices.*core feature' $A)"
check "040a" "CODEBASE_CONTEXT in backup AGENTS" "1" "$(grep -c 'CODEBASE_CONTEXT.*if present' $A)"
check "040b" "CODEBASE_CONTEXT in backup INIT (in §5a)" "1" "$(grep -c 'CODEBASE_CONTEXT.*if present' $I)"
check "041a" "SESSION_STATE_DETAIL in §5a backup AGENTS" "1" "$(grep -c 'SESSION_STATE_DETAIL.md.*if present' $A)"
check "041b" "SESSION_STATE_DETAIL in §5a backup INIT" "1" "$(grep -c 'SESSION_STATE_DETAIL.md.*if present' $I)"
check "041c" "PROJECT_MASTER_SPEC in §5a backup AGENTS" "1" "$(grep -c 'PROJECT_MASTER_SPEC.md.*if present' $A)"
check "041d" "PROJECT_MASTER_SPEC in §5a backup INIT" "1" "$(grep -c 'PROJECT_MASTER_SPEC.md.*if present' $I)"
check "042" "No 'key architectural' residue" "0" "$(grep -c 'key architectural' $A)"

# ============================================================
# Category 5: §3d Test Plan Design
# ============================================================
check "043" "§3d heading in AGENTS.md" "1" "$(grep -c '^## 3d) Test Plan' $A)"
check "044" "§3d heading in INIT.md" "1" "$(grep -c '^## 3d) Test Plan' $I)"
check_gte "045" "test scenario matrix in AGENTS.md" "1" "$(grep -c 'test scenario matrix' $A)"
check_gte "046" "test scenario matrix in INIT.md" "1" "$(grep -c 'test scenario matrix' $I)"
check "047" "verify each scenario in AGENTS.md" "1" "$(grep -c 'verify each scenario' $A)"
check "048" "verify each scenario in INIT.md" "1" "$(grep -c 'verify each scenario' $I)"
check_gte "049" "Result values note in AGENTS.md" "1" "$(grep -c 'PASS, PASS with notes' $A)"
check "050" "Test Scenarios template in INIT.md FILE 5" "1" "$(grep -c 'Test Scenarios' $I)"

# ============================================================
# Category 6: Cross-LLM Handoff (§4 rule 5)
# ============================================================
check "052" "Opening line requirement AGENTS.md" "1" "$(grep -c 'Opening line.*verbatim template\|verbatim template' $A)"
check "053" "Opening line requirement INIT.md" "1" "$(grep -c 'Opening line.*verbatim template\|verbatim template' $I)"
check_gte "054" "§1 startup sequence referenced in AGENTS.md" "1" "$(grep -c '§1 startup sequence' $A)"
check "056" "cross-tool handoffs rationale AGENTS.md" "1" "$(grep -c 'cross-tool handoffs' $A)"
check "057" "cross-tool handoffs rationale INIT.md" "1" "$(grep -c 'cross-tool handoffs' $I)"

# ============================================================
# Category 7: §1 New-Session Definition & Governance Gaps (v1.9)
# ============================================================
check "058" "3-trigger block AGENTS.md" "1" "$(grep -c 'Definition of.*new session' $A)"
check "059" "3-trigger block INIT.md" "1" "$(grep -c 'Definition of.*new session' $I)"
check "062" "Agent handoff trigger AGENTS.md" "1" "$(grep -c 'Agent handoff' $A)"
check "063" "Agent handoff trigger INIT.md" "1" "$(grep -c 'Agent handoff' $I)"
check "064" "§3 PERSIST sync AGENTS.md" "1" "$(grep -c 'same cross-document sync conditions' $A)"
check "065" "§3 PERSIST sync INIT.md" "1" "$(grep -c 'same cross-document sync conditions' $I)"
check "068" "Open Priorities regeneration AGENTS.md" "1" "$(grep -c 'Open Priorities regeneration' $A)"
check "069" "Open Priorities regeneration INIT.md" "1" "$(grep -c 'Open Priorities regeneration' $I)"
check "070" "replace not append AGENTS.md" "1" "$(grep -c 'replace, not append' $A)"
check "071" "replace not append INIT.md" "1" "$(grep -c 'replace, not append' $I)"
check "072" "SESSION_LOG summary max-3 AGENTS.md" "1" "$(grep -c 'SESSION_LOG summary field only' $A)"
check "073" "SESSION_LOG summary max-3 INIT.md" "1" "$(grep -c 'SESSION_LOG summary field only' $I)"
check "074" "Known Risks not Open Priorities AGENTS.md" "1" "$(grep -c 'Known Risks.*not Open Priorities' $A)"
check "075" "Known Risks not Open Priorities INIT.md" "1" "$(grep -c 'Known Risks.*not Open Priorities' $I)"
check "078" "§5.7 modification ops AGENTS.md" "1" "$(grep -c 'modification operations (create, delete' $A)"
check "079" "§5.7 modification ops INIT.md" "1" "$(grep -c 'modification operations (create, delete' $I)"

# ============================================================
# Category 8: DOC_SYNC_CHECKLIST (v2.0)
# ============================================================
check "083" "MANDATORY STARTUP marker" "1" "$(grep -c 'MANDATORY STARTUP' $A)"
check "084" "MANDATORY STARTUP in INIT" "1" "$(grep -c 'MANDATORY STARTUP' $I)"
check "085" "MANDATORY WORKFLOW marker" "1" "$(grep -c 'MANDATORY WORKFLOW' $A)"
check "086" "CONDITIONAL marker (no §2c)" "1" "$(grep 'CONDITIONAL.*apply when triggered' $A | grep -cv '§2c')"
check_gte "088" "DOC_SYNC_CHECKLIST referenced AGENTS.md" "1" "$(grep -c 'DOC_SYNC_CHECKLIST.md.*if it exists' $A)"
check_gte "089" "DOC_SYNC_CHECKLIST referenced INIT.md" "1" "$(grep -c 'DOC_SYNC_CHECKLIST.md.*if it exists' $I)"
check "090" "Release gate doc sync AGENTS.md" "1" "$(grep -c 'DOC_SYNC_CHECKLIST.*entries affected' $A)"
check "091" "Release gate doc sync INIT.md" "1" "$(grep -c 'DOC_SYNC_CHECKLIST.*entries affected' $I)"
check "094" "DOC_SYNC in backup AGENTS.md" "1" "$(grep -c 'DOC_SYNC_CHECKLIST.md.*if present' $A)"
check "095" "DOC_SYNC in backup INIT.md (in §5a)" "1" "$(grep -c 'DOC_SYNC_CHECKLIST.md.*if present' $I)"
check "100" "New checklist query AGENTS.md" "1" "$(grep -c 'Query.*DOC_SYNC_CHECKLIST' $A)"
check "101" "New checklist query INIT.md" "1" "$(grep -c 'Query.*DOC_SYNC_CHECKLIST' $I)"
check "102" "FILE 6 heading in INIT.md" "1" "$(grep -c 'FILE 6.*DOC_SYNC_CHECKLIST' $I)"
check "104" "Change Category Registry in INIT" "1" "$(grep -c 'Change Category Registry' $I)"
check "105" "Anti-pattern No Matching Row in INIT" "1" "$(grep -c 'Anti-pattern.*No Matching Row' $I)"
check "106" "DOC_SYNC_CHECKLIST.md exists" "1" "$(test -f dev/DOC_SYNC_CHECKLIST.md && echo 1 || echo 0)"
check "107" "Change Category Registry in checklist" "1" "$(grep -c 'Change Category Registry' dev/DOC_SYNC_CHECKLIST.md)"
check "109" "Governance rule row in checklist" "1" "$(grep -c 'Governance rule change.*AGENTS.md' dev/DOC_SYNC_CHECKLIST.md)"

# ============================================================
# Category 9: Handoff Chain Integrity (v2.1)
# ============================================================
check "112" "§1 Verbatim most-recent-dated AGENTS.md" "1" "$(grep -c 'most recent UTC date' $A)"
check "113" "§1 Verbatim most-recent-dated INIT.md" "1" "$(grep -c 'most recent UTC date' $I)"
check "114" "does not substitute AGENTS.md" "2" "$(grep -c 'does not substitute' $A)"
check "115" "does not substitute INIT.md" "2" "$(grep -c 'does not substitute' $I)"
check "116" "DOC_SYNC Matrix Scan mandatory AGENTS" "1" "$(grep -c 'DOC_SYNC Matrix Scan.*mandatory' $A)"
check "117" "DOC_SYNC Matrix Scan mandatory INIT" "1" "$(grep -c 'DOC_SYNC Matrix Scan.*mandatory' $I)"
check "118" "scan was skipped AGENTS" "1" "$(grep -c 'scan was skipped' $A)"
check "119" "scan was skipped INIT" "1" "$(grep -c 'scan was skipped' $I)"
check "120" "no file changes AGENTS" "1" "$(grep -c 'no file changes this task' $A)"
check "121" "no file changes INIT" "1" "$(grep -c 'no file changes this task' $I)"
check "124" "Post-startup first action AGENTS" "1" "$(grep -c 'Post-startup first action' $A)"
check_gte "125" "Post-startup first action INIT" "1" "$(grep -c 'Post-startup first action' $I)"

# ============================================================
# Category 10: §4a Session Log Maintenance (v2.2)
# ============================================================
check "126" "§4a heading AGENTS" "1" "$(grep -c '4a) Session Log Maintenance' $A)"
check "127" "§4a heading INIT" "1" "$(grep -c '4a) Session Log Maintenance' $I)"
check "128" "400-line trigger AGENTS" "1" "$(grep -c 'exceeds 400 lines' $A)"
check "129" "400-line trigger INIT" "1" "$(grep -c 'exceeds 400 lines' $I)"
check "130" "30-day trigger AGENTS" "1" "$(grep -c 'dated more than 30 days ago' $A)"
check "131" "30-day trigger INIT" "1" "$(grep -c 'dated more than 30 days ago' $I)"
check "132" "200-line target AGENTS" "1" "$(grep -c '200 lines' $A)"
check "133" "200-line target INIT" "1" "$(grep -c '200 lines' $I)"
check "134" "Quarterly format AGENTS" "1" "$(grep -c 'SESSION_LOG_YYYY_QN' $A)"
check "135" "Quarterly format INIT" "2" "$(grep -c 'SESSION_LOG_YYYY_QN' $I)"
check "136" "Never delete AGENTS" "1" "$(grep -c 'Never delete session entries' $A)"
check "137" "Never delete INIT" "1" "$(grep -c 'Never delete session entries' $I)"
check "138" "§4a in CONDITIONAL AGENTS" "1" "$(grep 'CONDITIONAL' $A | grep -c '§4a')"
check "139" "§4a in CONDITIONAL INIT" "1" "$(grep 'CONDITIONAL' $I | grep -c '§4a')"

# §4 Entry Size Cap (v3.0.3) — fail if any SESSION_LOG entry exceeds 110 lines (counted between ^## YYYY-MM-DD headers; includes verbatim block)
check "167" "Entry size cap ≤110 in SESSION_LOG" "0" "$(awk '/^## [0-9]{4}-[0-9]{2}-[0-9]{2}/{if(in_entry && count>110) over++; in_entry=1; count=0; next} in_entry{count++} END{if(in_entry && count>110) over++; print over+0}' dev/SESSION_LOG.md 2>/dev/null || echo 0)"
check "168" "§4 entry-cap rule present in AGENTS" "1" "$(grep -c 'hard cap ≤110 lines per entry' $A)"
check "169" "§4 entry-cap rule present in INIT" "1" "$(grep -c 'hard cap ≤110 lines per entry' $I)"

# §11a Reply Behavior (v3.0.3) — heading parity + key phrases AGENTS/INIT mirror
check "170" "§11a heading AGENTS" "1" "$(grep -c '^## 11a) Reply Behavior' $A)"
check "171" "§11a heading INIT" "1" "$(grep -c '^## 11a) Reply Behavior' $I)"
check "172" "§11a Judgement-first AGENTS" "1" "$(grep -c '\*\*Judgement-first\.\*\*' $A)"
check "173" "§11a Judgement-first INIT" "1" "$(grep -c '\*\*Judgement-first\.\*\*' $I)"
check "174" "§11a UNVERIFIED ≠ NA AGENTS" "1" "$(grep -c 'Unconfirmed = .UNVERIFIED.' $A)"
check "175" "§11a UNVERIFIED ≠ NA INIT" "1" "$(grep -c 'Unconfirmed = .UNVERIFIED.' $I)"

# ============================================================
# Category 11: Governance Audit Fixes (v2.3)
# ============================================================
check "140" "PLAN My understanding AGENTS" "1" "$(grep -c 'My understanding.*1-sentence restatement' $A)"
check "141" "PLAN My understanding INIT" "1" "$(grep -c 'My understanding.*1-sentence restatement' $I)"
check "142" "Conflict arbitration AGENTS" "1" "$(grep -c 'user instruction conflicts.*rule in this document' $A)"
check "143" "Conflict arbitration INIT" "1" "$(grep -c 'user instruction conflicts.*rule in this document' $I)"
check "144" "Triage read note AGENTS" "1" "$(grep -c 'Targeted file reads.*during triage' $A)"
check "145" "Triage read note INIT" "1" "$(grep -c 'Targeted file reads.*during triage' $I)"
check "146" "CHANGE deviation AGENTS" "1" "$(grep -c 'diverges from PLAN.*stop.*report' $A)"
check "147" "CHANGE deviation INIT" "1" "$(grep -c 'diverges from PLAN.*stop.*report' $I)"
check "148" "§8/§8b reconciliation AGENTS" "1" "$(grep -c 'monitoring.*promote to rule if recurrence' $A)"
check "149" "§8/§8b reconciliation INIT" "1" "$(grep -c 'monitoring.*promote to rule if recurrence' $I)"
check "150" "§11 CHANGE or PERSIST AGENTS" "1" "$(grep -c 'CHANGE or PERSIST phase' $A)"
check "151" "§11 CHANGE or PERSIST INIT" "1" "$(grep -c 'CHANGE or PERSIST phase' $I)"
check "152" "§11 exemption AGENTS" "1" "$(grep -c 'clarifying questions.*status updates' $A)"
check "153" "§11 exemption INIT" "1" "$(grep -c 'clarifying questions.*status updates' $I)"
check_gte "154" "CODEBASE_CONTEXT in FILE 4 template" "1" "$(grep -c 'Read.*CODEBASE_CONTEXT' $I)"

# ============================================================
# Category 12: PLAN Risk Grading & Lean Format (v2.4)
# ============================================================
check "156" "Risk level criteria AGENTS" "1" "$(grep -c 'Risk level.*HIGH or LOW' $A)"
check "157" "Risk level criteria INIT" "1" "$(grep -c 'Risk level.*HIGH or LOW' $I)"
check "158" "Lean format AGENTS" "1" "$(grep -c 'lean key-value style' $A)"
check "159" "Lean format INIT" "1" "$(grep -c 'lean key-value style' $I)"
check_gte "160" "FILE 5 bold key format" "1" "$(grep -c '\*\*ID:\*\*' $I)"
check "162" "Archive >400 AGENTS" "1" "$(grep -c '>400 lines' $A)"
check_gte "163" "Archive >400 INIT" "1" "$(grep -c '>400 lines' $I)"
check "164" "HIGH wait AGENTS (FPFR non-veto wording per v3.0.5)" "1" "$(grep -c 'wait for user non-veto' $A)"
check "165" "HIGH wait INIT (FPFR non-veto wording per v3.0.5)" "1" "$(grep -c 'wait for user non-veto' $I)"
check "166" "Assumptions and risks AGENTS" "1" "$(grep -c 'Assumptions and risks' $A)"
check "167" "Assumptions and risks INIT" "1" "$(grep -c 'Assumptions and risks' $I)"
check "168" "Self-challenge removed AGENTS" "0" "$(grep -c 'Challenge own assumptions' $A)"
check "169" "Self-challenge removed INIT" "0" "$(grep -c 'Challenge own assumptions' $I)"

# ============================================================
# Category 13: README Asset & Localization
# ============================================================
for img in ref_doc/overview_infograph_en.png ref_doc/overview_infograph_tw.png ref_doc/overview_infograph_cn.png ref_doc/overview_infograph_ja.png ref_doc/launch.png ref_doc/closesession.png ref_doc/install_step_1.png ref_doc/install_step_2.png ref_doc/install_step_3.png ref_doc/install_step_4.png; do
  check "IMG" "$img exists" "1" "$(test -f "$img" && echo 1 || echo 0)"
done

# ============================================================
# Category 14: Release-Doc Sync Governance (R29 series — v3.0.1)
# Guards against the "release published but README/index.html not updated" drift.
# DOC_SYNC_CHECKLIST.md `Release published` row enumerates required updates.
# ============================================================
# Latest stable tag string — bump explicitly when releasing a new stable version.
# This single-source variable is what regression checks below assert against.
LATEST_STABLE_TAG="v3.0.10"

check "R29-01" "README.md contains latest stable tag row ($LATEST_STABLE_TAG)" "1" "$(grep -c "^| \*\*$LATEST_STABLE_TAG\*\*" README.md)"
check "R29-02" "README.zh-TW.md contains latest stable tag row" "1" "$(grep -c "^| \*\*$LATEST_STABLE_TAG\*\*" README.zh-TW.md)"
check "R29-03" "README.zh-CN.md contains latest stable tag row" "1" "$(grep -c "^| \*\*$LATEST_STABLE_TAG\*\*" README.zh-CN.md)"
check "R29-04" "README.ja.md contains latest stable tag row" "1" "$(grep -c "^| \*\*$LATEST_STABLE_TAG\*\*" README.ja.md)"
check "R29-05" "docs/releases/${LATEST_STABLE_TAG}.md release notes file exists" "1" "$(test -f docs/releases/${LATEST_STABLE_TAG}.md && echo 1 || echo 0)"
check_gte "R29-06" "docs/qa/LATEST.md references latest stable tag" "1" "$(grep -c "$LATEST_STABLE_TAG" docs/qa/LATEST.md)"
# index.html stat counter must reflect total checks (main + legacy);
# value is hardcoded against current run total so any harness check change forces an update.
EXPECTED_INDEX_COUNTER="374"
check "R29-07" "docs/site/index.html stat counter = $EXPECTED_INDEX_COUNTER" "1" "$(grep -c "data-target=\"$EXPECTED_INDEX_COUNTER\"" docs/site/index.html)"
check "R29-08" "DOC_SYNC_CHECKLIST has Release published row" "1" "$(grep -c 'Release published' dev/DOC_SYNC_CHECKLIST.md)"
# README must mention latest stable tag in ≥2 places (version-table row + Snapshot/text body) — guards against
# the regression where the tag row is updated but the rest of the README still describes a previous version.
check_gte "R29-09" "README.md mentions $LATEST_STABLE_TAG in ≥2 places" "2" "$(grep -c "$LATEST_STABLE_TAG" README.md)"
check_gte "R29-10" "README.zh-TW.md mentions $LATEST_STABLE_TAG in ≥2 places" "2" "$(grep -c "$LATEST_STABLE_TAG" README.zh-TW.md)"
check_gte "R29-11" "README.zh-CN.md mentions $LATEST_STABLE_TAG in ≥2 places" "2" "$(grep -c "$LATEST_STABLE_TAG" README.zh-CN.md)"
check_gte "R29-12" "README.ja.md mentions $LATEST_STABLE_TAG in ≥2 places" "2" "$(grep -c "$LATEST_STABLE_TAG" README.ja.md)"

# ============================================================
# R30 series — §3c Release Lifecycle 4-Phase Governance (v3.0.2)
# Guards against the "release-shipped but post-release lifecycle skipped" drift.
# Without these, branch cleanup / sandbox validation / observability stay advisory.
# ============================================================
check "R30-01" "§3c Phase 3: Merge-source branch cleanup rule (AGENTS)" "1" "$(grep -c 'Merge-source branch cleanup' $A)"
check "R30-02" "§3c Phase 3: Merge-source branch cleanup rule (INIT mirror)" "1" "$(grep -c 'Merge-source branch cleanup' $I)"
check "R30-03" "§3c Phase 3: Fresh-environment validation rule (AGENTS)" "1" "$(grep -c 'Fresh-environment validation' $A)"
check "R30-04" "§3c Phase 3: Fresh-environment validation rule (INIT mirror)" "1" "$(grep -c 'Fresh-environment validation' $I)"
check "R30-05" "§3c Phase 4: Track production fail modes rule (AGENTS)" "1" "$(grep -c 'Track production fail modes' $A)"
check "R30-06" "§3c Phase 4: Track production fail modes rule (INIT mirror)" "1" "$(grep -c 'Track production fail modes' $I)"

# ============================================================
# R31 series — §1 Startup transparency + §4 closeout heading rename (v3.0.4)
# Guards against drift on the user-facing closeout block heading and the
# seed-context line that makes auto-fallback behavior visible to the user.
# ============================================================
check "R31-01" "§1 Seed context transparency rule (AGENTS)" "1" "$(grep -c 'Seed context transparency' $A)"
check "R31-02" "§1 Seed context transparency rule (INIT mirror)" "1" "$(grep -c 'Seed context transparency' $I)"
check "R31-03" "§1 Seed context line forms enumerated (AGENTS)" "1" "$(grep -c 'Seed context: paste + SESSION_LOG fallback (consistent)' $A)"
check "R31-04" "§1 Seed context line forms enumerated (INIT mirror)" "1" "$(grep -c 'Seed context: paste + SESSION_LOG fallback (consistent)' $I)"
check "R31-05" "§4 Section 2 heading rename (AGENTS, both rule 3 + skeleton)" "2" "$(grep -c 'NEXT SESSION OPENING MESSAGE' $A)"
check "R31-06" "§4 Section 2 heading rename (INIT mirror — rule 3 + skeleton + Quick Start)" "3" "$(grep -c 'NEXT SESSION OPENING MESSAGE' $I)"
check "R31-07" "Release notes _TEMPLATE.md exists" "1" "$(test -f docs/releases/_TEMPLATE.md && echo 1 || echo 0)"
check_gte "R31-08" "Release notes template has 'What you' mandatory section reference" "1" "$(grep -c 'What you' docs/releases/_TEMPLATE.md)"
check "R31-09" "v3.0.3 release notes contains 'What you'll feel' section (rewrite per template)" "1" "$(grep -c '## What you' docs/releases/v3.0.3.md)"
check "R31-10" "Lifecycle SVG (EN) exists" "1" "$(test -f ref_doc/lifecycle_flow_en.svg && echo 1 || echo 0)"
check "R31-11" "Lifecycle SVG (zh-TW) exists" "1" "$(test -f ref_doc/lifecycle_flow_tw.svg && echo 1 || echo 0)"
check "R31-12" "Lifecycle SVG (zh-CN) exists" "1" "$(test -f ref_doc/lifecycle_flow_cn.svg && echo 1 || echo 0)"
check "R31-13" "Lifecycle SVG (ja) exists" "1" "$(test -f ref_doc/lifecycle_flow_ja.svg && echo 1 || echo 0)"
check "R31-14" "README.md references lifecycle SVG" "1" "$(grep -c 'lifecycle_flow_en.svg' README.md)"
check "R31-15" "README.zh-TW.md references lifecycle SVG" "1" "$(grep -c 'lifecycle_flow_tw.svg' README.zh-TW.md)"
check "R31-16" "README.zh-CN.md references lifecycle SVG" "1" "$(grep -c 'lifecycle_flow_cn.svg' README.zh-CN.md)"
check "R31-17" "README.ja.md references lifecycle SVG" "1" "$(grep -c 'lifecycle_flow_ja.svg' README.ja.md)"

# ============================================================
# R32 series — v3.0.5: Tier 2 meta-instruction integration
# §0c Preference Priority Order / §3.5 FPFR / §3b anti-hardcoding /
# §5 preserve-original / §11a expanded (rules 6-10) / §11b Patch-only /
# §11c Deep-Fix / §13 Tooling Format Rules
# Each new section gets AGENTS + INIT parity check.
# ============================================================
# §0c Preference Priority Order
check "R32-01" "§0c Preference Priority Order present (AGENTS)" "1" "$(grep -c '^## 0c)' $A)"
check "R32-02" "§0c Preference Priority Order present (INIT mirror)" "1" "$(grep -c '^## 0c)' $I)"
check "R32-03" "§0c 5-item priority list — Verifiable correctness (AGENTS)" "1" "$(grep -c 'Verifiable correctness' $A)"
check "R32-04" "§0c 5-item priority list — Verifiable correctness (INIT mirror)" "1" "$(grep -c 'Verifiable correctness' $I)"

# §3.5 FPFR Output Format
check "R32-05" "§3.5 FPFR section present (AGENTS)" "1" "$(grep -c '^## 3.5)' $A)"
check "R32-06" "§3.5 FPFR section present (INIT mirror)" "1" "$(grep -c '^## 3.5)' $I)"
check "R32-07" "§3.5 5-section heading END-STATE SNAPSHOT (AGENTS)" "1" "$(grep -c 'END-STATE SNAPSHOT' $A)"
check "R32-08" "§3.5 5-section heading END-STATE SNAPSHOT (INIT mirror)" "1" "$(grep -c 'END-STATE SNAPSHOT' $I)"
check "R32-09" "§3.5 closing line verbatim (AGENTS)" "1" "$(grep -c '若不否決' $A)"
check "R32-10" "§3.5 closing line verbatim (INIT mirror)" "1" "$(grep -c '若不否決' $I)"
check "R32-11" "§3 PLAN HIGH-risk cross-refs §3.5 (AGENTS)" "1" "$(grep -c '§3.5 FPFR 5-section' $A)"
check "R32-12" "§3 PLAN HIGH-risk cross-refs §3.5 (INIT mirror)" "1" "$(grep -c '§3.5 FPFR 5-section' $I)"

# §3b anti-hardcoding hard rule
check "R32-13" "§3b anti-hardcoding hard rule present (AGENTS)" "1" "$(grep -c 'Hard rule (anti-hardcoding)' $A)"
check "R32-14" "§3b anti-hardcoding hard rule present (INIT mirror)" "1" "$(grep -c 'Hard rule (anti-hardcoding)' $I)"

# §5 rule 9 preserve original
check "R32-15" "§5 rule 9 preserve original files (AGENTS)" "1" "$(grep -c 'preserving original user-supplied files' $A)"
check "R32-16" "§5 rule 9 preserve original files (INIT mirror)" "1" "$(grep -c 'preserving original user-supplied files' $I)"

# §11a expanded rules 6-10
check "R32-17" "§11a rule 6 Reply skeleton (AGENTS)" "1" "$(grep -c '\*\*Reply skeleton\.\*\*' $A)"
check "R32-18" "§11a rule 6 Reply skeleton (INIT mirror)" "1" "$(grep -c '\*\*Reply skeleton\.\*\*' $I)"
check "R32-19" "§11a rule 7 Functional emoji vocabulary (AGENTS)" "1" "$(grep -c 'Functional emoji vocabulary' $A)"
check "R32-20" "§11a rule 7 Functional emoji vocabulary (INIT mirror)" "1" "$(grep -c 'Functional emoji vocabulary' $I)"
check "R32-21" "§11a rule 8 Output-only mode (AGENTS)" "1" "$(grep -c '\*\*Output-only mode\.\*\*' $A)"
check "R32-22" "§11a rule 8 Output-only mode (INIT mirror)" "1" "$(grep -c '\*\*Output-only mode\.\*\*' $I)"
check "R32-23" "§11a rule 9 SSOT verbatim alignment (AGENTS)" "1" "$(grep -c 'SSOT verbatim alignment' $A)"
check "R32-24" "§11a rule 9 SSOT verbatim alignment (INIT mirror)" "1" "$(grep -c 'SSOT verbatim alignment' $I)"
check "R32-25" "§11a rule 10 Reply register consistency (AGENTS)" "1" "$(grep -c '\*\*Reply register consistency\.\*\*' $A)"
check "R32-26" "§11a rule 10 Reply register consistency (INIT mirror)" "1" "$(grep -c '\*\*Reply register consistency\.\*\*' $I)"

# §11b Patch-only Delivery Format
check "R32-27" "§11b Patch-only section present (AGENTS)" "1" "$(grep -c '^## 11b) Patch-only Delivery Format' $A)"
check "R32-28" "§11b Patch-only section present (INIT mirror)" "1" "$(grep -c '^## 11b) Patch-only Delivery Format' $I)"

# §11c Deep-Fix / Final-Landing Mode
check "R32-29" "§11c Deep-Fix section present (AGENTS)" "1" "$(grep -c '^## 11c) Deep-Fix' $A)"
check "R32-30" "§11c Deep-Fix section present (INIT mirror)" "1" "$(grep -c '^## 11c) Deep-Fix' $I)"

# §13 Tooling Format Rules — 3 subsections
check "R32-31" "§13 Tooling Format Rules section present (AGENTS)" "1" "$(grep -c '^## 13) Tooling Format Rules' $A)"
check "R32-32" "§13 Tooling Format Rules section present (INIT mirror)" "1" "$(grep -c '^## 13) Tooling Format Rules' $I)"
check "R32-33" "§13 three subsections present (AGENTS)" "3" "$(grep -cE '^### 13\.[123]' $A)"
check "R32-34" "§13 three subsections present (INIT mirror)" "3" "$(grep -cE '^### 13\.[123]' $I)"

# ============================================================
# R33 series — Onboarding Wizard System (paradigm: draft+iterate)
# §3.6 Onboarding Wizard System / dev/wizards/playbook.md (behavior)
# / dev/templates/ (content) / §5a backup list extension (PROFILE.md +
# RUNBOOK.md) / INIT.md install POST-INSTALL: Profile Selection step
# / wizard_disabled_* flag persistence
# ============================================================

# Wizard system file existence
check "R33-01" "dev/wizards/ directory exists" "1" "$(test -d dev/wizards && echo 1 || echo 0)"
check "R33-04" "dev/wizards/playbook.md exists (behavior layer)" "1" "$(test -f dev/wizards/playbook.md && echo 1 || echo 0)"
check "R33-05" "dev/wizards/README.md exists" "1" "$(test -f dev/wizards/README.md && echo 1 || echo 0)"
check "R33-18" "dev/templates/ directory exists (content layer)" "1" "$(test -d dev/templates && echo 1 || echo 0)"
check "R33-19" "dev/templates/spec_template.md exists" "1" "$(test -f dev/templates/spec_template.md && echo 1 || echo 0)"
check "R33-20" "dev/templates/runbook_template.md exists" "1" "$(test -f dev/templates/runbook_template.md && echo 1 || echo 0)"

# Governance parity (AGENTS.md + INIT.md FILE 1 mirror)
check "R33-10" "§3.6 Onboarding Wizard System present (AGENTS)" "1" "$(grep -c '^## 3.6) Onboarding Wizard System' $A)"
check "R33-11" "§3.6 Onboarding Wizard System present (INIT mirror)" "1" "$(grep -c '^## 3.6) Onboarding Wizard System' $I)"
check_gte "R33-12" "§5a backup list includes PROFILE.md + RUNBOOK.md (AGENTS)" "1" "$(grep -c 'dev/PROFILE.md.*dev/RUNBOOK.md' $A)"
check_gte "R33-13" "§5a backup list includes PROFILE.md + RUNBOOK.md (INIT mirror)" "1" "$(grep -c 'dev/PROFILE.md.*dev/RUNBOOK.md' $I)"
check "R33-14" "INIT.md install POST-INSTALL: Profile Selection step present" "1" "$(grep -c 'POST-INSTALL: Profile Selection (for first-time install only' $I)"

# Wizard decline persistence (PROFILE.md wizard_disabled_* flags)
check_gte "R33-15" "§3 PLAN onboarding check reads PROFILE.md + handles wizard_disabled_spec (AGENTS)" "1" "$(grep -c 'wizard_disabled_spec' $A)"
check_gte "R33-16" "§3 PLAN onboarding check reads PROFILE.md + handles wizard_disabled_spec (INIT mirror)" "1" "$(grep -c 'wizard_disabled_spec' $I)"
check "R33-17" "INIT.md install POST-INSTALL: Profile Selection PROFILE.md template includes wizard_disabled_spec field" "1" "$(grep -c '^wizard_disabled_spec: false' $I)"

# Paradigm patch (2026-05-05): source-grounding discipline + labeled assumption tags + install two-message split
check_gte "R33-21" "§3.6 Source-grounding discipline present (AGENTS)" "1" "$(grep -c 'Source-grounding discipline' $A)"
check_gte "R33-22" "§3.6 Source-grounding discipline present (INIT mirror)" "1" "$(grep -c 'Source-grounding discipline' $I)"
check_gte "R33-23" "Labeled assumption tag [from your input] present (playbook)" "1" "$(grep -c '\[from your input\]' dev/wizards/playbook.md)"
check_gte "R33-24" "Labeled assumption tag [my inference] present (playbook)" "1" "$(grep -c '\[my inference\]' dev/wizards/playbook.md)"
check "R33-25" "INIT.md install POST-INSTALL: Setup Completion + Optional Wizard section present" "1" "$(grep -c 'POST-INSTALL: Setup Completion + Optional Wizard' $I)"
check_gte "R33-26" "INIT.md install Message 1 'Governance framework ready' present" "1" "$(grep -c 'Governance framework ready' $I)"
check_gte "R33-27" "INIT.md install two-message split discipline ('two separate messages') present" "1" "$(grep -c 'two separate messages' $I)"

# Reply-tone hard-rule patch (2026-05-07): plain-language strengthen + outcome-first option framing + backup list cleanup + startup inventory cleanup
check_gte "R33-28" "§11a rule 5 inline-English-mixing ban (AGENTS)" "1" "$(grep -c 'do not weave English mid-sentence' $A)"
check_gte "R33-29" "§11a rule 5 inline-English-mixing ban (INIT mirror)" "1" "$(grep -c 'do not weave English mid-sentence' $I)"
check_gte "R33-30" "§11a rule 5 ground truth carve-out (AGENTS)" "1" "$(grep -c 'Ground truth identifiers allowed inline' $A)"
check_gte "R33-31" "§11a rule 5 ground truth carve-out (INIT mirror)" "1" "$(grep -c 'Ground truth identifiers allowed inline' $I)"
check_gte "R33-32" "§11a rule 2 outcome-first option framing (AGENTS)" "1" "$(grep -c 'label must lead with impact / outcome' $A)"
check_gte "R33-33" "§11a rule 2 outcome-first option framing (INIT mirror)" "1" "$(grep -c 'label must lead with impact / outcome' $I)"
check_gte "R33-34" "§5a backup list includes dev/wizards/playbook.md (AGENTS)" "1" "$(grep -c 'dev/wizards/playbook.md' $A)"
check_gte "R33-35" "§5a backup list includes dev/wizards/playbook.md (INIT mirror)" "1" "$(grep -c 'dev/wizards/playbook.md' $I)"
check_gte "R33-36" "Header startup inventory includes §0a (AGENTS)" "1" "$(grep -c 'MANDATORY STARTUP — read every session: §0 §0a §0c' $A)"
check_gte "R33-37" "Header startup inventory includes §0a (INIT mirror)" "1" "$(grep -c 'MANDATORY STARTUP — read every session: §0 §0a §0c' $I)"

# Work-pool boundary patch (2026-05-07 round 2): hard-separate handoff seed context from this session's work pool / record
check_gte "R33-38" "§1 Work-pool boundary present (AGENTS)" "1" "$(grep -c 'Work-pool boundary (mandatory)' $A)"
check_gte "R33-39" "§1 Work-pool boundary present (INIT mirror)" "1" "$(grep -c 'Work-pool boundary (mandatory)' $I)"
check_gte "R33-40" "§4 Session work-pool boundary present (AGENTS)" "1" "$(grep -c 'Session work-pool boundary (mandatory)' $A)"
check_gte "R33-41" "§4 Session work-pool boundary present (INIT mirror)" "1" "$(grep -c 'Session work-pool boundary (mandatory)' $I)"

# Worktree edge case patch (v3.0.10): §1 fallback for skip-worktree files + §3c canonical execution locus for harness
check_gte "R33-42" "§1 Worktree fallback present (AGENTS)" "1" "$(grep -c 'Worktree fallback (mandatory)' $A)"
check_gte "R33-43" "§1 Worktree fallback present (INIT mirror)" "1" "$(grep -c 'Worktree fallback (mandatory)' $I)"
check_gte "R33-44" "§3c Canonical execution locus present (AGENTS)" "1" "$(grep -c 'Canonical execution locus' $A)"
check_gte "R33-45" "§3c Canonical execution locus present (INIT mirror)" "1" "$(grep -c 'Canonical execution locus' $I)"
check_gte "R33-46" "§1+§3c skip-worktree convention reference (AGENTS)" "1" "$(grep -c 'skip-worktree convention' $A)"
check_gte "R33-47" "§1+§3c skip-worktree convention reference (INIT mirror)" "1" "$(grep -c 'skip-worktree convention' $I)"

# §0b local-tool / SDK / skill alignment principle (post-v3.0.10 governance extension)
check_gte "R33-48" "§0b local-tool alignment principle (AGENTS)" "1" "$(grep -c 'Same alignment principle applies to local' $A)"
check_gte "R33-49" "§0b local-tool alignment principle (INIT mirror)" "1" "$(grep -c 'Same alignment principle applies to local' $I)"

# Task 2 — Pre-action discipline + File proliferation + Closeout stray-file scan (2026-05-12)
check_gte "R33-50" "§3 READ memory-not-source clause (AGENTS)" "1" "$(grep -c 'files not Read in this session are treated as' $A)"
check_gte "R33-51" "§3 READ memory-not-source clause (INIT mirror)" "1" "$(grep -c 'files not Read in this session are treated as' $I)"
check_gte "R33-52" "§3 READ new-file three-step verify (AGENTS)" "1" "$(grep -c 'Before creating a new file, verify no existing file' $A)"
check_gte "R33-53" "§3 READ new-file three-step verify (INIT mirror)" "1" "$(grep -c 'Before creating a new file, verify no existing file' $I)"
check_gte "R33-54" "§3b File proliferation discipline (AGENTS)" "1" "$(grep -c 'File proliferation discipline' $A)"
check_gte "R33-55" "§3b File proliferation discipline (INIT mirror)" "1" "$(grep -c 'File proliferation discipline' $I)"
check_gte "R33-56" "§4 Closeout stray-file scan (AGENTS)" "1" "$(grep -c 'Closeout stray-file scan' $A)"
check_gte "R33-57" "§4 Closeout stray-file scan (INIT mirror)" "1" "$(grep -c 'Closeout stray-file scan' $I)"

# Task 1 — Language layer separation framework (2026-05-12, second Task 1 batch)
check_gte "R33-58" "§11a rule 5 non-developer default (AGENTS)" "1" "$(grep -c 'Assume the user may not be a software developer' $A)"
check_gte "R33-59" "§11a rule 5 non-developer default (INIT mirror)" "1" "$(grep -c 'Assume the user may not be a software developer' $I)"
check_gte "R33-60" "§11a rule 5 Language layer separation framework (AGENTS)" "1" "$(grep -c 'Language layer separation' $A)"
check_gte "R33-61" "§11a rule 5 Language layer separation framework (INIT mirror)" "1" "$(grep -c 'Language layer separation' $I)"
check_gte "R33-62" "§11a rule 5 Layer 3 governance schema carve-out (AGENTS)" "1" "$(grep -c 'Governance internal schema files' $A)"
check_gte "R33-63" "§11a rule 5 Layer 3 governance schema carve-out (INIT mirror)" "1" "$(grep -c 'Governance internal schema files' $I)"
check_gte "R33-64" "§11a rule 5 multilingual universality declaration (AGENTS)" "1" "$(grep -c 'applies to any natural language' $A)"
check_gte "R33-65" "§11a rule 5 multilingual universality declaration (INIT mirror)" "1" "$(grep -c 'applies to any natural language' $I)"

# ============================================================
# Category 15: Legacy Harness Health (staleness detection)
# ============================================================
LEGACY_TS_FILE="docs/qa/.legacy_last_run"
LEGACY_SCRIPT="docs/qa/legacy_checks.sh"
if [ -f "$LEGACY_SCRIPT" ]; then
  if [ -f "$LEGACY_TS_FILE" ]; then
    legacy_last=$(cat "$LEGACY_TS_FILE" 2>/dev/null || echo 0)
    agents_mtime=$(stat -c %Y "$A" 2>/dev/null || stat -f %m "$A" 2>/dev/null || echo 0)
    diff_seconds=$(( agents_mtime - legacy_last ))
    diff_days=$(( diff_seconds / 86400 ))
    [ $diff_days -lt 0 ] && diff_days=0
    if [ $diff_days -gt 30 ]; then
      check "H01" "Legacy harness run within 30d of latest AGENTS.md change (gap: ${diff_days}d)" "1" "0"
    else
      check "H01" "Legacy harness run within 30d of latest AGENTS.md change (gap: ${diff_days}d)" "1" "1"
    fi
  else
    check "H01" "Legacy harness has run at least once (.legacy_last_run missing)" "1" "0"
  fi
else
  check "H01" "legacy_checks.sh present" "1" "0"
fi

# ============================================================
# Main Summary
# ============================================================
echo ""
echo "=========================================="
echo "  Main Regression: ${PASS}/${TOTAL} passed, ${FAIL} failed"
echo "=========================================="
if [ $FAIL -gt 0 ]; then
  echo -e "\nMain Failures:${FAILURES}"
  main_rc=1
else
  echo "  All main checks passed."
  main_rc=0
fi

# ============================================================
# Auto-chain Legacy Harness (default ON; LEGACY_SKIP=1 to bypass)
# ============================================================
if [ "${LEGACY_SKIP:-0}" = "1" ]; then
  echo ""
  echo "  Note: legacy_checks.sh skipped (LEGACY_SKIP=1)"
  echo "  Governance reminder: §3c Release Gate forbids LEGACY_SKIP for release verification."
  exit $main_rc
fi

if [ ! -f "$LEGACY_SCRIPT" ]; then
  echo ""
  echo "  WARNING: $LEGACY_SCRIPT not found — legacy chain skipped."
  exit $main_rc
fi

echo ""
echo "------------------------------------------"
echo "  Auto-chaining $LEGACY_SCRIPT ..."
echo "------------------------------------------"
set +e
bash "$LEGACY_SCRIPT"
legacy_rc=$?
set -e

if [ $main_rc -ne 0 ] || [ $legacy_rc -ne 0 ]; then
  echo ""
  echo "  Combined result: FAIL (main_rc=$main_rc, legacy_rc=$legacy_rc)"
  exit 1
fi

echo ""
echo "  Combined result: PASS (main + legacy all green)"
exit 0
