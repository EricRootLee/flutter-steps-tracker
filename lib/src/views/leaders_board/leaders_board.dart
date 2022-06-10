import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/data/network/database_client.dart';
import '../../utils/app_urls.dart';
import '../../utils/curve.dart';
import '../../utils/string_constants_util.dart';
import '../../widgets/common/app_cards.dart';

class LeadersBoard extends StatefulWidget {
  const LeadersBoard({Key? key}) : super(key: key);

  @override
  State<LeadersBoard> createState() => _LeadersBoardState();
}

class _LeadersBoardState extends State<LeadersBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Stack(
              children: [
                CustomPaint(size: Size(50.h, 250.w), painter: CurvePainter()),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        StringConstants.leadersBoardScreenAppBarTitle,
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(fontSize: 25),
                      ),
                    ),
                    Center(
                      child: Container(
                        child:
                            Image.asset(AppUrls.leadersBoardIcon, height: 200),
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseClient().getLeadersBoard(
                            FirebaseAuth.instance.currentUser!.uid),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot,
                        ) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.connectionState ==
                                  ConnectionState.active ||
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Center(child: const Text('Oops Men'));
                            } else if (snapshot.hasData) {
                              return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.separated(
                                      itemCount: (snapshot.data?.docs.length)!,
                                      separatorBuilder: (context, _) => Divider(
                                            indent: 30,
                                            endIndent: 20,
                                          ),
                                      itemBuilder: (context, index) =>
                                          LeadersBoardCard(
                                              snapshot.data?.docs[index]
                                                  ['gender'],
                                              (snapshot
                                                  .data?.docs[index]['steps']
                                                  .toString())!,
                                              index + 1,
                                              snapshot.data?.docs[index]
                                                  ['userName'])));
                            } else {
                              return Center(child: const Text('Keep Moving'));
                            }
                          } else {
                            return Text('State: ${snapshot.connectionState}');
                          }
                        },
                      ),
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
