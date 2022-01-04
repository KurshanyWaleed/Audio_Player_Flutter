import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class ListOfAudios extends StatelessWidget {
  List<SongInfo>? songs;

  ListOfAudios({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          height: 700,
          width: 700,
          child: FutureBuilder(
            future:
                FlutterAudioQuery().getSongs(sortType: SongSortType.DEFAULT),
            builder: (context, AsyncSnapshot<List<SongInfo>>? snapshot) {
              if (snapshot!.hasError) {
                return Container(
                    height: 72, width: 100, child: const Text("Loading..."));
              }

              if (snapshot.hasData) songs = snapshot.data;
              return Flexible(child: _buildListerView(context, songs));
            },
          ),
        ));
  }

  ListView _buildListerView(BuildContext context, List<SongInfo>? songsToShow) {
    return ListView.builder(
        itemCount: songsToShow!.length,
        itemBuilder: (_, index) {
          return ListTile(
              minVerticalPadding: 10,
              contentPadding: const EdgeInsets.all(10),
              minLeadingWidth: 10,
              title: Column(
                children: [
                  Row(
                    children: [
                      songsToShow[index].title.length >= 10
                          ? Text(
                              '${songsToShow[index].title.substring(0, songsToShow[index].title.length >= 50 ? songsToShow[index].title.length - 50 : songsToShow[index].title.length - 10)}...')
                          : Text(songsToShow[index].title)
                    ],
                  ),
                  Row(
                    children: const [Text("the"), Text(" title 2")],
                  )
                ],
              ),
              onTap: () {});
        });
  }
}
