import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demeter/models/user.dart' as model;
import 'package:demeter/providers/user_provider.dart';
import 'package:demeter/resources/firestore_methods.dart';
import 'package:demeter/utils/colors.dart';
import 'package:demeter/widgets/comment_card.dart';
import 'package:demeter/widgets/text_field_input.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final dynamic snap;
  const CommentsScreen({super.key, required this.snap});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Positioned(
          top: 5,
          child: Container(
            decoration: BoxDecoration(
              color: lightDemeter.withOpacity(0.4),
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ),
            width: 32,
            height: 4,
          ),
        ),
        Center(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text('Comments'),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: lightDemeter,
              ),
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.snap['postId'])
                        .collection('comments')
                        .orderBy(
                          'datePublished',
                          descending: true,
                        )
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return ListView.builder(
                          itemCount: (snapshot.data as dynamic).docs.length,
                          itemBuilder: (context, index) => CommentCard(
                                snap: (snapshot.data as dynamic)
                                    .docs[index]
                                    .data(),
                              ));
                    }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: user != null
                          ? CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(user.photoUrl),
                            )
                          : const CircleAvatar(
                              radius: 20,
                              backgroundColor: lightDemeter,
                            ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                        child: TextFieldInput(
                          textEditingController: _commentController,
                          hintText: user != null
                              ? "Comment as ${user.username}..."
                              : "Comment...",
                          textInputType: TextInputType.text,
                        ),
                      ),
                    ),
                    if (user != null)
                      IconButton(
                        onPressed: () async {
                          String res = await FirestoreMethods().postComment(
                              widget.snap['postId'],
                              _commentController.text,
                              user.uid,
                              user.username,
                              user.photoUrl);
                          if (res == 'success') {
                            setState(() {
                              _commentController.text = '';
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.send,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
