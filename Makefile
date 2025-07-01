APP_SCHEME=CodexSwiftUIApp
PACKAGE_PATH=CodexSwiftUIApp

build:
	@echo "Building iOS app"
	cd $(PACKAGE_PATH) && xcodebuild -scheme $(APP_SCHEME) -destination 'generic/platform=iOS' build

test:
	@echo "Running tests"
	cd $(PACKAGE_PATH) && xcodebuild -scheme $(APP_SCHEME) -destination 'platform=iOS Simulator,name=iPhone 14' test

list:
	@echo "Listing schemes"
	cd $(PACKAGE_PATH) && xcodebuild -list

deploy:
	@echo "Deploying app (placeholder)"
	# Replace with actual deployment command, e.g., using xcrun altool

lint:
	@echo "Running SwiftLint"
	swiftlint

.PHONY: build test list deploy lint
