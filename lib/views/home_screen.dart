import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

import '../viewmodels/auth_viewmodel.dart';
import '../models/document.dart';
import '../services/export_service.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final ExportService _exportService = ExportService();

  List<Document> _documents = [];
  Document? _selectedDocument;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showExportDialog(Document document) {
    showDialog(
      context: context,
      builder: (context) {
        String selectedFormat = 'jpeg';
        return AlertDialog(
          title: const Text('Export Document'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: const Text('JPEG'),
                    value: 'jpeg',
                    groupValue: selectedFormat,
                    onChanged: (value) {
                      setState(() {
                        selectedFormat = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('PNG'),
                    value: 'png',
                    groupValue: selectedFormat,
                    onChanged: (value) {
                      setState(() {
                        selectedFormat = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('PDF'),
                    value: 'pdf',
                    groupValue: selectedFormat,
                    onChanged: (value) {
                      setState(() {
                        selectedFormat = value!;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final fileName = document.name;

                String exportedPath = '';
                if (selectedFormat == 'pdf') {
                  exportedPath = await _exportService.exportImageAsPdf(
                    Uint8List.fromList(document.content),
                    fileName,
                  );
                } else {
                  exportedPath = await _exportService.exportImage(
                    Uint8List.fromList(document.content),
                    fileName,
                    selectedFormat,
                  );
                }

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Exported to: \$exportedPath')),
                );
              },
              child: const Text('Export'),
            ),
          ],
        );
      },
    );
  }

  void _uploadDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'txt'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;

      // Prompt for file name override
      final fileNameController = TextEditingController(text: file.name);
      final newName = await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter file name'),
            content: TextField(
              controller: fileNameController,
              decoration: const InputDecoration(labelText: 'File Name'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, fileNameController.text.trim());
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      if (newName != null && newName.isNotEmpty) {
        final newDoc = Document(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: newName,
          content: file.bytes ?? [],
        );
        setState(() {
          _documents.add(newDoc);
          _selectedDocument = newDoc;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('DocxSafe'),
        actions: [
          IconButton(
            icon: Icon(authVM.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              authVM.toggleDarkMode();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authVM.setAuthenticated(false);
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _selectedDocument == null
                ? null
                : () => _showExportDialog(_selectedDocument!),
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? DocumentsScreen(
              documents: _documents,
              selectedDocument: _selectedDocument,
              onSelectDocument: (doc) {
                setState(() {
                  _selectedDocument = doc;
                });
              },
              onAddFolder: _showAddFolderDialog,
            )
          : _selectedIndex == 1
          ? Center(child: Text('Tags Screen'))
          : const SettingsScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadDocument,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Documents'),
          BottomNavigationBarItem(icon: Icon(Icons.label), label: 'Tags'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _showAddFolderDialog(BuildContext context) {
    final _folderNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Folder'),
          content: TextField(
            controller: _folderNameController,
            decoration: const InputDecoration(labelText: 'Folder Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final folderName = _folderNameController.text.trim();
                if (folderName.isNotEmpty) {
                  // TODO: Implement folder creation logic
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Folder "$folderName" added (not implemented)',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class DocumentsScreen extends StatelessWidget {
  final List<Document> documents;
  final Document? selectedDocument;
  final ValueChanged<Document> onSelectDocument;
  final void Function(BuildContext) onAddFolder;

  const DocumentsScreen({
    Key? key,
    required this.documents,
    required this.selectedDocument,
    required this.onSelectDocument,
    required this.onAddFolder,
  }) : super(key: key);

  void _showDocumentPreview(BuildContext context, Document document) {
    showDialog(
      context: context,
      builder: (context) {
        Widget contentWidget;
        if (document.name.toLowerCase().endsWith('.jpg') ||
            document.name.toLowerCase().endsWith('.jpeg') ||
            document.name.toLowerCase().endsWith('.png')) {
          contentWidget = Image.memory(
            Uint8List.fromList(document.content),
            fit: BoxFit.contain,
          );
        } else if (document.name.toLowerCase().endsWith('.txt')) {
          contentWidget = SingleChildScrollView(
            child: Text(String.fromCharCodes(document.content)),
          );
        } else {
          contentWidget = const Center(
            child: Text('Preview not available for this file type.'),
          );
        }

        return AlertDialog(
          title: Text(document.name),
          content: SizedBox(width: 350, height: 450, child: contentWidget),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: documents.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final doc = documents[index];
              final isSelected = doc == selectedDocument;
              return ListTile(
                leading: Icon(
                  doc.name.toLowerCase().endsWith('.pdf')
                      ? Icons.picture_as_pdf
                      : (doc.name.toLowerCase().endsWith('.txt')
                            ? Icons.description
                            : Icons.image),
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                title: Text(
                  doc.name,
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                selected: isSelected,
                onTap: () => onSelectDocument(doc),
                trailing: isSelected
                    ? ElevatedButton(
                        onPressed: () =>
                            _showDocumentPreview(context, selectedDocument!),
                        child: const Text('View'),
                      )
                    : null,
              );
            },
          ),
        ),
        if (selectedDocument != null)
          Container(
            height: 180,
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey.shade100,
            ),
            child: Builder(
              builder: (context) {
                if (selectedDocument!.name.toLowerCase().endsWith('.jpg') ||
                    selectedDocument!.name.toLowerCase().endsWith('.jpeg') ||
                    selectedDocument!.name.toLowerCase().endsWith('.png')) {
                  return Image.memory(
                    Uint8List.fromList(selectedDocument!.content),
                    fit: BoxFit.contain,
                  );
                } else if (selectedDocument!.name.toLowerCase().endsWith(
                  '.txt',
                )) {
                  return SingleChildScrollView(
                    child: Text(
                      String.fromCharCodes(selectedDocument!.content),
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                } else {
                  return const Center(child: Text('No preview available'));
                }
              },
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.create_new_folder),
            label: const Text('Add Folder'),
            onPressed: () => onAddFolder(context),
          ),
        ),
      ],
    );
  }
}
