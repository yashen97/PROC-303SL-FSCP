import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insmanager/screens/animations/animations.dart';
import 'package:insmanager/screens/chat/const.dart';
import 'package:insmanager/screens/chat/fullPhoto.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  final String name;

  Chat(
      {Key key,
      @required this.peerId,
      @required this.peerAvatar,
      @required this.name})
      : super(key: key);

  @override
  _ChatScrrenState createState() =>
      _ChatScrrenState(peerId: peerId, peerAvatar: peerAvatar, name: name);
}

class _ChatScrrenState extends State<Chat> {
  final String peerId;
  final String peerAvatar;
  final String name;
  final String message;

  _ChatScrrenState(
      {Key key,
      @required this.peerId,
      @required this.peerAvatar,
      @required this.name,
      this.message});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text("Chat"),
        ),
        backgroundColor: Colors.indigo[700],
        elevation: 22,
        shadowColor: Colors.indigoAccent,
        brightness: Brightness.dark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10)),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: SizedBox(),
        ),
      ),
      body: new ChatScreen(
        peerId: peerId,
        peerAvatar: peerAvatar,
        message: message,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  final String message;

  ChatScreen(
      {Key key, @required this.peerId, @required this.peerAvatar, this.message})
      : super(key: key);

  @override
  State createState() => new ChatScreenState(
      peerId: peerId, peerAvatar: peerAvatar, message: message);
}

class ChatScreenState extends State<ChatScreen> {
  String peerId;
  String peerAvatar;
  String message = "";

  ChatScreenState(
      {Key key,
      @required this.peerId,
      @required this.peerAvatar,
      this.message});

  var listMessage;
  String groupChatId;
  SharedPreferences prefs;

  TextEditingController lang = TextEditingController();

  String langType = "sn";
  String out = "";

  String id;
  int message_count = 0;

  File imageFile;
  bool isLoading = true;
  bool isShowSticker;
  String imageUrl;
  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();
  String user_type = "";
  String login_user_type;

