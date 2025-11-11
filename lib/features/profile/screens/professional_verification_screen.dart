import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/premium_card.dart';

class ProfessionalVerificationScreen extends ConsumerStatefulWidget {
  const ProfessionalVerificationScreen({super.key});

  @override
  ConsumerState<ProfessionalVerificationScreen> createState() =>
      _ProfessionalVerificationScreenState();
}

class _ProfessionalVerificationScreenState
    extends ConsumerState<ProfessionalVerificationScreen> {
  bool _isLoading = false;
  String? _licenseNumber;
  final List<String> _uploadedDocuments = [];

  Future<void> _uploadDocument() async {
    // TODO: Implement file picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Seleccionar documento...'),
        duration: Duration(seconds: 2),
      ),
    );

    // Simular upload
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _uploadedDocuments.add('licencia_profesional.pdf');
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Documento subido correctamente'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  Future<void> _submitVerification() async {
    if (_uploadedDocuments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor sube al menos un documento'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solicitud enviada. Te notificaremos cuando sea revisada.'),
            backgroundColor: AppTheme.successColor,
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
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
      appBar: AppBar(
        title: const Text('Verificación Profesional'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header icon
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: AppTheme.glowPrimary(opacity: 0.3),
                ),
                child: const Icon(
                  Icons.verified_user,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Title
            const Text(
              'Verifica tu Identidad Profesional',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),

            // Subtitle
            const Text(
              'La verificación profesional te da acceso a funciones exclusivas y construye confianza en la comunidad.',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),

            // Benefits
            PremiumCard(
              gradient: AppTheme.cardGradient,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Beneficios de la Verificación',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildBenefit(
                    Icons.check_circle,
                    'Insignia de verificación en tu perfil',
                  ),
                  _buildBenefit(
                    Icons.star,
                    'Acceso prioritario a nuevo contenido',
                  ),
                  _buildBenefit(
                    Icons.people,
                    'Conexión con otros profesionales verificados',
                  ),
                  _buildBenefit(
                    Icons.workspace_premium,
                    'Funciones exclusivas para profesionales',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // License number (optional)
            const Text(
              'Número de Licencia Profesional (Opcional)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Ej: PSI-12345',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              onChanged: (value) {
                setState(() {
                  _licenseNumber = value;
                });
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // Document upload
            const Text(
              'Documentos de Verificación',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Sube tu licencia profesional, certificado, o documento que acredite tu profesión.',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Upload button
            PremiumOutlinedButton(
              text: 'Subir Documento',
              icon: Icons.upload_file,
              onPressed: _uploadDocument,
            ),
            const SizedBox(height: AppSpacing.md),

            // Uploaded documents
            if (_uploadedDocuments.isNotEmpty) ...[
              ...List.generate(
                _uploadedDocuments.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: PremiumCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(AppBorderRadius.sm),
                          ),
                          child: const Icon(
                            Icons.description,
                            color: AppTheme.primaryColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _uploadedDocuments[index],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimaryColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Listo para enviar',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.successColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppTheme.errorColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _uploadedDocuments.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Privacy notice
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppTheme.infoColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                border: Border.all(
                  color: AppTheme.infoColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.infoColor,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Tus documentos son confidenciales y solo serán revisados por nuestro equipo de verificación. No serán compartidos con terceros.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondaryColor,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Submit button
            PremiumButton(
              text: 'Enviar para Verificación',
              onPressed: _submitVerification,
              isLoading: _isLoading,
              enableGlow: _uploadedDocuments.isNotEmpty,
            ),
            const SizedBox(height: AppSpacing.md),

            // Skip button
            Center(
              child: TextButton(
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                child: const Text('Hacer Después'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefit(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.accentColor,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
