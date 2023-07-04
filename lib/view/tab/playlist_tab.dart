import 'dart:developer';

import 'package:flutter/material.dart';

import '../../model/paly_lsit.dart';
import '../../services/api_service.dart';

class PlaylistTab extends StatefulWidget {
  const PlaylistTab({Key? key}) : super(key: key);

  @override
  State<PlaylistTab> createState() => _PlaylistTabState();
}

class _PlaylistTabState extends State<PlaylistTab> {
  bool _loading = false;
  String _playListId = '';
  String _nextPageToken = '';
  PalyList? _palyList;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadVideos();
    //_buildInfoView();
    _scrollController = ScrollController();
    // _videosList = VideosList(kind: '', etag: '', videos: [], pageInfo: PageInfo());
    _palyList?.items = [];
    _loading = true;
  }

  _loadVideos() async {
    _palyList = await ApiServices.getPalyList(
      pageToken: _nextPageToken,
      channelId: '',
    );
    try {
      _nextPageToken = _palyList!.nextPageToken;
      //_videosList?.videos = _videosList?.videos;
      //  _videosList.videos.addAll(tempVideosList.videos);
      log('videos: ${_palyList?.items.length}');
      log('_nextPageToken $_nextPageToken');
    } catch (e) {
      log('$e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Home Tab'),
    );
  }
}
