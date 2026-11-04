#!/bin/sh
# 과제 폴더 루트에서 실행: sh .harness/install.sh   (다른 이름으로 받았어도 sh <폴더>/install.sh 로 실행 가능)
# 하는 일: 하네스를 .harness 로 정리 → git 추적 제외 → git 원본 커밋(저장소가 아닐 때만)
#          → AGENTS.md 뒤에 이어붙이기(덮어쓰기 안 함, 중복 안 함) → .agents/skills 로 스킬 복사
set -e
SRC=$(cd "$(dirname "$0")" && pwd)
[ -f "$SRC/AGENTS.md" ] || { echo "FAIL: $SRC/AGENTS.md 없음"; exit 1; }
case "$SRC" in "$PWD"/*) ;; *) echo "FAIL: 과제 폴더 루트에서 실행하세요 (지금: $PWD)"; exit 1;; esac

if [ "$SRC" != "$PWD/.harness" ]; then
  [ -e .harness ] || cp -R "$SRC" .harness
  echo "하네스를 .harness 로 복사함 (원래 위치: ${SRC#$PWD/})"
fi

NEW=0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { git init -q; NEW=1; }
EX=.git/info/exclude; mkdir -p .git/info
for p in .harness/ .agents/ "${SRC#$PWD/}/"; do grep -qxF "$p" "$EX" 2>/dev/null || echo "$p" >> "$EX"; done
if [ $NEW = 1 ]; then git add -A && git commit -qm "chore: 원본 상태" && echo "git init + 원본 커밋 (하네스 제외)"; fi

if grep -q "작업 지침 (짧게 유지)" AGENTS.md 2>/dev/null; then
  echo "AGENTS.md: 이미 이어붙여져 있음(건너뜀)"
else
  if [ -f AGENTS.md ]; then
    echo "AGENTS.md: 시험 제공 파일 있음 → 기존 내용 유지, 뒤에 이어붙임 (기존 지침이 우선)"
    printf '\n\n' >> AGENTS.md && cat .harness/AGENTS.md >> AGENTS.md
  else
    echo "AGENTS.md: 없음 → 과제 폴더 루트에 새로 만듦 (git 추적 제외)"
    cp .harness/AGENTS.md AGENTS.md
    grep -qxF "AGENTS.md" "$EX" || echo "AGENTS.md" >> "$EX"
  fi
fi

mkdir -p .agents/skills && cp -R .harness/skills/. .agents/skills/
echo "스킬: $(ls .harness/skills | tr '\n' ' ')"
echo "완료. 이제 Codex 세션을 새로 켜고 '너는 A' 처럼 말하세요."
git status --short | head -5
