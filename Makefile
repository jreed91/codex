APP_SCHEME=CodexSwiftUIApp
PACKAGE_PATH=CodexSwiftUIApp

build:
	@echo "Building iOS app"
	cd $(PACKAGE_PATH) && xcodebuild -scheme $(APP_SCHEME) -sdk iphonesimulator -destination 'generic/platform=iOS' build

test:
	@echo "Running tests on iPhone 16"
	cd $(PACKAGE_PATH) && xcodebuild -scheme $(APP_SCHEME) -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16' test

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
