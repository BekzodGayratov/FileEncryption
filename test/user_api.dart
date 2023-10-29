import 'package:flutter_test/flutter_test.dart';
import 'package:test/infrastructure/apis/user_service.dart';

void main() {
  group("USER APIS", () {
    test("Should return failure when cannot get users data", () async {
      final UserApis userApis = UserApis();
      var result = await userApis.getUsers();
      expect(result.isRight(), true);
    });
  });
}
