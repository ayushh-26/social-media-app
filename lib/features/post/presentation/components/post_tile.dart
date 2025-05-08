import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app/features/auth/presentation/components/my_text_field.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app/features/post/domain/entities/comment.dart';
import 'package:social_media_app/features/post/domain/entities/post.dart';
import 'package:social_media_app/features/post/presentation/components/comment_tile.dart';
import 'package:social_media_app/features/post/presentation/cubits/post_cubit.dart';
import 'package:social_media_app/features/post/presentation/cubits/post_states.dart';
import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profile/presentation/cubits/profile_cubits.dart';
import 'package:social_media_app/features/profile/presentation/pages/profile_page.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;

  const PostTile({
    super.key,
    required this.post,
    required this.onDeletePressed,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnPost = false;
  AppUser? currentUser;
  ProfileUser? postUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchPostUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.post.userId == currentUser?.uid);
  }

  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  void toggleLikePost() {
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    // Optimistically update UI
    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid); // unlike
      } else {
        widget.post.likes.add(currentUser!.uid); //like
      }
    });

    postCubit.toggleLikePost(widget.post.id, currentUser!.uid).catchError((
      error,
    ) {
      // Revert UI if error
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currentUser!.uid); // revert unlike
        } else {
          widget.post.likes.remove(currentUser!.uid); // revert like
        }
      });
    });
  }

  /*

comments

*/

  // comments text controller
  final commentTextController = TextEditingController();

  // open comment box -> user wants to type a new comment
  void openCommentBox() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Add a new comment"),
            content: MyTextField(
              controller: commentTextController,
              hintText: "Type a comment",
              obscureText: false,
            ),

            actions: [
              // cancel button
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ), // TextButton
              // save button
              TextButton(
                onPressed: () {
                  addComment();
                  Navigator.of(context).pop();
                },
                child: const Text("Save"),
              ), // TextButton
            ],
          ),
    );
  }

  void addComment() {
    // create a new comment
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: commentTextController.text,
      timestamp: DateTime.now(),
    ); // Comment

    // add comment using cubit
    if (commentTextController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
    }
  }

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  void showOptions() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Delete Post"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  widget.onDeletePressed?.call();
                  Navigator.of(context).pop();
                },
                child: const Text("Delete"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          // Top section
          GestureDetector(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(uid: widget.post.userId),
                  ),
                ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Profile image
                  if (postUser?.profileImageUrl != null)
                    CachedNetworkImage(
                      imageUrl: postUser!.profileImageUrl,
                      imageBuilder:
                          (context, imageProvider) => Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => const Icon(Icons.person),
                    )
                  else
                    const Icon(Icons.person, size: 40),

                  const SizedBox(width: 10),

                  // User name
                  Text(
                    postUser?.name ?? widget.post.userName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  // Delete button
                  if (isOwnPost)
                    GestureDetector(
                      onTap: showOptions,
                      child: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Post image
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(height: 430),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),

          // Buttons row
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: toggleLikePost,
                        child: Icon(
                          widget.post.likes.contains(currentUser!.uid)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              widget.post.likes.contains(currentUser!.uid)
                                  ? Colors.red
                                  : Theme.of(context).colorScheme.primary,
                        ),
                      ),

                      const SizedBox(width: 5),
                      // like count
                      Text(
                        widget.post.likes.length.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // when i toggle the like the entire page is getting reloaded so thats part of the state maangement when i tap onlike button we are currently sending this information to firestore and then we are refetching thata nd displaying back to our app thats why it is loading again and take a bit of time
                GestureDetector(
                  onTap: openCommentBox,
                  child: Icon(
                    Icons.comment,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                Text(
                  widget.post.comments.length.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                  ),
                ),

                const Spacer(),

                //Timestamp
                Text(widget.post.timestamp.toString().split(".").first),
              ],
            ),
          ),

          // caption
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
            child: Row(
              children: [
                // username
                Text(
                  widget.post.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(width: 10),

                // text
                Text(widget.post.text),
              ],
            ),
          ),
          // comment section
          BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              // LOADED
              if (state is PostsLoaded) {
                // final individual post
                final post = state.posts.firstWhere(
                  (post) => post.id == widget.post.id,
                );

                if (post.comments.isNotEmpty) {
                  // how many comments to show
                  int showCommentCount = post.comments.length;

                  // comment section
                  return ListView.builder(
                    itemCount: showCommentCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      // get individual comment
                      final comment = post.comments[index];

                      // comment tile UI
                      return CommentTile(comment: comment); // Row
                    },
                  );
                }
              }

              // LOADING ..
              if (state is PostsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              // ERROR
              else if (state is PostsError) {
                return Center(child: Text(state.message));
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
