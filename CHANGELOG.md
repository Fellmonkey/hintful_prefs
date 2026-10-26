# Changelog

## 1.0.1

- Add a minimal `example/` app showing `SharedPreferencesHintStore` in use.
- No library changes. This release re-triggers pub.dev's package analysis,
  which previously ran before `hintful` 1.0.0 was published and could not
  resolve the `hintful: ^1.0.0` dependency.

## 1.0.0

- Initial release: `SharedPreferencesHintStore` — the persistent
  `HintStore` for `hintful` over `shared_preferences` (namespaced keys under
  `hintful.`, fire-and-forget `markShown`, version-gated `shouldShow`).
- `clear()` — the debug/dev "forget every hint record under this prefix"
  tool (deliberately not part of the abstract `HintStore` contract).
- `shouldShow` delegates to `hintful`'s `HintStore.shouldShowVersion` — the
  gate `InMemoryHintStore` and `CallbackHintStore` call — so the version rule
  is not restated here and cannot drift from the core.
- `compareHintVersions()` — re-exported from `hintful` (the single segment-wise
  version ordering, `"1.10.0" > "1.9.0"`, and the comparison inside the gate
  above) for app-side store implementations.
