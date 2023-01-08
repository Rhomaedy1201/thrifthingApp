import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingProducts extends StatelessWidget {
  const ShimmerLoadingProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            color: const Color(0xFFF3F3F3),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: const Color(0xFFE3E3E3),
                highlightColor: Colors.white,
                child: Container(
                  margin: const EdgeInsets.only(
                      top: 10, left: 10, right: 10, bottom: 5),
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: const Color(0xFFE6E6E6),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 3),
                    Shimmer.fromColors(
                      baseColor: const Color(0xFFE3E3E3),
                      highlightColor: Colors.white,
                      child: Container(
                        width: 120,
                        height: 20,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6E6E6),
                          borderRadius: BorderRadius.circular(25 / 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Shimmer.fromColors(
                      baseColor: const Color(0xFFE3E3E3),
                      highlightColor: Colors.white,
                      child: Container(
                        width: 160,
                        height: 18,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6E6E6),
                          borderRadius: BorderRadius.circular(25 / 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 10 / 13,
      ),
      shrinkWrap: true,
      primary: false,
    );
  }
}
