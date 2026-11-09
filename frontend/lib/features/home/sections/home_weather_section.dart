import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Providers/weather_provider.dart';
import 'package:frontend/features/home/widgets/weather_suggestion_banner.dart';

class HomeWeatherSection extends ConsumerWidget {
  const HomeWeatherSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestion = ref.watch(weatherSuggestionProvider);
    return WeatherSuggestionBanner(suggestion: suggestion);
  }
}

