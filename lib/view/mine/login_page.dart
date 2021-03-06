import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flowermusic/base/app_config.dart';
import 'package:flutter_flowermusic/base/base.dart';
import 'package:flutter_flowermusic/main/dialog/dialog.dart';
import 'package:flutter_flowermusic/view/mine/register_page.dart';
import 'package:flutter_flowermusic/view/mine/reset_password_page.dart';
import 'package:flutter_flowermusic/viewmodel/mine/login_provide.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';
import 'package:rxdart/rxdart.dart';

class LoginPage extends PageProvideNode {
  LoginProvide provide = LoginProvide();

  LoginPage() {
    mProviders.provide(Provider<LoginProvide>.value(provide));
  }

  @override
  Widget buildContent(BuildContext context) {
    return _LoginContentPage(provide);
  }
}

class _LoginContentPage extends StatefulWidget {
  LoginProvide provide;

  _LoginContentPage(this.provide);

  @override
  State<StatefulWidget> createState() {
    return _LoginContentState();
  }
}

class _LoginContentState extends State<_LoginContentPage> {
  LoginProvide _provide;
  final _subscriptions = CompositeSubscription();

  final _loading = LoadingDialog();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _provide ??= widget.provide;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(239, 245, 255, 1),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _setupBack(),
              _setupTop(),
              Padding(
                padding: const EdgeInsets.only(bottom: 57),
              ),
              _setUpFrame(),
              _setupBottom(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    print("login释放");
    _subscriptions.dispose();
  }

  Widget _setupBack() {
    return new Container(
      height: 160,
      padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: new GestureDetector(
        onTap: () {
          this._goback(false);
        },
        child: new Icon(
          Icons.keyboard_arrow_left,
          color: Colors.black,
          size: 40,
        ),
      ),
    );
  }

  Widget _setupTop() {
    return Center(
      child: Hero(
        tag: 'bird',
        child: Image.asset(
          'images/bird.png',
          width: 95,
        ),
      ),
    );
  }

