import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/providers/auth_provider.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  int _selectedPlanIndex = 1; // Annual by default

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final subscription = authState.user?.subscription;
    final hasActiveSubscription = subscription?.status == 'active';
    final isTrialing = subscription?.status == 'trialing';

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.subscription),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current Status Card
            if (subscription != null)
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: hasActiveSubscription
                      ? AppTheme.primaryGradient
                      : LinearGradient(
                          colors: [
                            AppTheme.warningColor,
                            AppTheme.warningColor.withOpacity(0.8),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          hasActiveSubscription ? Icons.check_circle : Icons.access_time,
                          color: Colors.white,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          isTrialing
                              ? 'Período de Prueba'
                              : hasActiveSubscription
                                  ? 'Suscripción Activa'
                                  : 'Estado de Suscripción',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildStatusRow(
                      'Plan',
                      subscription.plan == 'monthly'
                          ? 'Mensual'
                          : subscription.plan == 'annual'
                              ? 'Anual'
                              : 'Trial',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    if (subscription.nextBillingDate != null)
                      _buildStatusRow(
                        'Próxima Facturación',
                        _formatDate(subscription.nextBillingDate!),
                      ),
                    if (subscription.trialEndsAt != null && isTrialing) ...[
                      const SizedBox(height: AppSpacing.sm),
                      _buildStatusRow(
                        'Trial Finaliza',
                        _formatDate(subscription.trialEndsAt!),
                      ),
                    ],
                  ],
                ),
              ),

            const SizedBox(height: AppSpacing.xl),

            // Header
            Text(
              hasActiveSubscription
                  ? 'Cambiar Plan'
                  : isTrialing
                      ? 'Elige tu Plan'
                      : 'Suscríbete Ahora',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Acceso ilimitado a toda nuestra biblioteca de música terapéutica',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),

            // Plans
            _buildPlanCard(
              index: 0,
              title: 'Plan Mensual',
              price: AppConstants.priceMonthly,
              period: 'mes',
              features: [
                'Acceso ilimitado a toda la biblioteca',
                'Nuevas composiciones cada mes',
                'Calidad de audio premium',
                'Sin anuncios',
                'Cancela cuando quieras',
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            _buildPlanCard(
              index: 1,
              title: 'Plan Anual',
              price: AppConstants.priceAnnual,
              period: 'año',
              discount: 'Ahorra 17%',
              recommended: true,
              features: [
                'Todos los beneficios del plan mensual',
                '2 meses gratis',
                'Soporte prioritario',
                'Acceso anticipado a nuevas funciones',
                'Recursos exclusivos para terapeutas',
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            // Subscribe Button
            ElevatedButton(
              onPressed: () {
                _showPaymentBottomSheet(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              ),
              child: Text(
                hasActiveSubscription
                    ? 'Cambiar Plan'
                    : 'Continuar al Pago',
                style: const TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Trial Info
            if (!hasActiveSubscription && !isTrialing)
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  border: Border.all(
                    color: AppTheme.successColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppTheme.successColor,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        '${AppConstants.trialDays} días de prueba gratis incluidos',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.successColor,
                            ),
                      ),
                    ),
                  ],
                ),
              ),

            // Features List
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Incluido en todos los planes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildFeatureItem('200+ composiciones terapéuticas'),
            _buildFeatureItem('Organizadas por categorías especializadas'),
            _buildFeatureItem('Streaming de alta calidad'),
            _buildFeatureItem('Reproducción en background'),
            _buildFeatureItem('Playlists personalizadas'),
            _buildFeatureItem('Historial de reproducción'),
            _buildFeatureItem('Sin anuncios ni interrupciones'),

            // Cancel Info
            if (hasActiveSubscription) ...[
              const SizedBox(height: AppSpacing.xl),
              const Divider(),
              const SizedBox(height: AppSpacing.md),
              TextButton.icon(
                onPressed: () {
                  _showCancelConfirmation(context);
                },
                icon: const Icon(Icons.cancel, color: AppTheme.errorColor),
                label: const Text(
                  'Cancelar Suscripción',
                  style: TextStyle(color: AppTheme.errorColor),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard({
    required int index,
    required String title,
    required double price,
    required String period,
    String? discount,
    bool recommended = false,
    required List<String> features,
  }) {
    final isSelected = _selectedPlanIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPlanIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.1)
              : AppTheme.cardColor,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected ? AppTheme.primaryColor : Colors.white54,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                if (recommended)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor,
                      borderRadius: BorderRadius.circular(AppBorderRadius.circular),
                    ),
                    child: Text(
                      'Recomendado',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '/$period',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                ),
                if (discount != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.successColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                    ),
                    child: Text(
                      discount,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.successColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check,
                        size: 20,
                        color: AppTheme.successColor,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          feature,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          const Icon(
            Icons.music_note,
            size: 16,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showPaymentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppBorderRadius.lg),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Método de Pago',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'La integración con Stripe se implementará aquí.',
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Incluirá:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text('• Formulario de tarjeta seguro'),
              const Text('• Validación en tiempo real'),
              const Text('• Confirmación de pago'),
              const Text('• Activación inmediata'),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Integración de Stripe pendiente'),
                    ),
                  );
                },
                child: const Text('Confirmar Pago'),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        );
      },
    );
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Suscripción'),
        content: const Text(
          '¿Estás seguro de que quieres cancelar tu suscripción? Mantendrás el acceso hasta el final del período actual.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, mantener'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Cancel subscription
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Suscripción cancelada'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorColor,
            ),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
  }
}
