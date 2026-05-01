#!/usr/bin/env bash
# Legacy Regression Checks for ai-session-governance
# Defends against v1.x–v2.6 historical drift patterns (89 checks).
# DO NOT REMOVE without quarantine review (see docs/qa/MIGRATION_NOTES.md).
# Auto-chained from run_checks.sh by default; LEGACY_SKIP=1 explicitly bypasses.
# Manual run: bash docs/qa/legacy_checks.sh

set -euo pipefail

PASS=0; FAIL=0; TOTAL=0; FAILURES=""
A="AGENTS.md"
I="INIT.md"
PYTHON_BIN=""
if command -v python >/dev/null 2>&1; then
  PYTHON_BIN="python"
elif command -v python3 >/dev/null 2>&1; then
  PYTHON_BIN="python3"
fi

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

# ============================================================
# R11: Harness Optimization Round 11 (v2.5)
# ============================================================
check "R11-01" "Attention anchor AGENTS.md (heading only, not DOC_SYNC mentions)" "1" "$(grep -c '^\*\*CORE RULES' $A)"
check "R11-02" "Attention anchor INIT.md (heading only, not DOC_SYNC mentions)" "1" "$(grep -c '^\*\*CORE RULES' $I)"
check "R11-03" "§2 refs §1 AGENTS" "1" "$(grep -c 'defer to the §1 read order' $A)"
check "R11-04" "§2 refs §1 INIT" "1" "$(grep -c 'defer to the §1 read order' $I)"
check "R11-05" "Old §2 file list gone" "0" "$(grep -c 'current baseline, execution thresholds' $A)"
check "R11-06" "§2c heading absent AGENTS" "0" "$(grep -c '^## 2c)' $A)"
check "R11-07" "§2c heading absent INIT" "0" "$(grep -c '^## 2c)' $I)"
check "R11-08" "§3 READ expanded AGENTS" "1" "$(grep -c 'full context of the section to be modified' $A)"
check "R11-09" "§3 READ expanded INIT" "1" "$(grep -c 'full context of the section to be modified' $I)"
check "R11-10" "§2b cross-ref updated AGENTS" "1" "$(grep -c '§3 READ coverage' $A)"
check "R11-11" "§2b cross-ref updated INIT" "1" "$(grep -c '§3 READ coverage' $I)"
check "R11-12" "QC fail-path AGENTS" "1" "$(grep -c 'QC reveals test failures' $A)"
check "R11-13" "QC fail-path INIT" "1" "$(grep -c 'QC reveals test failures' $I)"
check "R11-14" "Deviation resume AGENTS" "1" "$(grep -c 'receiving user direction following' $A)"
check "R11-15" "Deviation resume INIT" "1" "$(grep -c 'receiving user direction following' $I)"
check "R11-16" "Closeout protection AGENTS" "1" "$(grep -c 'confirm session-end intent' $A)"
check "R11-17" "Closeout protection INIT" "1" "$(grep -c 'confirm session-end intent' $I)"
check "R11-18" "Codex note README.md" "1" "$(grep -c 'project_doc_max_bytes' README.md)"
check "R11-19" "Codex note README.zh-TW.md" "1" "$(grep -c 'project_doc_max_bytes' README.zh-TW.md)"
check "R11-20" "Codex note README.zh-CN.md" "1" "$(grep -c 'project_doc_max_bytes' README.zh-CN.md)"
check "R11-21" "Codex note README.ja.md" "1" "$(grep -c 'project_doc_max_bytes' README.ja.md)"
check "R11-22" "§0b after §4a AGENTS" "1" "$(awk '/^## 4a\)/{a=NR} /^## 0b\)/{b=NR} END{print (b>a)?1:0}' $A)"
check "R11-23" "§0b after §4a INIT" "1" "$(awk '/^## 4a\)/{a=NR} /^## 0b\)/{b=NR} END{print (b>a)?1:0}' $I)"
check "R11-24" "§2c not in CONDITIONAL marker" "0" "$(grep 'CONDITIONAL.*apply when triggered' $A | grep -c '§2c' || true)"
check "R11-25" "§5a in CONDITIONAL marker AGENTS" "1" "$(grep 'CONDITIONAL.*apply when triggered' $A | grep -c '§5a')"
check "R11-26" "§5a in CONDITIONAL marker INIT" "1" "$(grep 'CONDITIONAL.*apply when triggered' $I | grep -c '§5a')"

