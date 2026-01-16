import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'db/app_database.dart';

void main() {
  runApp(const SnackKeeperApp());
}

enum DateType { expiry, production }

class SnackKeeperApp extends StatefulWidget {
  const SnackKeeperApp({super.key});

  @override
  State<SnackKeeperApp> createState() => _SnackKeeperAppState();
}

class _SnackKeeperAppState extends State<SnackKeeperApp> {
  final AppDatabase _database = AppDatabase();

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnackKeeper',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: HomePage(database: _database),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SnackKeeper'),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TrashPage(database: database),
                ),
              );
            },
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Trash',
          ),
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => EatenPage(database: database),
                ),
              );
            },
            icon: const Icon(Icons.history),
            tooltip: 'Eaten',
          ),
        ],
      ),
      body: StreamBuilder<List<Snack>>(
        stream: database.watchActiveSnacks(),
        builder: (context, snapshot) {
          final snacks = snapshot.data ?? [];
          if (snacks.isEmpty) {
            return const Center(
              child: Text('No snacks yet.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snacks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final snack = snacks[index];
              return Dismissible(
                key: ValueKey(snack.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.green,
                  padding: const EdgeInsets.only(right: 16),
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.check, color: Colors.white),
                ),
                onDismissed: (_) async {
                  await database.markEaten(snack.id);
                  if (!context.mounted) {
                    return;
                  }
                  final messenger = ScaffoldMessenger.of(context);
                  messenger.clearSnackBars();
                  messenger.showSnackBar(
                    SnackBar(
                      content: const Text('Marked as eaten.'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () async {
                          await database.restoreEaten(snack.id);
                        },
                      ),
                    ),
                  );
                },
                child: Card(
                  child: ListTile(
                    leading: SizedBox(
                      width: 64,
                      height: 64,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(snack.imagePath),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image);
                          },
                        ),
                      ),
                    ),
                    title: Text(snack.expiryDate),
                    subtitle: _buildSnackSubtitle(snack),
                    onTap: () {
                      _showSnackPreview(context, snack);
                    },
                    onLongPress: () async {
                      final confirmed = await _confirmMoveToTrash(context);
                      if (confirmed) {
                        await database.trashSnack(snack.id);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AddSnackPage(database: database),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Widget? _buildSnackSubtitle(Snack snack) {
  final details = <String>[];
  if (snack.name != null && snack.name!.trim().isNotEmpty) {
    details.add(snack.name!.trim());
  }
  if (snack.quantity != null && snack.quantity!.trim().isNotEmpty) {
    details.add('Qty: ${snack.quantity!.trim()}');
  }
  if (details.isEmpty) {
    return null;
  }
  return Text(details.join(' · '));
}

Widget? _buildTrashSubtitle(Snack snack) {
  final details = <String>[];
  if (snack.name != null && snack.name!.trim().isNotEmpty) {
    details.add(snack.name!.trim());
  }
  if (snack.quantity != null && snack.quantity!.trim().isNotEmpty) {
    details.add('Qty: ${snack.quantity!.trim()}');
  }
  details.add('Trashed: ${_formatDateFromMillis(snack.trashedAt)}');
  return Text(details.join(' · '));
}

Widget? _buildEatenSubtitle(Snack snack) {
  final details = <String>[];
  if (snack.name != null && snack.name!.trim().isNotEmpty) {
    details.add(snack.name!.trim());
  }
  if (snack.quantity != null && snack.quantity!.trim().isNotEmpty) {
    details.add('Qty: ${snack.quantity!.trim()}');
  }
  details.add('Eaten: ${_formatDateFromMillis(snack.eatenAt)}');
  return Text(details.join(' · '));
}

Future<bool> _confirmMoveToTrash(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Move to Trash?'),
        content: const Text('You can restore it within 30 days.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Move'),
          ),
        ],
      );
    },
  );
  return result ?? false;
}

void _showSnackPreview(BuildContext context, Snack snack) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return Dialog(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Product Photo'),
              const SizedBox(height: 8),
              _buildPreviewImage(snack.imagePath),
              if (snack.expiryImagePath != null &&
                  snack.expiryImagePath!.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Expiry Photo'),
                const SizedBox(height: 8),
                _buildPreviewImage(snack.expiryImagePath!),
              ],
              const SizedBox(height: 16),
              Text('Expiry Date: ${snack.expiryDate}'),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildPreviewImage(String imagePath) {
  return SizedBox(
    height: 240,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.file(
        File(imagePath),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Text('Image not found.'));
        },
      ),
    ),
  );
}

