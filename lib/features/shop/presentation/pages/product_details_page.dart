import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            SizedBox(
              height: 350.h,
              width: double.infinity,
              child: Hero(
                tag: product['imageUrl'],
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      product['imageUrl'],
                      fit: BoxFit.cover,
                    ),
                    // Gradient overlay for better text visibility
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                          stops: const [0.7, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content Container
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              transform: Matrix4.translationValues(0, -30, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product['name'],
                    style: GoogleFonts.poppins(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                      height: 1.2.h,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Price
                  Text(
                    ' ${product['price']} USD',
                    style: GoogleFonts.poppins(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4CAF50),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Rating
                  Row(
                    children: [
                      ...List.generate(
                          4,
                          (index) => const Icon(
                                Icons.star,
                                color: Color(0xFFFFA41C),
                                size: 20,
                              )),
                      const Icon(
                        Icons.star_half,
                        color: Color(0xFFFFA41C),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '4.5',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(128 reviews)',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // Description Header
                  Text(
                    'Description',
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Description
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Text(
                      product['description'],
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        color: Colors.grey[800],
                        height: 1.6.h,
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Related Products (Optional)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
