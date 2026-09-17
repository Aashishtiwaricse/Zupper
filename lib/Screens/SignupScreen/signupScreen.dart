import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zuperr/Screens/HomeScreen/HomeScreen.dart';
import 'package:zuperr/Screens/OtpVerifyScreen/otpVerify.dart';
import 'package:zuperr/Services/GoogleAuthService.dart/googleAuth.dart';
import 'package:zuperr/Services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  final GoogleAuthService _googleAuthService = GoogleAuthService();
  double _passwordStrength = 0.0;
String _strengthText = "";
Color _strengthColor = Colors.grey;
String? _phoneError;



//verify otp screen for signup

 Future<void> signupApi() async {
  setState(() {
    _isLoading = true;
  });

  try {
    final response = await _authService.signup(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      mobileNumber: _phoneController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (response.statusCode == 201) {
      final data = response.data;

      print('frommm register api');
      print(response.data);

      print('frommm regi otp');
            print(data["SignupToken"]);


      print(data["OTP"]);

      final otp = data["OTP"].toString();
final email = data["SignupUser"]["email"];
final signupToken = data["SignupToken"];

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            data["message"] ?? "OTP has been sent successfully.",
          ),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyOtpScreen(
              email: email,
      otp: otp,
      signupToken: signupToken,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Signup failed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString().replaceFirst("Exception: ", ""),
        ),
        backgroundColor: Colors.red,
      ),
    );
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isObscure = true;
  bool _isConfirmObscure = true;
  bool _agreeTerms = true;
  bool _subscribe = true;
  bool _isLoading = false;
  void _checkPasswordStrength(String password) {
  double strength = 0;

  if (password.isEmpty) {
    strength = 0;
  } else if (password.length < 6) {
    strength = 0.2;
  } else {
    if (password.length >= 8) strength += 0.25;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.20;
    if (RegExp(r'[a-z]').hasMatch(password)) strength += 0.20;
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.20;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      strength += 0.15;
    }
  }

  strength = strength.clamp(0.0, 1.0);

  setState(() {
    _passwordStrength = strength;

    if (strength == 0) {
      _strengthText = "";
      _strengthColor = Colors.grey;
    } else if (strength <= 0.3) {
      _strengthText = "Weak";
      _strengthColor = Colors.red;
    } else if (strength <= 0.7) {
      _strengthText = "Medium";
      _strengthColor = Colors.orange;
    } else {
      _strengthText = "Strong";
      _strengthColor = Colors.green;
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔵 BACKGROUND
          SizedBox.expand(
            child: Image.asset('assets/SignIn.png', fit: BoxFit.cover),
          ),

          /// 🔵 CONTENT
          SingleChildScrollView(
            child: Column(
              children: [
                /// 🔷 TOP TEXT
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 60,
                  ),
                  child: Column(
                    children: const [
                      Text(
                        "Zuperr",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Create Your\nFree Profile",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "One step closer to your dream job",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),

                /// 🔷 CARD
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ), // 👈 LEFT & RIGHT SPACE

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// 🔹 GOOGLE
                          _googleButton(),

                          const SizedBox(height: 16),

                          _divider(),

                          const SizedBox(height: 16),

                          /// 🔹 NAME ROW
                          Row(
                            children: [
                              Expanded(
                                child: _textField(
                                  _firstNameController,
                                  "First name",
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _textField(
                                  _lastNameController,
                                  "Last name",
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          _emailField(),
                          const SizedBox(height: 14),
                          _phoneField(),
                          const SizedBox(height: 14),
                          _passwordField(),
                          const SizedBox(height: 14),
                          _confirmPasswordField(),

                          const SizedBox(height: 16),

                          /// 🔹 CHECKBOXES
                        _checkboxRow1(
  _agreeTerms,
  (v) => setState(() => _agreeTerms = v!),
),

                          _checkboxRow(
                            _subscribe,
                            (v) => setState(() => _subscribe = v!),
                            "Keep me informed about the latest updates and opportunities by SMS, Email, and WhatsApp",
                          ),

                          const SizedBox(height: 20),

                          /// 🔘 BUTTON
                          GestureDetector(
                            onTap: () async {
                              if (!_formKey.currentState!.validate()) return;

                              if (!_agreeTerms) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Accept terms first"),
                                  ),
                                );
                                return;
                              }

                              signupApi();
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              alignment: Alignment.center,
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "Create Profile",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// 🔹 LOGIN
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("Already have an account? "),
                              Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ================== WIDGETS ==================

Widget _textField(TextEditingController controller, String hint) {
  return TextFormField(
    
    controller: controller,
    decoration: _inputDecoration(hint),
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return "$hint required";
      }

      // Prevent the same character repeated 4 or more times
      if (RegExp(r'(.)\1{3,}').hasMatch(value)) {
        return "Repeated characters are not allowed";
      }

      return null;
    },
  );
}

  Widget _emailField() {
    return TextFormField(
      controller: _emailController,
      decoration: _inputDecoration("Enter your email"),
      validator: (value) {
        if (value == null || value.isEmpty) return "Email required";
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return "Invalid email";
        }
        return null;
      },
    );
  }

Widget _phoneField() {
  return TextFormField(
    controller: _phoneController,
    keyboardType: TextInputType.phone,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(10),
    ],
    decoration: _inputDecoration("Enter your phone number").copyWith(
      errorText: _phoneController.text.isNotEmpty &&
              _phoneController.text.length < 10
          ? "Phone number must be 10 digits"
          : null,
    ),
    onChanged: (_) => setState(() {}),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "Phone required";
      }
      if (value.length != 10) {
        return "Phone number must be 10 digits";
      }
       // Reject sequential numbers like 1234567890 or 9876543210
      if (value == "1234567890" || value == "9876543210") {
        return "Please enter a valid phone number";
      }

      // Reject same digit repeated 10 times
      if (RegExp(r'^(\d)\1{9}$').hasMatch(value)) {
        return "Please enter a valid phone number";
      }

      // Reject repeated patterns like 8882222000
      if (RegExp(r'^(\d)\1{2,}(\d)\2{2,}(\d)\3{2,}$').hasMatch(value)) {
        return "Please enter a valid phone number";
      }
      return null;
    },
  );
}

Widget _passwordField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextFormField(
        controller: _passwordController,
        obscureText: _isObscure,
        onChanged: _checkPasswordStrength,
        decoration: _inputDecoration("Enter your password").copyWith(
          suffixIcon: IconButton(
            icon: Icon(
              _isObscure ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Password required";
          }
          if (value.length < 8) {
            return "Min 8 characters";
          }

          // Optional: Require at least one special character
          if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
            return "Include at least one special character";
          }
            if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return "Password must contain at least one capital letter";
  }

          return null;
        },
      ),

      const SizedBox(height: 6),

      Text(
        "Tip: Use uppercase, lowercase, numbers, and special characters (e.g. @, #, \$, !) for a stronger password.",
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),

      if (_passwordController.text.isNotEmpty) ...[
        const SizedBox(height: 10),

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: _passwordStrength,
            minHeight: 6,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation(_strengthColor),
          ),
        ),

        const SizedBox(height: 6),

        Align(
          alignment: Alignment.centerRight,
          child: Text(
            _strengthText,
            style: TextStyle(
              color: _strengthColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ],
  );
}

  Widget _confirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _isConfirmObscure,
      decoration: _inputDecoration("Enter your password again").copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmObscure ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () =>
              setState(() => _isConfirmObscure = !_isConfirmObscure),
        ),
      ),
      validator: (value) {
        if (value != _passwordController.text) {
          return "Passwords do not match";
        }
        return null;
      },
    );
  }

  Widget _checkboxRow(bool value, Function(bool?) onChanged, String text) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Expanded(child: Text(text)),
      ],
    );
  }

