import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:ui_challenge/constant/const.dart';
import 'package:ui_challenge/l10n/l10n.dart';
import 'package:ui_challenge/pages/home.dart';
import 'package:ui_challenge/pages/onboard/onboard.dart';
import 'package:ui_challenge/repositorys/upload.repository.dart';
import 'package:ui_challenge/services/auth.service.dart';
import 'package:ui_challenge/services/plant.service.dart';
import 'package:ui_challenge/services/profile.service.dart';
import 'package:ui_challenge/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'repositorys/auth.repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  localUser = await SharedPreferences.getInstance();
  runApp(const PlantHome());
}

class PlantHome extends StatelessWidget {
  const PlantHome({super.key});

  Widget _entrypoint() {
    if (localUser.getString('user_id') != null) {
      return HomePage(key: key);
    }
    return OnboardPage(key: key);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        Provider<UploadRepository>(create: (_) => UploadRepository()),
        Provider<AuthRepository>(create: (_) => AuthRepository()),
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<PlantService>(create: (_) => PlantService()),
        Provider<ProfileService>(create: (_) => ProfileService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        supportedLocales: L10n.all,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        theme: AppTheme.apptheme.copyWith(),
        home: CupertinoTheme(
          data: const CupertinoThemeData(
            brightness: Brightness.dark,
          ),
          child: _entrypoint(),
        ),
      ),
    );
  }
}
