import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:movie_admin/ui/users/manage_user_state.dart';

import '../../domain/model/user.dart';
import 'manager_users_bloc.dart';

class ManagerUsersPage extends StatefulWidget {
  static const routeName = '/manager_users';

  @override
  _ManagerUsersPageState createState() => _ManagerUsersPageState();
}

class _ManagerUsersPageState extends State<ManagerUsersPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isOpeningSlide = false;
  ScrollController _listUserController;

  SlidableController _slidableController;

  ManagerUsersBloc _bloc;

  final _listUsers = <User>[];

  @override
  @protected
  void initState() {
    super.initState();
    _slidableController = SlidableController(
      onSlideAnimationChanged: (_) {},
      onSlideIsOpenChanged: (isOpen) {
        setState(() => _isOpeningSlide = isOpen);
      },
    );
    _listUserController = ScrollController()
      ..addListener(() {
        if (_listUserController.position.pixels ==
            _listUserController.position.maxScrollExtent) {
          _bloc.loadUsers(_listUsers.length);
          print("12345");
        }
      });
  }

  Widget _buildSearchUser() {
    return SizedBox(width: 10, height: 10);
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<ManagerUsersBloc>(context);
    _bloc.loadUsers(_listUsers.length);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildSearchUser(),
          _buildListUsers(_bloc),
        ],
      ),
      floatingActionButton: _isOpeningSlide == true
          ? null
          : FloatingActionButton(
              onPressed: null,
              child: Icon(Icons.add),
            ),
    );
  }

  bool _isHasUserInList(User user, List<User> listUser) =>
      listUser.map((e) => e.uid).contains(user.uid);

  Widget _buildListUsers(ManagerUsersBloc bloc) {
    return StreamBuilder<ManageUserState>(
        stream: bloc.renderListStream$,
        builder: (context, snapShort) {
          print(snapShort.data.toString());
          if (snapShort.data is LoadUserSuccess) {
            final data = snapShort.data as LoadUserSuccess;
            _listUsers.addAll(
              data.users.where(
                (user) => !_isHasUserInList(user, _listUsers),
              ),
            );
            print(data.users.map((e) => e.uid).toString());
          }
          return Expanded(
            child: ListView.builder(
              controller: _listUserController,
              itemBuilder: (context, index) => index == _listUsers.length
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CircularProgressIndicator()],
                    )
                  : _buildItemUserByIndex(_listUsers[index]),
              itemCount: snapShort.data is LoadingUsersState
                  ? _listUsers.length + 1
                  : _listUsers.length,
            ),
          );
        });
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

  Widget _buildItemUserByIndex(User user) {
    return user.uid == null
        ? Text('Error')
        : Slidable.builder(
            key: Key(user.uid),
            controller: _slidableController,
            dismissal: SlidableDismissal(
              child: SlidableDrawerDismissal(),
              closeOnCanceled: true,
              onWillDismiss: (action) async {
                final isDismiss = await _showDialogConfirm();
                if (isDismiss) _bloc.removeUser(user);
                return isDismiss;
              },
              onDismissed: (actionType) {
                if (actionType == SlideActionType.primary) return;
                _showSnackBar(context, 'Delete user ${user.fullName}');
                _bloc.removeUser(user);
              },
            ),
            actionPane: SlidableScrollActionPane(),
            actionExtentRatio: 0.2,
            child: UserItemWidget(user),
            secondaryActionDelegate: SlideActionBuilderDelegate(
              actionCount: 1,
              builder: (context, index, animation, renderingMode) {
                return StreamBuilder<List<String>>(
                    stream: _bloc.renderItemRemove$,
                    builder: (context, snapShort) {
                      return snapShort.data?.contains(user.uid) ?? false
                          ? CircularProgressIndicator()
                          : IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () {
                                _bloc.removeUser(user);
                              },
                            );
                    });
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
      onTap: () => slide?.renderingMode == SlidableRenderingMode.none
          ? slide?.open()
          : slide?.close(),
      child: Container(
          color: Colors.white,
          child: Row(
            children: [
              _buildAvatar(70, context),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.fullName),
                  SizedBox(height: 5),
                  Text(user.email)
                ],
              )
            ],
          )),
    );
  }

  Widget _buildAvatar(double imageSize, BuildContext context) {
    return Container(
      width: imageSize,
      height: imageSize,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).backgroundColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
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
                progressIndicatorBuilder: (
                  BuildContext context,
                  String url,
                  progress,
                ) {
                  return Center(
                    child: CircularProgressIndicator(
                      value: progress.progress,
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  );
                },
                errorWidget: (
                  BuildContext context,
                  String url,
                  dynamic error,
                ) {
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