String _formatDateFromMillis(int? millis) {
  if (millis == null) {
    return '-';
  }
  final date = DateTime.fromMillisecondsSinceEpoch(millis);
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

class AddSnackPage extends StatefulWidget {
  const AddSnackPage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<AddSnackPage> createState() => _AddSnackPageState();
}

class _AddSnackPageState extends State<AddSnackPage> {
  String? _imagePath;
  String? _expiryImagePath;
  String? _expiryDateText;
  DateTime? _detectedDate;
  DateType _dateType = DateType.expiry;
  final TextEditingController _shelfLifeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  bool _saving = false;
  bool _scanning = false;

  bool get _canSave =>
      _imagePath != null &&
      _expiryImagePath != null &&
      _expiryDateText != null &&
      !_saving;

  @override
  void dispose() {
    _shelfLifeController.dispose();
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    final savedPath = await _pickAndSaveImage('snack');
    if (savedPath == null) {
      return;
    }
    setState(() {
      _imagePath = savedPath;
    });
  }

  Future<void> _takeExpiryPhoto() async {
    final savedPath = await _pickAndSaveImage('expiry');
    if (savedPath == null) {
      return;
    }
    setState(() {
      _expiryImagePath = savedPath;
    });
  }

  Future<String?> _pickAndSaveImage(String prefix) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked == null) {
      return null;
    }

    final dir = await getApplicationDocumentsDirectory();
    final extension = p.extension(picked.path);
    final fileName =
        '${prefix}_${DateTime.now().millisecondsSinceEpoch}$extension';
    final savedFile = await File(picked.path).copy(p.join(dir.path, fileName));
    return savedFile.path;
  }

  Future<void> _pickExpiryDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
    );
    if (picked == null) {
      return;
    }

    setState(() {
      _detectedDate = picked;
    });
    _updateExpiryFromInputs();
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Future<void> _scanExpiryDate() async {
    if (_expiryImagePath == null || _scanning) {
      return;
    }

    setState(() {
      _scanning = true;
    });

    final recognizer = TextRecognizer();
    try {
      final inputImage = InputImage.fromFilePath(_expiryImagePath!);
      final result = await recognizer.processImage(inputImage);
      final date = _extractDateFromText(result.text);
      if (date != null) {
        setState(() {
          _detectedDate = date;
        });
        _updateExpiryFromInputs();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No date found. Try again or pick it.')),
          );
        }
      }
    } finally {
      await recognizer.close();
      if (mounted) {
        setState(() {
          _scanning = false;
        });
      }
    }
  }

  DateTime? _extractDateFromText(String text) {
    final patterns = [
      RegExp(r'(20\d{2})\s*[./-]\s*(\d{1,2})\s*[./-]\s*(\d{1,2})'),
      RegExp(r'(20\d{2})\s*年\s*(\d{1,2})\s*月\s*(\d{1,2})\s*日'),
      RegExp(r'(?<!\d)(20\d{2})\s*(\d{2})\s*(\d{2})(?!\d)'),
      RegExp(r'(?<!\d)(\d{2})\s*[./-]\s*(\d{1,2})\s*[./-]\s*(\d{1,2})(?!\d)'),
    ];

    for (final pattern in patterns) {
      for (final match in pattern.allMatches(text)) {
        final year = int.parse(match.group(1)!);
        final month = int.parse(match.group(2)!);
        final day = int.parse(match.group(3)!);
        final fullYear = year < 100 ? 2000 + year : year;

        if (month < 1 || month > 12 || day < 1 || day > 31) {
          continue;
        }

        return DateTime(fullYear, month, day);
      }
    }
    return null;
  }

  void _updateExpiryFromInputs() {
    if (_detectedDate == null) {
      setState(() {
        _expiryDateText = null;
      });
      return;
    }

    if (_dateType == DateType.expiry) {
      setState(() {
        _expiryDateText = _formatDate(_detectedDate!);
      });
      return;
    }

    final months = int.tryParse(_shelfLifeController.text.trim());
    if (months == null || months <= 0) {
      setState(() {
        _expiryDateText = null;
      });
      return;
    }

    final expiry = _addMonths(_detectedDate!, months);
    setState(() {
      _expiryDateText = _formatDate(expiry);
    });
  }

  DateTime _addMonths(DateTime base, int months) {
    return DateTime(base.year, base.month + months, base.day);
  }

  Future<void> _saveSnack() async {
    if (!_canSave) {
      return;
    }

    setState(() {
      _saving = true;
    });

    await widget.database.addSnack(
      imagePath: _imagePath!,
      expiryImagePath: _expiryImagePath!,
      expiryDate: _expiryDateText!,
      name: _nameController.text.trim().isEmpty
          ? null
          : _nameController.text.trim(),
      quantity: _quantityController.text.trim().isEmpty
          ? null
          : _quantityController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Snack'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _takePhoto,
                      icon: const Icon(Icons.photo_camera),
                      label: const Text('Take Product Photo'),
                    ),
                    const SizedBox(height: 12),
                    if (_imagePath != null)
                      SizedBox(
                        height: 180,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_imagePath!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _takeExpiryPhoto,
                      icon: const Icon(Icons.receipt),
                      label: const Text('Take Expiry Photo'),
                    ),
                    const SizedBox(height: 12),
                    if (_expiryImagePath != null)
                      SizedBox(
                        height: 180,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_expiryImagePath!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _pickExpiryDate,
              icon: const Icon(Icons.event),
              label: const Text('Pick Expiry Date'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _scanExpiryDate,
              icon: const Icon(Icons.text_snippet),
              label: Text(_scanning ? 'Scanning...' : 'Scan Expiry Date'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<DateType>(
              value: _dateType,
              decoration: const InputDecoration(
                labelText: 'Detected Date Type',
              ),
              items: const [
                DropdownMenuItem(
                  value: DateType.expiry,
                  child: Text('Expiry date'),
                ),
                DropdownMenuItem(
                  value: DateType.production,
                  child: Text('Production date'),
                ),
              ],
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _dateType = value;
                  if (_dateType == DateType.expiry) {
                    _shelfLifeController.text = '';
                  }
                });
                _updateExpiryFromInputs();
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _shelfLifeController,
              decoration: const InputDecoration(
                labelText: 'Shelf life (months)',
              ),
              keyboardType: TextInputType.number,
              enabled: _dateType == DateType.production,
              onChanged: (_) => _updateExpiryFromInputs(),
            ),
            const SizedBox(height: 12),
            Text(
              _detectedDate == null
                  ? 'No date detected'
                  : 'Detected: ${_formatDate(_detectedDate!)}',
            ),
            const SizedBox(height: 8),
            Text(_expiryDateText == null
                ? 'Expiry date not ready'
                : 'Expiry date: $_expiryDateText'),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                        labelText: 'Snack Name (optional)',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity (optional)',
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _canSave ? _saveSnack : null,
                      child: _saving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Save'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TrashPage extends StatefulWidget {
  const TrashPage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  @override
  void initState() {
    super.initState();
    widget.database.purgeOldTrash(const Duration(days: 30));
  }

  Future<void> _confirmDelete(Snack snack) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete permanently?'),
          content: const Text('This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      await widget.database.deleteSnackPermanently(snack);
    }
  }

  Future<void> _confirmClearTrash() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear trash?'),
          content: const Text('This deletes all items permanently.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      await widget.database.clearTrash();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trash (30 days)'),
        actions: [
          IconButton(
            onPressed: _confirmClearTrash,
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear trash',
          ),
        ],
      ),
      body: StreamBuilder<List<Snack>>(
        stream: widget.database.watchTrashSnacks(),
        builder: (context, snapshot) {
          final snacks = snapshot.data ?? [];
          if (snacks.isEmpty) {
            return const Center(child: Text('Trash is empty.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snacks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final snack = snacks[index];
              return Card(
                child: ListTile(
                  leading: SizedBox(
                    width: 64,
                    height: 64,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(snack.imagePath),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image);
                        },
                      ),
                    ),
                  ),
                  title: Text(snack.expiryDate),
                  subtitle: _buildTrashSubtitle(snack),
                  onTap: () {
                    _showSnackPreview(context, snack);
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          await widget.database.restoreSnack(snack.id);
                        },
                        icon: const Icon(Icons.restore),
                        tooltip: 'Restore',
                      ),
                      IconButton(
                        onPressed: () => _confirmDelete(snack),
                        icon: const Icon(Icons.delete),
                        tooltip: 'Delete',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EatenPage extends StatelessWidget {
  const EatenPage({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eaten History'),
      ),
      body: StreamBuilder<List<Snack>>(
        stream: database.watchEatenSnacks(),
        builder: (context, snapshot) {
          final snacks = snapshot.data ?? [];
          if (snacks.isEmpty) {
            return const Center(child: Text('No eaten snacks yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snacks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final snack = snacks[index];
              return Card(
                child: ListTile(
                  leading: SizedBox(
                    width: 64,
                    height: 64,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(snack.imagePath),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image);
                        },
                      ),
                    ),
                  ),
                  title: Text(snack.expiryDate),
                  subtitle: _buildEatenSubtitle(snack),
                  onTap: () {
                    _showSnackPreview(context, snack);
                  },
                  trailing: IconButton(
                    onPressed: () async {
                      await database.restoreEaten(snack.id);
                    },
                    icon: const Icon(Icons.restore),
                    tooltip: 'Restore',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
