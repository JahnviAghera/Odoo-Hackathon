import 'package:flutter/material.dart';
import 'package:rewear/home.dart';
import 'package:rewear/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  bool _isLoading = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("[DEBUG] AuthScreen initialized.");
    supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      print("[DEBUG] Auth event detected: $event");
      if (event == AuthChangeEvent.signedIn) {
        print("[DEBUG] User signed in. Navigating to HomeScreen.");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  Future<void> _handleAuth() async {
    setState(() {
      _isLoading = true;
    });

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    print("[DEBUG] Auth mode: ${_isLogin ? "Login" : "Register"}");
    print("[DEBUG] Email: $email");
    print("[DEBUG] Password: ${'*' * password.length}");
    if (!_isLogin) {
      print("[DEBUG] Confirm Password: ${'*' * _confirmPasswordController.text.trim().length}");
      print("[DEBUG] Name: $name");
    }

    if (!_isLogin && password != _confirmPasswordController.text.trim()) {
      _showErrorSnackBar("Passwords do not match");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      if (_isLogin) {
        print("[DEBUG] Attempting login...");
        await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
        print("[DEBUG] Login successful.");
      } else {
        print("[DEBUG] Attempting registration...");
        final response = await supabase.auth.signUp(
          email: email,
          password: password,
          data: {'full_name': name},
        );
        print("[DEBUG] Registration result: ${response.user?.id}");
        _showErrorSnackBar("Please check your email for verification.");
      }
    } on AuthException catch (error) {
      print("[DEBUG] AuthException: ${error.message}");
      _showErrorSnackBar(error.message);
    } catch (error) {
      print("[DEBUG] Unexpected error: $error");
      _showErrorSnackBar("An unexpected error occurred.");
    }

    setState(() {
      _isLoading = false;
    });
  }
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _toggleFormMode() {
    setState(() {
      _isLogin = !_isLogin;
      print("[DEBUG] Form mode toggled. New mode: ${_isLogin ? "Login" : "Register"}");
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/images/logo_blue_large.png',
                  height: 60, width: 60),
              const SizedBox(height: 10),
              Text(
                _isLogin ? 'Welcome Back 👋' : 'Join ReWear 👗',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF202020),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _isLogin
                    ? 'Login to continue your journey.'
                    : 'Create an account to begin.',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              if (!_isLogin)
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              if (!_isLogin) const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              if (!_isLogin)
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleAuth,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004CFF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          _isLogin ? 'Login' : 'Register',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: _toggleFormMode,
                  child: Text(
                    _isLogin
                        ? "Don't have an account? Register"
                        : "Already registered? Login",
                    style: const TextStyle(
                      color: Color(0xFF004CFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

