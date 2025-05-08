import 'package:flutter/material.dart';
import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profile/presentation/pages/profile_page.dart';

class UserTile extends StatelessWidget {
  final ProfileUser user;

  const UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      subtitleTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
      ),
      leading: Icon(
        Icons.person,
        color: Theme.of(context).colorScheme.primary,
      ), // Icon
      trailing: Icon(
        Icons.arrow_forward,
        color: Theme.of(context).colorScheme.primary,
      ), // Icon
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(uid: user.uid),
            ), // MaterialPageRoute
          ),
    ); // ListTile
  }
}
