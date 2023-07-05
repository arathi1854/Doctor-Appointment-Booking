class UserModel {
  late String Name;
  late String Address;
  late String Mobile;
  late String Age;
  late String Height;
  late String Weight;
  late String Password;
  late String UserId;

  UserModel(
      {required String Name,
      required String Age,
      required String Address,
      required String Mobile,
      required String Height,
      required String Weight,
      required String Password,
      required String UserId}) {
    this.Name = Name;
    this.Age = Age;
    this.Address=Address;
    this.Mobile=Mobile;
    this.Height = Height;
    this.Weight = Weight;
    this.Password = Password;
    this.UserId = UserId;
  }
}
