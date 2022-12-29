import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? paymentIntentData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Payment implementation'),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: InkWell(
          onTap: () async {
            await openPaymentSheetWidget();
          },
          child: Container(
            decoration: BoxDecoration(
                color: primaryColor,),
            height: 50,
            width: 200,
            child: const Center(
              child: Text(
                'Pay 200 Rupees',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> openPaymentSheetWidget() async {
    try {
      paymentIntentData = await makingPaymentDataIntentApi('200', 'INR');
      await Stripe.instance
          .initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          appearance: PaymentSheetAppearance(
            primaryButton: const PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: Colors.blue,
                ),
              ),
            ),
            colors: PaymentSheetAppearanceColors(background: blueShade50),
          ),
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          style: ThemeMode.system,
          merchantDisplayName: 'Merchant Display Name',
        ),
      )
          .then((value) {
        showPaymentSheetWidget();
      });
    } catch (e, s) {
      debugPrint('Exception:$e$s');
    }
  }

  showPaymentSheetWidget() async {
    try {
      /*   await Stripe.instance.presentPaymentSheet(
          // ignore: deprecated_member_use
          parameters: PresentPaymentSheetParameters(
        clientSecret: paymentIntentData!['client_secret'],
        confirmPayment: true,
      ));*/
      await Stripe.instance.presentPaymentSheet();
      debugPrint('Payment Intent Id${paymentIntentData!['id']}');
      debugPrint(
          'Payment Intent Client Secret${paymentIntentData!['client_secret']}');
      debugPrint('Payment Intent Amount${paymentIntentData!['amount']}');
      debugPrint('Payment Intent All Details$paymentIntentData');
      setState(() {
        paymentIntentData = null;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.blue,
          content: Text(
            "Paid Successfully Completed",
            style: TextStyle(color: Colors.white),
          )));
    } on StripeException catch (e) {
      debugPrint('StripeException:  $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Stripe Exception"),
              ));
    } catch (e) {
      debugPrint('$e');
    }
  }

  makingPaymentDataIntentApi(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51M4HYcSGi5DRanM6cV3LojXkCACgKBdNc5OExZgq82Qm6r5UaFPIwm7d9S10Uq3ffgn1wOM7BI3rRr3dlYzrR7IG00MxsrWSDR',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (err) {
      debugPrint('callPaymentIntentApi Exception: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }
}
