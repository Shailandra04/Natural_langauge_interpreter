# Natural Language Translator with OCR

A Flutter application that translates text using the Google Translation API and integrates Optical Character Recognition (OCR) to extract text from images for translation.

This app combines real-time text translation and OCR capabilities, allowing users to scan images, extract text, and translate it into different languages. It uses the Google Cloud Translation API for text translation and a popular Flutter OCR plugin to extract text from images.

## Features

- **Real-time Text Translation**: Translate text between multiple languages.
- **Google Translate API**: Utilizes Google Cloud's Translation API for high accuracy and speed.
- **Multi-language Support**: Supports translation between a wide range of languages.
- **OCR Support**: Scan images, extract text, and translate the extracted text.
- **Simple and Intuitive UI**: Easy-to-use interface built with Flutter.

## Prerequisites

Before you begin, ensure you have the following installed:

- [Flutter](https://flutter.dev/docs/get-started/install) - Version 3.x or above
- [Google Cloud API Key](https://cloud.google.com/docs/authentication/getting-started) - You'll need a valid Google Cloud API key for accessing the Google Translation API.
- Flutter plugin for OCR (e.g., [google_ml_kit](https://pub.dev/packages/google_ml_kit) or [firebase_ml_vision](https://pub.dev/packages/firebase_ml_vision)).

## Getting Started

To get started with the project:

### 1. Clone the Repository

Clone this repo to your local machine using:

```bash
git clone https://github.com/Shailandra04/Natural_langauge_interpreter.git

### 2. Install Dependencies

Navigate to the project folder and install the required dependencies using `flutter pub get`:

```bash
cd Natural_langauge_interpreter
flutter pub get

## 3. Set Up Google Cloud Translation API

- Go to the [Google Cloud Console](https://console.cloud.google.com/).
- Create a new project (or select an existing one).
- Enable the **Cloud Translation API** for your project.
- Generate an **API key** and save it for use in the app.

## 4. Set Up Google Cloud Vision API for OCR

- In the [Google Cloud Console](https://console.cloud.google.com/), enable the **Cloud Vision API** for your project.
- Generate a **Vision API key** and save it.

## 5. Configure the API Keys

In your Flutter project, navigate to where you store your API keys (e.g., `.env` file or directly in your code) and add the following code snippet for both APIs:

```dart
final String translationApiKey = 'YOUR_GOOGLE_TRANSLATION_API_KEY';
final String visionApiKey = 'YOUR_GOOGLE_VISION_API_KEY';

## 6. Run the App

Once you have everything set up, run the app on your device or emulator:

```bash
flutter run
