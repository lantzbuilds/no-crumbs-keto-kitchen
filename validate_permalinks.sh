#!/bin/bash

RECIPE_DIR="./docs/_recipes"
missing=0

echo "Checking recipe files in $RECIPE_DIR for 'permalink'..."

for file in "$RECIPE_DIR"/*.md; do
  if ! grep -q "^permalink:" "$file"; then
    echo "❌ Missing permalink in: $file"
    missing=$((missing+1))
  else
    echo "✅ Found permalink in: $file"
  fi
done

if [ $missing -eq 0 ]; then
  echo "🎉 All recipe files have a permalink."
else
  echo "⚠️  $missing file(s) missing permalinks."
fi
