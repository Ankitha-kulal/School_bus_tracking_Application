import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentListPage extends StatelessWidget {
  final String busNumber;

  StudentListPage({required this.busNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students for Bus $busNumber'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('busNumber', isEqualTo: busNumber)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var studentDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: studentDocs.length,
            itemBuilder: (context, index) {
              var studentData = studentDocs[index].data() as Map<String, dynamic>;

              return Card(
                child: ListTile(
                  title: Text(studentData['name'] ?? 'No name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: studentData.entries.map((entry) {
                      return Text('${entry.key}: ${entry.value}');
                    }).toList(),
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
