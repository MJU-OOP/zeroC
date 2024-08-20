import 'package:flutter/material.dart';
import 'package:zero_c/controller/Crank.dart';
import 'package:zero_c/feed/feed_screen.dart';

class RankScreen extends StatefulWidget {
  @override
  _RankScreenState createState() => _RankScreenState();
}

class _RankScreenState extends State<RankScreen> {
  List<MapEntry<String, int>> sortedSchoolRankings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSchoolRankings();
  }

  Future<void> _loadSchoolRankings() async {
    final rankController = RankController();
    Map<String, int> rankings = await rankController.getSchoolRankings();

    // rankings를 postCount 내림차순으로 정렬
    setState(() {
      sortedSchoolRankings = rankings.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      isLoading = false;
    });

    print("Sorted school rankings: $sortedSchoolRankings"); // 랭킹 데이터 출력
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이번주 챌린지: 텀블러 사용'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      '순위',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: sortedSchoolRankings.length,
                    itemBuilder: (context, index) {
                      String schoolName = sortedSchoolRankings[index].key;
                      int postCount = sortedSchoolRankings[index].value;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FeedScreen(
                                schoolId: 'mju',
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey[300]!, width: 1),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${index + 1}위 $schoolName',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '탄소 절약 게시글 수 : $postCount 개',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
