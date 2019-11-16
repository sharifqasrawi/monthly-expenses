import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/setting.dart';
import '../providers/settings.dart';
import '../widgets/drawer.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var _isLoading = false;
  var _isInit = true;
  final _form = GlobalKey<FormState>();

  var _setting = Setting(
    setTitle: '',
    setValue: '',
  );

  var _initValues = {
    'currency': '',
  };

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    try {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Settings>(context, listen: false)
          .addSetting(_setting)
          .then((_) {
        setState(() {
          _isLoading = false;
        });


        Navigator.of(context).pushReplacementNamed('/');
      });
    } catch (error) {
      await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('An Error Occured'),
                content: const Text('Sorry, something went wrong.'),
                actions: <Widget>[
                  FlatButton(
                    child: const Text('Okay'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ));
      setState(() {
        _isLoading = false;
      });
    }

    _setting =
        Setting(setTitle: _setting.setTitle, setValue: _setting.setValue);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _initValues['currency'] =
          Provider.of<Settings>(context, listen: false).getSettingValue('currency');
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'System Settings',
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveForm,
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 117, 155, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 88, 17, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(15),
                  child: Form(
                    key: _form,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: (InputDecoration(
                              labelText: 'Currency',
                            )),
                            initialValue: _initValues['currency'],
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Currency is required';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _setting = Setting(
                                setTitle: 'currency',
                                setValue: value,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