Future<void> _openUrl(String url) async {
  final Uri uri = Uri.parse(url);

  if (await canLaunchUrl(uri)) {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }
}
  Widget _checkboxRow1(
  bool value,
  Function(bool?) onChanged,
) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Checkbox(
        value: value,
        onChanged: onChanged,
      ),

      Expanded(
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            children: [
              const TextSpan(
                text: "By continuing, I confirm that I have read the ",
              ),

              TextSpan(
                text: "Cancellation Policy",
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _openUrl(
                      "https://yourdomain.com/cancellation-policy",
                    );
                  },
              ),

              const TextSpan(text: ", "),

              TextSpan(
                text: "User Agreement",
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _openUrl(
                      "https://yourdomain.com/user-agreement",
                    );
                  },
              ),

              const TextSpan(text: ", "),

              TextSpan(
                text: "Terms of Services",
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _openUrl(
                      "https://uat.zuperr.co/employee-terms-conditions",
                    );
                  },
              ),

              const TextSpan(text: " and "),

              TextSpan(
                text: "Privacy Policy",
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _openUrl(
                      "https://uat.zuperr.co/employee-privacy-policy",
                    );
                  },
              ),

              const TextSpan(text: " of Zuperr"),
            ],
          ),
        ),
      ),
    ],
  );
}

  Widget _divider() {
    return Row(
      children: const [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text("Or signup with"),
        ),
        Expanded(child: Divider()),
      ],
    );
  }

  Widget _googleButton() {
    return ElevatedButton.icon(
      icon: Image.asset("assets/google.png", height: 22),
      label: const Text("Continue with Google"),
      onPressed: () async {
        try {
          final response = await _googleAuthService.signInWithGoogle();

          Get.snackbar("Success", response["message"] ?? "Login Successful");

          Get.offAll(() => const HomeScreen());
        } catch (e) {
          Get.snackbar("Error", e.toString().replaceFirst("Exception: ", ""));
        }
      },
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
