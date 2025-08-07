# === Configuration ===
WORKSPACE = algoframe-meet.xcworkspace
SCHEME = AlgoframeMeetSDK

DEVICE_ARCHIVE_PATH = sdk/out/ios-device
SIMULATOR_ARCHIVE_PATH = sdk/out/ios-simulator
MACOS_ARCHIVE_PATH = sdk/out/macos
XCFRAMEWORK_OUTPUT = sdk/out/AlgoframeMeetSDK.xcframework
HERMES_SRC = Pods/hermes-engine/destroot/Library/Frameworks/universal/hermes.xcframework
HERMES_DEST = sdk/out/hermes.xcframework

# === Targets ===

.PHONY: all clean build device sim macos xcframework xcframework-all xcframework-device xcframework-sim xcframework-macos copy-hermes

all: clean build

clean:
	@echo "🧹 Cleaning previous builds..."
	rm -rf $(DEVICE_ARCHIVE_PATH).xcarchive \
	       $(SIMULATOR_ARCHIVE_PATH).xcarchive \
	       $(MACOS_ARCHIVE_PATH).xcarchive \
	       $(XCFRAMEWORK_OUTPUT)

	@echo "🧼 Cleaning Xcode project..."
	xcodebuild clean -workspace $(WORKSPACE) -scheme $(SCHEME)

build: device sim macos xcframework-all

device:
	@echo "📱 Archiving for iOS device..."
	xcodebuild archive \
		-workspace $(WORKSPACE) \
		-scheme $(SCHEME) \
		-configuration Release \
		-sdk iphoneos \
		-destination 'generic/platform=iOS' \
		-archivePath $(DEVICE_ARCHIVE_PATH) \
		SKIP_INSTALL=NO \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES

sim:
	@echo "📲 Archiving for iOS simulator..."
	xcodebuild archive \
		-workspace $(WORKSPACE) \
		-scheme $(SCHEME) \
		-configuration Release \
		-sdk iphonesimulator \
		-destination 'generic/platform=iOS Simulator' \
		-archivePath $(SIMULATOR_ARCHIVE_PATH) \
		SKIP_INSTALL=NO \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES

macos:
	@echo "💻 Archiving for macOS..."
	xcodebuild archive \
		-workspace $(WORKSPACE) \
		-scheme $(SCHEME) \
		-configuration Release \
		-sdk macosx \
		-archivePath $(MACOS_ARCHIVE_PATH) \
		SKIP_INSTALL=NO \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# === XCFramework creation targets ===

xcframework: 
	@echo "❌ Please specify a subtarget: device, sim, macos, or all"
	@echo "Example: make xcframework-device"

xcframework-device:
	@echo "📦 Creating XCFramework (device only)..."
	xcodebuild -create-xcframework \
		-framework $(DEVICE_ARCHIVE_PATH).xcarchive/Products/Library/Frameworks/$(SCHEME).framework \
		-output $(XCFRAMEWORK_OUTPUT)
	$(MAKE) copy-hermes

xcframework-sim:
	@echo "📦 Creating XCFramework (simulator only)..."
	xcodebuild -create-xcframework \
		-framework $(SIMULATOR_ARCHIVE_PATH).xcarchive/Products/Library/Frameworks/$(SCHEME).framework \
		-output $(XCFRAMEWORK_OUTPUT)
	$(MAKE) copy-hermes

xcframework-macos:
	@echo "📦 Creating XCFramework (macOS only)..."
	xcodebuild -create-xcframework \
		-framework $(MACOS_ARCHIVE_PATH).xcarchive/Products/Library/Frameworks/$(SCHEME).framework \
		-output $(XCFRAMEWORK_OUTPUT)
	$(MAKE) copy-hermes

xcframework-all:
	@echo "📦 Creating XCFramework (device + sim + macOS)..."
	xcodebuild -create-xcframework \
		-framework $(DEVICE_ARCHIVE_PATH).xcarchive/Products/Library/Frameworks/$(SCHEME).framework \
		-framework $(SIMULATOR_ARCHIVE_PATH).xcarchive/Products/Library/Frameworks/$(SCHEME).framework \
		-framework $(MACOS_ARCHIVE_PATH).xcarchive/Products/Library/Frameworks/$(SCHEME).framework \
		-output $(XCFRAMEWORK_OUTPUT)
	$(MAKE) copy-hermes

copy-hermes:
	@echo "📦 Copying Hermes XCFramework..."
	@if [ -d "$(HERMES_SRC)" ]; then \
		mkdir -p $(XCFRAMEWORK_OUTPUT); \
		cp -a "$(HERMES_SRC)" "$(HERMES_DEST)"; \
		echo "✅ Hermes copied to $(HERMES_DEST)"; \
	else \
		echo "⚠️ Hermes source not found at $(HERMES_SRC)"; \
	fi
