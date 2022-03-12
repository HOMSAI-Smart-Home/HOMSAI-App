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

