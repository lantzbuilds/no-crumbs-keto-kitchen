#!/bin/bash

# Set input and output paths
WIKI_DIR="./wiki"  # Change this to where your .wiki files are
POSTS_DIR="./docs/_posts"

# Create the output directory if it doesn't exist
mkdir -p "$POSTS_DIR"

# Date prefix (adjust this if needed)
DATE=$(date +%Y-%m-%d)

# Loop through all markdown files in the wiki directory
for file in "$WIKI_DIR"/*.md; do
  filename=$(basename "$file")
  title="${filename%.md}"
  slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-')
  new_filename="$POSTS_DIR/${DATE}-${slug}.md"

  echo "---" > "$new_filename"
  echo "layout: page" >> "$new_filename"
  echo "title: "$title"" >> "$new_filename"
  echo "---" >> "$new_filename"
  echo "" >> "$new_filename"
  cat "$file" >> "$new_filename"

  echo "Converted $file -> $new_filename"
done
