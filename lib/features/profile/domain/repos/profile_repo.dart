// profile_repo.dart

/*

Profile Repository

*/

import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';

abstract class ProfileRepo {
  Future<ProfileUser?> fetchUserProfile(String uid);
  Future<void> updateProfile(ProfileUser updatedProfile);
  Future<void> toggleFollow(String currentUid, String targetUid);
}
