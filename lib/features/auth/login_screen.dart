import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import 'register_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              
              // Logo & Welcome
              Icon(
                Icons.local_gas_station_rounded,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Hoş Geldiniz',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Yakıt takip uygulamanıza giriş yapın',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 60),

              // Google Sign In Button
              _SocialLoginButton(
                onPressed: () async {
                  // TODO: Implement actual Google Sign In
                  final success = await ref.read(currentUserProvider.notifier).signInWithGoogle(
                    providerId: 'mock_google_id',
                    name: 'Google Kullanıcısı',
                    email: 'google@example.com',
                  );
                  if (success && context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                icon: Icons.g_mobiledata,
                label: 'Google ile Devam Et',
                backgroundColor: Colors.white,
                textColor: Colors.black87,
                borderColor: Colors.grey.shade300,
              ),
              const SizedBox(height: 16),

              // Apple Sign In Button
              _SocialLoginButton(
                onPressed: () async {
                  // TODO: Implement actual Apple Sign In
                  final success = await ref.read(currentUserProvider.notifier).signInWithApple(
                    providerId: 'mock_apple_id',
                    name: 'Apple Kullanıcısı',
                    email: 'apple@example.com',
                  );
                  if (success && context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                icon: Icons.apple,
                label: 'Apple ile Devam Et',
                backgroundColor: Colors.black,
                textColor: Colors.white,
              ),
              const SizedBox(height: 32),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.cardBorder)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'veya',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.cardBorder)),
                ],
              ),
              const SizedBox(height: 32),

              // Manual Register Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Hesap Oluştur',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Terms & Privacy
              Text(
                'Devam ederek Kullanım Koşulları ve Gizlilik Politikası\'nı kabul etmiş olursunuz.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;

  const _SocialLoginButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          side: BorderSide(
            color: borderColor ?? backgroundColor,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
