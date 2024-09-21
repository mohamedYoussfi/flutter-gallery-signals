import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:signal_posts/store/store.dart';
import 'package:signals/signals_flutter.dart';

class GalleryPage extends StatelessWidget {
  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Watch(
          (context) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "Gallery : Page ${store.state.value.currentPage} / ${store.state.value.totalPages}"),
              (store.state.value.status == Status.loading)
                  ? CircularProgressIndicator()
                  : Container()
            ],
          ),
        ),
      ),
      body: Center(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        hintText: "Keyword",
                      ),
                      controller: textEditingController,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    store.newSearch(textEditingController.text);
                  },
                  icon: const Icon(Icons.search),
                )
              ],
            ),
          ),
          Watch.builder(
            builder: (context) {
              return Expanded(
                child: LazyLoadScrollView(
                  onEndOfPage: () {
                    store.nexPage();
                    scrollController
                        .jumpTo(scrollController.position.maxScrollExtent);
                  },
                  child: ListView.separated(
                    controller: scrollController,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(4),
                        margin: const EdgeInsets.all(4),
                        child: Card(
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                child: Center(
                                  child: Text(
                                      "${store.state.value.imageData.hits[index].tags?.toUpperCase()}"),
                                ),
                              ),
                              Card(
                                child: Image.network(
                                    "${store.state.value.imageData.hits[index].webformatURL}"),
                              ),
                              Card(
                                child: Row(
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(Icons.visibility),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                              "${store.state.value.imageData.hits[index].views}")
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(Icons.download),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                              "${store.state.value.imageData.hits[index].downloads}")
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(Icons.comment),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                              "${store.state.value.imageData.hits[index].comments}")
                                        ],
                                      ),
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.end,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: store.state.value.imageData.hits.length,
                  ),
                ),
              );
            },
          )
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Fav",
            icon: Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(
            label: "Setting",
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
