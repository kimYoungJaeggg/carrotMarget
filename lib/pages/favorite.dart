import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/detail.dart';
import 'package:flutter_application_1/repository/contents_repository.dart';
import 'package:flutter_application_1/utils/data_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyFavoriteContents extends StatefulWidget {
  MyFavoriteContents({Key? key}) : super(key: key);

  @override
  _MyFavoriteContentsState createState() => _MyFavoriteContentsState();
}

class _MyFavoriteContentsState extends State<MyFavoriteContents> {
  ContentsRepository contentsRepository = ContentsRepository();
  PreferredSizeWidget _appBarWidget() {
    return AppBar(
        title: Text(
      "관심목록",
      style: TextStyle(fontSize: 15),
    ));
  }

  Widget _bodyWidget() {
    return FutureBuilder(
        future: _loadMyFavoriteContentsList(),
        builder: (BuildContext context, dynamic snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("데이터 오류"));
          }
          if (snapshot.hasData) {
            return _makeDataList(snapshot.data);
          }

          return Center(child: Text("데이터없음"));
        });
  }

  Future<List<dynamic>?> _loadMyFavoriteContentsList() async {
    return await contentsRepository.loadFavoriteContents();
  }

  _makeDataList(List<dynamic> datas) {
    return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (BuildContext _context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return DetailContentView(data: datas[index]);
              }));
            },
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Hero(
                          tag: datas[index]["cid"].toString(),
                          child: Image.asset(
                            datas[index]["image"].toString(),
                            width: 100,
                            height: 100,
                          ),
                        )),
                    Expanded(
                      child: Container(
                        height: 100,
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              datas[index]["title"].toString(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 5),
                            Text(
                              datas[index]["location"].toString(),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black.withOpacity(0.3)),
                            ),
                            SizedBox(height: 5),
                            Text(
                              DataUtils.calcStringToWon(
                                  datas[index]["price"].toString()),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/heart_off.svg",
                                    width: 13,
                                    height: 13,
                                  ),
                                  SizedBox(width: 5),
                                  Text(datas[index]["likes"].toString()),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )),
          );
        },
        separatorBuilder: (BuildContext _context, int index) {
          return Container(height: 1, color: Colors.black.withOpacity(0.4));
        },
        itemCount: datas.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarWidget(),
      body: _bodyWidget(),
    );
  }
}
