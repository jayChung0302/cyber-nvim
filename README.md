🧠 Cyber Neovim for Python / FastAPI / ML

Neovim 0.11 + lazy.nvim + uv + FastAPI + PyTorch + Debug(DAP)
Apple Silicon(macOS arm64) 기준으로 완전 재현 가능한 설정

✨ Features

🚀 Python / FastAPI / ML 개발 최적화

🧪 알고리즘 문제 풀이 (stdin / multi-case diff)

🐞 디버깅 (breakpoint, 변수 hover, scopes, UI)

🎨 Cyber / Nerd / Neon 테마

🧠 LSP (Pyright) + 자동완성

✂️ 저장 시 자동 포맷 (isort → black)

🌳 NERDTree + Telescope

🧩 Dashboard (시작 화면)

🖥️ Environment

OS: macOS (Apple Silicon arm64)

Shell: zsh

Terminal: iTerm2

Neovim: 0.11+

Python: uv

Plugin Manager: lazy.nvim

### 1️⃣ 필수 시스템 패키지 설치
Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

Neovim & 필수 도구
brew install neovim git ripgrep fd luajit

### 2️⃣ ⚠️ 중요: Tree-sitter CLI 설치 (필수)

nvim-treesitter는 library가 아니라 CLI가 필요함

아래 명령을 반드시 실행해야 한다:

brew install tree-sitter-cli


확인:

which tree-sitter
tree-sitter --version


정상 출력 예:

/opt/homebrew/bin/tree-sitter
tree-sitter 0.26.x


❗ tree-sitter만 설치하면 안 되고
❗ **반드시 tree-sitter-cli**여야 한다.

### 3️⃣ iTerm2 (권장 설정)
Font
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font


Font: JetBrainsMono Nerd Font

Size: 13~14

Ligatures: ON

Transparency: 5~10%

### 4️⃣ Neovim 설정 설치
Clone
git clone <YOUR_REPO_URL> ~/.dotfiles/nvim

Symlink
rm -rf ~/.config/nvim
ln -s ~/.dotfiles/nvim ~/.config/nvim

### 5️⃣ 최초 실행
nvim


플러그인 설치가 자동으로 진행됨.

설치 완료 후:

:Lazy sync

### 6️⃣ Tree-sitter 파서 설치

Neovim 안에서:

:TSInstall lua python bash json yaml markdown


확인:

:checkhealth nvim-treesitter


정상 상태:

✔ tree-sitter-cli found
✔ Installed languages: lua python ...

### 7️⃣ Python 프로젝트 (uv)
가상환경 생성
uv venv

필수 패키지
uv pip install black isort debugpy pyright fastapi uvicorn

### 8️⃣ 주요 Keymaps
🌳 탐색
키	기능
<leader>n	NERDTree Toggle
<leader>ff	파일 검색
<leader>fg	Live grep
🧪 실행
키	기능
<leader>rr	현재 Python 파일 실행 (uv)
<leader>ri	input.txt를 stdin으로 실행
<leader>rc	cases/in ↔ cases/out diff 실행
🧠 알고리즘
키	기능
<leader>at	Python 알고리즘 템플릿 삽입
🐞 디버깅 (DAP)
키	기능
<leader>db	Breakpoint
<leader>dB	조건 Breakpoint
<leader>dc	Continue
<leader>do	Step over
<leader>di	Step into
<leader>dO	Step out
<leader>dh	변수 Hover
<leader>ds	Scopes
<leader>du	DAP UI 토글
🎨 테마
키	테마
<leader>tc	Cyberdream
<leader>tt	Tokyonight
<leader>to	Oxocarbon
<leader>tm	Catppuccin
### 9️⃣ FastAPI 실행

프로젝트 루트에서 main.py가 있을 때:

<leader>fa


실행:

uvicorn main:app --reload

### 10️⃣ 문제 해결 가이드
❌ tree-sitter-cli not found
brew install tree-sitter-cli

❌ module 'nvim-treesitter.configs' not found

plugins.lua에서 treesitter는 opts = {} 방식만 사용

config = function() 사용 금지 (Neovim 0.11)

## 📌 권장 사항

lazy-lock.json 커밋 유지 (완전 재현)

Tree-sitter는 auto_install = false

파서 업데이트는 수동 (:TSUpdate)

🏁 Final State Checklist

 Neovim 0.11 실행

 :Lazy 에러 없음

 :checkhealth nvim-treesitter OK

 Python LSP(Pyright) 정상

 Debug / Breakpoint 정상

## 🚀 Next Steps (Optional)

ruff --fix → isort → black 저장 파이프라인

PyTorch tensor hover 요약

프로젝트 타입별 LSP 강도 자동 전환

iTerm2 → Preferences → Profiles → Text
✅ Font

반드시 이것 중 하나여야 함

JetBrainsMono Nerd Font

JetBrainsMono Nerd Font Mono

❌ JetBrains Mono (일반 버전) ❌

👉 이름에 반드시 Nerd Font가 들어가야 한다

설정 예

Font: JetBrainsMono Nerd Font

Size: 13~14

Use ligatures: ON

Anti-aliased: ON

📌 여기서 Apply 안 누르고 창 닫는 경우도 많으니 꼭 확인

3️⃣ Nerd Font 설치 여부 재확인 (터미널)
ls ~/Library/Fonts | grep -i jetbrains


정상이라면 이런 게 보여야 함:

JetBrainsMonoNerdFont-Regular.ttf
JetBrainsMonoNerdFontMono-Regular.ttf


없다면 다시 설치:

brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font


설치 후 iTerm2 완전 재시작 (⌘Q 필수)

4️⃣ iTerm2 Fallback 폰트 설정 (중요, 은근히 안 되는 포인트)
Preferences → Profiles → Text → Font

Use built-in Powerline glyphs ✅ ON

Unicode normalization form → None

Fallback fonts:

Symbols Nerd Font

Noto Color Emoji (선택)

👉 fallback이 없으면 일부 아이콘이 ?로 뜰 수 있음
