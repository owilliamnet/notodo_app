import 'package:flutter/material.dart';
import 'package:notodo_app/Util/database_client.dart';
import '../Model/nodo_item.dart';

class NoTodoScreen extends StatefulWidget {
  _NoTodoScreenState createState() => _NoTodoScreenState();
}

class _NoTodoScreenState extends State<NoTodoScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  var db = DataBaseHelper();
  final List<NoDoItem> _itemList = <NoDoItem>[];

  @override
  void initState() {
    super.initState();
    _readNoDoList();
  }

  void _handleSubmitted(String text) async {
    _textEditingController.clear();

    NoDoItem nodoIten = NoDoItem(text, DateTime.now().toIso8601String());
    int savedItemID = await db.saveItem(nodoIten);

    NoDoItem addedItem = await db.getItem(savedItemID);

    setState(() {
      _itemList.insert(0, addedItem);
    });

    print("Item saved id: $savedItemID");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              reverse: false,
              itemCount: _itemList.length,
              itemBuilder: (_, int index) {
                return Card(
                  color: Colors.white10,
                  child: ListTile(
                    title: _itemList[index],
                    onLongPress: () => debugPrint("clicked"),
                    trailing: Listener(
                      key: Key(_itemList[index].itemName),
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.redAccent,
                      ),
                      onPointerDown: (pointerEvent) => debugPrint(""),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(
            height: 1,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Item",
        backgroundColor: Colors.redAccent,
        child: ListTile(
          title: Icon(Icons.add),
        ),
        onPressed: _showFormDialog,
      ),
    );
  }

  void _showFormDialog() {
    var alert = AlertDialog(
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              textAlign: TextAlign.justify,
              controller: _textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Item",
                hintText: "eg. Don't buy stuff",
                icon: Icon(Icons.note_add),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _handleSubmitted(_textEditingController.text);
            _textEditingController.clear();
          },
          child: Text("Save"),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        )
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _readNoDoList() async {
    List items = await db.getItems();
    items.forEach((item) {
      //NoDoItem nodoItem = NoDoItem.fromMap(item);
      setState(() {
        _itemList.add(NoDoItem.map(item));
      });

      //print("DB Items: ${nodoItem.itemName}");
    });
  }
}
