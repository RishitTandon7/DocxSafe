# DocxSafe

DocxSafe is a Flutter-based secure document management application that allows users to upload, view, and share documents securely. It supports biometric authentication and PIN setup for enhanced security.

## Features

- **User Authentication:** Supports biometric authentication and PIN-based authentication.
- **Document Upload:** Upload images (JPEG, PNG), PDFs, and text files from device storage.
- **Document Management:** View a list of uploaded documents with file type icons.
- **Document Preview:** Preview images and text files within the app.
- **Document Export:** Export documents in JPEG, PNG, or PDF formats.
- **Folder Management:** Create folders to organize documents (folder creation UI available; functionality to be implemented).
- **Dark Mode:** Toggle between light and dark themes.
- **Settings:** Manage app settings including PIN setup.

## Getting Started

### Prerequisites

- Flutter SDK (version 3.8.1 or compatible)
- Dart SDK
- Compatible IDE (e.g., VSCode, Android Studio)

### Installation

1. Clone the repository:
   ```
   git clone <repository-url>
   cd docxsafe
   ```

2. Install dependencies:
   ```
   flutter pub get
   ```

3. Run the app:
   ```
   flutter run
   ```

## Usage

- Use the "+" button to upload documents from your device.
- Select a document from the list to preview or export it.
- Use the "Add Folder" button to create folders (functionality to be implemented).
- Toggle dark mode using the icon in the app bar.
- Log out using the logout icon.
- Configure PIN and other settings in the Settings tab.

## Project Structure

- `lib/`
  - `models/`: Data models for Document and Folder.
  - `viewmodels/`: State management classes.
  - `views/`: UI screens including HomeScreen, SettingsScreen, and PIN setup dialog.
  - `services/`: Services like ExportService for document export functionality.
  - `main.dart`: App entry point and theme configuration.

## Notes

- Folder management is partially implemented; folder creation UI is present but backend logic is pending.
- Document preview supports images and text files; PDF preview shows a placeholder message.
- Material 3 design is disabled for better UI customization.

## Contributing

Contributions are welcome! Please open issues or submit pull requests for improvements.

## License

This project is licensed under the MIT License.
