import 'package:echosphere/View/Constant/app_color.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: premiumScaffoldColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
        child: Column(
          children: [

            /// =========================
            /// FRONT SIDE CARD
            /// =========================
            Container(
              width: double.infinity,
              height: 230,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),

                border: Border.all(
                  color: goldPrimaryColor.withOpacity(0.12),
                  width: 1,
                ),

                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0E0E0E),
                    Color(0xFF151515),
                    Color(0xFF1C1407),
                  ],
                ),

                boxShadow: [
                  BoxShadow(
                    color: goldPrimaryColor.withOpacity(0.10),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                  const BoxShadow(
                    color: Colors.black54,
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),

                child: Stack(
                  children: [

                    /// DESIGN
                    Positioned(
                      top: -60,
                      left: -50,
                      child: Container(
                        height: 180,
                        width: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: goldPrimaryColor.withOpacity(0.05),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: -80,
                      right: -60,
                      child: Container(
                        height: 220,
                        width: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: goldPrimaryColor.withOpacity(0.04),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(18),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          /// TOP TAG
                          Center(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 7,
                              ),

                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(40),

                                color: goldPrimaryColor
                                    .withOpacity(0.10),
                              ),

                              child: const Text(
                                'ADVENTURE PASS',

                                style: TextStyle(
                                  color: goldPrimaryColor,
                                  fontWeight:
                                      FontWeight.w800,
                                  letterSpacing: 1,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          /// TITLE
                          const Center(
                            child: Column(
                              children: [

                                Text(
                                  'ECHOSPHERE',

                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight:
                                        FontWeight.w900,
                                    letterSpacing: 1.2,
                                  ),
                                ),

                                SizedBox(height: 4),

                                Text(
                                  'MULTI SERVICES PVT. LTD.',

                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 10,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),

                          /// BOTTOM
                          Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,

                            children: [

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [

                                    const Text(
                                      'XXXXX XXXX',

                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 21,
                                        fontWeight:
                                            FontWeight.w700,
                                        letterSpacing: 1.4,
                                      ),
                                    ),

                                    const SizedBox(
                                        height: 16),

                                    Row(
                                      children: [

                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,

                                          children: const [

                                            Text(
                                              'MEMBER ID',

                                              style:
                                                  TextStyle(
                                                color:
                                                    Colors
                                                        .white54,
                                                fontSize:
                                                    8,
                                                letterSpacing:
                                                    1,
                                              ),
                                            ),

                                            SizedBox(
                                                height:
                                                    4),

                                            Text(
                                              '#01254',

                                              style:
                                                  TextStyle(
                                                color:
                                                    Colors
                                                        .white,
                                                fontWeight:
                                                    FontWeight
                                                        .bold,
                                                fontSize:
                                                    13,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(
                                            width: 28),

                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,

                                          children: const [

                                            Text(
                                              'VALID THRU',

                                              style:
                                                  TextStyle(
                                                color:
                                                    Colors
                                                        .white54,
                                                fontSize:
                                                    8,
                                                letterSpacing:
                                                    1,
                                              ),
                                            ),

                                            SizedBox(
                                                height:
                                                    4),

                                            Text(
                                              '09/24',

                                              style:
                                                  TextStyle(
                                                color:
                                                    Colors
                                                        .white,
                                                fontWeight:
                                                    FontWeight
                                                        .bold,
                                                fontSize:
                                                    13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              /// QR
                              Container(
                                height: 68,
                                width: 68,

                                padding:
                                    const EdgeInsets.all(5),

                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(
                                          16),
                                ),

                                child: const Icon(
                                  Icons.qr_code_2,
                                  color: Colors.black,
                                  size: 48,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            /// =========================
/// BACK SIDE CARD
/// =========================
Container(
  width: double.infinity,
  height: 290,

  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(24),

    border: Border.all(
      color: goldPrimaryColor.withOpacity(0.12),
      width: 1,
    ),

    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF0E0E0E),
        Color(0xFF151515),
        Color(0xFF1C1407),
      ],
    ),

    boxShadow: [
      BoxShadow(
        color: goldPrimaryColor.withOpacity(0.10),
        blurRadius: 24,
        offset: const Offset(0, 12),
      ),
      const BoxShadow(
        color: Colors.black54,
        blurRadius: 18,
        offset: Offset(0, 8),
      ),
    ],
  ),

  child: ClipRRect(
    borderRadius: BorderRadius.circular(24),

    child: Padding(
      padding: const EdgeInsets.all(14),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          /// BLACK STRIP
          // Container(
          //   height: 28,
          //   // width: double.infinity,
          //   width: 220,

          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(10),
          //     color: Colors.white,
          //   ),
          // ),

          // const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,

              child: Container(
                height: 36,
                width: 100,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
              ),
            ),

          const SizedBox(height: 4),

          Align(
            alignment: Alignment.centerRight,

            child: Text(
              'CARD HOLDER SIGNATURE',

              style: TextStyle(
                color:
                    Colors.white.withOpacity(0.55),

                fontSize: 7,
                letterSpacing: 1,
              ),
            ),
          ),

          const SizedBox(height: 10),

          /// COMPANY NAME
          const Center(
            child: Column(
              children: [

                Text(
                  'ECHOSPHERE',

                  style: TextStyle(
                    color: goldPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  'MULTI SERVICES PVT. LTD.',

                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 8,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// CONTACT INFO
          Center(
            child: Column(
              children: [

                const Text(
                  '8208251866 / 9272031602',

                  style: TextStyle(
                    color: goldPrimaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'www.echonsk.in',

                  style: TextStyle(
                    color:
                        Colors.white.withOpacity(0.78),

                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// ADDRESS
          Container(
            width: double.infinity,

            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),

            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(10),

              color:
                  Colors.white.withOpacity(0.03),
            ),

                      child: Text(
              'To avail discount info., Kindly Call on 8208251866 / 9272031602 or Mail us at echospherensk2024@gmail.com\nWeb - www.echonsk.in',

              textAlign: TextAlign.center,

              maxLines: 3,

              overflow: TextOverflow.visible,

              style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                fontSize: 8,
                height: 1.3,
              ),
            ),
            
          ),

          const SizedBox(height: 8),

          Container(
            width: double.infinity,

            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),

            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(10),

              color:
                  Colors.white.withOpacity(0.03),
            ),

            child: Text(
              'Flat No.09, Narayan Deep Housing Society, Anand Nagar, Deolali, Nashik - 422401',

              textAlign: TextAlign.center,

              maxLines: 2,

              overflow: TextOverflow.ellipsis,

              style: TextStyle(
                color:
                    Colors.white.withOpacity(0.75),

                fontSize: 8,
                height: 1.3,
              ),
            ),
          ),

          const SizedBox(height: 8),

          /// POWERED BY
          Center(
            child: Text(
              'Powered By Echosphere',

              style: TextStyle(
                color:
                    Colors.white.withOpacity(0.55),

                fontSize: 8,
                fontStyle: FontStyle.italic,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    ),
  ),
),
          ],
        ),
      ),
    );
  }
}
