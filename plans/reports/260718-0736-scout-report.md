---
title: Codebase Scout Report
date: 2026-07-18
author: Antigravity
type: report
---

# Scout Report

An initial survey of the codebase structure and key modules in the **student_management** repository was performed.

## Relevant Files

### 1. App Configuration & Entrypoint
* [student_management/pubspec.yaml](file:///home/james/Projects/PE-PRM/PRM393_PE_SE181521/student_management/pubspec.yaml) - Declares dependencies including `sqflite`, `google_sign_in`, `google_maps_flutter`, and `geocoding`.
* [student_management/lib/main.dart](file:///home/james/Projects/PE-PRM/PRM393_PE_SE181521/student_management/lib/main.dart) - Entrypoint setting up MaterialApp, light/dark themes, and launching [LoginScreen](file:///home/james/Projects/PE-PRM/PRM393_PE_SE181521/student_management/lib/screens/login_screen.dart#L5).

### 2. Database & Models
* [student_management/lib/db/database_helper.dart](file:///home/james/Projects/PE-PRM/PRM393_PE_SE181521/student_management/lib/db/database_helper.dart) - Initializes the SQLite database, contains table schemas (`Student`, `Major`), seeds initial data, and provides helper CRUD functions.
* [student_management/lib/models/major.dart](file:///home/james/Projects/PE-PRM/PRM393_PE_SE181521/student_management/lib/models/major.dart) - Defines the [Major](file:///home/james/Projects/PE-PRM/PRM393_PE_SE181521/student_management/lib/models/major.dart#L1) model with `toMap` and `fromMap` mappings.
* [student_management/lib/models/student.dart](file:///home/james/Projects/PE-PRM/PRM393_PE_SE181521/student_management/lib/models/student.dart) - Defines the [Student](file:///home/james/Projects/PE-PRM/PRM393_PE_SE181521/student_management/lib/models/student.dart#L1) model with `toMap` and `fromMap` mappings.

### 3. User Interface / Screens
* [student_management/lib/screens/login_screen.dart](file:///home/james/Projects/PE-PRM/PRM393_PE_SE181521/student_management/lib/screens/login_screen.dart) - Handles Google Sign-In and offers a quick bypass test button.
* [student_management/lib/screens/home_screen.dart](file:///home/james/Projects/PE-PRM/PRM393_PE_SE181521/student_management/lib/screens/home_screen.dart) - Implements a BottomNavigationBar switching between student list and major list screens.
* [student_management/lib/screens/student_list_screen.dart](file:///home/james/Projects/PE-PRM/PRM393_PE_SE181521/student_management/lib/screens/student_list_screen.dart) - Renders the list of students with options to edit, delete, or view their addresses on the map.
* [student_management/lib/screens/student_form_screen.dart](file:///home/james/Projects/PE-PRM/PRM393_PE_SE181521/student_management/lib/screens/student_form_screen.dart) - Manage form fields for adding or editing student details, validating entries, picking dates, and matching dropdown options.
* [student_management/lib/screens/major_list_screen.dart](file:///home/james/Projects/PE-PRM/PRM393_PE_SE181521/student_management/lib/screens/major_list_screen.dart) - Renders the list of majors with editing/deleting controls.
* [student_management/lib/screens/major_form_screen.dart](file:///home/james/Projects/PE-PRM/PRM393_PE_SE181521/student_management/lib/screens/major_form_screen.dart) - Form screen to add/edit major details.
* [student_management/lib/screens/map_screen.dart](file:///home/james/Projects/PE-PRM/PRM393_PE_SE181521/student_management/lib/screens/map_screen.dart) - Converts student addresses into lat/long coordinates using geocoding and displays a marker on a Google Map.

### 4. Tests
* [student_management/test/widget_test.dart](file:///home/james/Projects/PE-PRM/PRM393_PE_SE181521/student_management/test/widget_test.dart) - Generated boilerplate widget counter test (fails because it relies on code templates that do not exist).

## Unresolved Questions
* **Google Sign-In Configuration**: The codebase does not contain `google-services.json` which is required for Google Sign-In to function properly on Android. We need to verify if the client intends to run the app with Google Sign-In or relies on the "Quick Login" bypass for local testing.
* **Maps API Key Restrictions**: The Google Maps API key in [AndroidManifest.xml](file:///home/james/Projects/PE-PRM/PRM393_PE_SE181521/student_management/android/app/src/main/AndroidManifest.xml#L14) is hardcoded. It needs to be verified whether this key is valid and restricted appropriately.
