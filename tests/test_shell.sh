#!/usr/bin/env bash
set -eu
root=$(cd "$(dirname "$0")/.." && pwd)
tmp=$(mktemp -d "${TMPDIR:-/tmp}/framework-shell-test.XXXXXXXX")
trap 'rm -rf "$tmp"' EXIT
cli="$root/bin/ai-framework"
[ "$("$cli" --version)" = 'ai-framework 1.4.0' ]
[ "$("$cli" version)" = 'ai-framework 1.4.0' ]
if "$cli" --version unexpected >/dev/null 2>&1; then exit 1; fi
"$cli" --help | rg -q 'project update'
"$cli" help | rg -q 'init project'
"$cli" project update --help | rg -q 'confirmation'
if "$cli" framework update . >/dev/null 2>&1; then exit 1; fi
mkdir -p "$tmp/source/framework"
cp "$root/AGENTS.md" "$root/GOVERNANCE.md" "$root/USAGE.md" "$tmp/source/framework/"
cp -R "$root/roles" "$root/protocols" "$root/templates" "$tmp/source/framework/"
(cd "$tmp/source" && zip -qr "$tmp/one.zip" framework)
hash() { if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | awk '{print $1}'; else shasum -a 256 "$1" | awk '{print $1}'; fi; }
h1=$(hash "$tmp/one.zip"); c1=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
printf '\nnew version\n' >> "$tmp/source/framework/GOVERNANCE.md"
(cd "$tmp/source" && zip -qr "$tmp/two.zip" framework)
h2=$(hash "$tmp/two.zip"); c2=bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
run() { "$cli" "$@" >/dev/null; }
run init project "$tmp/project" --commit "$c1" --sha256 "$h1" --archive "$tmp/one.zip"
mkdir "$tmp/default-dir"
(cd "$tmp/default-dir" && run init project --commit "$c1" --sha256 "$h1" --archive "$tmp/one.zip")
[ "$(cat "$tmp/default-dir/.ai-framework/VERSION")" = "$c1" ]
(cd "$tmp/default-dir" && printf 'yes\n' | run project update --commit "$c2" --sha256 "$h2" --archive "$tmp/two.zip")
[ "$(cat "$tmp/default-dir/.ai-framework/VERSION")" = "$c2" ]
mkdir "$tmp/tagbin"
cat > "$tmp/tagbin/git" <<EOF
#!/usr/bin/env bash
printf '%s\\t%s\\n' '$c2' 'refs/tags/v1.0.0' '$c1' 'refs/tags/v1.0.0^{}'
EOF
chmod +x "$tmp/tagbin/git"
cat > "$tmp/tagbin/curl" <<'EOF'
#!/usr/bin/env bash
while [ "$#" -gt 0 ]; do
  if [ "$1" = -o ]; then cp "$TEST_RELEASE_ZIP" "$2"; exit; fi
  shift
