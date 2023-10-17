import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  InAppWebViewController controller = InAppWebViewController(1, InAppWebView());
  late PullToRefreshController RefreshController;
  @override
  initState() {
    super.initState();
    final webProvider = Provider.of<WebProvider>(context, listen: false);
    RefreshController = PullToRefreshController(
      onRefresh: () {
        controller.reload();
      },
    );
    webProvider.loadBookmarks();
  }
  void loadHomePage() async{
    final webProvider = Provider.of<WebProvider>(context, listen: false);
    await controller.loadUrl(urlRequest: URLRequest(url: Uri.parse(webProvider.HomepageUri)));
    print(webProvider.HomepageUri);
  }
  TextEditingController Bookmark = TextEditingController();
  void showCurrentUrl() async {
    final webProvider = Provider.of<WebProvider>(context,listen: false);
    Uri? currentUrl = await controller.getUrl();
    String currentUrlString = currentUrl?.toString() ?? "URL not available";
    String trimStringWithEllipsis(String input, int maxLength) {
      if (input.length <= maxLength) {
        return input;
      } else {
        return input.substring(0, maxLength - 3) + '...';
      }
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Bookmark'),
          content: Container(
            height: 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: Bookmark,
                  decoration: InputDecoration(
                      label: Text('Bookmark Name')
                  ),
                ),
                SizedBox(height: 20),
                Text(trimStringWithEllipsis(currentUrlString,50))
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')
            ),
            TextButton(
                onPressed: () {
                  print(Bookmark.text);
                  webProvider.AddBookmark(Name: Bookmark.text, link: currentUrlString);
                  Navigator.pop(context);
                },
                child: Text('Save')
            )
          ],
        );
      },
    );
  }
  Widget build(BuildContext context) {
    final webProvider = Provider.of<WebProvider>(context,listen: false);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'My Browser',
          ),
          centerTitle: true,
          actions: [
            PopupMenuButton(
              surfaceTintColor: Colors.white,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                      padding: EdgeInsets.zero,
                      child: TextButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Consumer<WebProvider>(
                                builder: (context, webProvider, child) {
                                  return AlertDialog(
                                    scrollable: true,
                                    title: Text('Bookmarks'),
                                    content: Container(
                                      height: webProvider.Bookmarks.length*35+25,
                                      child: webProvider.Bookmarks.length>0?Column(
                                        children: [
                                          for(int i = 0 ; i < webProvider.Bookmarks.length ; i++)...[
                                            Expanded(
                                              child: SizedBox(
                                                height: 37,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    InkWell(
                                                        onTap: () {

                                                        },
                                                        child: Text(webProvider.Bookmarks[i].Name)
                                                    ),
                                                     InkWell(
                                                       onTap: () {
                                                         webProvider.RemoveBookmark(i);
                                                       },
                                                       child: Icon(Icons.delete_outline_rounded),
                                                     )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Divider(),
                                          ]
                                        ],
                                      ):Text('No Bookmarks')
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        label: Text('All Bookmarks'),
                        icon: Icon(Icons.bookmark),
                      )),
                  PopupMenuItem(
                    padding: EdgeInsets.zero,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Consumer<WebProvider>(
                              builder: (context, webProvider, child) {
                                return AlertDialog(
                                  title: Text('Search Engine'),
                                  content: Container(
                                    height: 225,
                                    child: Column(
                                      children: [
                                        RadioListTile(
                                          value: 'Google',
                                          groupValue: webProvider.SearchEngine,
                                          onChanged: (value) {
                                            webProvider.ChangeSerchEngine(
                                                value!);
                                          },
                                          title: Text('Google'),
                                        ),
                                        RadioListTile(
                                          value: 'Yahoo',
                                          groupValue: webProvider.SearchEngine,
                                          onChanged: (value) {
                                            print(webProvider.SearchEngine);
                                            webProvider.ChangeSerchEngine(
                                                value!);
                                          },
                                          title: Text('Yahoo'),
                                        ),
                                        RadioListTile(
                                          value: 'Bing',
                                          groupValue: webProvider.SearchEngine,
                                          onChanged: (value) {
                                            print(webProvider.SearchEngine);
                                            webProvider.ChangeSerchEngine(
                                                value!);
                                          },
                                          title: Text('Bing'),
                                        ),
                                        RadioListTile(
                                          value: 'Duck Duck Go',
                                          groupValue: webProvider.SearchEngine,
                                          onChanged: (value) {
                                            print(webProvider.SearchEngine);
                                            webProvider.ChangeSerchEngine(
                                                value!);
                                          },
                                          title: Text('Duck Duck Go'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: TextButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Consumer<WebProvider>(
                                builder: (context, webProvider, child) {
                                  return AlertDialog(
                                    title: Text('Search Engine'),
                                    content: Container(
                                      height: 225,
                                      child: Column(
                                        children: [
                                          RadioListTile(
                                            value: 'Google',
                                            groupValue: webProvider.SearchEngine,
                                            onChanged: (value) {
                                              webProvider.ChangeSerchEngine(
                                                  value!);
                                            },
                                            title: Text('Google'),
                                          ),
                                          RadioListTile(
                                            value: 'Yahoo',
                                            groupValue: webProvider.SearchEngine,
                                            onChanged: (value) {
                                              print(webProvider.SearchEngine);
                                              webProvider.ChangeSerchEngine(
                                                  value!);
                                            },
                                            title: Text('Yahoo'),
                                          ),
                                          RadioListTile(
                                            value: 'Bing',
                                            groupValue: webProvider.SearchEngine,
                                            onChanged: (value) {
                                              print(webProvider.SearchEngine);
                                              webProvider.ChangeSerchEngine(
                                                  value!);
                                            },
                                            title: Text('Bing'),
                                          ),
                                          RadioListTile(
                                            value: 'Duck Duck Go',
                                            groupValue: webProvider.SearchEngine,
                                            onChanged: (value) {
                                              print(webProvider.SearchEngine);
                                              webProvider.ChangeSerchEngine(
                                                  value!);
                                            },
                                            title: Text('Duck Duck Go'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        label: Text('Search Engine'),
                        icon: Icon(Icons.devices),
                      ),
                    ),
                  ),
                ];
              },
            )
          ],
        ),
        body: InAppWebView(
          pullToRefreshController: RefreshController,
          onWebViewCreated: (webcontroller) {
            controller = webcontroller;
          },
          onProgressChanged: (CONTROLLER, progress) {
             if(progress==100){
               RefreshController.endRefreshing();
             }
          },
          initialUrlRequest: URLRequest(url: Uri.parse(webProvider.HomepageUri)),
        ),
        bottomNavigationBar: CupertinoTabBar(iconSize: 25, items: [
          BottomNavigationBarItem(
              icon: InkWell(
                  onTap: () {
                    loadHomePage();
                    print(webProvider.HomepageUri)
                  },
                  child: Icon(
                    Icons.home_outlined,
                    color: Colors.black,
                  )),
              label: '',
              activeIcon: Icon(
                Icons.home,
                color: Colors.black,
              )),
          BottomNavigationBarItem(
              icon: InkWell(
                  onTap: () {
                    showCurrentUrl();
                  },
                  child: Icon(Icons.bookmark_add_outlined, color: Colors.black)
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: InkWell(
                  onTap: () async {
                    if (await controller.canGoBack()) {
                      controller.goBack();
                    }
                  },
                  child: Icon(Icons.arrow_back_ios, color: Colors.black)),
              label: ''),
          BottomNavigationBarItem(
              icon: InkWell(
                  onTap: () async {
                    controller.reload();
                  },
                  child: Icon(Icons.refresh, color: Colors.black)),
              label: ''),
          BottomNavigationBarItem(
              icon: InkWell(
                  onTap: () async {
                    if (await controller.canGoForward()) {
                      controller.goForward();
                    }
                  },
                  child: Icon(Icons.arrow_forward_ios_outlined,
                      color: Colors.black)),
              label: ''),
        ]
        )
    );
  }
}

class WebProvider extends ChangeNotifier {
  String HomepageUri = 'https://www.google.com';
  List<Bookmark> Bookmarks= [];
  String SearchEngine = 'Google';
  void ChangeSerchEngine(String value) {
    SearchEngine = value;
    notifyListeners();
  }
  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList('bookmarks');
    if (bookmarks != null) {
      Bookmarks = bookmarks
          .map((bookmark) {
        final parts = bookmark.split('|');
        return Bookmark(Name: parts[0], link: parts[1]);
      })
          .toList();
      notifyListeners();
    }
  }
  Future<void> saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarkStrings = Bookmarks.map((bookmark) {
      return '${bookmark.Name}|${bookmark.link}';
    }).toList();
    await prefs.setStringList('bookmarks', bookmarkStrings);
  }
  void AddBookmark({required String Name,required String link }){
    Bookmarks.add(Bookmark(Name: Name, link: link));
    saveBookmarks();
    notifyListeners();
  }
  void RemoveBookmark(int index){
    Bookmarks.removeAt(index);
    saveBookmarks();
    notifyListeners();
  }
}
class Bookmark{
  String Name = '';
  String link = '';
  Bookmark({required this.Name,required this.link});
}
