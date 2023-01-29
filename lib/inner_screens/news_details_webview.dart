import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:news_app/services/global_methods.dart';
import 'package:news_app/services/utils.dart';
import 'package:news_app/widgets/vertical_spacing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class newsDetailsWebView extends StatefulWidget {
  final String url;

  const newsDetailsWebView({super.key, required this.url});

  @override
  State<newsDetailsWebView> createState() => _newsDetailsWebViewState();
}

class _newsDetailsWebViewState extends State<newsDetailsWebView> {
  late WebViewController webViewController;
  double _progress = 0.0;
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context: context).getThemeTextColor;
    return WillPopScope(
      onWillPop: () async {
        if (await webViewController.canGoBack()) {
          webViewController.goBack();
          //inside browser
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () async {
                if (await webViewController.canGoBack()) {
                  webViewController.goBack();
                } else {
                  Navigator.of(context).pop();
                }
              },
              icon: Icon(Icons.arrow_back_ios)),
          iconTheme: IconThemeData(color: color),
          title: Text(
            'URL',
            style: TextStyle(color: color),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [
            IconButton(
                onPressed: () {
                  _showModalBottomSheet();
                },
                icon: Icon(Icons.more_horiz))
          ],
        ),
        body: Column(
          children: [
            LinearProgressIndicator(
              value: _progress,
              color: _progress == 1.0 ? Colors.transparent : Colors.blue,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            Expanded(
              child: WebView(
                  onProgress: ((progress) {
                    setState(() {
                      _progress = progress / 100;
                    });
                  }),
                  initialUrl: widget.url,
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showModalBottomSheet() async {
    await showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                verticalSpacing(20),
                Container(
                  height: 5,
                  width: 35,
                  decoration: BoxDecoration(color: Colors.grey),
                ),
                verticalSpacing(20),
                Text(
                  'More Options',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                verticalSpacing(20),
                Divider(
                  thickness: 2,
                ),
                verticalSpacing(20),
                ListTile(
                  onTap: () async {
                    try {
                      await Share.share(widget.url,
                          subject: 'Look what I made!');
                    } catch (error) {
                      GlobalMethods.errorDialog(
                          error: error.toString(), context: context);
                    }
                  },
                  leading: Icon(Icons.share),
                  title: Text(
                    'Share',
                  ),
                ),
                ListTile(
                  onTap: () async {
                    if (!await launchUrl(Uri.parse(widget.url))) {
                      throw 'Could not launch ${widget.url}';
                    }
                  },
                  leading: Icon(Icons.open_in_browser),
                  title: Text(
                    'Open in browser',
                  ),
                ),
                ListTile(
                  onTap: () async {
                    try {
                      await webViewController.reload();
                    } catch (error) {
                      GlobalMethods.errorDialog(
                          error: error.toString(), context: context);
                    } finally {
                      Navigator.of(context).pop();
                    }
                  },
                  leading: Icon(Icons.refresh),
                  title: Text(
                    'Refresh',
                  ),
                ),
                verticalSpacing(30),
              ],
            ),
          );
        });
  }
}