done
printf '%s' "${TEST_LATEST_URL:-https://github.com/sarawuth-pimsai/ai-dual-orchestrator-framework/releases/tag/v1.0.0}"
EOF
chmod +x "$tmp/tagbin/curl"
PATH="$tmp/tagbin:$PATH" run init project "$tmp/versioned" --version v1.0.0 --sha256 "$h1" --archive "$tmp/one.zip"
[ "$(cat "$tmp/versioned/.ai-framework/VERSION")" = "$c1" ]
PATH="$tmp/tagbin:$PATH" run init project "$tmp/latest" --sha256 "$h1" --archive "$tmp/one.zip"
[ "$(cat "$tmp/latest/.ai-framework/VERSION")" = "$c1" ]
run init project "$tmp/latest-update" --commit "$c2" --sha256 "$h2" --archive "$tmp/two.zip"
printf 'yes\n' | PATH="$tmp/tagbin:$PATH" run project update "$tmp/latest-update" --sha256 "$h1" --archive "$tmp/one.zip"
[ "$(cat "$tmp/latest-update/.ai-framework/VERSION")" = "$c1" ]
printf 'v1.0.0 %s %s\n' "$c1" "$h1" > "$tmp/trusted-releases"
AI_FRAMEWORK_TRUST_FILE="$tmp/trusted-releases" TEST_RELEASE_ZIP="$tmp/one.zip" PATH="$tmp/tagbin:$PATH" run init project "$tmp/simple"
[ "$(cat "$tmp/simple/.ai-framework/VERSION")" = "$c1" ]
if AI_FRAMEWORK_TRUST_FILE="$tmp/missing-trust" PATH="$tmp/tagbin:$PATH" run init project "$tmp/untrusted" 2>/dev/null; then exit 1; fi
[ ! -e "$tmp/untrusted" ]
printf 'v1.0.0 %s %s\n' "$c2" "$h1" > "$tmp/wrong-trust"
if AI_FRAMEWORK_TRUST_FILE="$tmp/wrong-trust" PATH="$tmp/tagbin:$PATH" run init project "$tmp/wrong-tag" 2>/dev/null; then exit 1; fi
[ ! -e "$tmp/wrong-tag" ]
if AI_FRAMEWORK_TRUST_FILE="$tmp/trusted-releases" TEST_RELEASE_ZIP="$tmp/two.zip" PATH="$tmp/tagbin:$PATH" run init project "$tmp/wrong-asset" 2>/dev/null; then exit 1; fi
[ ! -e "$tmp/wrong-asset" ]
if TEST_LATEST_URL=https://example.com/tag/v1.0.0 PATH="$tmp/tagbin:$PATH" run init project "$tmp/badlatest" --sha256 "$h1" --archive "$tmp/one.zip" 2>/dev/null; then exit 1; fi
[ ! -e "$tmp/badlatest" ]
if PATH="$tmp/tagbin:$PATH" run init project "$tmp/latest-wrong" --sha256 "$(printf '%064d' 0)" --archive "$tmp/one.zip" 2>/dev/null; then exit 1; fi
[ ! -e "$tmp/latest-wrong" ]
if PATH="$tmp/tagbin:$PATH" run init project "$tmp/badversion" --version invalid --sha256 "$h1" --archive "$tmp/one.zip" 2>/dev/null; then exit 1; fi
if PATH="$tmp/tagbin:$PATH" run init project "$tmp/both" --version v1.0.0 --commit "$c1" --sha256 "$h1" --archive "$tmp/one.zip" 2>/dev/null; then exit 1; fi
run init project "$tmp/project" --commit "$c1" --sha256 "$h1" --archive "$tmp/one.zip"
printf 'decision\n' > "$tmp/project/decision.md"
printf 'no\n' | run project update "$tmp/project" --commit "$c2" --sha256 "$h2" --archive "$tmp/two.zip"
[ "$(cat "$tmp/project/.ai-framework/VERSION")" = "$c1" ]
printf 'yes\n' | run project update "$tmp/project" --commit "$c2" --sha256 "$h2" --archive "$tmp/two.zip"
[ "$(cat "$tmp/project/.ai-framework/VERSION")" = "$c2" ]
printf 'yes\n' | run project update "$tmp/project" --commit "$c1" --sha256 "$h1" --archive "$tmp/one.zip"
[ "$(cat "$tmp/project/.ai-framework/VERSION")" = "$c1" ]
[ "$(cat "$tmp/project/decision.md")" = decision ]
printf 'local edit\n' > "$tmp/project/AGENTS.md"
if printf 'yes\n' | run project update "$tmp/project" --commit "$c2" --sha256 "$h2" --archive "$tmp/two.zip" 2>/dev/null; then exit 1; fi
[ "$(cat "$tmp/project/AGENTS.md")" = 'local edit' ]
mkdir "$tmp/conflict"; printf 'existing\n' > "$tmp/conflict/CLAUDE.md"
if run init project "$tmp/conflict" --commit "$c1" --sha256 "$h1" --archive "$tmp/one.zip" 2>/dev/null; then exit 1; fi
[ "$(cat "$tmp/conflict/CLAUDE.md")" = existing ]
if run init project "$tmp/wrong" --commit "$c1" --sha256 "$(printf '%064d' 0)" --archive "$tmp/one.zip" 2>/dev/null; then exit 1; fi
[ ! -e "$tmp/wrong" ]
mkdir "$tmp/linkproject"; ln -s "$tmp" "$tmp/linkproject/.ai-framework"
if run init project "$tmp/linkproject" --commit "$c1" --sha256 "$h1" --archive "$tmp/one.zip" 2>/dev/null; then exit 1; fi
# Simulate a mid-write failure; the wrapper fails only the third move.
mkdir "$tmp/fakebin"
real_mv=$(command -v mv)
cat > "$tmp/fakebin/mv" <<WRAPPER
#!/usr/bin/env bash
n=0; [ ! -f "$tmp/count" ] || n=\$(cat "$tmp/count")
n=\$((n+1)); printf '%s' "\$n" > "$tmp/count"
[ "\$n" -ne 3 ] || exit 1
exec "$real_mv" "\$@"
WRAPPER
chmod +x "$tmp/fakebin/mv"
run init project "$tmp/recovery" --commit "$c1" --sha256 "$h1" --archive "$tmp/one.zip"
if printf 'yes\n' | PATH="$tmp/fakebin:$PATH" run project update "$tmp/recovery" --commit "$c2" --sha256 "$h2" --archive "$tmp/two.zip" 2>/dev/null; then exit 1; fi
[ "$(cat "$tmp/recovery/.ai-framework/VERSION")" = "$c1" ]
run init project "$tmp/recovery" --commit "$c1" --sha256 "$h1" --archive "$tmp/one.zip"
printf 'Shell integration tests passed: init, repeat, conflicts, integrity, symlinks, preview/cancel, update, rollback, write recovery.\n'
