import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youtube_app/model/videos_list.dart';
import 'package:youtube_app/view/tab/about_tab.dart';
import 'package:youtube_app/view/tab/home_tab.dart';
import 'package:youtube_app/view/tab/playlist_tab.dart';
import 'package:youtube_app/view/tab/video_tab.dart';
import 'package:youtube_app/view/video_players_screen.dart';

import '../model/channelInfo_model.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ChannelInfo? _channelInfo;
  Item? _item;
  bool _loading = false;
  String _playListId = '';
  String _nextPageToken = '';
  VideosList? _videosList;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getChannelInfo();
    //  _scrollController = ScrollController();
    // _videosList = VideosList(kind: '', etag: '', videos: [], pageInfo: PageInfo());
    _buildInfoView();
    _videosList?.videos = [];
    _loading = true;
  }

  _getChannelInfo() async {
    _channelInfo = await ApiServices.getChannelInfo();
    _item = _channelInfo?.items[0];
    _playListId = _item!.contentDetails.relatedPlaylists.uploads;
    log('_playListId $_playListId');
    await _loadVideos();
    setState(() {
      _loading = true;
    });
  }

  _loadVideos() async {
    _videosList = await ApiServices.getVideosList(
      playListId: _playListId,
      pageToken: _nextPageToken,
    );
    try {
      _nextPageToken = _videosList!.nextPageToken;
      //_videosList?.videos = _videosList?.videos;
      //  _videosList.videos.addAll(tempVideosList.videos);
      log('videos: ${_videosList?.videos.length}');
      log('_nextPageToken $_nextPageToken');
    } catch (e) {
      log('$e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: _loading == false
              ? const CircularProgressIndicator()
              : Row(
                  children: [
                    _item?.snippet.thumbnails.medium.url != null
                        ? CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                              _item?.snippet.thumbnails.medium.url != null
                                  ? _item?.snippet.thumbnails.medium.url
                                      as dynamic
                                  : '',
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        _item?.snippet.title != null
                            ? _item?.snippet.title as dynamic
                            : '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    // Text(_item?.statistics.videoCount != null
                    //     ? _item?.statistics.videoCount as dynamic
                    //     : ''),
                    // const SizedBox(width: 20),
                  ],
                ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            isScrollable: true,
            physics: BouncingScrollPhysics(),
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Videos'),
              Tab(text: 'Playlists'),
              Tab(text: 'About'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HomeTab(),
            VideoTab(),
            PlaylistTab(),
            AboutTab(),
          ],
        ),
      ),
    );
  }

  _buildInfoView() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: _loading == false
              ? const CircularProgressIndicator()
              : Row(
                  children: [
                    _item?.snippet.thumbnails.medium.url != null
                        ? CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                              _item?.snippet.thumbnails.medium.url != null
                                  ? _item?.snippet.thumbnails.medium.url
                                      as dynamic
                                  : '',
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _item?.snippet.title != null
                            ? _item?.snippet.title as dynamic
                            : '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    // Text(_item?.statistics.videoCount != null
                    //     ? _item?.statistics.videoCount as dynamic
                    //     : ''),
                    // const SizedBox(width: 20),
                  ],
                ),
        ),
      ),
    );
  }
}
