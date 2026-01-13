import 'package:flutter/material.dart';
import '../services/local_service.dart';
import '../services/cloud_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();
  final LocalService localService = LocalService();
  final CloudService cloudService = CloudService();

  String storage = 'local';
  List<String> localData = [];

  @override
  void initState() {
    super.initState();
    loadLocalData();
  }

  Future<void> loadLocalData() async {
    localData = await localService.getData();
    setState(() {});
  }

  void addData() async {
    if (controller.text.isEmpty) return;

    if (storage == 'local') {
      await localService.addData(controller.text);
      await loadLocalData();
    } else {
      await cloudService.addData(controller.text);
    }

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CRUD Mobile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            RadioListTile(
              title: const Text('Local Storage'),
              value: 'local',
              groupValue: storage,
              onChanged: (value) {
                setState(() => storage = value!);
                loadLocalData();
              },
            ),
            RadioListTile(
              title: const Text('Cloud Storage'),
              value: 'cloud',
              groupValue: storage,
              onChanged: (value) {
                setState(() => storage = value!);
              },
            ),

            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: addData,
              child: const Text('Tambah'),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: storage == 'local'
                  ? ListView.builder(
                      itemCount: localData.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(localData[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await localService.deleteData(index);
                              loadLocalData();
                            },
                          ),
                        );
                      },
                    )
                  : StreamBuilder(
                      stream: cloudService.getData(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final docs = snapshot.data!.docs;

                        return ListView(
                          children: docs.map((doc) {
                            return ListTile(
                              title: Text(doc['name']),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  cloudService.deleteData(doc.id);
                                },
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