  _setUpFrame() {
    return Stack(
      children: [
        Provide<LoginProvide>(
          builder: (BuildContext context, Widget child, LoginProvide provide) {
            return Hero(
              tag: 'frame',
              child: ClipPath(
                clipper: _CustomClipper(),
                child: Container(
                  height: 331,
                  width: 302,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(color: Color.fromRGBO(181, 181, 181, 0.16), offset: Offset(0, 10), blurRadius: 6)
                      ]),
                ),
              ),
            );
          },
        ),
        Positioned(
          height: 331,
          width: 302,
          child: Padding(
            padding: const EdgeInsets.only(top: 120.0, left: 20, right: 20),
            child: Column(
              children: <Widget>[
                _setupItem(0),
                Hero(
                  tag: 'email',
                  child: Divider(
                    height: 0,
                    color: Colors.transparent,
                  ),
                ),
                _setupItem(1),
                Hero(
                  tag: 'forget',
                  child: Align(
                      heightFactor: 2,
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                          onTap: () {
                            this._resetPwd();
                          },
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              "Forget Password",
                              style: TextStyle(color: Color(0xFF7B7B7B)),
                            ),
                          ))),
                )
              ],
            ),
          ),
        ),
        Positioned(
          left: 113,
          width: 76,
          height: 76,
          child: Hero(
            tag: 'avatar',
            child: DecoratedBox(
              decoration: BoxDecoration(
                  image: DecorationImage(image: ExactAssetImage('images/user.png')),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2)),
            ),
          ),
        ),
        Positioned(
          left: 92,
          bottom: 0,
          width: 119,
          height: 47,
          child: Transform.translate(
            offset: Offset(0, 24),
            child: Hero(
              tag: 'login',
              child: CupertinoButton(
                pressedOpacity: 0.8,
                padding: EdgeInsets.all(0),
                borderRadius: BorderRadius.all(Radius.circular(34)),
                color: const Color(0xFF6DA2FF),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  _login();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  _setupItem(int index) {
    return Hero(
      tag: index == 0 ? 'name' : 'pwd',
      child: CupertinoTextField(
          obscureText: index == 2,
          prefix: Icon(
            index == 0 ? Icons.person_outline : Icons.lock_outline,
            color: const Color(0xFFBED5FF),
            size: 24.0,
          ),
          padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
          clearButtonMode: OverlayVisibilityMode.editing,
          textCapitalization: TextCapitalization.words,
          autocorrect: false,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 1.0, color: const Color(0xFFBED5FF))),
          ),
          placeholderStyle: TextStyle(color: const Color(0xFFBED5FF)),
          placeholder: index == 0 ? 'Username' : 'Password',
          onChanged: (str) {
            if (index == 0) {
              _provide.userName = str;
            }
            if (index == 1) {
              _provide.password = str;
            }
          }),
    );
  }

  _setupBottom() {
    return Padding(
      padding: const EdgeInsets.only(top: 70.0),
      child: Hero(
        tag: 'sign',
        child: CupertinoButton(
          pressedOpacity: 0.8,
          padding: EdgeInsets.all(0),
          child: Text(
            'Sign up',
            style: TextStyle(color: Color(0xFF6DA2FF)),
          ),
          onPressed: () {
            Navigator.push(context, HeroPageRoute(builder: (_) => RegisterPage(), fullscreenDialog: true));
          },
        ),
      ),
    );
  }

  _login() {
    if (_provide.agreeProtocol == false) {
      Fluttertoast.showToast(msg: "尚未同意注册协议", gravity: ToastGravity.CENTER);
      return;
    }
    var s = _provide
        .login()
        .doOnListen(() {
          _loading.show(context);
        })
        .doOnCancel(() {})
        .listen((data) {
          _loading.hide(context);
          if (data.success) {
            var res = data.data as Map;

            /// 存储用户信息
            AppConfig.userTools.setUserData(res).then((success) {
              if (success) {
                Fluttertoast.showToast(msg: "登录成功", gravity: ToastGravity.CENTER);
                Future.delayed(Duration(seconds: 1), () {
                  this._goback(true);
                });
              }
            });
          }
        }, onError: (e) {
          _loading.hide(context);
        });
    _subscriptions.add(s);
  }

  _resetPwd() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ResetPasswordPage())).then((value) {});
  }

  _goback(bool logined) {
    Navigator.pop(context, logined);
  }
}

class _CustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 100);
    path.quadraticBezierTo(5, 86, 20, 80);
    path.lineTo(287, 0);
    path.lineTo(307, 0);
    path.lineTo(307, 344);
    path.lineTo(0, 344);
    path.lineTo(0, 100);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class HeroPageRoute<T> extends PageRoute<T> {
  /// Construct a MaterialPageRoute whose contents are defined by [builder].
  ///
  /// The values of [builder], [maintainState], and [fullScreenDialog] must not
  /// be null.
  HeroPageRoute({
    @required this.builder,
    RouteSettings settings,
    this.maintainState = true,
    bool fullscreenDialog = false,
  })  : assert(builder != null),
        assert(maintainState != null),
        assert(fullscreenDialog != null),
        assert(opaque),
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  /// Builds the primary contents of the route.
  final WidgetBuilder builder;

  @override
  final bool maintainState;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 800);

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) {
    return previousRoute is MaterialPageRoute || previousRoute is CupertinoPageRoute;
  }

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    // Don't perform outgoing animation if the next route is a fullscreen dialog.
    return (nextRoute is MaterialPageRoute && !nextRoute.fullscreenDialog) ||
        (nextRoute is CupertinoPageRoute && !nextRoute.fullscreenDialog);
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final Widget result = builder(context);
    assert(() {
      if (result == null) {
        throw FlutterError('The builder for route "${settings.name}" returned null.\n'
            'Route builders must never return null.');
      }
      return true;
    }());
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: result,
    );
  }

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    final PageTransitionsTheme theme = Theme.of(context).pageTransitionsTheme;
    return theme.buildTransitions<T>(this, context, animation, secondaryAnimation, child);
  }

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}
