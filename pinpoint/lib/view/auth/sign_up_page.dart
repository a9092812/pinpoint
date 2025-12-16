import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinpoint/resources/routes/app_routes.dart';
import '../../viewModel/auth/auth_provider.dart';
import '../../DTO/auth.dart';

class SignUpPage extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final ValueNotifier<String?> _selectedRole = ValueNotifier(null);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> _submitRegister() async {
      if (!_formKey.currentState!.validate() || _selectedRole.value == null) {
        return;
      }
      _isLoading.value = true;
      try {
        final req = AuthRequest.forRegister(
          email: _emailCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          password: _passwordCtrl.text.trim(),
          role: _selectedRole.value,
        );
        final error = await ref.read(authProvider).register(req);
        if (context.mounted) {
          if (error == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("Registered successfully. Please log in.")),
            );
            context.go(AppRoutes.logIn);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error)),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occurred: $e")),
          );
        }
      } finally {
        _isLoading.value = false;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Text(
                    'Create your Account',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey[850],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Join the Pinpoint network to get started.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Email Field
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined, color: Colors.grey[600]),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    validator: (val) =>
                        (val == null || val.isEmpty || !val.contains('@'))
                            ? 'Please enter a valid email'
                            : null,
                  ),
                  const SizedBox(height: 16),

                  // Phone Field
                  TextFormField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      prefixIcon: Icon(Icons.phone_outlined, color: Colors.grey[600]),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    validator: (val) =>
                        (val == null || val.isEmpty) ? 'Please enter your phone number' : null,
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  ValueListenableBuilder<bool>(
                    valueListenable: _obscurePassword,
                    builder: (_, isObscure, __) => TextFormField(
                      controller: _passwordCtrl,
                      obscureText: isObscure,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[600]),
                        suffixIcon: IconButton(
                          icon: Icon(isObscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                          onPressed: () =>
                              _obscurePassword.value = !isObscure,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      validator: (val) => (val == null || val.length < 6)
                          ? 'Password must be at least 6 characters'
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Role Dropdown
                  ValueListenableBuilder<String?>(
                    valueListenable: _selectedRole,
                    builder: (_, value, __) => DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select your Role',
                        prefixIcon: Icon(Icons.person_search_outlined, color: Colors.grey[600]),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      value: value,
                      onChanged: (val) => _selectedRole.value = val,
                      items: const [
                        DropdownMenuItem(value: 'USER', child: Text('Student')),
                        DropdownMenuItem(value: 'ADMIN', child: Text('Admin')),
                        DropdownMenuItem(
                            value: 'INSTITUTE', child: Text('Institute')),
                      ],
                      validator: (val) =>
                          val == null ? 'Please select a role' : null,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Sign Up Button
                  ValueListenableBuilder<bool>(
                    valueListenable: _isLoading,
                    builder: (_, isLoading, __) => SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submitRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A73E8),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?",
                          style: TextStyle(color: Colors.grey[600])),
                      TextButton(
                        onPressed: () {
                          context.go(AppRoutes.logIn);
                        },
                        child: const Text(
                          "Login here",
                          style: TextStyle(
                            color: Color(0xFF1A73E8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
