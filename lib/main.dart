import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegistrationForm(),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang chủ'),
      ),
      body: Center(
        child: Text('Chúc mừng bạn đã đến trang chủ'),
      ),
    );
  }
}

class _RegistrationFormState extends State<RegistrationForm> {
  String radioValue = 'Nam';
  double progressValue = 0.0;
  Completer<void> _completionNotifier = Completer<void>();
  bool isRegistrationInProgress = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  List<String> selectedInterests = [];

  void showSnackbar(String message) {
  final snackBar = SnackBar(
    content: Text(message),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

  void updateProgress() {
  setState(() {
    progressValue += 0.1;
    if (progressValue >= 1.0) {
      progressValue = 0.0;
      selectedInterests.clear();
      isRegistrationInProgress = false; // Kết thúc quá trình đăng ký

      // Hiển thị thông báo đăng ký thành công
      showSnackbar('Đăng ký thành công!');

      // Chuyển hướng sau khi người dùng đã thấy thông báo thành công
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => SuccessPage(),
        ));
      });
    }
  });
}


  void resetForm() {
    nameController.clear();
    emailController.clear();
  }

  void autoCompleteProgress() {
  isRegistrationInProgress = true; // Bắt đầu quá trình đăng ký
  Timer.periodic(Duration(milliseconds: 200), (timer) {
    if (progressValue < 1.0 && isRegistrationInProgress) {
      updateProgress();
    } else {
      resetForm();
      timer.cancel();

      if (progressValue >= 1.0) {
        // Quá trình đăng ký đã hoàn thành, điều hướng sang trang chủ
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => SuccessPage(),
        ));
      }
    }
  });
}


  bool isInputValid() {
    return nameController.text.isNotEmpty && emailController.text.isNotEmpty;
  }

  bool isEmailValid(String email) {
    // Sử dụng biểu thức chính quy để kiểm tra định dạng email
    String emailPattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-zA-Z]{2,4})$';
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Họ và tên:'),
            TextField(controller: nameController),
            SizedBox(height: 20),
            Text('Email:'),
            TextField(controller: emailController),
            SizedBox(height: 20),
            Text('Chọn giới tính:'),
            RadioListTile(
              title: Text('Nam'),
              value: 'Nam',
              groupValue: radioValue,
              onChanged: (value) {
                setState(() {
                  radioValue = value.toString();
                });
              },
            ),
            RadioListTile(
              title: Text('Nữ'),
              value: 'Nữ',
              groupValue: radioValue,
              onChanged: (value) {
                setState(() {
                  radioValue = value.toString();
                });
              },
            ),
            SizedBox(height: 20),
            Text('Chọn sở thích:'),
            CheckboxListTile(
              title: Text('Thể thao'),
              value: selectedInterests.contains('Thể thao'),
              onChanged: (value) {
                setState(() {
                  if (value!) {
                    selectedInterests.add('Thể thao');
                  } else {
                    selectedInterests.remove('Thể thao');
                  }
                });
              },
            ),
            CheckboxListTile(
              title: Text('Xem phim'),
              value: selectedInterests.contains('Xem phim'),
              onChanged: (value) {
                setState(() {
                  if (value!) {
                    selectedInterests.add('Xem phim');
                  } else {
                    selectedInterests.remove('Xem phim');
                  }
                });
              },
            ),
            CheckboxListTile(
              title: Text('Mua sắm'),
              value: selectedInterests.contains('Mua sắm'),
              onChanged: (value) {
                setState(() {
                  if (value!) {
                    selectedInterests.add('Mua sắm');
                  } else {
                    selectedInterests.remove('Mua sắm');
                  }
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
            onPressed: () {
              if (!isInputValid()) {
                showSnackbar('Vui lòng nhập đầy đủ thông tin.');
              } else if (!isEmailValid(emailController.text)) {
                showSnackbar('Vui lòng nhập địa chỉ email hợp lệ.');
              } else if (selectedInterests.isEmpty) {
                showSnackbar('Vui lòng chọn ít nhất một sở thích.');
              } else if (!isRegistrationInProgress) {
                // Đăng ký chỉ khi các điều kiện cần thiết được đáp ứng
                // Gọi autoCompleteProgress() sau khi đã kiểm tra xong điều kiện
                autoCompleteProgress();
              } else if (isRegistrationInProgress) {
                // Bạn có thể xử lý nếu quá trình đăng ký đang diễn ra
              }
            },
            child: Text('Đăng ký'),
          ),

            SizedBox(height: 20),
            LinearProgressIndicator(
              value: progressValue,
              minHeight: 10,
              backgroundColor: Color.fromARGB(255, 8, 147, 247),
              valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 16, 2, 96)),
            ),
            Text('${(progressValue * 100).toStringAsFixed(0)}%'),
          ],
        ),
      ),
    );
  }
}
