import 'package:flutter/material.dart';
import 'package:notodo_app/Util/database_client.dart';
import 'package:notodo_app/Util/date_formatter.dart';
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

    //NoDoItem nodoIten = NoDoItem(text, DateTime.now().toIso8601String());
    NoDoItem nodoIten = NoDoItem(text, dateFormatted());

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
                    // Add for me.
                    leading: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.black12,
                      child: Text("${_itemList[index].id}"),
                    ),
                    // End add for me.
                    title: _itemList[index],
                    onLongPress: () => _updateNoDo(_itemList[index], index),
                    trailing: Listener(
                      key: Key(_itemList[index].itemName),
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.redAccent,
                      ),
                      onPointerDown: (pointerEvent) =>
                          _deleteNoDo(_itemList[index].id, index),
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
            Navigator.pop(context);
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
      setState(() {
        _itemList.add(NoDoItem.map(item));
      });
    });
  }

  _deleteNoDo(int id, int index) async {
    debugPrint("Deleted item $id");

    await db.deleteItem(id);

    setState(() {
      _itemList.removeAt(index);
    });
  }

  _updateNoDo(NoDoItem item, int index) async {
    var alert = AlertDialog(
      title: Text("Update Item"),
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Item",
                hintText: "eg. Don't buy stuff",
                icon: Icon(Icons.update),
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            NoDoItem _newItemUpdatted = NoDoItem.fromMap({
              "itemName": _textEditingController.text,
              "dateCreated": dateFormatted(),
              "id": item.id,
            });

            _handleSubmittedUpdate(index, item); // redrawing the screen
            await db.updateItem(_newItemUpdatted); // updating the item
            setState(() {
              _readNoDoList();// redrawing the screem with all items saved in the db
            });

            Navigator.pop(context);
          },
          child: Text("Update"),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmittedUpdate(int index, NoDoItem item) {
    setState(() {
      _itemList.removeWhere((element) {
        _itemList[index].itemName == item.itemName;
      });
    });
  }
}
