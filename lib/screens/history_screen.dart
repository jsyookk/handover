
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:handover/constants.dart';
import 'package:handover/controllers/history_controller.dart';
import 'package:handover/controllers/user_auth_controller.dart';
import 'package:handover/widget/friend_category.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:handover/widget/card_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String firstTitle = '내가 만든 ';
  String firstTitle1 = '게임';

  String secondTitle = '내가 참여했던 ';
  String secondTitle1 = '게임';

  String thirdTitle = '친구들이 참여한 ';
  String thirdTitle1 = '게임';

  String _selectetdFriendUserId = '';

  final HistoryController histroyCtrl = Get.find();

  RefreshController _mineRefreshController =
      RefreshController(initialRefresh: true);
  RefreshController _joinRefreshController =
      RefreshController(initialRefresh: true);
  RefreshController _friendRefreshController =
      RefreshController(initialRefresh: false);

  void _onFriendRefresh() async {

    setState(() {
      histroyCtrl.friendListLoading = true;
    });

    await histroyCtrl.fetchFriendList(_selectetdFriendUserId);

    setState(() {
      histroyCtrl.friendListLoading = false;
    });

    _friendRefreshController.refreshCompleted();
  }

  void _onFriendLoading() async {
    if(mounted){

      setState(() {
        histroyCtrl.friendListLoading = true;
      });

      await histroyCtrl.fetchAddFriendList(_selectetdFriendUserId);

      setState(() {
        histroyCtrl.friendListLoading = false;
      });
    }
    _friendRefreshController.loadComplete();
  }

  void _onJoinRefresh() async {

    setState(() {
      histroyCtrl.joinListLoading = true;
    });

    await histroyCtrl.fetchJoinGameList();

    setState(() {
      histroyCtrl.joinListLoading = false;
    });

    _joinRefreshController.refreshCompleted();
  }

  void _onJoinLoading() async {
    if(mounted){
      setState(() {
        histroyCtrl.joinListLoading = true;
      });

      await histroyCtrl.fetchAddJoinGameList();

      setState(() {
        histroyCtrl.joinListLoading = false;
      });
    }
    _joinRefreshController.loadComplete();
  }

  void _onMineRefresh() async {

    setState(() {
      histroyCtrl.myListLoading = true;
    });

    await histroyCtrl.fetchMakeChainList();

    setState(() {
      histroyCtrl.myListLoading = false;
    });

    _mineRefreshController.refreshCompleted();
  }

  void _onMineLoading() async {
    if (mounted) {
      setState(() {
        histroyCtrl.myListLoading = true;
      });

      await histroyCtrl.fetchAddMakeChainList();

      setState(() {
        histroyCtrl.myListLoading = false;
      });
    }
    _mineRefreshController.loadComplete();
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: backgroundColour,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: backgroundColour,
              title: Text('gallery', style: kAppbarTextStyle))),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                        text: firstTitle,
                        style: kSubtitleTextStyle,
                        children: <TextSpan>[
                          TextSpan(text: firstTitle1, style: kSubtitleTextStyle)
                        ]),
                  ),
                  Container(
                    height: 300,
                    child: Obx(() {
                      return SmartRefresher(
                          scrollDirection: Axis.horizontal,
                          enablePullDown: true,
                          enablePullUp: true,
                          controller: _mineRefreshController,
                          onRefresh: _onMineRefresh,
                          onLoading: _onMineLoading,
                          header: ClassicHeader(
                            iconPos: IconPosition.top,
                            outerBuilder: (child) {
                              return Container(
                                width: 280.0,
                                child: Center(
                                  child: child,
                                ),
                              );
                            },
                          ),
                          footer: ClassicFooter(
                            iconPos: IconPosition.top,
                            outerBuilder: (child) {
                              return Container(
                                width: 280.0,
                                child: Center(
                                  child: child,
                                ),
                              );
                            },
                          ),
                          child: histroyCtrl.mylist.length > 0
                              ? ListView.builder(
                                  itemExtent: 180.0,
                                  scrollDirection: Axis.horizontal,
                                  physics: ClampingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return CardView(
                                      title: histroyCtrl.mylist[index].gameInfo.keyword,
                                      imageUrl: histroyCtrl.mylist[index]
                                          .finishedUsers.last.imgUrl,
                                      onTap: () {
                                        Get.toNamed('/history/multiImg',
                                            arguments: histroyCtrl.mylist[index]);
                                      },
                                    );
                                  },
                                  itemCount: histroyCtrl.mylist.length,
                                )
                              : Container(
                                  height: 300,
                                ));
                    }),
                  ),
                  RichText(
                    text: TextSpan(
                        text: secondTitle,
                        style: kSubtitleTextStyle,
                        children: <TextSpan>[
                          TextSpan(
                              text: secondTitle1, style: kSubtitleTextStyle)
                        ]),
                  ),
                  Container(
                    height: 300,
                    child: Obx(() {
                     return SmartRefresher(
                         scrollDirection: Axis.horizontal,
                         enablePullDown: true,
                         enablePullUp: true,
                         controller: _joinRefreshController,
                         onRefresh: _onJoinRefresh,
                         onLoading: _onJoinLoading,
                         header: ClassicHeader(
                           iconPos: IconPosition.top,
                           outerBuilder: (child) {
                             return Container(
                               width: 280.0,
                               child: Center(
                                 child: child,
                               ),
                             );
                           },
                         ),
                         footer: ClassicFooter(
                           iconPos: IconPosition.top,
                           outerBuilder: (child) {
                             return Container(
                               width: 280.0,
                               child: Center(
                                 child: child,
                               ),
                             );
                           },
                         ),
                         child: histroyCtrl.joinList.length > 0
                             ? ListView.builder(
                           itemExtent: 180.0,
                           scrollDirection: Axis.horizontal,
                           physics: ClampingScrollPhysics(),
                           itemBuilder: (context, index) {
                             return CardView(
                               title: histroyCtrl
                                   .joinList[index].gameInfo.keyword,
                               imageUrl: histroyCtrl.joinList[index]
                                   .finishedUsers.last.imgUrl,
                               onTap: () {
                                 Get.toNamed('/history/multiImg',
                                     arguments: histroyCtrl
                                         .joinList[index]);
                               },
                             );
                           },
                           itemCount: histroyCtrl.joinList.length,
                         )
                             : Container(height: 300));
                   })),
                  RichText(
                    text: TextSpan(
                        text: thirdTitle,
                        style: kSubtitleTextStyle,
                        children: <TextSpan>[
                          TextSpan(text: thirdTitle1, style: kSubtitleTextStyle)
                        ]),
                  ),
                  Container(
                    height: 100,
                    child: Consumer<UserController>(
                        builder: (context, userController, _) {
                      return userController.friends.length <= 0
                          ? Container()
                          : ListView.separated(
                              padding: const EdgeInsets.all(12.0),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return FriendCategory(
                                  nickName: userController
                                      .friends[index].profileNickname,
                                  thumbnailUrl: userController.friends[index]
                                              .profileThumbnailImage.isBlank ==
                                          null
                                      ? 'https://imgur.com/I80W1Q0.png'
                                      : userController
                                          .friends[index].profileThumbnailImage
                                          .toString(),
                                  onTap: () {
                                    print(
                                        'friend id : ${userController.friends[index].id}');
                                    _selectetdFriendUserId = userController
                                        .friends[index].id
                                        .toString();
                                    _onFriendRefresh();
                                    //loadFriendData(userController.friends[index].id.toString());
                                  },
                                );
                              },
                              itemCount: userController.friends.length,
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: 20,
                                );
                              },
                            );
                    }),
                  ),
                  Container(
                    height: 300,
                    child: Obx((){
                      return SmartRefresher(
                          scrollDirection: Axis.horizontal,
                          enablePullDown: true,
                          enablePullUp: true,
                          controller: _friendRefreshController,
                          onRefresh: _onFriendRefresh,
                          onLoading: _onFriendLoading,
                          header: ClassicHeader(
                          iconPos: IconPosition.top,
                          outerBuilder: (child) {
                        return Container(
                          width: 280.0,
                          child: Center(
                            child: child,
                          ),
                        );
                      },
                      ),
                      footer: ClassicFooter(
                      iconPos: IconPosition.top,
                      outerBuilder: (child) {
                      return Container(
                      width: 280.0,
                      child: Center(
                      child: child,
                      ),
                      );
                      },
                      ),
                      child: histroyCtrl.friendList.length > 0
                              ? ListView.builder(
                                  itemExtent: 180.0,
                                  scrollDirection: Axis.horizontal,
                                  physics: ClampingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return CardView(
                                      title: histroyCtrl
                                          .friendList[index].gameInfo.keyword,
                                      imageUrl: histroyCtrl
                                          .friendList[index]
                                          .finishedUsers
                                          .last
                                          .imgUrl,
                                      onTap: () {
                                        Get.toNamed('/history/multiImg',
                                            arguments: histroyCtrl
                                                .friendList[index]);
                                      },
                                    );
                                  },
                                  itemCount: histroyCtrl.friendList.length,
                                )
                              : Container(
                                  height: 300,
                                ));
                    })),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
