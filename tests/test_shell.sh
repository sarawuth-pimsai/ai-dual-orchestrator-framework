#!/usr/bin/env bash
set -eu
root=$(cd "$(dirname "$0")/.." && pwd)
tmp=$(mktemp -d "${TMPDIR:-/tmp}/framework-shell-test.XXXXXXXX")
trap 'rm -rf "$tmp"' EXIT
cli="$root/bin/ai-framework"
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
run init project "$tmp/project" --commit "$c1" --sha256 "$h1" --archive "$tmp/one.zip"
printf 'decision\n' > "$tmp/project/decision.md"
printf 'no\n' | run framework update "$tmp/project" --commit "$c2" --sha256 "$h2" --archive "$tmp/two.zip"
[ "$(cat "$tmp/project/.ai-framework/VERSION")" = "$c1" ]
printf 'yes\n' | run framework update "$tmp/project" --commit "$c2" --sha256 "$h2" --archive "$tmp/two.zip"
[ "$(cat "$tmp/project/.ai-framework/VERSION")" = "$c2" ]
printf 'yes\n' | run framework update "$tmp/project" --commit "$c1" --sha256 "$h1" --archive "$tmp/one.zip"
[ "$(cat "$tmp/project/.ai-framework/VERSION")" = "$c1" ]
[ "$(cat "$tmp/project/decision.md")" = decision ]
printf 'local edit\n' > "$tmp/project/AGENTS.md"
if printf 'yes\n' | run framework update "$tmp/project" --commit "$c2" --sha256 "$h2" --archive "$tmp/two.zip" 2>/dev/null; then exit 1; fi
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
if printf 'yes\n' | PATH="$tmp/fakebin:$PATH" run framework update "$tmp/recovery" --commit "$c2" --sha256 "$h2" --archive "$tmp/two.zip" 2>/dev/null; then exit 1; fi
[ "$(cat "$tmp/recovery/.ai-framework/VERSION")" = "$c1" ]
run init project "$tmp/recovery" --commit "$c1" --sha256 "$h1" --archive "$tmp/one.zip"
printf 'Shell integration tests passed: init, repeat, conflicts, integrity, symlinks, preview/cancel, update, rollback, write recovery.\n'
