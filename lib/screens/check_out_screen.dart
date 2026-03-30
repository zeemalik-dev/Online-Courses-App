import 'package:wilan/constants.dart';
import 'package:wilan/models/common_functions.dart';
import 'package:wilan/providers/courses.dart';
import 'package:wilan/providers/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/course.dart';

class CheckoutSessionScreen extends StatefulWidget {
  final Course? course;

  static const routeName = '/course-checkout';
  const CheckoutSessionScreen({Key? key, this.course}) : super(key: key);

  @override
  State<CheckoutSessionScreen> createState() => _CheckoutSessionScreenState();
}

class _CheckoutSessionScreenState extends State<CheckoutSessionScreen> {
  bool isGift = false;
  final TextEditingController couponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final course = widget.course;

    // 🔥 NULL CASE UI
    if (course == null) {
      return Scaffold(
        backgroundColor: const Color(0xffF6EEF3),
        appBar: AppBar(
          title: const Text("CHECKOUT"),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            "No course found",
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    // ✅ NORMAL UI
    return Scaffold(
      backgroundColor: const Color(0xffF6EEF3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "CHECKOUT",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "YOUR CART ITEMS",
                      style: TextStyle(
                        fontSize: 13,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildCartCard(course),
                    const SizedBox(height: 20),
                    _buildTotalSection(course),
                    const SizedBox(height: 20),
                    _buildCheckoutButton(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  // ================= CART CARD =================

  Widget _buildCartCard(Course course) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 LEFT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  course.shortDescription ?? "",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "COURSE",
                    style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // 🔹 RIGHT CONTENT
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                course.getFormattedPrice(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (course.discountFlag == 1)
                Text(
                  course.getOriginalPrice(),
                  style: const TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              const SizedBox(height: 6),
              if (course.discountFlag == 1)
                Text(
                  "Save ${course.formatPrice(course.savings.toString())}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 10),
              const Icon(Icons.delete_outline, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  // ================= TOTAL SECTION =================

  Widget _buildTotalSection(Course course) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // 🔹 SUBTOTAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Subtotal"),
              Text(
                course.getFormattedPrice(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const Divider(height: 30),

          // 🔹 TOTAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                course.getFormattedPrice(),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 🔹 COUPON FIELD
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: couponController,
                  decoration: InputDecoration(
                    hintText: "Apply coupon",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  // TODO: Apply coupon API
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Apply",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 🔹 GIFT OPTION
          Row(
            children: [
              Checkbox(
                value: isGift,
                onChanged: (value) {
                  setState(() {
                    isGift = value ?? false;
                  });
                },
              ),
              const Text("Send as a gift"),
            ],
          ),
        ],
      ),
    );
  }

  // ================= BUTTON =================

  void _launchURL(String url) async => await canLaunch(url)
      ? await launch(url, forceSafariVC: false)
      : throw 'Could not launch $url';

  Widget _buildCheckoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          var _authToken = await SharedPreferenceHelper().getAuthToken();
          if (!(widget.course?.isPurchased ?? false)) {
            if (_authToken != null) {
              if (widget.course?.isPaid == 0) {
                Provider.of<Courses>(context, listen: false)
                    .getEnrolled(widget.course!.id)
                    .then((_) => CommonFunctions.showSuccessToast(
                        'Enrolled Successfully'));
              } else {
                final url =
                    '$BASE_URL/api/web_redirect_to_buy_course/$_authToken/${widget.course!.id}/academybycreativeitem';
                _launchURL(url);
              }
            } else {
              CommonFunctions.showSuccessToast('Please login first');
            }
          }
          // TODO: Payment Integration
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: const Text(
          "Continue to Payment",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
