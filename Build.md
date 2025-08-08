# 📦 SDK Preparation Guide

This guide explains how to generate a **React Native iOS bundle** and integrate it into an **iOS SDK**.

---

## 🚀 Prerequisites

Make sure you have the following installed on your machine:

- [Node.js](https://nodejs.org/)  
- [Yarn](https://classic.yarnpkg.com/lang/en/)  
- [React Native CLI](https://reactnative.dev/docs/environment-setup)  
- [CocoaPods](https://cocoapods.org/)  
- **Xcode Command Line Tools**  
- `make` utility (comes pre-installed on macOS, but verify before proceeding)  

---

## 📂 Step 1 — Prepare the React Native Bundle

### 1.1 Clone the Frontend Project
First, clone the **React Native frontend** repository:

```bash
git clone <REPO_URL>
cd <CLONED_PROJECT_DIRECTORY>
```

---

### 1.2 Install Dependencies
Install all required packages using Yarn:

```bash
yarn install
```

---

### 1.3 Generate the iOS Bundle
Run the following command to bundle the JavaScript for iOS:

```bash
npx react-native bundle   --platform ios   --dev false   --entry-file index.js   --bundle-output ios/main.jsbundle   --assets-dest ios
```

This will create:
- `main.jsbundle` → The compiled JavaScript code.
- Assets copied into the `ios` directory.

---

### 1.4 Verify the Bundle
Ensure the bundle is generated successfully:

```bash
ls ios | grep main.jsbundle
```

---

## 📦 Step 2 — Integrate with the iOS SDK

1. Copy the `main.jsbundle` and asset files into your **iOS SDK resources folder**.
2. Make sure the bundle is included in your SDK target's **Build Phases → Copy Bundle Resources** in Xcode.
3. Rebuild the SDK.

---

## 🛠 Troubleshooting

- **Metro bundler not found**  
  Install it globally:  
  ```bash
  yarn global add react-native-cli
  ```

- **Permission denied**  
  Ensure you have execution rights:  
  ```bash
  chmod +x <script_file>
  ```

- **CocoaPods errors**  
  Navigate to the `ios` folder and run:  
  ```bash
  pod install
  ```

---

## 📄 License
This guide is for internal use. Unauthorized sharing is prohibited.
