import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../model/channelInfo_model.dart';
import '../../model/videos_list.dart';
import '../../services/api_service.dart';
import '../video_players_screen.dart';

class VideoTab extends StatefulWidget {
  const VideoTab({Key? key}) : super(key: key);

  @override
  State<VideoTab> createState() => _VideoTabState();
}

class _VideoTabState extends State<VideoTab> {
  ChannelInfo? _channelInfo;
  Item? _item;
  bool _loading = false;
  String _playListId = '';
  String _nextPageToken = '';
  VideosList? _videosList;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getChannelInfo();
    //_buildInfoView();
    _scrollController = ScrollController();
    // _videosList = VideosList(kind: '', etag: '', videos: [], pageInfo: PageInfo());
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
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // _buildInfoView(),
          Expanded(
              child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollNotification) {
              if (_videosList!.videos.length >=
                  int.parse(_item!.statistics.videoCount)) {
                return true;
              }

              if (scrollNotification.metrics.pixels ==
                  scrollNotification.metrics.maxScrollExtent) {
                _loadVideos();
              }
              return true;
            },
            child: _videosList?.videos != null
                ? ListView.builder(
                    controller: _scrollController,
                    itemCount: _videosList?.videos.length,
                    itemBuilder: (context, index) {
                      VideoItem videoItem =
                          _videosList?.videos[index] as dynamic;
                      return InkWell(
                        onTap: () async {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return VideoPlayerScreen(
                                videoItem: videoItem,
                              );
                            },
                          ));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  videoItem.video.thumbnails
                                              .thumbnailsDefault !=
                                          null
                                      ? CachedNetworkImage(
                                          imageUrl: videoItem.video.thumbnails
                                              .thumbnailsDefault.url,
                                        )
                                      : const SizedBox(),
                                  const SizedBox(width: 20),
                                  Flexible(child: Text(videoItem.video.title)),
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    'Published Date: ${videoItem.video.publishedAt}'),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox(),
          )),
        ],
      ),
    );
  }

  _buildInfoView() {
    return _loading == false
        ? const CircularProgressIndicator()
        : Container(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
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
                    Text(_item?.statistics.videoCount != null
                        ? _item?.statistics.videoCount as dynamic
                        : ''),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
            ),
          );
  }
}
