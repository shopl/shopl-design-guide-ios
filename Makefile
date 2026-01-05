# Makefile

.PHONY: help bootstrap setup generate clean-gen renew-all-certs sync-qa-devices encode-cert

help:
	@echo "사용 가능한 명령어:"
	@echo "  make bootstrap    - Homebrew, Mise 등 시스템 필수 도구 설치"
	@echo "  make setup        - 프로젝트 의존성(Ruby, Tuist) 설치"
	@echo "  make generate     - Tuist 프로젝트 생성 및 Xcode 실행"
	@echo "  make clean-gen    - 캐시 삭제 후 의존성 재설치 및 프로젝트 생성"
	@echo "  make distribution - 배포(로컬 테스트용)"
	
bootstrap:
	@echo "🛠️ Checking Homebrew installation..."
	@command -v brew >/dev/null || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	@echo "📋 Checking for rbenv conflict..."
	@if command -v rbenv >/dev/null; then echo "⚠️ Warning: rbenv detected. It may conflict with mise."; fi
	@echo "📦 Installing Homebrew dependencies (Brewfile)..."
	@brew bundle --file=./Brewfile
	@echo "📦 Checking Mise installation..."
	@command -v mise >/dev/null || curl -s https://mise.run | sh
	@echo "✅ Bootstrap 완료! 환경 변수 적용을 위해 터미널을 재시작하거나 'source ~/.zshrc'를 실행하세요."
	
setup:
	@echo "🛠️  Setting up environment with mise..."
	@mise install
	@echo "📦 Installing Bundler..."
	@mise exec ruby -- gem install bundler
	@echo "📦 Installing Ruby dependencies..."
	@mise exec ruby -- bundle install
	@echo "📦  Installing Tuist dependencies..."
	@mise exec tuist -- tuist install
	@echo "📦 Installing Node dependencies..."
	@mise exec node -- npm ci # Husky 설치
	@echo "✅ Setup completed!"

generate:
	@echo "🚀 Generating project..."
	@mise exec tuist -- tuist generate

clean-gen:
	@echo "🧹 Cleaning Tuist cache and artifacts..."
	@mise exec tuist -- tuist clean
	@echo "📦 Re-installing dependencies..."
	@mise exec tuist -- tuist install
	@$(MAKE) generate
	tuist generate

	# 로컬 테스트용
distribute:
	@if [ ! -f .env ]; then \
		echo "❌ 에러: .env 파일이 없습니다!"; \
		echo "💡 해결: github secret 값을 대신 넣어줄 .env 파일이 필요합니다."; \
		exit 1; \
	fi
	bundle exec fastlane distribute
