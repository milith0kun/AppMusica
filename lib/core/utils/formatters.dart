import 'package:intl/intl.dart';

/// Formatting utilities for the app

class Formatters {
  /// Format duration from seconds to MM:SS or HH:MM:SS format
  static String formatDuration(int seconds) {
    if (seconds < 0) return '0:00';

    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    } else {
      return '${minutes}:${secs.toString().padLeft(2, '0')}';
    }
  }

  /// Format Duration object to MM:SS or HH:MM:SS format
  static String formatDurationObject(Duration duration) {
    return formatDuration(duration.inSeconds);
  }

  /// Format date to readable Spanish format
  static String formatDate(DateTime date) {
    return DateFormat('d \'de\' MMMM \'de\' yyyy', 'es').format(date);
  }

  /// Format date to short format (DD/MM/YYYY)
  static String formatDateShort(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Format date to relative format (Hoy, Ayer, or date)
  static String formatDateRelative(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Hoy';
    } else if (dateOnly == yesterday) {
      return 'Ayer';
    } else if (now.difference(dateOnly).inDays < 7) {
      return DateFormat('EEEE', 'es').format(date);
    } else if (now.year == date.year) {
      return DateFormat('d \'de\' MMMM', 'es').format(date);
    } else {
      return DateFormat('d \'de\' MMMM \'de\' yyyy', 'es').format(date);
    }
  }

  /// Format time (HH:MM)
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Format date and time
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('d \'de\' MMMM \'de\' yyyy, HH:mm', 'es').format(dateTime);
  }

  /// Format timestamp to "hace X minutos/horas/días"
  static String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Hace un momento';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return 'Hace $minutes ${minutes == 1 ? 'minuto' : 'minutos'}';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return 'Hace $hours ${hours == 1 ? 'hora' : 'horas'}';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return 'Hace $days ${days == 1 ? 'día' : 'días'}';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Hace $weeks ${weeks == 1 ? 'semana' : 'semanas'}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'Hace $months ${months == 1 ? 'mes' : 'meses'}';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'Hace $years ${years == 1 ? 'año' : 'años'}';
    }
  }

  /// Format number with thousand separators
  static String formatNumber(int number) {
    return NumberFormat('#,###', 'es').format(number);
  }

  /// Format decimal number
  static String formatDecimal(double number, {int decimals = 2}) {
    return NumberFormat('#,##0.${'0' * decimals}', 'es').format(number);
  }

  /// Format currency (USD)
  static String formatCurrency(double amount, {String symbol = '\$'}) {
    return '$symbol${NumberFormat('#,##0.00', 'es').format(amount)}';
  }

  /// Format percentage
  static String formatPercentage(double value, {int decimals = 0}) {
    return '${NumberFormat('#,##0.${'0' * decimals}', 'es').format(value)}%';
  }

  /// Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Format bitrate
  static String formatBitrate(int kbps) {
    if (kbps < 1000) {
      return '$kbps kbps';
    } else {
      return '${(kbps / 1000).toStringAsFixed(1)} Mbps';
    }
  }

  /// Format audio quality label
  static String formatAudioQuality(int kbps) {
    if (kbps >= 320) {
      return 'Alta calidad';
    } else if (kbps >= 192) {
      return 'Calidad media';
    } else {
      return 'Calidad básica';
    }
  }

  /// Format song count
  static String formatSongCount(int count) {
    return '$count ${count == 1 ? 'canción' : 'canciones'}';
  }

  /// Format playlist count
  static String formatPlaylistCount(int count) {
    return '$count ${count == 1 ? 'playlist' : 'playlists'}';
  }

  /// Format album count
  static String formatAlbumCount(int count) {
    return '$count ${count == 1 ? 'álbum' : 'álbumes'}';
  }

  /// Format artist count
  static String formatArtistCount(int count) {
    return '$count ${count == 1 ? 'artista' : 'artistas'}';
  }

  /// Format total duration for playlist/album
  static String formatTotalDuration(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;

    if (hours > 0) {
      return '$hours ${hours == 1 ? 'hora' : 'horas'} $minutes ${minutes == 1 ? 'minuto' : 'minutos'}';
    } else if (minutes > 0) {
      return '$minutes ${minutes == 1 ? 'minuto' : 'minutos'}';
    } else {
      return 'Menos de 1 minuto';
    }
  }

  /// Format subscription period
  static String formatSubscriptionPeriod(String period) {
    switch (period.toLowerCase()) {
      case 'monthly':
        return 'Mensual';
      case 'yearly':
        return 'Anual';
      case 'trial':
        return 'Prueba';
      default:
        return period;
    }
  }

  /// Format subscription status
  static String formatSubscriptionStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Activa';
      case 'trial':
        return 'Prueba';
      case 'expired':
        return 'Expirada';
      case 'cancelled':
        return 'Cancelada';
      default:
        return status;
    }
  }

  /// Format phone number for display
  static String formatPhoneNumber(String phone) {
    // Remove all non-digit characters
    final digitsOnly = phone.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length == 10) {
      // Format as (XXX) XXX-XXXX
      return '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3, 6)}-${digitsOnly.substring(6)}';
    } else if (digitsOnly.length == 11 && digitsOnly.startsWith('1')) {
      // Format as +1 (XXX) XXX-XXXX
      return '+1 (${digitsOnly.substring(1, 4)}) ${digitsOnly.substring(4, 7)}-${digitsOnly.substring(7)}';
    }

    return phone; // Return as-is if format is not recognized
  }

  /// Format credit card number for display (show last 4 digits)
  static String formatCreditCardMasked(String cardNumber) {
    if (cardNumber.length < 4) return cardNumber;
    final last4 = cardNumber.substring(cardNumber.length - 4);
    return '**** **** **** $last4';
  }

  /// Truncate text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Capitalize each word
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Format BPM (Beats Per Minute)
  static String formatBpm(int bpm) {
    return '$bpm BPM';
  }

  /// Format musical key
  static String formatKey(String key) {
    return key.toUpperCase();
  }

  /// Format list of items with commas and "y"
  static String formatList(List<String> items) {
    if (items.isEmpty) return '';
    if (items.length == 1) return items[0];
    if (items.length == 2) return '${items[0]} y ${items[1]}';

    final lastItem = items.last;
    final otherItems = items.sublist(0, items.length - 1).join(', ');
    return '$otherItems y $lastItem';
  }

  /// Format play count
  static String formatPlayCount(int count) {
    if (count < 1000) {
      return count.toString();
    } else if (count < 1000000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
  }

  /// Format download count
  static String formatDownloadCount(int count) {
    return '${formatPlayCount(count)} ${count == 1 ? 'descarga' : 'descargas'}';
  }

  /// Format therapy session duration
  static String formatSessionDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes ${minutes == 1 ? 'minuto' : 'minutos'}';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '$hours ${hours == 1 ? 'hora' : 'horas'}';
      } else {
        return '$hours ${hours == 1 ? 'hora' : 'horas'} $remainingMinutes ${remainingMinutes == 1 ? 'minuto' : 'minutos'}';
      }
    }
  }
}
