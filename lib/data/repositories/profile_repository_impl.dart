import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<List<Profile>> getProfiles() async {
    return [
      Profile(id: '1', name: '田中 太郎', age: 25, imageUrl: 'https://picsum.photos/400/600?random=1'),
      Profile(id: '2', name: '佐藤 花子', age: 23, imageUrl: 'https://picsum.photos/400/600?random=2'),
      Profile(id: '3', name: '鈴木 一郎', age: 28, imageUrl: 'https://picsum.photos/400/600?random=3'),
      Profile(id: '4', name: '川路 律輝', age: 16, imageUrl: 'https://picsum.photos/400/600?random=4'),
    ];
  }
}
