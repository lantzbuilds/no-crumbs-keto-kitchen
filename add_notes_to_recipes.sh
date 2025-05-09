#!/bin/bash

POSTS_DIR="./docs/_posts"
RECIPES_DIR="./docs/_recipes"
tmpfile=$(mktemp)

for post in "$POSTS_DIR"/*.md; do
  filename=$(basename "$post")
  # Remove full YYYY-MM-DD- prefix to get the actual slug
  slug=$(echo "$filename" | sed 's/^20[0-9][0-9]-[0-9][0-9]-[0-9][0-9]-//')
  recipe_file="$RECIPES_DIR/$slug"

  if [ ! -f "$recipe_file" ]; then
    echo "⚠️ Skipping $filename — no matching file in _recipes"
    continue
  fi

  # Extract the '## Notes' section (from ## Notes to end or until next ##)
  awk '/^## Notes/{flag=1; next} /^## /{flag=0} flag' "$post" > "$tmpfile"

  if [ -s "$tmpfile" ]; then
    echo "📝 Adding notes from $filename to $recipe_file"

    # Format notes as YAML list items
    sed -e 's/^/  - /' "$tmpfile" > "${tmpfile}.yaml"

    # Inject into frontmatter
    awk -v notes_block="$(cat ${tmpfile}.yaml)" '
      BEGIN { in_frontmatter=0; inserted=0 }
      /^---/ {
        if (in_frontmatter == 1 && inserted == 0) {
          print "notes:"
          print notes_block
          inserted=1
        }
        in_frontmatter = 1 - in_frontmatter
      }
      { print }
    ' "$recipe_file" > "${recipe_file}.tmp" && mv "${recipe_file}.tmp" "$recipe_file"
  else
    echo "ℹ️ No notes found in $filename"
  fi
done

rm -f "$tmpfile" "${tmpfile}.yaml"
