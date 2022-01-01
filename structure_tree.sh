#!/bin/bash

# Use the tree command to display the project structure
# See: https://linux.die.net/man/1/tree for information
# To install tree run `brew install tree` on mac
# To install on linux run: `yum install tree` or `apt-get install tree` depending on your system
# This bash file will convert the output of the repository tree structure to a markdown file

set -e

markdown_tree=$(tree -a -L 2 -tf --noreport \
      -I "$(grep -hvE '^$|^#' $1/.gitignore|sed 's:/$::'|tr \\n '\|'| xargs -I{} echo '{}|README.md')" \
      --charset ascii $1 | \
      sed \
      -e 's:.*/README.md$::g' \
      -e 's:.*/structure.md$::g' \
      -e 's:.*ignore$::g' \
      -e 's:.*git.*::g' \
      -e '/^$/d' \
      -e 's/`/|/g' \
      -e 's/    |/|   |/g' \
      -e 's/|   /  /g' \
      -e 's/|--/-/g' \
      -e 's:- \(\(.*\)/\(.*\)\):- [\3](\1):g' \
      -e 's/\.md]/]/g' | \
      sort | \
      tail -n +2
)

printf "# Structure \n\n%s\n" "$markdown_tree"
