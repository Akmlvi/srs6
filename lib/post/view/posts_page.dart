import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/get_posts.dart';
import 'package:flutter_application_1/post/bloc/post_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});
  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  List<Posts> posts = [];
  late PostBloc postBloc;

  @override
  void initState() {
    super.initState();
    postBloc = PostBloc();
    postBloc.add(GetPostEvent());
  }

  @override
  void dispose() {
    postBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: BlocBuilder<PostBloc, PostState>(
        bloc: postBloc,
        builder: (context, state) {
          if (state is LoadingPostState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FetchedPostsState) {
            posts = state.posts;
            return buildBody();
          }
          if (state is FailurePostState) {
            return const Center(child: Text("Some Error: не удалось загрузить посты"));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget buildBody() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final item = posts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(item.body),
              ],
            ),
          ),
        );
      },
    );
  }
}