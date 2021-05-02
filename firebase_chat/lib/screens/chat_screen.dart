import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 320-321) flutter class, probably integrated to work with google`s library?
      body: StreamBuilder(
        // 320-321) how to access collections with their id and some of their props.
        stream: Firestore.instance
            .collection('chats/jdXMcEP9xkQh3x3MgL4S/messages')
            .snapshots(),
        builder: (ctx, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final documents = streamSnapshot.data.documents;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (ctx, index) => Container(
              padding: EdgeInsets.all(8),
              child: Text(documents[index]['text']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // [318] this is how you access the db, which is nice.
          Firestore.instance
              .collection('chats/jdXMcEP9xkQh3x3MgL4S/messages')
              .add({'text': 'This was added by clicking the button!'});
        },
      ),
    );
  }
}

// StreamBuilder(
//   stream: Firestore.instance
//       .collection('chats/WJtXsfXnb4iRu38sDbEM/messages')
//       .snapshots(),
//   builder: (ctx, streamSnapshot) {
//     if (streamSnapshot.connectionState == ConnectionState.waiting) {
//       return Center(
//         child: CircularProgressIndicator(),
//       );
//     }
//     final documents = streamSnapshot.data.documents;
//     return ListView.builder(
//       itemCount: documents.length,
//       itemBuilder: (ctx, index) => Container(
//         padding: EdgeInsets.all(8),
//         child: Text(documents[index]['text']),
//       ),
//     );
//   },
// ),