  initPreference() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      user_type = prefs.getString('login_type') ?? "";
      login_user_type = prefs.getString('login_type');
    });
  }

  ChangeMessageCount() {
    print("peerId" + peerId);
  }

  @override
  void initState() {
    initPreference();

    ChangeMessageCount();
    textEditingController.text = message;
    super.initState();
    focusNode.addListener(onFocusChange);
    groupChatId = '';

    setState(() {
      isLoading = false;
    });

    isShowSticker = false;
    imageUrl = '';

    readLocal();

    /*FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-3665814374229575~5533418811");
    videoAd.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      print("REWARDED VIDEO AD $event");
      if (event == RewardedVideoAdEvent.rewarded) {
        setState(() {
          _coins += rewardAmount;
        });
      }
    };*/
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  readLocal() async {
    prefs = await SharedPreferences.getInstance();

    id = prefs.getString('userId');

    print(login_user_type);

    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }

    Firestore.instance
        .collection('users')
        .document(id)
        .updateData({'chattingWith': peerId});

    setState(() {});
  }

  /*Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }*/
  File _image;
  final picker = ImagePicker();
  Future getImageFromGallery() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print("No Image Selected");
      }
    });
  }

  File _image1;
  final picker1 = ImagePicker();
  Future getImageFromCamera() async {
    final pickedImage = await picker1.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedImage != null) {
        _image1 = File(pickedImage.path);
      } else {
        print("No Image Selected");
      }
    });
  }

  Future<void> _showChoiceDilog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make a Choice!"),
            content: Container(
              child: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Text("Gallery"),
                        onTap: () {
                          Navigator.pop(context);
                          getImageFromGallery();
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          getImageFromCamera();
                        },
                        child: Text("Camera"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  void onSendMessage(String content, int type) async {
    setState(() {
      message_count++;
    });

    // type: 0 = text, 1 = image, 2 = sticker
    // int available_message = prefs.getInt('points');

    //prefs.setInt('points', available_message-adminChat);

    //decreamentPayments(adminChat,prefs.getString('id'));

    //  print(available_message);
    //if(message_count < available_message){

    if (content.trim() != '') {
      textEditingController.clear();

      //   var updateCount = Firestore.instance.collection("myPersonalChat").document(id).collection(id).document(peerId);
      //  updateCount.updateData({'countMessage':0});

      // /   var updateMe = Firestore.instance.collection("myPersonalChat").document(peerId).collection(peerId).document(id);
      //   updateMe.updateData({'createdAt':DateTime.now().millisecondsSinceEpoch.toString(),'latestMessage':content });

      //  QuerySnapshot count_mesage = await  Firestore.instance.collection("myPersonalChat").document(peerId).collection(peerId).where("id" ,isEqualTo: id).getDocuments();
      //     Firestore.instance.collection("myPersonalChat").document(peerId).collection(peerId).document(id);
      //    updateMe.updateData({'countMessage' : count_mesage.documents[0]['countMessage']+1 });

      // var updatelastMessage = Firestore.instance.collection("myPersonalChat").document(id).collection(id).document(peerId);
      //updatelastMessage.updateData({'latestMessage':content });

      //  SaveLatestMessage();

      //uploadRequest( user_type =="admin" ? peerId: id,content);

      var documentReference = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });

      var documentReference1 = Firestore.instance
          .collection('chatNotification')
          .document(groupChatId);
      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference1,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == id) {
      return DelayedAnimation(
        child: Row(
          children: <Widget>[
            document['type'] == 0
                // Text
                ? DelayedAnimation(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        document['content'],
                        style: TextStyle(color: primaryColor),
                      ),
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      width: 250.0,
                      decoration: BoxDecoration(
                          color: greyColor2,
                          borderRadius: BorderRadius.circular(8.0)),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                          right: 10.0),
                    ),
                    delay: 500,
                  )
                : document['type'] == 1
                    // Image
                    ? DelayedAnimation(
                        child: Container(
                          child: FlatButton(
                            child: Material(
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        themeColor),
                                  ),
                                  width: 200.0,
                                  height: 200.0,
                                  padding: EdgeInsets.all(70.0),
                                  decoration: BoxDecoration(
                                    color: greyColor2,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Material(
                                  child: Image.asset(
                                    'images/img_not_available.jpeg',
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                imageUrl: document['content'],
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FullPhoto(url: document['content'])));
                            },
                            padding: EdgeInsets.all(0),
                          ),
                          margin: EdgeInsets.only(
                              bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                              right: 10.0),
                        ),
                        delay: 500,
                      )
                    // Sticker
                    : DelayedAnimation(
                        child: Container(
                          child: new Image.asset(
                            'images/${document['content']}.gif',
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                          ),
                          margin: EdgeInsets.only(
                              bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                              right: 10.0),
                        ),
                        delay: 500,
                      ),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        ),
        delay: 500,
      );
    } else {
      // Left (peer message)
      return DelayedAnimation(
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  isLastMessageLeft(index)
                      ? Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                strokeWidth: 1.0,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(themeColor),
                              ),
                              width: 35.0,
                              height: 35.0,
                              padding: EdgeInsets.all(10.0),
                            ),
                            imageUrl: peerAvatar,
                            width: 35.0,
                            height: 35.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(18.0),
                          ),
                          clipBehavior: Clip.hardEdge,
                        )
                      : Container(width: 35.0),
                  document['type'] == 0
                      ? DelayedAnimation(
                          child: Container(
                            child: Text(
                              document['content'],
                              style: TextStyle(color: Colors.white),
                            ),
                            padding:
                                EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                            width: 250.0,
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(8.0)),
                            margin: EdgeInsets.only(left: 10.0),
                          ),
                          delay: 500,
                        )
                      : document['type'] == 1
                          ? DelayedAnimation(
                              child: Container(
                                child: FlatButton(
                                  child: Material(
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  themeColor),
                                        ),
                                        width: 200.0,
                                        height: 200.0,
                                        padding: EdgeInsets.all(70.0),
                                        decoration: BoxDecoration(
                                          color: greyColor2,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Material(
                                        child: Image.asset(
                                          'images/img_not_available.jpeg',
                                          width: 200.0,
                                          height: 200.0,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                        clipBehavior: Clip.hardEdge,
                                      ),
                                      imageUrl: document['content'],
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FullPhoto(
                                                url: document['content'])));
                                  },
                                  padding: EdgeInsets.all(0),
                                ),
                                margin: EdgeInsets.only(left: 10.0),
                              ),
                              delay: 500,
                            )
                          : DelayedAnimation(
                              delay: 500,
                              child: Container(
                                child: new Image.asset(
                                  'images/${document['content']}.gif',
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.cover,
                                ),
                                margin: EdgeInsets.only(
                                    bottom:
                                        isLastMessageRight(index) ? 20.0 : 10.0,
                                    right: 10.0),
                              ),
                            ),
                ],
              ),

              // Time
              isLastMessageLeft(index)
                  ? DelayedAnimation(
                      delay: 500,
                      child: Container(
                        child: Text(
                          DateFormat('dd MMM kk:mm').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(document['timestamp']))),
                          style: TextStyle(
                              color: greyColor,
                              fontSize: 12.0,
                              fontStyle: FontStyle.italic),
                        ),
                        margin:
                            EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                      ),
                    )
                  : Container()
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: EdgeInsets.only(bottom: 10.0),
        ),
        delay: 500,
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Firestore.instance
          .collection('users')
          .document(id)
          .updateData({'chattingWith': null});
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                // List of messages
                buildListMessage(),

                // Sticker
                (isShowSticker ? buildSticker() : Container()),

                // Input content
                buildInput(),
              ],
            ),

            // Loading
            buildLoading(),
          ],
        ),
      ),
    );
  }

  @override
  dispose() {
    super.dispose();
  }

  Widget buildSticker() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi1', 2),
                child: new Image.asset(
                  'images/mimi1.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi2', 2),
                child: new Image.asset(
                  'images/mimi2.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi3', 2),
                child: new Image.asset(
                  'images/mimi3.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi4', 2),
                child: new Image.asset(
                  'images/mimi4.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi5', 2),
                child: new Image.asset(
                  'images/mimi5.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi6', 2),
                child: new Image.asset(
                  'images/mimi6.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi7', 2),
                child: new Image.asset(
                  'images/mimi7.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi8', 2),
                child: new Image.asset(
                  'images/mimi8.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi9', 2),
                child: new Image.asset(
                  'images/mimi9.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: new BoxDecoration(
          border:
              new Border(top: new BorderSide(color: greyColor2, width: 0.5)),
          color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.image),
                onPressed: () {
                  _showChoiceDilog(context);
                }, //getImage,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextFormField(
                maxLines: null,
                style: TextStyle(color: primaryColor, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: greyColor),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () {
                  setState(() {
                    message_count++;
                  });

                  if (message_count > 1) {
                    setState(() {
                      message_count = 0;
                    });
                  }
                  onSendMessage(textEditingController.text, 0);
                },
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border:
              new Border(top: new BorderSide(color: greyColor2, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(themeColor)))
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('messages')
                  .document(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(themeColor)));
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }
/* SaveLatestMessage()async{


    String url = "https://smartwriters.lk/Writer/save_message_info.php";
    http.Response res;

    //print

    print(textEditingController.text);

    res = await http.post(Uri.encodeFull(url), headers: {
      "Accept": "application/json"
    }, body: {
      "user_id":login_user_type == "client" ? prefs.getString('client_id') : widget.peerId,
      "writer_id" : login_user_type == "client" ? peerId: prefs.getString('writer_id'),
      "message":textEditingController.text//message??""
    });
    var responseBody = json.decode(res.body);
    print(responseBody);
  }*/

}
