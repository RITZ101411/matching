import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class GetProfiles {
  final ProfileRepository repository;

  GetProfiles(this.repository);

  Future<List<Profile>> call() => repository.getProfiles();
}
