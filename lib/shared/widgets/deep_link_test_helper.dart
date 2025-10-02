import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

/// Widget to help test and share deep links
class DeepLinkTestHelper extends StatelessWidget {
  const DeepLinkTestHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.share),
      tooltip: 'Test Deep Link',
      onPressed: () => _showDeepLinkDialog(context),
    );
  }

  void _showDeepLinkDialog(BuildContext context) {
    final controller = TextEditingController(text: '9DMLIqXVUesGdgrJLCb8');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deep Link Testi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hasta ID:'),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Hasta ID girin',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Oluşturulacak link:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.grey[200],
              child: SelectableText(
                'myapp://addPatient?id=${controller.text}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              final link = 'myapp://addPatient?id=${controller.text}';
              Clipboard.setData(ClipboardData(text: link));
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Link kopyalandı!')));
            },
            child: const Text('Kopyala'),
          ),
          TextButton(
            onPressed: () async {
              final link =
                  'https://medical-app-2c545.web.app/addPatient?id=${controller.text}';
              SharePlus.instance.share(
                ShareParams(
                  text:
                      'ID: ${controller.text}\n*Hasta bilgisini eklemek için linki kullanın\n$link',
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Paylaş'),
          ),
        ],
      ),
    );
  }
}
