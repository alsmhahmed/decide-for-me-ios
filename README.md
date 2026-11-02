# Decide For Me 🧠

A hyper-rational decision assistant iOS app for chronically indecisive people facing life choices (career shifts, moving apartments, choosing hobbies). The user inputs their dilemma (Option A vs. Option B), and the app weighs both options against their core personal priorities to deliver a clear verdict, justification, and actionable first step.

The app is built with native SwiftUI, following the Modern Minimalist design system generated via Google Stitch, and supports both English and Arabic (with complete Right-to-Left layout adaptation).

---

## 🛠 Tech Stack

- **UI & Architecture**: SwiftUI (iOS 17+), MVVM pattern with clean service abstraction.
- **Styling & Design System**: Custom tokens from Google Stitch (colors, Inter typography with dynamic Arabic system font fallback, 4px/8px grid system, continuous smooth corners).
- **Authentication**: Firebase Authentication (Anonymous sign-in on app launch).
- **Database**: Cloud Firestore (Real-time snapshot listener on `users/{uid}` for persistent user priorities).
- **AI Engine**: Firebase AI Logic (`TemplateGenerativeModel` using Gemini Developer API backend) powered by a server prompt template (`decider-flow`).
- **Security**: Firebase App Check with `AppCheckDebugProviderFactory` enabled in DEBUG builds.
- **Localization**: Native String Catalog (`Localizable.xcstrings`) supporting English and Modern Standard Arabic (العربية), with in-app language switching and dynamic RTL flipping.

---

## 🚀 Setup & Getting Started

> **Note**: `GoogleService-Info.plist` is intentionally excluded from this repository for security and privacy. You must provide your own Firebase configuration to build and run the app.

### Prerequisites

- macOS with Xcode 15+ installed.
- iOS 17.0+ deployment target (Simulator or physical iPhone).

### 1. Clone the Repository

```bash
git clone <repository-url>
cd decide-for-me-ios
```

### 2. Configure Firebase

1. Go to the [Firebase Console](https://console.firebase.google.com/) and create a new Firebase project (or use an existing one).
2. Register an **Apple/iOS app** in your Firebase project:
   - Bundle ID: `com.alsmhahmed.DecideForMe` (or adjust the bundle ID in Xcode under Project Settings > Signing & Capabilities to match your own).
3. Download your `GoogleService-Info.plist` file from Firebase.
4. Move `GoogleService-Info.plist` into the `DecideForMe/` directory and ensure it is included in the `DecideForMe` app target.

### 3. Enable Firebase Services

1. **Authentication**:
   - In Firebase Console > Authentication > Sign-in method, enable **Anonymous** sign-in.
2. **Cloud Firestore**:
   - In Firebase Console > Firestore Database, create a database.
   - The app reads and writes user priorities at `users/{uid}` (field: `priorities: string`).
3. **Firebase AI Logic**:
   - Enable the **Firebase AI Logic** API in your project (using the Gemini Developer API backend).
   - In the Firebase Console, create a server prompt template with ID:
     ```
     decider-flow
     ```
   - Configure the template to accept variables `{{priorities}}`, `{{optionA}}`, and `{{optionB}}`.
   - Ensure the model response returns structured JSON with the following fields:
     ```json
     {
       "verdict": "...",
       "justification": "...",
       "firstStep": "..."
     }
     ```

### 4. Configure App Check (Debug Token)

1. When running in Xcode (Debug build), Firebase App Check prints a debug token to the Xcode console on first launch:
   ```
   [AppCheckCore] Firebase App Check debug token: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
   ```
2. Copy this token, navigate to **Firebase Console > App Check > Apps > Manage debug tokens**, and add the token.

### 5. Build and Run

1. Open `DecideForMe.xcodeproj` in Xcode.
2. Let Xcode resolve Swift Package Dependencies (`firebase-ios-sdk`).
3. Select your destination (Simulator or physical iPhone) and press **Run** (`⌘R`).
