#!/usr/bin/env sh
# Symlink the dotfiles into place. Nothing that already exists is overwritten: anything in the way
# is reported and skipped, and the script exits non-zero so it is not missed.

status=0

link() {
    src=$1
    dest=$2
    # -ef compares what the link points at, so a trailing slash in the link doesn't matter (dash, bash and macOS sh support it)
    # shellcheck disable=SC3013
    if [ -L "$dest" ] && [ "$dest" -ef "$src" ]; then
        echo "ok: $dest"
    elif [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "skipped: $dest already exists and is not a link to $src" >&2
        status=1
    else
        ln -sv "$src" "$dest"
    fi
}

for f in ~/.dotfiles/linkables/*; do
    link "$f" ~/."$(basename "$f")"
done

mkdir -p ~/.config
for f in ~/.dotfiles/config/*; do
    link "$f" ~/.config/"$(basename "$f")"
done

exit "$status"
