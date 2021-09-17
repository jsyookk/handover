import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:handover/constants.dart';
import 'package:handover/controllers/user_point_controller.dart';
import 'package:handover/utils/admob_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

enum ItemType{
  image,
  animation
}


typedef rewardCallback = Function(int reward);

class StoreScreen extends StatefulWidget {
  @override
  _StoreScreenState createState() => _StoreScreenState();


}

class _StoreScreenState extends State<StoreScreen> {

  var box = GetStorage();
  var userId;
  AdMobManager admob;

  final AdListener rewardListener = AdListener(
            onAdLoaded: (Ad ad) => print('Ad loaded'),
            onAdFailedToLoad: (Ad ad , LoadAdError error){
            ad.dispose();
            print('RewardAd failed to load : $error');
          },
            onAdOpened: (Ad ad) => print('RewardAd opened.'),
            onAdClosed : (Ad ad){
            ad.dispose();
            print('RewardAd closed.');
          },
            onApplicationExit: (Ad ad) => print('Left application.'),
            onRewardedAdUserEarnedReward: (RewardedAd ad , RewardItem reward){
            print(reward.type);
            print(reward.amount);

            print('Reward earned : $reward');
          }
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = box.read('userid');

    admob = AdMobManager();
    admob.init( rewardListener ,rewardListener);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: backgroundColour,
        body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Column(
              children:<Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text('my ad Point : '),
                    Container(
                      child:
                        StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('users').doc(userId.toString()).snapshots(),
                          builder : (context , AsyncSnapshot<DocumentSnapshot> snapshot){
                            if (!snapshot.hasData) return const Text('0');
                            return Text('${snapshot.data.get('ad_point')}');
                          }
                        ),
                    ),
                    InkWell(
                        onTap: () {
                          admob.showRewardAd();
                          Provider.of<UserPointController>(context , listen: false).addAdPoint(100);
                        },
                        child: Image.asset(
                            'images/ad_48_dp.png',
                            width: 48,
                            height: 48
                        )),

                  ],
                ),
                Text('그림 배경' , style: kTitleTextStyle),
                Container(
                height: 180,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('store').doc('back_img').collection('items').snapshots(),
                  builder : (context , AsyncSnapshot<QuerySnapshot> snapshot){
                    if (!snapshot.hasData) return const Text('Loading ...');
                    else if(snapshot.hasError) return const Text('Something went wrong');
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.size,
                        itemBuilder: (context , index) {
                          return ItemView(
                              document:  snapshot.data.docs[index] ,
                              onTap :(){},
                              type: ItemType.image);
                          }
                    );
                  }
                ),
              ),
                Text('보내기 임팩트' , style: kTitleTextStyle),
                Container(
                  height: 180,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('store').doc('send_impact').collection('items').snapshots(),
                      builder : (context , AsyncSnapshot<QuerySnapshot> snapshot){
                        if (!snapshot.hasData) return const Text('Loading ...');
                        else if(snapshot.hasError) return const Text('Something went wrong');
                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.size,
                            itemBuilder: (context , index) {
                              return ItemView(
                                  document:  snapshot.data.docs[index] ,
                                  onTap :(){},
                                  type: ItemType.animation);
                            }
                        );
                      }
                  ),
                ),
            ]),
          ),
        )
      )
    );


  }
}

class ItemView extends StatelessWidget {
  final ItemType type;
  final Function onTap;
  final DocumentSnapshot document;

  const ItemView({ this.document , this.onTap , this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 180,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
        ),
        clipBehavior: Clip.antiAlias,
        child: GestureDetector(
          onTap: this.onTap,
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 6,
                  child:
                      this.type == ItemType.image ?
                      Image.network(document['url'] , fit: BoxFit.fill) :
                      Lottie.network(document['url'],
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.fill
                      )),
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                      child: Center(
                        child: Text.rich(
                            TextSpan(
                                children:<TextSpan>[
                                  TextSpan(text : document['name'] ,  style: TextStyle(fontSize:15,fontWeight: FontWeight.bold)),
                                  TextSpan(text : '\n'),
                                  TextSpan(text : document['price'].toString()),
                                  TextSpan(text : ' p')
                                ])
                        ),
                      ))),
              Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                          child: Text(document['tag'] , style: TextStyle(color: Colors.white)))))
            ],
          ),
        ),
      ),
    );
  }
}

