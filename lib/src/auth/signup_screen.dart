import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zeroC/src/screens/challenge_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();

  String? _selectedSex;
  String? _selectedSchoolId;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nicknameController,
                decoration: InputDecoration(labelText: 'Nickname'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your nickname';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _birthController,
                decoration: InputDecoration(labelText: 'Birth Date'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your birth date';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedSex,
                items: ['M', 'F'].map((String sex) {
                  return DropdownMenuItem<String>(
                    value: sex,
                    child: Text(sex == 'M' ? 'Male' : 'Female'),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSex = newValue;
                  });
                },
                decoration: InputDecoration(labelText: 'Sex'),
                validator: (value) {
                  if (value == null) {
                    return 'Please select your sex';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedSchoolId,
                items: [
                  DropdownMenuItem(value: 'SNU', child: Text('서울대학교')),
                  DropdownMenuItem(value: 'KNUA', child: Text('한국예술종합학교')),
                  DropdownMenuItem(value: 'SNUST', child: Text('서울과학기술대학교')),
                  DropdownMenuItem(value: 'SNUE', child: Text('서울교육대학교')),
                  DropdownMenuItem(value: 'KNSU', child: Text('한국체육대학교')),
                  DropdownMenuItem(value: 'UOS', child: Text('서울시립대학교')),
                  DropdownMenuItem(value: 'CUK', child: Text('가톨릭대학교')),
                  DropdownMenuItem(value: 'CAU', child: Text('중앙대학교')),
                  DropdownMenuItem(value: 'DSWU', child: Text('덕성여자대학교')),
                  DropdownMenuItem(value: 'DGU', child: Text('동국대학교')),
                  DropdownMenuItem(value: 'DDWU', child: Text('동덕여자대학교')),
                  DropdownMenuItem(value: 'MJU', child: Text('명지대학교')),
                  DropdownMenuItem(value: 'SMU', child: Text('상명대학교')),
                  DropdownMenuItem(value: 'SGU', child: Text('서강대학교')),
                  DropdownMenuItem(value: 'SKU', child: Text('서경대학교')),
                  DropdownMenuItem(value: 'SWU', child: Text('서울여자대학교')),
                  DropdownMenuItem(value: 'SKHU', child: Text('성공회대학교')),
                  DropdownMenuItem(value: 'SSWU', child: Text('성신여자대학교')),
                  DropdownMenuItem(value: 'SJU', child: Text('세종대학교')),
                  DropdownMenuItem(value: 'SMWU', child: Text('숙명여자대학교')),
                  DropdownMenuItem(value: 'SSU', child: Text('숭실대학교')),
                  DropdownMenuItem(value: 'YSU', child: Text('연세대학교')),
                  DropdownMenuItem(value: 'EHWU', child: Text('이화여자대학교')),
                  DropdownMenuItem(value: 'PUTS', child: Text('장로회신학대학교')),
                  DropdownMenuItem(value: 'CSU', child: Text('총신대학교')),
                  DropdownMenuItem(value: 'HUFS', child: Text('한국외국어대학교')),
                  DropdownMenuItem(value: 'HSU', child: Text('한성대학교')),
                  DropdownMenuItem(value: 'HYU', child: Text('한양대학교')),
                  DropdownMenuItem(value: 'HIU', child: Text('홍익대학교')),
                  DropdownMenuItem(value: 'KU', child: Text('고려대학교')),
                  DropdownMenuItem(value: 'SKKU', child: Text('성균관대학교')),
                  DropdownMenuItem(value: 'KWU', child: Text('광운대학교')),
                  DropdownMenuItem(value: 'KMU', child: Text('국민대학교')),
                ].toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSchoolId = newValue;
                  });
                },
                decoration: InputDecoration(labelText: 'School'),
                validator: (value) {
                  if (value == null) {
                    return 'Please select your school';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _signUp,
                      child: Text('Sign Up'),
                    ),
              if (_errorMessage != null) ...[
                SizedBox(height: 20),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await _firestore.collection('user_table').doc(userCredential.user!.uid).set({
        'user_id': userCredential.user!.uid,
        'pw': _passwordController.text,
        'school_id': _selectedSchoolId,
        'phone': _phoneController.text,
        'sex': _selectedSex,
        'birth': _birthController.text,
        'name': _nameController.text,
        'nick_name': _nicknameController.text,
        'profile_image': '', 
        'profile_content': '',
      });

      // 회원가입 완료 후 ChallengeScreen으로 이동
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ChallengeScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}