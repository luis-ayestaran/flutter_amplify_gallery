import 'package:amplify_flutter/amplify.dart';
import 'package:flutter_amplify/services/analytics_events.dart';

class AnalyticsService {
  static void log( AbstractAnalyticsEvent event ) {
    Amplify.Analytics.recordEvent(event: event.value);
  }
}