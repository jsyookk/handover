import 'package:flutter/material.dart';
import 'package:handover/constants.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';
import 'package:handover/controllers/history_controller.dart';
import 'package:handover/model/game_list.dart';
import 'package:handover/widget/card_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GridViewScreen extends StatefulWidget {

  @override
  _GridViewScreenState createState() => _GridViewScreenState();
}

class _GridViewScreenState extends State<GridViewScreen> {
  final HistoryController histroyCtrl = Get.find();
  final _id = Get.parameters['id'];
  final _nickname = Get.parameters['nickname'];
  int _LoadingCnt = 0;

  RefreshController _mineRefreshController =
  RefreshController(initialRefresh: true);

  void _onMineRefresh() async {

    setState(() {
      histroyCtrl.myListLoading = true;
    });

    await histroyCtrl.fetchMakeChainList(id : _id);
    await histroyCtrl.fetchMyListRefreshAddJoinList(id : _id);

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

      //내가 만든 게임 + 내가 참여한 게임
      _LoadingCnt++ % 2 == 0 ? await histroyCtrl.fetchAddMakeChainList(id : _id) : await histroyCtrl.fetchMyListAddJoinList(id : _id);

      setState(() {
        histroyCtrl.myListLoading = false;
      });
    }
    _mineRefreshController.loadComplete();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
    child: AppBar(
    elevation: 0,
    iconTheme: IconThemeData(
    color:Colors.black
    ),
    backgroundColor: backgroundColour,
    title: Text('$_nickname 님의 보관함', style: kAppbarTextStyle),
    ),
    ),
    body: SafeArea(
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Expanded(
                  flex: 1,
                      child: GroupButton(
                          unselectedTextStyle: kCategoryButtonTextStyle,
                          selectedTextStyle: kCategoryButtonTextStyle,
                          unselectedColor: inactiveButtonColour,
                          selectedColor: activeButtonColour,
                          borderRadius: BorderRadius.circular(20.0),
                          spacing: 4,
                          isRadio: true,
                          direction: Axis.horizontal,
                          buttons: ['최신순' , '좋아요순'],
                          onSelected: (index , isSelected)=> print('$index button is selected')
                      ),
                    ),
              SizedBox(
                height: 15
              ),
              Obx(() {
                return Expanded(
                  flex: 13,
                  child: SmartRefresher(
                      scrollDirection: Axis.vertical,
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
                          ? StaggeredGridView.countBuilder(
                            crossAxisCount: 4,
                            itemCount: histroyCtrl.mylist.length,
                            mainAxisSpacing: 4.0,
                            crossAxisSpacing: 4.0,
                            itemBuilder: (BuildContext context, int index) =>
                                GestureDetector(
                                  child: CardView(
                                    title: histroyCtrl.mylist[index].gameInfo
                                        .keyword,
                                    imageUrl: histroyCtrl.mylist[index]
                                        .finishedUsers.first.imgUrl,
                                    onTap: () => Get.toNamed(
                                        '/history/multiImg',
                                        arguments: histroyCtrl.mylist[index]),
                                    likeCnt: 10,
                                    funnyCnt: 12,
                                    declarationCnt:3,
                                  ),
                                ),
                            staggeredTileBuilder: (int index) =>
                                StaggeredTile.count(2, 2),
                          ) : Container(
                                child: Center(child: Text('아직 완료한 게임이 없습니다.')),
                              )),
                );
              })],
            ),
          ),
        ),
      ),
    );
  }
}

