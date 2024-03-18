import 'package:flutter/material.dart';

class gezdirSayfam extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<gezdirSayfam> {
  String searchQuery = '';
  bool sortByDiscount = false;
  bool sortByExpiryDate = false;
  bool showAllItemsButton = false;

  List<WalletItem> walletItems = [
    WalletItem(
      title: 'Edirne Tava Ciğer',
      discount: 30,
      expiryDate: DateTime(2024, 3, 28),
    ),
    WalletItem(
      title: 'Kent Müzesi',
      discount: 50,
      expiryDate: DateTime(2024, 3, 30),
    ),
    WalletItem(
      title: 'Aile Çay Bahçesi',
      discount: 10,
      expiryDate: DateTime(2024, 4, 1),
    ),
    WalletItem(
      title: 'Tekirdağ Köftecisi',
      discount: 17,
      expiryDate: DateTime(2024, 6, 1),
    ),
    WalletItem(
      title: 'Tepe Restaurant',
      discount: 10,
      expiryDate: DateTime(2024, 6, 15),
    ),
    WalletItem(
      title: 'Merkez Butik',
      discount: 50,
      expiryDate: DateTime(2024, 4, 30),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<WalletItem> sortedItems = List.from(walletItems);

    if (sortByDiscount) {
      sortedItems.sort((a, b) => b.discount.compareTo(a.discount));
    } else if (sortByExpiryDate) {
      sortedItems.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: searchQuery.isEmpty,
        backgroundColor: Color(0xFF50C4ED),
        title: Text(
          'Gezdir Cüzdanım',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Color(0xFF333A73),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            color: Color(0xFF333A73),
            onPressed: () async {
              final String? selected = await showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
              if (selected != null && selected.isNotEmpty) {
                setState(() {
                  searchQuery = selected;
                  showAllItemsButton = true;
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            color: Color(0xFF333A73),
            onPressed: () async {
              final String? selected = await showMenu(
                context: context,
                position: RelativeRect.fromLTRB(100, 50, 0, 100),
                items: [
                  PopupMenuItem(
                    value: 'discount',
                    child: Text('Yüzdeye göre sırala'),
                  ),
                  PopupMenuItem(
                    value: 'expiry',
                    child: Text('Son geçerlilik tarihine göre sırala'),
                  ),
                ],
              );
              if (selected != null) {
                setState(() {
                  sortByDiscount = selected == 'discount';
                  sortByExpiryDate = selected == 'expiry';
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          if (showAllItemsButton)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  searchQuery = '';
                  showAllItemsButton = false;
                });
              },
              child: Text(
                'Tüm İndirimleri Göster',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: sortedItems
                  .where((item) =>
                  item.title.toLowerCase().contains(searchQuery.toLowerCase()))
                  .map(
                    (item) => Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: WalletItem(
                    title: item.title,
                    discount: item.discount,
                    expiryDate: item.expiryDate,
                  ),
                ),
              )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class WalletItem extends StatelessWidget {
  final String title;
  final int discount;
  final DateTime expiryDate;

  const WalletItem({
    Key? key,
    required this.title,
    required this.discount,
    required this.expiryDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: Color(0xFFFBA834),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '%$discount İndirimli',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Color(0xFF333A73),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Geçerlilik Tarihi: ${expiryDate.day}.${expiryDate.month}.${expiryDate.year}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  @override
  String? get searchFieldLabel => null;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text('Arama sonuçları: $query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestions = [
      'Edirne Tava Ciğer',
      'Kent Müzesi',
      'Aile Çay Bahçesi',
      'Tekirdağ Köftecisi',
      'Tepe Restaurant',
      'Merkez Butik',
    ];

    final List<String> filteredSuggestions = suggestions
        .where((suggestion) =>
        suggestion.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredSuggestions.length,
      itemBuilder: (context, index) {
        final suggestion = filteredSuggestions[index];
        return ListTile(
          title: Text(suggestion),
          onTap: () {
            close(context, suggestion);
          },
        );
      },
    );
  }
}
