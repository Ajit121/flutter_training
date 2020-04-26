class UserData {
  String name;
  String mobile;
  String email;
  int gender;
  int dob;
  String image;
  int userPreference;

  UserData(
      {this.name,
        this.mobile,
        this.email,
        this.gender,
        this.dob,
        this.image,
        this.userPreference});

  UserData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    gender = json['gender'];
    dob = json['dob'];
    image = json['image'];
    userPreference = json['user_preference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['image'] = this.image;
    data['user_preference'] = this.userPreference;
    return data;
  }
}

