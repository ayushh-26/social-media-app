import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/home/presentation/components/my_drawer.dart';
import 'package:social_media_app/features/post/presentation/components/post_tile.dart';
import 'package:social_media_app/features/post/presentation/cubits/post_cubit.dart';
import 'package:social_media_app/features/post/presentation/cubits/post_states.dart';
import 'package:social_media_app/features/post/presentation/pages/upload_post_Page.dart';
import 'package:social_media_app/responsive/constrained_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // post cubit
  late final postCubit = context.read<PostCubit>();

  // on startup
  @override
  void initState() {
    super.initState();
    // fetch all posts
    fetchAllPosts();
  }

  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  void deletePost(String postId) {
    postCubit.deletePost(postId);
    fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      // App BAR
      appBar: AppBar(
        title: const Text("Home"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        actions: [
          // upload new post
          IconButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadPostPage(),
                  ), // MaterialPageRoute
                ),
            icon: const Icon(Icons.add),
          ), // IconButton
        ],
      ), // AppBar
      // DRAWER
      drawer: const MyDrawer(),
      //body
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          // loading
          if (state is PostsLoading && state is PostUploading) {
            return const Center(child: CircularProgressIndicator());
          }
          // loaded
          else if (state is PostsLoaded) {
            final allPosts = state.posts;

            if (allPosts.isEmpty) {
              return const Center(child: Text("No Posts Available"));
            }
            return ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context, index) {
                // get individual post
                final post = allPosts[index];

                // image
                return PostTile(
                  post: post,
                  onDeletePressed: () => deletePost(post.id),
                );
              },
            );
          }
          // error
          else if (state is PostsError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox();
          }
        },
      ),
    ); // Scaffold
  }
}
