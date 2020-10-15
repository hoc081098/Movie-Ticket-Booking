import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'manager_users_bloc.dart';

import '../../domain/model/user.dart';

class ManagerUsersPage extends StatefulWidget {
  static const routeName = '/manager_users';

  @override
  _ManagerUsersPageState createState() => _ManagerUsersPageState();
}

class _ManagerUsersPageState extends State<ManagerUsersPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isOpeningSlide = false;

  SlidableController _slidableController;

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

  Widget _buildSearchUser() {
    return SizedBox(width: 0, height: 0);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ManagerUsersBloc>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildSearchUser(),
          _buildListUsers(bloc),
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

  Widget _buildListUsers(ManagerUsersBloc bloc) {
    var itemCount = 0;
    return StreamBuilder<List<User>>(
        stream: bloc.getUsersStream$,
        builder: (context, snapShort) {
          itemCount += snapShort.data?.length ?? 0;
          return ListView.builder(
            itemBuilder: (context, index) =>
                _buildItemUserByIndex(snapShort.data[index], bloc),
            itemCount: itemCount,
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

  Widget _buildItemUserByIndex(User user, ManagerUsersBloc bloc) {
    return StreamBuilder<bool>(
        stream: bloc.isRemoving$,
        builder: (context, snapShort) {
          return Slidable.builder(
            key: Key(user.uid),
            controller: _slidableController,
            dismissal: SlidableDismissal(
              child: SlidableDrawerDismissal(),
              closeOnCanceled: true,
              onWillDismiss: (action) async {
                return await _showDialogConfirm()
                    ? bloc.removeUser(user)
                    : false;
              },
              onDismissed: (actionType) {
                if (actionType == SlideActionType.primary) return;
                _showSnackBar(context, 'Delete user ${user.fullName}');
                bloc.removeUser(user);
              },
            ),
            actionPane: SlidableScrollActionPane(),
            actionExtentRatio: 0.2,
            child: UserItemWidget(user),
            secondaryActionDelegate: SlideActionBuilderDelegate(
              actionCount: 1,
              builder: (context, index, animation, renderingMode) {
                return snapShort.data == true
                    ? CircularProgressIndicator()
                    : IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () => Slidable.of(context).dismiss(),
                      );
              },
            ),
          );
        });
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
        color: Theme.of(context).backgroundColor,
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
