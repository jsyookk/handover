
import 'package:flutter/material.dart';

class CardView extends StatelessWidget {
  final String imageUrl;
  final String title;
  final Function onTap;
  final int likeCnt;
  final int funnyCnt;
  final int declarationCnt;

  const CardView({this.title , this.imageUrl , this.onTap , this.likeCnt , this.funnyCnt , this.declarationCnt});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550,
      child: Column(
        children: [
          Expanded(
            flex: 8,
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
                        flex: 8,
                        child: Image.network(imageUrl)),
                    Divider(),
                    Expanded(
                        flex: 2,
                        child: Text(title , style: TextStyle(fontSize: 18),)),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                                children: [
                                  Icon(Icons.send , size : 15),
                                  Text('$likeCnt' , style: TextStyle(fontSize: 13),)
                                ]),
                            SizedBox(
                              width: 3.0,
                            ),
                            Row(
                                children: [
                                  Icon(Icons.whatshot_rounded , size : 15),
                                  Text('$funnyCnt', style: TextStyle(fontSize: 13),)
                                ]),
                            SizedBox(
                              width: 3.0,
                            ),
                            Row(
                                children: [
                                  Icon(Icons.wb_sunny , size: 15,),
                                  Text('$declarationCnt' , style: TextStyle(fontSize: 13),)
                                ]),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
      ]),
    );
  }
}