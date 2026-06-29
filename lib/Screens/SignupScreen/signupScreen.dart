import 'package:flutter/material.dart';
import 'package:zuperr/Screens/OtpVerifyScreen/otpVerify.dart';
import 'package:zuperr/Services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  


final AuthService _authService = AuthService();
Future<void> signupApi() async {
  try {
    setState(() {
      _isLoading = true;
    });

    final response = await _authService.signup(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      mobileNumber: _phoneController.text.trim(),
      password: _passwordController.text.trim(),
    );

    final otp = response["OTP"];
    final email = response["SignupUser"]["email"];

if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "OTP has been sent to your registered email and mobile number.",
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VerifyOtpScreen(
          email: email,
          otp: otp.toString(),
        ),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  } finally {
    setState(() {
      _isLoading = false;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔵 BACKGROUND
          SizedBox.expand(
            child: Image.asset(
              'assets/SignIn.png',
              fit: BoxFit.cover,
            ),
          ),

          /// 🔵 CONTENT
          SingleChildScrollView(
            child: Column(
              children: [
                /// 🔷 TOP TEXT
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 60),
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
  padding: const EdgeInsets.symmetric(horizontal: 12), // 👈 LEFT & RIGHT SPACE

                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
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
                                  fontSize: 22, fontWeight: FontWeight.bold),
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
                                      _firstNameController, "First name")),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: _textField(
                                      _lastNameController, "Last name")),
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
                          _checkboxRow(
                            _agreeTerms,
                            (v) => setState(() => _agreeTerms = v!),
                            "By continuing, I confirm that I have read the Terms",
                          ),
                  
                          _checkboxRow(
                            _subscribe,
                            (v) => setState(() => _subscribe = v!),
                            "Keep me informed about updates",
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
                                          fontWeight: FontWeight.w600),
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
                                    fontWeight: FontWeight.w600),
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
      validator: (value) =>
          value == null || value.isEmpty ? "$hint required" : null,
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
      decoration: _inputDecoration("Enter your phone number"),
      validator: (value) {
        if (value == null || value.isEmpty) return "Phone required";
        if (value.length < 10) return "Invalid phone";
        return null;
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _isObscure,
      decoration: _inputDecoration("Enter your password").copyWith(
        suffixIcon: IconButton(
          icon: Icon(_isObscure
              ? Icons.visibility_off
              : Icons.visibility),
          onPressed: () =>
              setState(() => _isObscure = !_isObscure),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "Password required";
        if (value.length < 6) return "Min 6 characters";
        return null;
      },
    );
  }

  Widget _confirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _isConfirmObscure,
      decoration:
          _inputDecoration("Enter your password again").copyWith(
        suffixIcon: IconButton(
          icon: Icon(_isConfirmObscure
              ? Icons.visibility_off
              : Icons.visibility),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/google.png", height: 18),
          const SizedBox(width: 10),
          const Text("Continue with Google"),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}