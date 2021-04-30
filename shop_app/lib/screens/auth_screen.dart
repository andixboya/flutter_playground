import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

// url for signup
// web-api-key =>
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      // 264) cascade_operator (chain_operator)
                      // 264) also nice transform stuff!
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color: Theme.of(context).accentTextTheme.title.color,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    // 264) the widget form i think? Also a separate widget.
                    // its stateful!
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

// 281) SingleTickerProviderStateMixin (its a provider) necessary for animations to work
class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  // 264)  why did we need globalKey, i`ve forgotten..?
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;

  // 264) map , which will hold our data perhaps (a model would be nicer)
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  // 281) props for single animation or for the widget itself to be manipulated
  AnimationController _controller;
  Animation<Size> _heightAnimation;
  // 284) 2 additional different widgets with animations.
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

// 281) in initState the props necessary for animations are added!
  @override
  void initState() {
    super.initState();

    // 281) needs to be bound and holds info how FAST the transition will be done.
    _controller = AnimationController(
      // 281) with this you link the widget so that it can be manipulated.
      vsync: this,
      duration: Duration(
        // 281)  how much time will the transition take place perhaps?
        milliseconds: 300,
      ),
    );

    // this is to point which param is going to be manipulated i think? (size)
    // in our case size?
    // for now , not being used,  used by animatedContainer instead...
    _heightAnimation = Tween<Size>(
            // 281)  start and end states
            begin: Size(double.infinity, 260),
            end: Size(double.infinity, 320))
        // 281)  it needs to be started as well (with the below method)+
        // it needs its objectAnimation?
        .animate(
      CurvedAnimation(
        parent: _controller,
        // 281) this is how will the transition occur within the 300 miliseconds
        // in the below case probably inn the first 100mils. 70% of animation
        // and then in the rest 200 the 30% of the transition.
        curve: Curves.fastOutSlowIn,
      ),
    );
    // 281) (added at 281) necessary for the changes to be displayed and widget  to get rebuilt.
    // 282) (removed at 282) [imp/] here the listener will drop, because the AnimatedBuilder will listen instead!
    // _heightAnimation.addListener(() => setState(() {}));

// 283) [imp/] here the rest of the animations are initialized
// // 283) beginning + end (of different animation)
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      // to which controller its linked (the animation)
      // // 283) what is the transition
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // 281) also any controller needs to be disposed of!
    _controller.dispose();
  }

  // 266) turn it into async
  void _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
        // Log user in
      } else {
        // Sign user up
        // 266) add listener for data here but don`t trigger changes, because you need just the data!
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'],
          _authData['password'],
        );
      }
      // 268) how to catch errrosr with different syntax? ( or maybe separte instead of catch, which gets everything)
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  // opening of dialog, which will display the error with 2 close buttons.
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
//283) here the transitions need to be switched as well! otherwise nothing will happen
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    // the option with animatedBuilder (from 281)
    // final builderOption = AnimatedBuilder(
    //   animation: _heightAnimation,
    //   // 282) With animatedBuilder only the container is the one that gets rebuilt!
    //   // [imp/] while its child context is passed into the container and the child is left unchanged!
    //   builder: (ctx, ch) => Container(
    //     // 281) as if now it will be done via animation
    //     // this is a dynamic height, which will trigger rebuilds.
    //     // [imp/] *** problem is that this rebuilds the whole widget tree, instead only the container should be rebuilt!
    //     height: _heightAnimation.value.height,
    //     constraints:
    //         // 281) also necessary here:
    //         // beforehand was this _authMode == AuthMode.Signup ? 320 : 260 which triggers instant change (without transition)
    //         BoxConstraints(minHeight: _heightAnimation.value.height),
    //     width: deviceSize.width * 0.75,
    //     padding: EdgeInsets.all(16.0),
    //     child: ch,
    //   ),
    //   // 282) here the info, within the container is left unbuilt, as only the height needs to be rebuilt!
    //   // the pattern is like consumer !
    //   child: Form(
    //     key: _formKey,
    //     child: SingleChildScrollView(
    //       child: Column(
    //         children: <Widget>[
    //           TextFormField(
    //             decoration: InputDecoration(labelText: 'E-Mail'),
    //             keyboardType: TextInputType.emailAddress,
    //             validator: (value) {
    //               if (value.isEmpty || !value.contains('@')) {
    //                 return 'Invalid email!';
    //               }
    //               return null;
    //             },
    //             // 264) submit of data.
    //             onSaved: (value) {
    //               _authData['email'] = value;
    //             },
    //           ),
    //           TextFormField(
    //             decoration: InputDecoration(labelText: 'Password'),
    //             obscureText: true,
    //             controller: _passwordController,
    //             validator: (value) {
    //               if (value.isEmpty || value.length < 5) {
    //                 return 'Password is too short!';
    //               }
    //             },
    //             onSaved: (value) {
    //               _authData['password'] = value;
    //             },
    //           ),
    //           if (_authMode == AuthMode.Signup)
    //             TextFormField(
    //               enabled: _authMode == AuthMode.Signup,
    //               decoration: InputDecoration(labelText: 'Confirm Password'),
    //               obscureText: true,
    //               validator: _authMode == AuthMode.Signup
    //                   ? (value) {
    //                       if (value != _passwordController.text) {
    //                         return 'Passwords do not match!';
    //                       }
    //                     }
    //                   : null,
    //             ),
    //           SizedBox(
    //             height: 20,
    //           ),
    //           if (_isLoading)
    //             CircularProgressIndicator()
    //           else
    //             RaisedButton(
    //               child:
    //                   Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
    //               onPressed: _submit,
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(30),
    //               ),
    //               padding:
    //                   EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
    //               color: Theme.of(context).primaryColor,
    //               textColor: Theme.of(context).primaryTextTheme.button.color,
    //             ),
    //           FlatButton(
    //             child: Text(
    //                 '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
    //             onPressed: _switchAuthMode,
    //             padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
    //             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //             textColor: Theme.of(context).primaryColor,
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      // 283) the option with animated container, it holds the logic of the above builder!
      // 283) it probably rebuilts itself alone. No need for explanation that the child should not be rebuilt.
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        // 283)  here the params are kept too
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  // 264) submit of data.
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                // 283) here for the third field, animations are added (fading(fading_widget) + collapsing one(animated_container))
                // instead of just using plain if statement for rendering of widget.
                AnimatedContainer(
                  constraints: BoxConstraints(
                    // 283) here the check is actually done, which is related to the collapsing
                    // of the elements.
                    minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                    maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
                  ),
                  // 283) here the duration
                  duration: Duration(milliseconds: 300),
                  // 283) and here how it transitions.
                  curve: Curves.easeIn,
                  // i`ll leave a simple animated, because it gets messed up for some reason
                  // not worth debugging.
                  child: TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                          }
                        : null,
                  ),

                  // form could be here as well as child!
                  // child: FadeTransition(
                  //   opacity: _opacityAnimation,
                  //   child:
                  //   // slide works, fade ... perhaps not?
                  //    SlideTransition(
                  //     position: _slideAnimation,
                  //     child:),
                  // ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
