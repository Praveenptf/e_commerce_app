import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mechine_test/controller/home_screen_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:animate_do/animate_do.dart';

/// ✅ MODEL
class OfferBanner {
  final String imagePath;

  OfferBanner({required this.imagePath});
}

/// ✅ WIDGET
class CarouselBanner extends StatefulWidget {
  final HomeController homeController;

  const CarouselBanner({super.key, required this.homeController});

  @override
  State<CarouselBanner> createState() => _CarouselBannerState();
}

class _CarouselBannerState extends State<CarouselBanner> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.homeController.isLoadingOffers.value) {
        return _loadingBanner();
      }

      if (widget.homeController.offerBanners.isEmpty) {
        return _emptyBanner();
      }

      return _carouselBanner();
    });
  }

  Widget _carouselBanner() {
    final offers = widget.homeController.offerBanners;

    return FadeInUp(
      duration: const Duration(milliseconds: 700),
      child: Column(
        children: [
          CarouselSlider.builder(
            itemCount: offers.length,
            itemBuilder: (context, index, _) {
              final banner = offers[index];

              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  banner.imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              );
            },
            options: CarouselOptions(
              height: 180,
              autoPlay: offers.length > 1,
              enlargeCenterPage: true,
              autoPlayInterval: const Duration(seconds: 3),
              onPageChanged: (index, reason) {
                setState(() => _currentIndex = index);
              },
            ),
          ),

          if (offers.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: AnimatedSmoothIndicator(
                activeIndex: _currentIndex,
                count: offers.length,
                effect: const WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Color(0xFFFF5722),
                  dotColor: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _loadingBanner() {
    return Container(
      height: 180,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const CircularProgressIndicator(color: Color(0xFFFF5722)),
    );
  }

  Widget _emptyBanner() {
    return _errorBox('No offers available');
  }

  Widget _errorBox(String text) {
    return Container(
      height: 180,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFF5722),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
