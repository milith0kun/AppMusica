import 'package:flutter_test/flutter_test.dart';
import 'package:app_musica/core/utils/formatters.dart';

void main() {
  group('Formatters - Duration', () {
    test('formats seconds correctly', () {
      expect(Formatters.formatDuration(30), equals('0:30'));
      expect(Formatters.formatDuration(90), equals('1:30'));
      expect(Formatters.formatDuration(125), equals('2:05'));
    });

    test('formats hours correctly', () {
      expect(Formatters.formatDuration(3600), equals('1:00:00'));
      expect(Formatters.formatDuration(3661), equals('1:01:01'));
      expect(Formatters.formatDuration(7325), equals('2:02:05'));
    });

    test('handles zero and negative', () {
      expect(Formatters.formatDuration(0), equals('0:00'));
      expect(Formatters.formatDuration(-10), equals('0:00'));
    });
  });

  group('Formatters - Date Relative', () {
    test('formats today', () {
      final today = DateTime.now();
      expect(Formatters.formatDateRelative(today), equals('Hoy'));
    });

    test('formats yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(Formatters.formatDateRelative(yesterday), equals('Ayer'));
    });

    test('formats recent days as weekday', () {
      final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
      final result = Formatters.formatDateRelative(threeDaysAgo);
      // Should be a weekday name in Spanish
      expect(result.isNotEmpty, isTrue);
      expect(result, isNot(equals('Hoy')));
      expect(result, isNot(equals('Ayer')));
    });
  });

  group('Formatters - Time Ago', () {
    test('formats recent time', () {
      final now = DateTime.now();
      expect(Formatters.formatTimeAgo(now), equals('Hace un momento'));
    });

    test('formats minutes', () {
      final fiveMinutesAgo = DateTime.now().subtract(const Duration(minutes: 5));
      expect(Formatters.formatTimeAgo(fiveMinutesAgo), equals('Hace 5 minutos'));

      final oneMinuteAgo = DateTime.now().subtract(const Duration(minutes: 1));
      expect(Formatters.formatTimeAgo(oneMinuteAgo), equals('Hace 1 minuto'));
    });

    test('formats hours', () {
      final twoHoursAgo = DateTime.now().subtract(const Duration(hours: 2));
      expect(Formatters.formatTimeAgo(twoHoursAgo), equals('Hace 2 horas'));

      final oneHourAgo = DateTime.now().subtract(const Duration(hours: 1));
      expect(Formatters.formatTimeAgo(oneHourAgo), equals('Hace 1 hora'));
    });

    test('formats days', () {
      final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
      expect(Formatters.formatTimeAgo(threeDaysAgo), equals('Hace 3 días'));

      final oneDayAgo = DateTime.now().subtract(const Duration(days: 1));
      expect(Formatters.formatTimeAgo(oneDayAgo), equals('Hace 1 día'));
    });
  });

  group('Formatters - Numbers', () {
    test('formats numbers with thousand separators', () {
      expect(Formatters.formatNumber(1000), equals('1.000'));
      expect(Formatters.formatNumber(1234567), equals('1.234.567'));
      expect(Formatters.formatNumber(100), equals('100'));
    });

    test('formats decimals correctly', () {
      expect(Formatters.formatDecimal(1234.56), equals('1.234,56'));
      expect(Formatters.formatDecimal(1234.5, decimals: 1), equals('1.234,5'));
    });

    test('formats currency', () {
      expect(Formatters.formatCurrency(19.99), equals('\$19,99'));
      expect(Formatters.formatCurrency(199.99), equals('\$199,99'));
      expect(Formatters.formatCurrency(1234.56), equals('\$1.234,56'));
    });

    test('formats percentage', () {
      expect(Formatters.formatPercentage(75), equals('75%'));
      expect(Formatters.formatPercentage(75.5, decimals: 1), equals('75,5%'));
    });
  });

  group('Formatters - File Size', () {
    test('formats bytes', () {
      expect(Formatters.formatFileSize(500), equals('500 B'));
    });

    test('formats kilobytes', () {
      expect(Formatters.formatFileSize(1024), equals('1.0 KB'));
      expect(Formatters.formatFileSize(2048), equals('2.0 KB'));
    });

    test('formats megabytes', () {
      expect(Formatters.formatFileSize(1024 * 1024), equals('1.0 MB'));
      expect(Formatters.formatFileSize(5 * 1024 * 1024), equals('5.0 MB'));
    });

    test('formats gigabytes', () {
      expect(Formatters.formatFileSize(1024 * 1024 * 1024), equals('1.0 GB'));
    });
  });

  group('Formatters - Audio Quality', () {
    test('formats bitrate', () {
      expect(Formatters.formatBitrate(128), equals('128 kbps'));
      expect(Formatters.formatBitrate(256), equals('256 kbps'));
      expect(Formatters.formatBitrate(1000), equals('1.0 Mbps'));
    });

    test('formats audio quality label', () {
      expect(Formatters.formatAudioQuality(128), equals('Calidad básica'));
      expect(Formatters.formatAudioQuality(256), equals('Calidad media'));
      expect(Formatters.formatAudioQuality(320), equals('Alta calidad'));
    });
  });

  group('Formatters - Counts', () {
    test('formats song count', () {
      expect(Formatters.formatSongCount(1), equals('1 canción'));
      expect(Formatters.formatSongCount(5), equals('5 canciones'));
      expect(Formatters.formatSongCount(0), equals('0 canciones'));
    });

    test('formats playlist count', () {
      expect(Formatters.formatPlaylistCount(1), equals('1 playlist'));
      expect(Formatters.formatPlaylistCount(5), equals('5 playlists'));
    });

    test('formats album count', () {
      expect(Formatters.formatAlbumCount(1), equals('1 álbum'));
      expect(Formatters.formatAlbumCount(5), equals('5 álbumes'));
    });

    test('formats artist count', () {
      expect(Formatters.formatArtistCount(1), equals('1 artista'));
      expect(Formatters.formatArtistCount(5), equals('5 artistas'));
    });
  });

  group('Formatters - Total Duration', () {
    test('formats minutes only', () {
      expect(Formatters.formatTotalDuration(120), equals('2 minutos'));
      expect(Formatters.formatTotalDuration(60), equals('1 minuto'));
      expect(Formatters.formatTotalDuration(30), equals('Menos de 1 minuto'));
    });

    test('formats hours and minutes', () {
      expect(Formatters.formatTotalDuration(3600), equals('1 hora 0 minutos'));
      expect(Formatters.formatTotalDuration(3660), equals('1 hora 1 minuto'));
      expect(Formatters.formatTotalDuration(7200), equals('2 horas 0 minutos'));
      expect(Formatters.formatTotalDuration(7320), equals('2 horas 2 minutos'));
    });
  });

  group('Formatters - Subscription', () {
    test('formats subscription period', () {
      expect(Formatters.formatSubscriptionPeriod('monthly'), equals('Mensual'));
      expect(Formatters.formatSubscriptionPeriod('yearly'), equals('Anual'));
      expect(Formatters.formatSubscriptionPeriod('trial'), equals('Prueba'));
    });

    test('formats subscription status', () {
      expect(Formatters.formatSubscriptionStatus('active'), equals('Activa'));
      expect(Formatters.formatSubscriptionStatus('trial'), equals('Prueba'));
      expect(Formatters.formatSubscriptionStatus('expired'), equals('Expirada'));
      expect(Formatters.formatSubscriptionStatus('cancelled'), equals('Cancelada'));
    });
  });

  group('Formatters - Phone Number', () {
    test('formats 10 digit phone', () {
      expect(
        Formatters.formatPhoneNumber('1234567890'),
        equals('(123) 456-7890'),
      );
    });

    test('formats 11 digit phone with country code', () {
      expect(
        Formatters.formatPhoneNumber('11234567890'),
        equals('+1 (123) 456-7890'),
      );
    });

    test('handles already formatted phone', () {
      final result = Formatters.formatPhoneNumber('(123) 456-7890');
      expect(result, equals('(123) 456-7890'));
    });
  });

  group('Formatters - Credit Card', () {
    test('masks card number', () {
      expect(
        Formatters.formatCreditCardMasked('1234567890123456'),
        equals('**** **** **** 3456'),
      );
    });

    test('handles short card number', () {
      expect(Formatters.formatCreditCardMasked('123'), equals('123'));
    });
  });

  group('Formatters - Text Utilities', () {
    test('truncates text', () {
      expect(
        Formatters.truncateText('This is a long text', 10),
        equals('This is a ...'),
      );
      expect(
        Formatters.truncateText('Short', 10),
        equals('Short'),
      );
    });

    test('capitalizes first letter', () {
      expect(Formatters.capitalize('hello'), equals('Hello'));
      expect(Formatters.capitalize('HELLO'), equals('Hello'));
      expect(Formatters.capitalize(''), equals(''));
    });

    test('capitalizes each word', () {
      expect(Formatters.capitalizeWords('hello world'), equals('Hello World'));
      expect(Formatters.capitalizeWords('HELLO WORLD'), equals('Hello World'));
    });
  });

  group('Formatters - Music Specific', () {
    test('formats BPM', () {
      expect(Formatters.formatBpm(120), equals('120 BPM'));
      expect(Formatters.formatBpm(60), equals('60 BPM'));
    });

    test('formats musical key', () {
      expect(Formatters.formatKey('c major'), equals('C MAJOR'));
      expect(Formatters.formatKey('g minor'), equals('G MINOR'));
    });
  });

  group('Formatters - Lists', () {
    test('formats empty list', () {
      expect(Formatters.formatList([]), equals(''));
    });

    test('formats single item', () {
      expect(Formatters.formatList(['item']), equals('item'));
    });

    test('formats two items', () {
      expect(Formatters.formatList(['item1', 'item2']), equals('item1 y item2'));
    });

    test('formats multiple items', () {
      expect(
        Formatters.formatList(['item1', 'item2', 'item3']),
        equals('item1, item2 y item3'),
      );
    });
  });

  group('Formatters - Play Count', () {
    test('formats small numbers', () {
      expect(Formatters.formatPlayCount(999), equals('999'));
    });

    test('formats thousands', () {
      expect(Formatters.formatPlayCount(1000), equals('1.0K'));
      expect(Formatters.formatPlayCount(1500), equals('1.5K'));
      expect(Formatters.formatPlayCount(999999), equals('999.9K'));
    });

    test('formats millions', () {
      expect(Formatters.formatPlayCount(1000000), equals('1.0M'));
      expect(Formatters.formatPlayCount(2500000), equals('2.5M'));
    });
  });

  group('Formatters - Session Duration', () {
    test('formats minutes only', () {
      expect(Formatters.formatSessionDuration(30), equals('30 minutos'));
      expect(Formatters.formatSessionDuration(1), equals('1 minuto'));
    });

    test('formats hours only', () {
      expect(Formatters.formatSessionDuration(60), equals('1 hora'));
      expect(Formatters.formatSessionDuration(120), equals('2 horas'));
    });

    test('formats hours and minutes', () {
      expect(Formatters.formatSessionDuration(90), equals('1 hora 30 minutos'));
      expect(Formatters.formatSessionDuration(125), equals('2 horas 5 minutos'));
      expect(Formatters.formatSessionDuration(61), equals('1 hora 1 minuto'));
    });
  });
}