# ============================================================
# R26: Re-Audit Fixes (v2.6)
# ============================================================
check "R26-01" "§1 no 'last occurring' residue AGENTS" "0" "$(grep -c 'last occurring such heading' $A)"
check "R26-02" "§1 no 'last occurring' residue INIT" "0" "$(grep -c 'last occurring such heading' $I)"
check "R26-03" "§1 regardless of physical position AGENTS" "1" "$(grep -c 'regardless of the entry' $A)"
check "R26-04" "§1 regardless of physical position INIT" "1" "$(grep -c 'regardless of the entry' $I)"
check "R26-05" "§1→§2 cross-ref AGENTS" "1" "$(grep -c 'subject to the precedence rules in §2 rule 5' $A)"
check "R26-06" "§1→§2 cross-ref INIT" "1" "$(grep -c 'subject to the precedence rules in §2 rule 5' $I)"
check "R26-05b" "§1 same-date tiebreaker AGENTS" "1" "$(grep -c 'physically topmost entry wins' $A)"
check "R26-06b" "§1 same-date tiebreaker INIT" "1" "$(grep -c 'physically topmost entry wins' $I)"
check "R26-07" "INIT top-block delegates to §5a" "1" "$(grep -c 'single source of truth for bootstrap root safety' $I)"
check "R26-08" "INSTALL_ROOT_OK present in INIT" "1" "$(grep -c 'INSTALL_ROOT_OK' $I | awk '{print ($1>=1)?1:0}')"
check "R26-09" "INSTALL_WRITE_OK present in INIT" "1" "$(grep -c 'INSTALL_WRITE_OK' $I | awk '{print ($1>=1)?1:0}')"
check "R26-10" "Boot cue uniform AGENTS" "1" "$(grep -c 'randomize across styles uniformly' $A)"
check "R26-11" "Boot cue uniform INIT" "1" "$(grep -c 'randomize across styles uniformly' $I)"
check "R26-12" "Closeout cue within-session AGENTS" "1" "$(grep -c 'within a single session, the Closeout Visual Cue must differ' $A)"
check "R26-13" "Closeout cue within-session INIT" "1" "$(grep -c 'within a single session, the Closeout Visual Cue must differ' $I)"
check "R26-14" "Boot cue no 'if the previous style is known' AGENTS" "0" "$(grep -c 'if the previous style is known' $A)"
check "R26-15" "Boot cue no 'if the previous style is known' INIT" "0" "$(grep -c 'if the previous style is known' $I)"
check "R26-16" "§0b scope clarification AGENTS" "1" "$(grep -c 'Editing documentation, governance rules, or templates' $A)"
check "R26-17" "§0b scope clarification INIT" "1" "$(grep -c 'Editing documentation, governance rules, or templates' $I)"
check "R26-18" "§12 grandfather clause AGENTS" "1" "$(grep -c 'not retroactively rewritten' $A)"
check "R26-19" "§12 grandfather clause INIT" "1" "$(grep -c 'not retroactively rewritten' $I)"
check "R26-20" "§12 HHMM format present AGENTS" "1" "$(grep -c 'YYYYMMDD.*HHMM' $A | awk '{print ($1>=1)?1:0}')"
check "R26-21" "§12 HHMM format present INIT" "1" "$(grep -c 'YYYYMMDD.*HHMM' $I | awk '{print ($1>=1)?1:0}')"
check "R26-22" "§10 filename enforcement heading AGENTS" "1" "$(grep -c 'Filename enforcement' $A)"
check "R26-23" "§10 filename enforcement heading INIT" "1" "$(grep -c 'Filename enforcement' $I)"
check "R26-24" "§10 forbidden alt-names list AGENTS" "1" "$(grep -c 'alternative names such as' $A)"
check "R26-25" "§10 forbidden alt-names list INIT" "1" "$(grep -c 'alternative names such as' $I)"
check "R26-26" "§10 forbids ARCHITECTURE alt AGENTS" "1" "$(grep -c 'ARCHITECTURE.md' $A)"
check "R26-27" "§10 forbids ARCHITECTURE alt INIT" "1" "$(grep -c 'ARCHITECTURE.md' $I)"
check "R26-28" "§5 forbids Remove-Item AGENTS" "1" "$(grep -c 'Remove-Item -Recurse -Force' $A)"
check "R26-29" "§5 forbids Remove-Item INIT" "1" "$(grep -c 'Remove-Item -Recurse -Force' $I)"
check "R26-30" "§5 forbids git reset --hard AGENTS" "1" "$(grep -c 'git reset --hard' $A)"
check "R26-31" "§5 forbids git reset --hard INIT" "1" "$(grep -c 'git reset --hard' $I)"
check "R26-32" "§5 forbids git clean -fdx AGENTS" "1" "$(grep -c 'git clean -fdx' $A)"
check "R26-33" "§5 forbids git clean -fdx INIT" "1" "$(grep -c 'git clean -fdx' $I)"
check "R26-34" "§5a step 10 abort rule AGENTS" "1" "$(grep -c 'If high-risk markers are detected' $A)"
check "R26-35" "§5a step 10 abort rule INIT" "1" "$(grep -c 'If high-risk markers are detected' $I)"
check "R26-36" "§4 major separator rule AGENTS" "1" "$(grep -c 'Major separator:' $A)"
check "R26-37" "§4 major separator rule INIT" "1" "$(grep -c 'Major separator:' $I)"
check "R26-38" "§4 minor separator rule AGENTS" "1" "$(grep -c 'Minor separator:' $A)"
check "R26-39" "§4 minor separator rule INIT" "1" "$(grep -c 'Minor separator:' $I)"

