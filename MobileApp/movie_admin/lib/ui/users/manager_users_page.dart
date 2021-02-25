import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tuple/tuple.dart';

import '../../domain/model/theatre.dart';
import '../../domain/model/user.dart';
import '../../utils/snackbar.dart';
import '../app_scaffold.dart';
import '../theatres/theatre_page.dart';
import 'manage_user_state.dart';
import 'manager_users_bloc.dart';

class ManagerUsersPage extends StatefulWidget {
  static const routeName = '/manager_users';

  @override
  _ManagerUsersPageState createState() => _ManagerUsersPageState();
}

class _ManagerUsersPageState extends State<ManagerUsersPage>
    with DisposeBagMixin {
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
        }
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bloc == null) {
      _bloc = BlocProvider.of<ManagerUsersBloc>(context);
      _bloc.loadUsers(_listUsers.length);
      _bloc.showSnackBar$
          .listen((text) => context.showSnackBar(text))
          .disposedBy(bag);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  Widget _buildSearchUser() {
    return SizedBox(width: 10, height: 10);
  }

  @override
  Widget build(BuildContext context) {
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
          _listenStateChange(context, snapShort);
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

  Future<bool> _showDialogConfirm(String text, String description) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(text),
          content: Text(description),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
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
        : StreamBuilder<Map<String, DestroyUserType>>(
            stream: _bloc.renderItemRemove$,
            builder: (context, snapShort) {
              return Slidable.builder(
                key: Key(user.uid),
                controller: _slidableController,
                actionPane: SlidableScrollActionPane(),
                actionExtentRatio: 0.2,
                child: UserItemWidget(user),
                actionDelegate: SlideActionBuilderDelegate(
                  actionCount: 1,
                  builder: (context, index, animation, renderingMode) {
                    final data = snapShort.data ?? {};
                    return data[user.uid] == DestroyUserType.CHANGE_ROLE
                        ? Center(child: CircularProgressIndicator())
                        : IconSlideAction(
                            caption:
                                user.role == Role.USER ? 'To staff' : 'To user',
                            color: Colors.blue,
                            icon: user.role == Role.USER
                                ? Icons.arrow_circle_up
                                : Icons.arrow_circle_down,
                            onTap: () async {
                              Theatre theatre;

                              if (user.role == Role.USER) {
                                theatre =
                                    await AppScaffold.of(context).pushNamed(
                                  TheatresPage.routeName,
                                  arguments: TheatresMode.pick,
                                ) as Theatre;
                                if (theatre == null) {
                                  return;
                                }
                              }

                              print(theatre);
                              _bloc.destroyUser(
                                Tuple3(
                                  user,
                                  DestroyUserType.CHANGE_ROLE,
                                  theatre?.id,
                                ),
                              );
                            },
                          );
                  },
                ),
                secondaryActionDelegate: SlideActionBuilderDelegate(
                  actionCount: 2,
                  builder: (context, index, animation, renderingMode) {
                    final data = snapShort.data ?? {};
                    final iconBlock = data[user.uid] == DestroyUserType.BLOCK ||
                            data[user.uid] == DestroyUserType.UNBLOCK
                        ? Center(child: CircularProgressIndicator())
                        : IconSlideAction(
                            caption: user.isActive ? 'Block' : 'Unblock',
                            color:
                                user.isActive ? Colors.limeAccent : Colors.grey,
                            icon: Icons.block,
                            onTap: () async {
                              final isDismiss = await _showDialogConfirm(
                                user.isActive
                                    ? 'Block this user'
                                    : 'Unblock this user',
                                user.isActive
                                    ? 'User will be block '
                                    : 'User will be unblock ',
                              );
                              if (isDismiss) {
                                _bloc.destroyUser(
                                  Tuple3(
                                    user,
                                    user.isActive
                                        ? DestroyUserType.BLOCK
                                        : DestroyUserType.UNBLOCK,
                                    null,
                                  ),
                                );
                              }
                            },
                          );
                    final iconRemove = data[user.uid] == DestroyUserType.REMOVE
                        ? Center(child: CircularProgressIndicator())
                        : IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () async {
                              final isDismiss = await _showDialogConfirm(
                                'Delete this user',
                                'User will be deleted ',
                              );
                              if (isDismiss) {
                                _bloc.destroyUser(Tuple3(
                                  user,
                                  DestroyUserType.REMOVE,
                                  null,
                                ));
                              }
                            },
                          );
                    return index == 0 ? iconBlock : iconRemove;
                  },
                ),
              );
            },
          );
  }

  void _listenStateChange(
      BuildContext context, AsyncSnapshot<ManageUserState> snapshot) {
    final state = snapshot.data;
    print('##### $state');
    if (state is LoadUserSuccess) {
      _listUsers.addAll(
        state.users.where(
          (user) => !_isHasUserInList(user, _listUsers),
        ),
      );
    }
    if (state is DeleteUserSuccess) {
      _listUsers.removeWhere((e) => e.uid == state.idUserDelete);
    }
    if (state is BlockUserSuccess) {
      final index = _listUsers.indexWhere((e) => e.uid == state.user.uid);
      if (index != -1) {
        _listUsers.removeAt(index);
        _listUsers.insert(index, state.user);
      }
    }
    if (state is UnblockUserSuccess) {
      final data = state;
      final index = _listUsers.indexWhere((e) => e.uid == data.user.uid);
      if (index != -1) {
        _listUsers.removeAt(index);
        _listUsers.insert(index, data.user);
      }
    }
    if (state is ChangeRoleSuccess) {
      final data = state;
      final index = _listUsers.indexWhere((e) => e.uid == data.user.uid);
      print(index);
      if (index != -1) {
        _listUsers.removeAt(index);
        _listUsers.insert(index, data.user);
      }
    }
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
          height: 96,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildAvatar(70, context),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(user.email),
                    SizedBox(height: 5),
                    _buildStatusRoleUser(user.isActive),
                  ],
                ),
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

  Widget _buildStatusRoleUser(bool isActive) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'status: ',
          style: TextStyle(fontSize: 8),
        ),
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(3)),
        ),
        SizedBox(width: 10),
        Text(
          'role: ',
          style: TextStyle(fontSize: 8),
        ),
        SizedBox(width: 3),
        Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
              color: user.role == Role.ADMIN
                  ? Colors.lightBlueAccent
                  : user.role == Role.STAFF
                      ? Colors.cyanAccent
                      : Colors.lightGreenAccent,
              borderRadius: BorderRadius.circular(2)),
          child: Text(
            user.role.string().toLowerCase(),
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (user.role == Role.STAFF) ...[
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              user.theatre?.name ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
