import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Models/SavedAccount/savedAccount.dart';
import 'package:zuperr/Screens/HomeMain/homeMain.dart';
import 'package:zuperr/Screens/HomeScreen/jobDetailsScreen.dart';
import 'package:zuperr/Screens/SignInScreen/Widget/savedAccounts.dart';
import 'package:zuperr/Screens/SignInScreen/forgotPass.dart';
import 'package:zuperr/Screens/SignInScreen/reactivateAccount.dart';
import 'package:zuperr/Screens/SignInScreen/signInOtpVerify.dart';
import 'package:zuperr/Services/GoogleAuthService.dart/googleAuth.dart';
import 'package:zuperr/Services/PublicJobService/PublicJobService.dart';
import 'package:zuperr/Services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = true;
  bool _isLoading = false;
  final AuthService _authService = AuthService();
  bool _isButtonEnabled = false;

  final GoogleAuthService googleAuthService = GoogleAuthService();
  final GoogleAuthService _googleAuthService = GoogleAuthService();
  List<SavedAccount> accounts = [];

  Future<void> loadAccounts() async {
    final prefs = await SharedPreferences.getInstance();

    final list = prefs.getStringList("saved_accounts") ?? [];

    accounts = list.map((e) => SavedAccount.fromJson(jsonDecode(e))).toList();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _emailController.addListener(_validateInputs);
    _passwordController.addListener(_validateInputs);
    _loadRememberMe();
    loadAccounts();
   
  }

  void _validateInputs() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final isValidEmail = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);

    setState(() {
      _isButtonEnabled = isValidEmail && password.length >= 6;
    });
  }

  Future<void> _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();

    final remember = prefs.getBool("remember_me") ?? false;

    if (remember) {
      _emailController.text = prefs.getString("saved_email") ?? "";
      _passwordController.text = prefs.getString("saved_password") ?? "";
    }

    setState(() {
      _rememberMe = remember;
    });

    _validateInputs();
  }

  
  Future<void> _handlePostLoginNavigation() async {
  final prefs = await SharedPreferences.getInstance();

  final pendingJobId =
      prefs.getString("pending_job_id");

  // =========================================================
  // NORMAL LOGIN
  // =========================================================

  if (pendingJobId == null || pendingJobId.isEmpty) {
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const MainScreen(),
      ),
      (route) => false,
    );

    return;
  }

  print("======================================");
  print("PENDING JOB FOUND AFTER LOGIN");
  print("JOB ID: $pendingJobId");
  print("======================================");

  // Remove first
  await prefs.remove("pending_job_id");

  // Fetch job
  final job =
      await PublicJobService.getJob(pendingJobId);

  if (!mounted) return;

  if (job != null) {

    print("Opening pending job");

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => JobDetailScreen(
          job: job,
        ),
      ),
      (route) => false,
    );

  } else {

    print("Unable to load pending job");

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const MainScreen(),
      ),
      (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Unable to load the job. Please try again.",
        ),
      ),
    );
  }
}

