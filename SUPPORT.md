# Support policy — 1.x maintenance line

This branch is the **1.x line** of `hintful_prefs`: dependency `hintful:
^1.0.0`, Dart 3.2 / Flutter 3.16 floor. It is **alive and maintained**.

- Bug fixes and compatibility patches continue as 1.0.x from this branch;
  CI checks Flutter 3.47.0 and 3.50.0.
- Its public API is frozen (`SharedPreferencesHintStore` plus the re-exported
  `compareHintVersions`).
- It pairs with `hintful` 1.x, which remains the supported line for apps that
  cannot move to `material_ui` / Flutter 3.47+.

The forward line is `hintful_prefs` 2.x, which depends on `hintful` 2.x.
Both lines implement the same two-member `HintStore` contract.