# ============================================================
# R27: P3 Root-Fix (v2.7)
# ============================================================
check "R27-01" "Handoff compactness budget AGENTS" "1" "$(grep -c 'Session handoff compactness budget' $A)"
check "R27-02" "Handoff compactness budget INIT" "1" "$(grep -c 'Session handoff compactness budget' $I)"
check "R27-03" "Maintenance trigger evaluation AGENTS" "1" "$(grep -c 'evaluate triggers directly from `dev/SESSION_LOG.md`' $A)"
check "R27-04" "Maintenance trigger evaluation INIT" "1" "$(grep -c 'evaluate triggers directly from `dev/SESSION_LOG.md`' $I)"
check "R27-05" "No Python requirement in AGENTS §4a" "0" "$(grep -c 'python docs/qa/session_log_maintenance.py' $A)"
check "R27-06" "No Python requirement in INIT §4a" "0" "$(grep -c 'python docs/qa/session_log_maintenance.py' $I)"
check "R27-07" "FILE 7 heading removed from INIT.md" "0" "$(grep -c 'FILE 7: docs/qa/session_log_maintenance.py' $I)"
check "R27-08" "session_log_maintenance.py exists" "1" "$(test -f docs/qa/session_log_maintenance.py && echo 1 || echo 0)"
check "R27-08b" "Doc sync row in INIT checklist template" "1" "$(grep -c 'Session-log maintenance policy changed' $I)"
check "R27-08c" "Doc sync row in dev checklist" "1" "$(grep -c 'Session-log maintenance policy changed' dev/DOC_SYNC_CHECKLIST.md)"

if [ -n "$PYTHON_BIN" ] && [ -f docs/qa/session_log_maintenance.py ] && $PYTHON_BIN docs/qa/session_log_maintenance.py --self-test >/dev/null 2>&1; then
  selftest_rc=0
elif [ -z "$PYTHON_BIN" ]; then
  selftest_rc=0
else
  selftest_rc=1
fi
check "R27-09" "session_log_maintenance self-test matrix (skip if python unavailable)" "0" "$selftest_rc"

if [ -n "$PYTHON_BIN" ] && [ -f docs/qa/session_log_maintenance.py ] && $PYTHON_BIN docs/qa/session_log_maintenance.py --check --session-log dev/SESSION_LOG.md >/dev/null 2>&1; then
  check_exec_rc=0
elif [ -z "$PYTHON_BIN" ]; then
  check_exec_rc=0
else
  check_exec_rc=$?
fi
check "R27-10" "session_log_maintenance check command executable (0 or 2, skip if python unavailable)" "1" "$([ $check_exec_rc -eq 0 -o $check_exec_rc -eq 2 ] && echo 1 || echo 0)"
check "R27-11" "README EN hides internal maintenance script" "0" "$(grep -c 'session_log_maintenance.py' README.md)"
check "R27-12" "README zh-TW hides internal maintenance script" "0" "$(grep -c 'session_log_maintenance.py' README.zh-TW.md)"
check "R27-13" "README zh-CN hides internal maintenance script" "0" "$(grep -c 'session_log_maintenance.py' README.zh-CN.md)"
check "R27-14" "README ja hides internal maintenance script" "0" "$(grep -c 'session_log_maintenance.py' README.ja.md)"
check "R27-15" "README EN hides Python maintenance commands" "0" "$(grep -c 'python docs/qa/session_log_maintenance.py' README.md)"
check "R27-16" "README zh-TW hides Python maintenance commands" "0" "$(grep -c 'python docs/qa/session_log_maintenance.py' README.zh-TW.md)"
check "R27-17" "README zh-CN hides Python maintenance commands" "0" "$(grep -c 'python docs/qa/session_log_maintenance.py' README.zh-CN.md)"
check "R27-18" "README ja hides Python maintenance commands" "0" "$(grep -c 'python docs/qa/session_log_maintenance.py' README.ja.md)"
check "R27-19" "INIT package self-containment: no docs/qa/run_checks.sh reference" "0" "$(grep -c 'docs/qa/run_checks.sh' $I)"
check "R27-20" "INIT package self-containment: no docs/qa/session_log_maintenance.py reference" "0" "$(grep -c 'docs/qa/session_log_maintenance.py' $I)"

# ============================================================
# Summary + last-run timestamp
# ============================================================
echo ""
echo "=========================================="
echo "  Legacy Regression: ${PASS}/${TOTAL} passed, ${FAIL} failed"
echo "=========================================="
if [ $FAIL -gt 0 ]; then
  echo -e "\nLegacy Failures:${FAILURES}"
  exit 1
fi

echo "  All legacy checks passed."
date -u +"%s" > docs/qa/.legacy_last_run
echo "  Last-run timestamp written: docs/qa/.legacy_last_run"
exit 0