Future<void> loginApi() async {
  try {
    print("LOGIN BUTTON CLICKED");

    setState(() {
      _isLoading = true;
    });

    print("EMAIL: ${_emailController.text}");
    print("PASSWORD: ${_passwordController.text}");

    final response = await _authService.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      rememberMe: _rememberMe,
    );

    print("LOGIN RESPONSE:");
    print(response);

    if (!mounted) return;

    // =========================================================
    // TWO FACTOR AUTHENTICATION
    // =========================================================

    if (response["requiresTwoFactor"] == true) {
      final String challengeToken =
          response["challengeToken"]?.toString() ?? "";

      if (challengeToken.isEmpty) {
        throw Exception(
          "Challenge token not received from server",
        );
      }

      print("2FA REQUIRED");
      print("Challenge Token received");

      // DO NOT SAVE TOKEN
      // Pass it directly to OTP screen

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyOtpScreen(
            email: _emailController.text.trim(),
            challengeToken: challengeToken,
          ),
        ),
      );

      return;
    }

    // =========================================================
    // NORMAL LOGIN
    // =========================================================

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          response["message"] ?? "Login successful",
        ),
        backgroundColor: Colors.green,
      ),
    );
    await _handlePostLoginNavigation();

   
  } catch (e) {
    print("LOGIN ERROR: $e");

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString().replaceAll("Exception: ", ""),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔵 BACKGROUND IMAGE
          SizedBox.expand(
            child: Image.asset(
              'assets/SignIn.png', // your background image
              fit: BoxFit.cover,
            ),
          ),

          /// 🔵 CONTENT
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    /// 🔷 TOP TEXT SECTION
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),

                            /// Logo
                            const Text(
                              "Zuperr",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),

                            const SizedBox(height: 20),

                            /// Title
                            const Text(
                              "Welcome Back!\nSign in to Continue",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.3,
                              ),
                            ),

                            const SizedBox(height: 12),

                            /// Subtitle
                            const Text(
                              "Pick up where you left off",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// 🔷 BOTTOM CARD
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        bottom: 110,
                      ),
                      child: Container(
                        width: 700,
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),

                            const SizedBox(height: 20),

                            /// Email
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  _emailField(),
                                  const SizedBox(height: 14),
                                  _passwordField(),
                                ],
                              ),
                            ),

                            const SizedBox(height: 14),

                            /// Remember + Forgot
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _rememberMe,
                                      activeColor: Colors.blue, // tick color
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value!;
                                        });
                                      },
                                    ),
                                    const Text("Remember me"),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const ForgotPasswordScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            /// Login Button
                            GestureDetector(
                              onTap: () {
                                if (_isLoading) return;

                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }

                                loginApi();
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: (_isButtonEnabled && !_isLoading)
                                      ? Colors.blue
                                      : Colors.blue.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                alignment: Alignment.center,
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        "Log In",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            /// Sign up
                            GestureDetector(
                              onTap: () => Navigator.pushReplacementNamed(
                                context,
                                '/signup',
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text("Don’t have an account? "),
                                  Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),
                            const SizedBox(height: 12),

                            Center(
                              child: TextButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) =>
                                        const ReactivateAccountBottomSheet(),
                                  );
                                },
                                child: const Text(
                                  "Reactivate Account",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            /// Divider
                            Row(
                              children: const [
                                Expanded(child: Divider()),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text("Or login with"),
                                ),
                                Expanded(child: Divider()),
                              ],
                            ),

                            const SizedBox(height: 16),

                            /// Google Button
                            Center(
                              child: ElevatedButton.icon(
                                icon: Image.asset(
                                  "assets/google.png",
                                  height: 22,
                                ),
                                label: const Text("Continue with Google"),
                                onPressed: () async {
                                  if (_rememberMe) {
                                    await saveRememberedAccount(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim(),
                                    );
                                  }
                                  try {
                                    final response = await _googleAuthService
                                        .signInWithGoogle();

                                    print("SUCCESS RESPONSE: $response");

                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const MainScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  } catch (e, s) {
                                    print(e);
                                    print(s);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emailField() {
    return Autocomplete<SavedAccount>(
      displayStringForOption: (SavedAccount option) => option.email,

      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return accounts;
        }

        return accounts.where(
          (account) => account.email.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          ),
        );
      },

      onSelected: (SavedAccount account) {
        _emailController.text = account.email;
        _passwordController.text = account.password;
        setState(() {});
      },

      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
            textEditingController.text = _emailController.text;

            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration("Enter your email address"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Email is required";
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return "Enter valid email";
                }
                return null;
              },
              onChanged: (value) {
                _emailController.text = value;
              },
            );
          },
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),

      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),

      // Normal border
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),

      // Focused border
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
      ),

      // 🔴 Error border (IMPORTANT)
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 177, 40, 30),
          width: 1,
        ),
      ),

      // 🔴 Focused error border
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _isObscure,
      decoration: InputDecoration(
        hintText: "Enter your password",
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        filled: true,
        fillColor: Colors.white,

        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
          icon: Icon(
            _isObscure ? Icons.visibility_off : Icons.visibility,
            color: _isObscure ? Colors.grey : Colors.blue,
          ),
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
        ),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // ✅ CORRECT PLACE for validation
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Password is required";
        }
        if (value.length < 6) {
          return "Minimum 6 characters";
        }
        return null;
      },
    );
  }
}
