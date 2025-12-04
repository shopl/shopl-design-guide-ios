# Makefile

# 초기 세팅(Ruby, Tuist 버전 고정)
setup:
	@echo "🛠️  Setting up environment with mise..."
	
	# .ruby-version, .tuist-version을 읽어서 설치
	mise install
	
	bundle install
	
	tuist install
	
	# Husky 설치
	npm ci
	
	@echo "✅  Setup completed!"

clean-install:
	tuist clean
	tuist intall
	
generate:
	tuist generate

	# 로컬 테스트용
distribute:
	@if [ ! -f .env ]; then \
		echo "❌ 에러: .env 파일이 없습니다!"; \
		echo "💡 해결: github secret 값을 대신 넣어줄 .env 파일이 필요합니다."; \
		exit 1; \
	fi
	bundle exec fastlane distribute
