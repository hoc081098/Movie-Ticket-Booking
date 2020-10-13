import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../domain/model/user.dart';

class UsersPage extends StatefulWidget {
  static const routeName = '/users';

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isOpeningSlide = false;

  SlidableController _slidableController = null;

  final List<User> items = List.generate(
    20,
        (index) =>
        User(
          uid: "",
          email: "",
          phoneNumber: "",
          fullName: "",
          gender: null,
          avatar: "",
          address: "",
          birthday: null,
          location: null,
          isCompleted: true,
          isActive: true,
        ),
  );

  @override
  @protected
  void initState() {
    _slidableController = SlidableController(
      onSlideAnimationChanged: (_) {},
      onSlideIsOpenChanged: (isOpen) {
        setState(() => _isOpeningSlide = isOpen);
      },
    );
    super.initState();
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Users"),
    );
  }

  Widget _buildBody() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildSearchUser(),
        _buildList(context),
      ],
    );
  }

  Widget _buildSearchUser() {
    return SizedBox(width: 0, height: 0);
  }

  Widget _buildFloatButton() {
    return _isOpeningSlide == true
        ? null
        : FloatingActionButton(
      onPressed: null,
      child: Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatButton(),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _getSlidableWithDelegates(context, index);
      },
      itemCount: items.length,
    );
  }

  Future<bool> _showDialogConfirm() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete this user'),
          content: Text('User will be deleted '),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  Widget _getSlidableWithDelegates(BuildContext context, int indexOfListItem) {
    final item = items[indexOfListItem];

    return Slidable.builder(
      key: Key(item.uid),
      controller: _slidableController,
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        closeOnCanceled: true,
        onWillDismiss: (action) => _showDialogConfirm(),
        onDismissed: (actionType) {
          if (actionType == SlideActionType.primary) return;
          _showSnackBar(
              context, 'Delete user ${items[indexOfListItem].fullName}');
          setState(() {
            items.removeAt(indexOfListItem);
          });
        },
      ),
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.2,
      child: UserItemWidget(items[indexOfListItem]),
      secondaryActionDelegate: SlideActionBuilderDelegate(
        actionCount: 1,
        builder: (context, index, animation, renderingMode) {
          return IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => Slidable.of(context).dismiss(),
          );
        },
      ),
    );
  }

  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class UserItemWidget extends StatelessWidget {
  UserItemWidget(this.user);

  final User user;

  @override
  Widget build(BuildContext context) {
    final slide = Slidable.of(context);
    return GestureDetector(
      onTap: () =>
      slide?.renderingMode == SlidableRenderingMode.none
          ? slide?.open()
          : slide?.close(),
      child: Container(
        color: Colors.white,
        child: ListTile(
          leading: _buildAvatar(70, context),
          title: Text(user.fullName),
          subtitle: Text(user.email),
        ),
      ),
    );
  }

  Widget _buildAvatar(double imageSize, BuildContext context) {
    return Container(
      width: imageSize,
      height: imageSize,
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme
            .of(context)
            .backgroundColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            offset: Offset(0.0, 1.0),
            color: Colors.grey.shade500,
            spreadRadius: 1,
          )
        ],
      ),
      child: ClipOval(
        child: user.avatar == null
            ? Center(
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: imageSize * 0.7,
          ),
        )
            : CachedNetworkImage(
          imageUrl: user.avatar,
          fit: BoxFit.cover,
          width: imageSize,
          height: imageSize,
          progressIndicatorBuilder: (BuildContext context,
              String url,
              progress,) {
            return Center(
              child: CircularProgressIndicator(
                value: progress.progress,
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            );
          },
          errorWidget: (BuildContext context,
              String url,
              dynamic error,) {
            return Center(
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: imageSize * 0.7,
              ),
            );
          },
        ),
      ),
    );
  }
}
