import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xlife/views/screens/user/screen_user_chat.dart';
import '../../helpers/constants.dart';
import '../../helpers/styles.dart';

class ItemUserInbox extends StatefulWidget {
  const ItemUserInbox({Key? key}) : super(key: key);

  @override
  _ItemUserInboxState createState() => _ItemUserInboxState();
}

class _ItemUserInboxState extends State<ItemUserInbox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Column(
          children: [
            ListTile(
              title: Text(
                "Sami Khan",
                style: normal_h2Style_bold,
              ),
              subtitle: Text(
                "hey john,\n I’m looking for a video editor for my video editing task.",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              leading: Badge(
                badgeContent: Text(
                  "  ",
                  style: normal_h6Style.copyWith(color: Colors.white),
                ),
                badgeColor: Colors.green,
                elevation: 0,
                toAnimate: false,
                animationDuration: Duration(seconds: 1),
                animationType: BadgeAnimationType.fade,
                position: BadgePosition.bottomEnd(
                  bottom: 5,
                  end: 0,
                ),
                child: Container(
                  height: Get.height * 0.08,
                  width: Get.width * 0.14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          "https://upload.wikimedia.org/wikipedia/commons/3/3a/Elton_John_Cannes_2019.jpg"),
                    ),
                  ),
                ),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("3 hr", style: TextStyle(color: hintColor),),
                  Badge(
                    badgeContent: Text(
                      " 1 ",
                      style: normal_h3Style.copyWith(color: Colors.white),
                    ),
                    toAnimate: false,
                    shape: BadgeShape.circle,
                    position: BadgePosition.center(),
                  ),
                ],
              ),
              onTap: (){
                Get.to(ScreenUserChat());
              },
            ),
            Divider(
              color: Colors.black45,
              indent: Get.width * 0.1,
              endIndent: Get.width * 0.05,
              height: Get.height * 0.03,
            )
          ],
        ),
      ),
    );
  }
}