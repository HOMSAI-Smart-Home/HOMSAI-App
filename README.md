# Innover App

Innover Flutter application

## Used libraries

- charts_flutter: Material Design data/charts visualization library
- flutter_svg: Dart-native SVG rendering library
- intl: used for internationalization and localization facilities such as date/number formatting and parsing
- sqflite: used to persist and query data on the local device
- flutter_localizations: used to support localization
- http: used to consume HTTP resources
- get_it: service locator used to implement dependency injection
- shared_preferences: used to provide a persistent store for simple data
- flutter_native_splash: automatically generates iOS, Android, and Web-native code for customizing this native splash screen background color and splash image.
- rive: used to handle .riv animation file.
- formz: unified form representation in Dart. Formz aims to simplify form representation and validation in a generic way.
- rxdart: RxDart extends the capabilities of Dart Streams and StreamControllers.
- bloc: A dart package that helps implement the BLoC pattern.
- flutter_bloc: Widgets that make it easy to integrate blocs and cubits into Flutter. Built to work with package:bloc.
- bloc_concurrency: exposes custom event transformers inspired by ember concurrency. Built to work with bloc.
- equatable: Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code.
- super_rich_text: Handles boilerplate for rich text when you need to make a part of the text with a different font style
- flutter_web_auth: used for handling web authentication like google auth
- lan_scanner: allows discovering network devices in local network (LAN) via multi-threaded ICMP pings.
- network_info_plus: allows Flutter apps to discover network info and configure themselves accordingly.
- package_info_plus: provides an API for querying information about an application package.

## Localization files

Flutter generates localizations files on when building the app.

To generate Flutter localiztion files manually
```
flutter gen-l10n
```

## Linting

To run Flutter code analysis
```
flutter analyze
```

There is no automatic linting automatic fix.
You can simply look at linting errors in the Android Studio Dart Analysis section.

## Build

To build the release apk
```
flutter build apk --target {{path of Main.dart}} --release
```

### Pre-commit hook integration
This will perform the lint on every commit and will abort it in case of errors

In the root of the project run
```
cp pre-commit-hook .git/hooks/pre-commit
```

Then give permission with command
```
chmod +x .git/hooks/pre-commit
```

### Prepare-commit-msg hook integration
This will automatically prepend JIRA Ticket ID (branch name) on commit message

In the root of the project run
```
cp prepare-commit-msg .git/hooks/prepare-commit-msg
```

Then give permission with command
```
chmod +x .git/hooks/prepare-commit-msg
```

