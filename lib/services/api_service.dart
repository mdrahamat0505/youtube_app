import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../model/channelInfo_model.dart';
import '../model/paly_lsit.dart';
import '../model/videos_list.dart';
import '../utilitis/constants.dart';

class ApiServices {
  static const CHANNEL_ID = 'UCqeY2XaXTOcfN6XtxpiM_Fg';
  static const _baseUrl = 'www.googleapis.com';

  /*
  *
  * curl \
  'https://youtube.googleapis.com/youtube/v3/channels?key=[YOUR_API_KEY]' \
  --header 'Authorization: Bearer [YOUR_ACCESS_TOKEN]' \
  --header 'Accept: application/json' \
  --compressed
  *
  *
  * */

  // static const CHANNEL_ID = 'UC5lbdURzjB0irr-FTbjWN1A';
  // static const _baseUrl = 'www.googleapis.com';

  static Future<ChannelInfo> getChannelInfo() async {
    Map<String, String> parameters = {
      'part': 'snippet,contentDetails,statistics',
      'id': CHANNEL_ID,
      'key': API_KEY2,
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/channels',
      parameters,
    );
    Response response = await http.get(uri, headers: headers);
    log(response.body);
    ChannelInfo channelInfo = channelInfoFromJson(response.body);
    return channelInfo;
  }

  static Future<VideosList> getVideosList(
      {required String playListId, required String pageToken}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playListId,
      'maxResults': '5',
      'pageToken': pageToken,
      'key': API_KEY2,
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    Response response = await http.get(uri, headers: headers);
    log(response.body);
    VideosList videosList = videosListFromJson(response.body);
    return videosList;
  }

  static Future<PalyList> getPalyList(
      {required String channelId, required String pageToken}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'channelId': CHANNEL_ID,
      'maxResults': '1',
      'pageToken': pageToken,
      // 'access_token': access_token,
      'key': API_KEY2,
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlists',
      parameters,
    );
    Response response = await http.get(uri, headers: headers);
    log(response.body);
    PalyList palyList = palyListFromJson(response.body);
    return palyList;
  }

  /*
  * curl \
curl \
  'https://youtube.googleapis.com/youtube/v3/playlists?part=snippet&channelId=UCqeY2XaXTOcfN6XtxpiM_Fg&maxResults=2&access_token=AIzaSyCMKU0ZqclhHJG4PU-78zoEzMzYOjwDxZ8&key=[YOUR_API_KEY]' \
  --header 'Authorization: Bearer [YOUR_ACCESS_TOKEN]' \
  --header 'Accept: application/json' \
  --compressed

  *
  *
GET https://youtube.googleapis.com/youtube/v3/playlists?part=snippet&channelId=UCqeY2XaXTOcfN6XtxpiM_Fg&maxResults=2&access_token=AIzaSyCMKU0ZqclhHJG4PU-78zoEzMzYOjwDxZ8&key=[YOUR_API_KEY] HTTP/1.1

Authorization: Bearer [YOUR_ACCESS_TOKEN]
Accept: application/json
n
  * */
}
