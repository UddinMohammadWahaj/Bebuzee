import 'dart:async';
import 'dart:io';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/models/profile_feed_model.dart';
import 'package:bizbultest/models/profile_posts_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/widgets/Newsfeeds/feed_footer.dart';
import 'package:bizbultest/widgets/Newsfeeds/feed_header.dart';
import 'package:bizbultest/widgets/profile_feed_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'dart:convert';

import '../../api/ApiRepo.dart' as ApiRepo;
import '../api/api.dart';
import '../models/boost_post_slider_model.dart';
import '../widgets/boosted_post_slider_card.dart';
import 'Discover/discover_people_from_tags.dart';

class ProfileSponsorPage extends StatefulWidget {
  final String? logo;
  final NewsFeedModel? post;
  final String? memberID;
  final String? country;
  final String? currentMemberImage;
  final bool? isMemberLoaded;
  final String? postID;
  final String? listOfPostID;
  final String? otherMemberID;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;
  final Function? refresh;
  String? from;

  ProfileSponsorPage(
      {Key? key,
      this.logo,
      this.memberID,
      this.country,
      this.currentMemberImage,
      this.isMemberLoaded,
      this.postID,
      this.listOfPostID,
      this.post,
      this.otherMemberID,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar,
      this.from = '',
      this.refresh})
      : super(key: key);

  @override
  _ProfileSponsorPageState createState() => _ProfileSponsorPageState();
}

class _ProfileSponsorPageState extends State<ProfileSponsorPage> {
  late AllFeeds feedsList;
  late bool isFeedLoaded;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var currentId;
  Future<BoostPosts?> getBoostedSlider(
      String postID, String postType, String memberID) async {
    var newurl =
        'https://www.bebuzee.com/api/prmoted_slider_data.php?action=prmoted_slider_data?action=prmoted_slider_data&post_type=$postType&post_id=$postID&user_id=$memberID';
    print("called boost =$newurl");
    var client = Dio();
    var response = await ApiProvider().fireApi(newurl).then((v) => v);

    // await client.postUri(newurl).then((v) => v);

    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=prmoted_slider_data?action=prmoted_slider_data&post_type=$postType&post_id=$postID&user_id=$memberID");

    // var response = await http.get(url);
    print("boost post slider response ${response!.data}");
    if (response!.statusCode == 200) {
      BoostPosts boostData = BoostPosts.fromJson(response!.data['data']);

      return boostData;
    } else {
      return null;
    }
  }

  Future<void> getProfileFeeds() async {
    // var url = Uri.parse(
    // "https://www.bebuzee.com/new_files/all_apis/member_profile_api_call.php");

    // final response = await http.post(url, body: {
    //   "user_id": CurrentUser().currentUser.memberID,
    //   "current_user_id": currentId,
    //   "post_ids": "",
    //   "action": "profile_feed_data",
    //   "country": CurrentUser().currentUser.country,
    //   "post_id": widget.postID,
    //   "all_post_ids": widget.listOfPostID,
    // });

    var response = await ApiRepo.postWithToken("api/member_sponsor_data.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "current_user_id": currentId,
      "post_ids": "",
      "country": CurrentUser().currentUser.country,
      "post_id": widget.postID,
      "all_post_ids": widget.listOfPostID,
    });

