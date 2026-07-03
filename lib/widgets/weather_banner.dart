import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../theme/aesthetics.dart';

class WeatherBanner extends StatefulWidget {
  const WeatherBanner({super.key});

  @override
  State<WeatherBanner> createState() => _WeatherBannerState();
}

class _WeatherBannerState extends State<WeatherBanner> {
  bool _hasFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasFetched) {
      _hasFetched = true;
      // Fetch real weather from wttr.in on first render
      final restaurantState = InheritedRestaurantState.of(context);
      restaurantState.fetchRealWeather();
    }
  }

  @override
  Widget build(BuildContext context) {
    final restaurantState = InheritedRestaurantState.of(context);

    return ListenableBuilder(
      listenable: restaurantState,
      builder: (context, _) {
        final weather = restaurantState.currentWeather;
        final temp = restaurantState.currentTemp;
        final isFetching = restaurantState.isFetchingWeather;

        String weatherText;
        IconData weatherIcon;
        Color bannerColor;
        String recommendReason;

        switch (weather) {
          case WeatherMode.sunny:
            weatherText = "Warm & Sunny";
            weatherIcon = Icons.wb_sunny_outlined;
            bannerColor = const Color(0xFFFDF7E7);
            recommendReason = "Cool down with our refreshing premium ice creams and cold brews.";
            break;
          case WeatherMode.rainy:
            weatherText = "Rainy Day Comfort";
            weatherIcon = Icons.umbrella_outlined;
            bannerColor = const Color(0xFFEBF0EF);
            recommendReason = "Warm up with cozy wood-fired pizza and rich double espresso.";
            break;
          case WeatherMode.cold:
            weatherText = "Cool & Breezy";
            weatherIcon = Icons.ac_unit_outlined;
            bannerColor = const Color(0xFFF0EAE1);
            recommendReason = "Satisfy your cravings with our hot gourmet burgers and warm waffles.";
            break;
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: bannerColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: CafeTheme.primary.withOpacity(0.15)),
            boxShadow: CafeTheme.softShadow,
          ),
          child: isFetching
              ? Row(
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: CafeTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Fetching real-time weather...",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: CafeTheme.textMuted,
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(weatherIcon, color: CafeTheme.primary, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "$weatherText • ${temp.toStringAsFixed(1)}°C",
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontFamily: 'Georgia',
                                      color: CafeTheme.textDark,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Live indicator dot
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF4CAF50),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    "LIVE",
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4CAF50),
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                recommendReason,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: CafeTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Refresh button
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => restaurantState.fetchRealWeather(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: CafeTheme.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: CafeTheme.primary.withOpacity(0.3)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.refresh, size: 14, color: CafeTheme.primary),
                              SizedBox(width: 4),
                              Text(
                                "Refresh",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: CafeTheme.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
