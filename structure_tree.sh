#!/bin/bash

set -e

markdown=$(tree -a -L 2 -tf --noreport \
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
      tail -n +2
)

# The output is then returned with a trailing newline character.
printf "# Structure \n\n%s\n" "$markdown"