    if (response!.success == 1) {
      AllFeeds feedData = AllFeeds.fromJson(response!.data['data']);
      if (mounted) {
        setState(() {
          // if (widget.from == "advert") {
          //   feedData.feeds = feedData.feeds
          //       .where((element) => element.boostData == 1)
          //       .toList();
          //   feedsList = feedData;
          // } else {
          feedsList = feedData;
          // }
          isFeedLoaded = true;
          print("response true profile");
          print(feedData.feeds[0].postId);
          print(feedData.feeds[0].postType);
        });
      }
    }
    if (response!.success != 1 || response!.data['data'] == null) {
      print("no response");
      setState(() {
        isFeedLoaded = false;
      });
    }
  }

  void _onLoading() async {
    int len = feedsList.feeds.length;
    String urlStr = "";
    for (int i = 0; i < len; i++) {
      urlStr += feedsList.feeds[i].postId!;
      if (i != len - 1) {
        urlStr += ",";
      }
    }
    try {
      // var url = Uri.parse(
      //     "https://www.bebuzee.com/new_files/all_apis/member_profile_api_call.php");

      // final response = await http.post(url, body: {
      //   "user_id": CurrentUser().currentUser.memberID,
      //   "current_user_id": currentId,
      //   "post_ids": urlStr,
      //   "action": "profile_feed_data",
      //   "country": CurrentUser().currentUser.country,
      //   "post_id": widget.postID,
      //   "all_post_ids": widget.listOfPostID,
      // });
      print(
          "loading sponsor :- api/member_sponsor_data.php?user_id=${CurrentUser().currentUser.memberID}&all_post_ids=${urlStr}");
      var response =
          await ApiRepo.postWithToken("api/member_sponsor_data.php", {
        "user_id": CurrentUser().currentUser.memberID,
        "current_user_id": currentId,
        "post_ids": urlStr,
        "country": CurrentUser().currentUser.country,
        "post_id": widget.postID,
        "all_post_ids": urlStr,
      });
      if (response!.success == 1) {
        AllFeeds feedData = AllFeeds.fromJson(response!.data['data']);
        AllFeeds feedsTemp = feedsList;
        feedsTemp.feeds.addAll(feedData.feeds);
        if (mounted) {
          setState(() {
            feedsList = feedsTemp;
          });
        }
      }
    } on SocketException catch (e) {
      Fluttertoast.showToast(
        msg: "Couldn't refresh feed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15.0,
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          _refreshController.loadFailed();
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
          });

          return Container();
        },
      );
    }
    _refreshController.loadComplete();
  }

  bool delete = false;

  void _onRefresh() async {
    getProfileFeeds();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    if (widget.otherMemberID != null) {
      currentId = widget.otherMemberID;
    } else {
      currentId = CurrentUser().currentUser.memberID;
    }

    // print(widget.postID + " in feeeeeeedsss");

    getProfileFeeds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        backgroundColor: Colors.white,
        body: WillPopScope(
          // ignore: missing_return
          onWillPop: () async {
            print("back");
            Navigator.pop(context);
            widget.refresh!();
            return true;
          },
          child: Container(
            margin: EdgeInsets.only(top: 1.0.h),
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: CustomHeader(
                builder: (context, mode) {
                  return Container(
                    child: Center(child: loadingAnimation()),
                  );
                },
              ),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus? mode) {
                  Widget body;

                  if (mode == LoadStatus.idle) {
                    body = Text("");
                  } else if (mode == LoadStatus.loading) {
                    body = loadingAnimation();
                  } else if (mode == LoadStatus.failed) {
                    body = Container(
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              new Border.all(color: Colors.black, width: 0.7),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(CustomIcons.reload),
                        ));
                  } else if (mode == LoadStatus.canLoading) {
                    body = Text("");
                  } else {
                    body = Text(
                      AppLocalizations.of(
                        "No more Data",
                      ),
                    );
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              controller: _refreshController,
              onLoading: _onLoading,
              onRefresh: _onRefresh,
              child: ListView.builder(
                  itemCount:
                      isFeedLoaded == true ? feedsList.feeds.length + 1 : 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      if (widget.from == "advert") return Container();
                      return Padding(
                        padding: EdgeInsets.only(bottom: 2.5.h),
                        child: !delete
                            ? Column(
                                children: [
                                  FeedHeader(
                                    refresh: () {
                                      if (index == 0) {
                                        setState(() {
                                          delete = true;
                                        });
                                      }
                                    },
                                    setNavBar: widget.setNavBar,
                                    isChannelOpen: widget.isChannelOpen,
                                    changeColor: widget.changeColor,
                                    feed: widget.post,
                                    sKey: _scaffoldKey,
                                  ),
                                  FeedFooter(
                                    stickerList: widget.post!.stickers,
                                    positionList: widget.post!.position,
                                    setNavBar: widget.setNavBar,
                                    isChannelOpen: widget.isChannelOpen,
                                    changeColor: widget.changeColor,
                                    sKey: _scaffoldKey,
                                    feed: widget.post,
                                    onPressMatchText: (value) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DiscoverPageFromTags(
                                              memberID: widget.memberID,
                                              logo: widget.logo,
                                              country: widget.country,
                                              tag:
                                                  value.toString().substring(1),
                                              currentMemberImage: CurrentUser()
                                                  .currentUser
                                                  .memberID,
                                            ),
                                          ));
                                    },
                                  ),
                                ],
                              )
                            : Container(),
                      );
                    } else if (isFeedLoaded == false) {
                      return Container(
                        child: loadingAnimation(),
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 2.5.h),
                        child: Column(
                          children: [
                            FeedHeader(
                              setNavBar: widget.setNavBar,
                              isChannelOpen: widget.isChannelOpen,
                              changeColor: widget.changeColor,
                              feed: feedsList.feeds[index - 1],
                              sKey: _scaffoldKey,
                              refresh: () {
                                Timer(Duration(seconds: 2), () {
                                  getProfileFeeds();
                                });
                              },
                            ),
                            FeedFooter(
                              stickerList: feedsList.feeds[index - 1].stickers,
                              positionList: feedsList.feeds[index - 1].position,
                              setNavBar: widget.setNavBar,
                              isChannelOpen: widget.isChannelOpen,
                              changeColor: widget.changeColor,
                              sKey: _scaffoldKey,
                              feed: feedsList.feeds[index - 1],
                              onPressMatchText: (value) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DiscoverPageFromTags(
                                        memberID: widget.memberID,
                                        logo: widget.logo,
                                        country: widget.country,
                                        tag: value.toString().substring(1),
                                        currentMemberImage:
                                            CurrentUser().currentUser.memberID,
                                      ),
                                    ));
                              },
                            ),
                            feedsList.feeds[index - 1].postPromotedSlider! > 0
                                ? FutureBuilder(
                                    future: getBoostedSlider(
                                        feedsList.feeds[index - 1].postId!,
                                        feedsList.feeds[index - 1].postType,
                                        feedsList.feeds[index - 1].postUserId!),
                                    builder: (context,
                                        AsyncSnapshot<BoostPosts?> snapshot) {
                                      if (snapshot.hasData) {
                                        return Container(
                                          height: 25.0.h,
                                          child: ListView.builder(
                                            addAutomaticKeepAlives: false,
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                snapshot.data!.boosts.length,
                                            itemBuilder: (context, indexBoost) {
                                              return BoostedPostCards(
                                                memberID: widget.memberID,
                                                memberImage: CurrentUser()
                                                    .currentUser
                                                    .image,
                                                country: widget.country,
                                                memberName: CurrentUser()
                                                    .currentUser
                                                    .fullName,
                                                boost: snapshot
                                                    .data!.boosts[indexBoost],
                                                feed:
                                                    feedsList.feeds[index - 1],
                                              );
                                            },
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    })
                                : Container(),
                          ],
                        ),
                      );
                    }
                  }),
            ),
          ),
        ));
  }
}
