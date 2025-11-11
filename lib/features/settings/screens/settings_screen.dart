import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../data/models/user_model.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final preferences = authState.user?.preferences ??
        const UserPreferences(
          language: 'es',
          audioQuality: '256kbps',
          autoplay: true,
          notificationsEnabled: true,
          historyEnabled: true,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
      ),
      body: ListView(
        children: [
          // Audio Section
          _buildSectionHeader(context, 'Audio'),
          ListTile(
            leading: const Icon(Icons.high_quality),
            title: const Text('Calidad de Audio'),
            subtitle: Text(_getQualityLabel(preferences.audioQuality)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showQualityDialog(context, preferences);
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.play_arrow),
            title: const Text('Reproducción Automática'),
            subtitle: const Text('Reproducir siguiente canción automáticamente'),
            value: preferences.autoplay,
            onChanged: (value) {
              _updatePreferences(
                context,
                ref,
                preferences.copyWith(autoplay: value),
              );
            },
          ),
          const Divider(),

          // Notifications Section
          _buildSectionHeader(context, 'Notificaciones'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text('Notificaciones Push'),
            subtitle: const Text('Recibir notificaciones de nuevo contenido'),
            value: preferences.notificationsEnabled,
            onChanged: (value) {
              _updatePreferences(
                context,
                ref,
                preferences.copyWith(notificationsEnabled: value),
              );
            },
          ),
          const Divider(),

          // Privacy Section
          _buildSectionHeader(context, 'Privacidad'),
          SwitchListTile(
            secondary: const Icon(Icons.history),
            title: const Text('Historial de Reproducción'),
            subtitle: const Text('Guardar historial de canciones escuchadas'),
            value: preferences.historyEnabled,
            onChanged: (value) {
              _updatePreferences(
                context,
                ref,
                preferences.copyWith(historyEnabled: value),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Limpiar Historial'),
            subtitle: const Text('Eliminar todo el historial de reproducción'),
            onTap: () {
              _showClearHistoryDialog(context);
            },
          ),
          const Divider(),

          // Account Section
          _buildSectionHeader(context, 'Cuenta'),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Información Personal'),
            subtitle: const Text('Editar nombre, profesión, ubicación'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _navigateToEditProfile(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Cambiar Contraseña'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _navigateToChangePassword(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Verificación Profesional'),
            subtitle: Text(
              authState.user?.professionalVerified == true
                  ? 'Verificado'
                  : 'No verificado',
            ),
            trailing: authState.user?.professionalVerified == true
                ? const Icon(Icons.check_circle, color: AppTheme.successColor)
                : const Icon(Icons.chevron_right),
            onTap: () {
              if (authState.user?.professionalVerified != true) {
                // Navigate to verification
              }
            },
          ),
          const Divider(),

          // App Section
          _buildSectionHeader(context, 'Aplicación'),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Idioma'),
            subtitle: const Text('Español'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Show language picker
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Tema'),
            subtitle: const Text('Oscuro'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Show theme picker
            },
          ),
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Caché'),
            subtitle: const Text('Gestionar datos almacenados'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showCacheOptions(context);
            },
          ),
          const Divider(),

          // About Section
          _buildSectionHeader(context, 'Acerca de'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Versión'),
            subtitle: const Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Términos de Servicio'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () {
              // Open terms
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Política de Privacidad'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () {
              // Open privacy policy
            },
          ),
          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text('Licencias'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: AppStrings.appName,
                applicationVersion: '1.0.0',
              );
            },
          ),

          const SizedBox(height: AppSpacing.xl),

          // Danger Zone
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: OutlinedButton.icon(
              onPressed: () {
                _showDeleteAccountDialog(context);
              },
              icon: const Icon(Icons.delete_forever),
              label: const Text('Eliminar Cuenta'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.errorColor,
                side: const BorderSide(color: AppTheme.errorColor),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  String _getQualityLabel(String quality) {
    switch (quality) {
      case '128kbps':
        return 'Normal (128 kbps)';
      case '256kbps':
        return 'Alta (256 kbps)';
      case '320kbps':
        return 'Muy Alta (320 kbps)';
      default:
        return 'Normal';
    }
  }

  void _showQualityDialog(BuildContext context, UserPreferences preferences) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Calidad de Audio'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Normal (128 kbps)'),
              subtitle: const Text('Menor consumo de datos'),
              value: '128kbps',
              groupValue: preferences.audioQuality,
              onChanged: (value) {
                if (value != null) {
                  _updatePreferences(
                    context,
                    ref,
                    preferences.copyWith(audioQuality: value),
                  );
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Alta (256 kbps)'),
              subtitle: const Text('Recomendado'),
              value: '256kbps',
              groupValue: preferences.audioQuality,
              onChanged: (value) {
                if (value != null) {
                  _updatePreferences(
                    context,
                    ref,
                    preferences.copyWith(audioQuality: value),
                  );
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _updatePreferences(
    BuildContext context,
    WidgetRef ref,
    UserPreferences newPreferences,
  ) {
    // Update preferences via repository
    // For now, just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preferencias actualizadas'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar Historial'),
        content: const Text(
          '¿Estás seguro de que quieres eliminar todo tu historial de reproducción? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Historial eliminado')),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorColor,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showCacheOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gestionar Caché'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tamaño aproximado: 24.5 MB'),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'La caché incluye imágenes de portadas y datos temporales que mejoran el rendimiento de la app.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Caché limpiada')),
              );
            },
            child: const Text('Limpiar Caché'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Cuenta'),
        content: const Text(
          'Esta acción eliminará permanentemente tu cuenta y todos tus datos. No podrás recuperar esta información.\n\n¿Estás completamente seguro?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Delete account
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorColor,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    Navigator.pushNamed(context, '/edit-profile');
  }

  void _navigateToChangePassword(BuildContext context) {
    Navigator.pushNamed(context, '/change-password');
  }
}
