import 'package:floor/floor.dart';
import 'package:homsai/datastore/models/database/base.entity.dart';

@Entity(
  tableName: 'User',
)
class User extends BaseEntity {
  final String email;

  User(
    this.email, {
    int? id,
  }) : super(id);

  User copyWith({email}) => User(
    email ?? this.email,
    id: id,
  );
}
