import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:testing_aplikasi/screen/authentication/FORGOT_PASSWORD/create_new_password_page.dart';

class VerifyOtpPage extends StatefulWidget {
  final String email;

  const VerifyOtpPage({Key? key, required this.email}) : super(key: key);

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage>
    with SingleTickerProviderStateMixin {
  late List<TextEditingController> _otpControllers;
  late List<FocusNode> _focusNodes;
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;

  bool _isLoading = false;
  int _resendCooldown = 60;
  bool _canResend = false;
  String? _errorMessage;

  static const int _otpLength = 8; // 8 kolom

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
    _startResendTimer();

    _fadeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeOut,
    );
    _fadeAnimationController.forward();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendCooldown = 60;

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;

      setState(() {
        if (_resendCooldown > 0) {
          _resendCooldown--;
        } else {
          _canResend = true;
        }
      });

      return _resendCooldown > 0;
    });
  }

  String get _otpCode => _otpControllers.map((c) => c.text).join();

  Future<void> _verifyOtp() async {
    if (_otpCode.length != _otpLength) {
      setState(() {
        _errorMessage = 'Masukkan kode OTP $_otpLength digit';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final supabase = Supabase.instance.client;

      await supabase.auth.verifyOTP(
        email: widget.email,
        token: _otpCode,
        type: OtpType.email,
      );

      if (!mounted) return;

      setState(() => _isLoading = false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordPage(email: widget.email),
        ),
      );
    } on AuthException catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = _getErrorMessage(e.message);
      });
      _clearOtp();
    } catch (_) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Terjadi kesalahan. Coba lagi.';
      });
      _clearOtp();
    }
  }

  void _clearOtp() {
    for (var c in _otpControllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
  }

  String _getErrorMessage(String error) {
    if (error.toLowerCase().contains('invalid')) {
      return 'Kode OTP salah. Silakan coba lagi.';
    } else if (error.toLowerCase().contains('expired')) {
      return 'Kode OTP sudah kadaluarsa. Kirim ulang kode.';
    } else if (error.toLowerCase().contains('rate')) {
      return 'Terlalu banyak percobaan. Tunggu sebentar.';
    }
    return 'Verifikasi gagal. Coba lagi.';
  }

  Future<void> _resendCode() async {
    if (!_canResend) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final supabase = Supabase.instance.client;

      await supabase.auth.signInWithOtp(email: widget.email);

      if (!mounted) return;

      setState(() => _isLoading = false);

      _startResendTimer();
      _clearOtp();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text('Kode verifikasi baru telah dikirim ke email Anda'),
            ],
          ),
          backgroundColor: const Color(0xFF2E7D32),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (_) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal mengirim kode virifikasi';
      });
    }
  }

  void _onOtpChanged(int index, String value) {
    if (value.length > 1) {
      _otpControllers[index].text = value.substring(0, 1);
    }

    if (value.isNotEmpty && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    if (_errorMessage != null) {
      setState(() => _errorMessage = null);
    }

    if (_otpCode.length == _otpLength) {
      _verifyOtp();
    }
  }

  @override
  void dispose() {
    for (var c in _otpControllers) c.dispose();
    for (var n in _focusNodes) n.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Ukuran box OTP yang nyaman (tidak terlalu kecil)
    final double boxSize = screenWidth > 500 ? 65 : 55;

    // Split OTP menjadi 2 baris (masing-masing 4 kolom)
    List<int> firstRow = [0, 1, 2, 3];
    List<int> secondRow = [4, 5, 6, 7];

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Background gradient modern
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF0FDF4), Color(0xFFFFFFFF)],
                  stops: [0.0, 0.6],
                ),
              ),
            ),

            // Decorative circles
            Positioned(
              top: -screenHeight * 0.2,
              right: -screenWidth * 0.3,
              child: Container(
                width: screenWidth * 0.7,
                height: screenWidth * 0.7,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -screenHeight * 0.15,
              left: -screenWidth * 0.25,
              child: Container(
                width: screenWidth * 0.6,
                height: screenWidth * 0.6,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.04),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Top navigation bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            borderRadius: BorderRadius.circular(40),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.arrow_back_rounded,
                                color: Color(0xFF2E7D32),
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4CAF50),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'VERIFY',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2E7D32),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Main content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                        child: Column(
                          children: [
                            // Lottie Animation Hero
                            Lottie.asset(
                              'assets/verify_otp.json',
                              width: 170,
                              height: 170,
                              fit: BoxFit.contain,
                              repeat: true,
                              animate: true,
                            ),
                            const SizedBox(height: 16),

                            // Title
                            const Text(
                              'Kode Verifikasi  ',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF191C1E),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Subtitle
                            Text(
                              'Masukkan kode verifikasi 8 digit yang telah kami kirimkan ke email Anda.',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 6),

                            const SizedBox(height: 32),

                            // OTP Input Fields - 2 BARIS (4 atas, 4 bawah)
                            // BARIS PERTAMA (4 digit pertama)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: firstRow.map((index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  width: boxSize,
                                  height: boxSize,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(16),

                                    // ✅ SHADOW (biar tidak datar)
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: TextFormField(
                                    controller: _otpControllers[index],
                                    focusNode: _focusNodes[index],
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    maxLength: 1,
                                    style: TextStyle(
                                      fontSize: boxSize * 0.45,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF191C1E),
                                    ),
                                    decoration: InputDecoration(
                                      counterText: '',

                                      // ❌ HAPUS fill karena sudah pakai Container
                                      filled: false,

                                      // ✅ BORDER NORMAL (tipis)
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1.2,
                                        ),
                                      ),

                                      // ✅ BORDER SAAT FOCUS
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF2E7D32),
                                          width: 2,
                                        ),
                                      ),

                                      // ✅ ERROR (biar lengkap)
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                          width: 1.5,
                                        ),
                                      ),

                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    onChanged: (value) =>
                                        _onOtpChanged(index, value),
                                  ),
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 16),

                            // BARIS KEDUA (4 digit terakhir)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: secondRow.map((index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  width: boxSize,
                                  height: boxSize,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(16),

                                    // ✅ SHADOW (biar tidak flat)
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: TextFormField(
                                    controller: _otpControllers[index],
                                    focusNode: _focusNodes[index],
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    maxLength: 1,
                                    style: TextStyle(
                                      fontSize: boxSize * 0.45,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF191C1E),
                                    ),
                                    decoration: InputDecoration(
                                      counterText: '',

                                      // ❌ HAPUS fill (sudah pakai Container)
                                      filled: false,

                                      // ✅ BORDER NORMAL
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1.2,
                                        ),
                                      ),

                                      // ✅ BORDER FOCUS
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF2E7D32),
                                          width: 2,
                                        ),
                                      ),

                                      // ✅ ERROR (optional tapi bagus)
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                          width: 1.5,
                                        ),
                                      ),

                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    onChanged: (value) =>
                                        _onOtpChanged(index, value),
                                  ),
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 24),

                            // Error message
                            if (_errorMessage != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.red.shade200,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 18,
                                      color: Colors.red.shade700,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _errorMessage!,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.red.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            const SizedBox(height: 28),

                            // Verify Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _verifyOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2E7D32),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  disabledBackgroundColor: Colors.grey[300],
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.verified_rounded, size: 20),
                                    SizedBox(width: 10),
                                    Text(
                                      'Verifikasi Kode ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Resend section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Tidak menerima kode?',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: _canResend ? _resendCode : null,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _canResend
                                          ? const Color.fromARGB(
                                              255,
                                              195,
                                              238,
                                              199,
                                            )
                                          : const Color.fromARGB(
                                              255,
                                              191,
                                              220,
                                              199,
                                            ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.refresh_rounded,
                                          size: 14,
                                          color: _canResend
                                              ? const Color(0xFF2E7D32)
                                              : const Color.fromARGB(
                                                  255,
                                                  7,
                                                  7,
                                                  7,
                                                ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          _canResend
                                              ? 'Kirim Ulang'
                                              : 'Kirim Ulang (${_resendCooldown}s)',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: _canResend
                                                ? const Color(0xFF2E7D32)
                                                : const Color.fromARGB(
                                                    255,
                                                    15,
                                                    15,
                                                    15,
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Security footer
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFE8F5E9),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shield_rounded,
                                    size: 14,
                                    color: const Color(
                                      0xFF2E7D32,
                                    ).withOpacity(0.6),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Kode verifikasi bersifat rahasia dan\n jangan dibagikan kepada siapa pun',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Loading overlay
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.4),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF2E7D32),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Memverifikasi kode...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
