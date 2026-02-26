import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final _phone = TextEditingController(text: '+91'); // default CC
  final _otp = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _verificationId;
  bool _codeSent = false;
  bool _busy = false;

  @override
  void dispose() {
    _phone.dispose();
    _otp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // important so the layout resizes for keyboard
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Login with Mobile',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, color: Colors.white)),
        backgroundColor: const Color(0xFFE67E22),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Scrollable body so fields never get hidden
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _phone,
                          enabled: !_codeSent,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Phone (with country code)',
                            hintText: '+919876543210',
                            filled: true,
                            fillColor:
                                const Color(0xFF5D78FF).withOpacity(0.05),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Enter phone';
                            }
                            final digits = v.replaceAll(RegExp(r'\D'), '');
                            if (digits.length < 10)
                              return 'Phone seems invalid';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        if (_codeSent)
                          TextFormField(
                            controller: _otp,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'OTP',
                              filled: true,
                              fillColor:
                                  const Color(0xFF5D78FF).withOpacity(0.05),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (v) {
                              if (!_codeSent) return null;
                              if (v == null || v.trim().isEmpty) {
                                return 'Enter OTP';
                              }
                              if (v.trim().length < 6) {
                                return 'OTP must be 6 digits';
                              }
                              return null;
                            },
                          ),

                        // Push content up to bottom; keeps button at bottom of screen when no keyboard
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),

      // Button that lifts with keyboard using AnimatedPadding + SafeArea
      bottomNavigationBar: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16, // <-- key
          top: 8,
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: FilledButton(
              onPressed: _busy
                  ? null
                  : () async {
                      // dismiss keyboard first
                      FocusScope.of(context).unfocus();
                      if (!_codeSent) {
                        await _startPhoneVerification();
                      } else {
                        await _submitOtp();
                      }
                    },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF5D78FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: _busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text(
                      _codeSent ? 'Verify OTP' : 'Send OTP',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _startPhoneVerification() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _busy = true);
    final phone = _phone.text.trim();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await FirebaseAuth.instance.signInWithCredential(credential);
          if (!mounted) return;
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Verified!')));
          Navigator.pop(context, true); // success
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Auto verify failed: $e')),
          );
        } finally {
          if (mounted) setState(() => _busy = false);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!mounted) return;
        final msg = switch (e.code) {
          'too-many-requests' => 'Too many attempts. Try again later.',
          'captcha-check-failed' => 'Verification blocked. Disable VPN/Proxy.',
          'invalid-phone-number' => 'Invalid phone number.',
          'quota-exceeded' => 'SMS quota exceeded. Use test numbers.',
          _ => 'Verification failed: ${e.message}',
        };
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
        setState(() => _busy = false);
      },
      codeSent: (String verificationId, int? resendToken) {
        if (!mounted) return;
        setState(() {
          _verificationId = verificationId;
          _codeSent = true;
          _busy = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP sent')),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> _submitOtp() async {
    if (!_formKey.currentState!.validate()) return;
    if (_verificationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No verification id, resend OTP')),
      );
      return;
    }

    setState(() => _busy = true);
    try {
      final cred = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _otp.text.trim(),
      );
      await FirebaseAuth.instance.signInWithCredential(cred);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Logged in!')));
      Navigator.pop(context, true); // success
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP: ${e.message}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
