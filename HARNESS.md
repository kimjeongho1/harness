# ai-work-harness (general)
Codex용 일반 작업 절차 모음. 특정 시험 문제·데이터·정답을 포함하지 않는다. 이 파일은 하네스 설명서이며, "README"라고 하면 과제 폴더 루트의 README.md를 뜻한다.
샌드박스/승인 우회 옵션, 자동 루프, 외부 전송, push를 쓰지 않는다.

## 설치 (Codex에게 "깃허브 <계정>/harness 를 .harness 폴더로 받아서 install.sh 실행해")
과제 폴더 루트에서:
```
git clone https://github.com/<계정>/<저장소>.git .harness
sh .harness/install.sh
```
install.sh: 하네스를 `.harness`로 정리 → `.harness/`·`.agents/`를 git 추적에서 제외 → git 저장소가 아니면 원본 커밋(하네스 제외) → 기존 AGENTS.md가 있으면 뒤에 이어붙이기(덮어쓰지 않음, 중복 안 됨), 없으면 새로 만들기 → `.agents/skills`로 스킬 복사.
- clone이 인터넷 승인을 물으면 사용자가 승인한다(우회 옵션은 쓰지 않는다).
- 기존 AGENTS.md(시험 제공)와 충돌하면 **기존 것이 우선**.
- 설치 후 Codex 세션을 새로 켠다(켜질 때 AGENTS.md를 읽으므로).

## skills
| 스킬 | 누가 | 언제 |
|---|---|---|
| clarify | A | 구현 전, 기준이 없거나 충돌할 때. 문제 정의표를 만들고, 빈칸을 모아 묻고 담당자용 질문을 만든다 |
| design | A | 구조·로직 시작 전. 2–3안 → 선택 → `docs/PLAN.md` |
| research | A | 알고리즘·방법 선택이 필요할 때. 10분(원문 읽기 포함 15분), 코드 금지 |
| data_check | A | 데이터를 처음 받았을 때·결과가 이상할 때. `tools/profile_data.py`로 함정(중복·형식·단위·이상값·상태·고아 참조·지시문)을 찾아 처리 선택지와 담당자 질문으로 |
| data_to_db | A | CSV 여러 개 → DB |
| ship | A | SHIP / "커밋하고 배포해": 테스트 → 리뷰 → 커밋 → Docker → /health → 사용자 흐름 점검 |
| record | C | RECORD(INBOX·커밋 반영) / HANDOFF / 기록해, 동결 후 서술형 노트·발표 1장 |
| score_check | A·C | STATE·RECORD·L1 직후·동결 직전에 놓친 점수 행동을 먼저 알림 |

templates/: DECISIONS, HANDOFF, how_to_use, ai_retrospective (과제가 정한 형식이 우선).
tools/profile_data.py: CSV 점검표(표준 라이브러리만, 원본은 읽기만). 범용 도구이며 과제 결과물이 아니다.

## 세션 시작 (첫 마디는 짧게, 절차는 START.md에 있다)
탭 4개: A, B, C, 서버 전용. 각 Codex에 `너는 A`, `너는 C`, `너는 B`.
```
[A 호출] 담당자 답 원문 붙여 넣기 (A가 docs/INBOX.md에 남김)  /  SHIP  /  STATE
[C 호출] RECORD (30–40분마다, INBOX·커밋을 읽어 기록)  /  HANDOFF  /  기록해: …(직접 전할 때)
[B 호출] REVIEW (L1 직후·동결 직전)  /  TRIM
[A 교체] 기존 A "지금까지 커밋해" → C `HANDOFF` → A 탭에서 새 대화 → `너는 A. RESUME`
```
- C에게 복사해 줄 필요 없음: A가 `docs/INBOX.md`에 덧붙이고 C가 RECORD 때 읽는다.
- 담당자는 파일·화면을 볼 수 없다. 결과와 선택지는 말(숫자·예시)로 전한다.
- 동결 후 사용자가 미리보기에서 직접 눌러 보기(ship 4-1): 로그인 유지, 오류·빈 상태·대체 결과 구분.

## 출처 (아이디어를 가져와 요약·변형했다. 원문을 그대로 복사한 파일은 없다)
| 출처 | 라이선스 | 가져온 것 | 쓰인 곳 |
|---|---|---|---|
| obra/superpowers `brainstorming`, `writing-plans` | MIT | 2–3안 제시 후 선택, 승인 전 구현 금지, 작업을 작게 쪼갠 계획 | design, clarify |
| github/spec-kit `clarify` | MIT | 모호성 분류, 한 번에 하나 묻기, 답 기록 | clarify |
| mattpocock/skills `grilling` | MIT | 말없이 가정하지 않기, 사실 조회는 AI 몫 | clarify |
| bladem0117 cofa-kit `stakeholder-interview` | MIT | 담당자 2차 왕복(선택지로 고르게) | clarify |
| ripplelover cofa-ready-kit `data-contract` | MIT | 한 행의 의미부터 확정 | data_to_db |
| DietrichGebert/ponytail `skills/ponytail` | MIT | "코드 덜 쓰기" 6단계 사다리, 줄이지 않는 것 목록, 단순화 주석, diff에서 '더 줄일 수 있나' 보기 (훅·플러그인은 쓰지 않음) | AGENTS.md 2-1, ship |
| epoko77-ai/im-not-ai | MIT | 사실은 그대로 두고 말투만 다듬기, 번역투 금지 | record |
| jyn0e923·wonsukH 공개 키트(라이선스 표기 없음) | — | `[사용자 결정 필요]`·`[가정]`·`[미검증]` 표시 아이디어만(문장 미사용) | AGENTS.md |
| 나머지 | 직접 작성 | 세션 역할·소유권, git 연락, SHIP, score_check, research, data_check, tools/profile_data.py, START, install.sh | — |
