# Support policy

`hintful_prefs` mirrors the two `hintful` lines. Upgrade the two packages
together.

| Line | Dependency | SDK floor | Role |
|---|---|---|---|
| **1.x** | `hintful: ^1.0.0` | Dart 3.2 / Flutter 3.16 | **maintenance** — still alive for older Flutter |
| **2.x** | `hintful: ^2.0.0` | Dart 3.13 / Flutter 3.47 | **current** development (Material comes from `material_ui`) |

- 1.x keeps receiving bug-fix releases as 1.0.x from the `1.x` branch. Its
  public API is frozen; CI checks Flutter 3.47.0 and 3.50.0.
- 2.x is where new work happens; its CI also checks both SDKs.
- `SharedPreferencesHintStore`'s own API is unchanged between the lines — the
  major bump exists because `HintStore` types come from `hintful`.
