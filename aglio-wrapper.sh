#!/bin/bash -eu
#
# aglio-wrapper.sh runs aglio on all .md files in a given input directory and
# writes the corresponding .html output files to a given output directory.

# --------------------
# Globals
# --------------------
input_dir=""
output_dir=""
local_assets=""
format_changelog=""
changelog_created=""
changelog_tmpl=${changelog_tmpl:-$(cat <<EOF
\\
# Group Navigation\\
\\
## Table of Contents\\
\\
 + [Service Overview](home.html)\\
 + [RESTful API Documentation](rest.html)\\
 + [Thrift API Documentation](thrift.html)\\
 + [Changelog](changelog.html) ([PDF](changelog.pdf))\\
\\
\\
# Group Changelog
EOF
)}


# --------------------
# Functions
# --------------------

# Prints script usage message.
print_usage() {
  echo "Usage: -i <input dir> -o <output dir> [-l]" 1>&2;
}


# --------------------
# CLI
# --------------------

# Note: place a colon after every option for which there should be an additional
# option argument (e..g, -i <indir> means "i:").
while getopts "i:o:lc" opt; do
  case $opt in
    i)
      input_dir=$OPTARG
      ;;
    o)
      output_dir=$OPTARG
      ;;
    l)
      local_assets="-t olio-local --theme-style default --theme-style /aglio/templates/cte.less"
      ;;
    c)
      format_changelog="true"
  esac
done

# Verify that required command-line options were specified. Note that we are
# using -z to test for empty string, use ${x// } to remove all spaces.
if [[ (-z "${input_dir// }") || (-z "${output_dir// }") ]]; then
  print_usage
  exit 1;
fi

# Verify that specified directories exist
if [ ! -d "$input_dir" ]; then
  echo "Error: can't read directory: '$input_dir'"
  exit 1;
fi

if [ ! -z "$output_dir" ]; then
  mkdir -p $output_dir
fi

if [ ! -d "$output_dir" ]; then
  echo "Error: can't read directory: '$output_dir'"
  exit 1;
fi

# format changelong for use with Aglio
if [ -n "$format_changelog" ] && [ ! -f "$input_dir/changelog.md" ]; then
  changelog_created="true"

  if [ -f "$input_dir/CHANGELOG" ]; then
    sed "2i\\
  $changelog_tmpl\\
" $input_dir/CHANGELOG > $input_dir/changelog.md
  else
    echo "WARNING: CHANGELOG does not exist!"
  fi
fi

# Loop over *.md files in input directory
for input_file_path in $input_dir/*.md; do
  if [[ "$input_file_path" == "$input_dir/*.md" ]]; then
    echo "No files matching pattern '$input_dir/*.md'"
    break
  fi

  input_filename=$(basename "$input_file_path")
  input_extension="${input_filename##*.}"
  input_filename="${input_filename%.*}"
  output_file_path="$output_dir/$input_filename.html"

  echo "Running 'aglio $local_assets -i $input_file_path -o $output_file_path..."
  aglio $local_assets -i $input_file_path -o $output_file_path
done

# cleanup generated changelog
if [ -n "$format_changelog" ] && [ -n "$changelog_created" ]; then
  if [ -f $input_dir/changelog.md ]; then
    rm $input_dir/changelog.md
  fi
fi

# copy in local assets
if [ ! -z "$local_assets" ]; then
  for d in css js fonts; do
    cp -R /aglio/assets/$d $output_dir
    chmod -R ugo+rw $output_dir/$d
    chmod ugo+x $output_dir/$d
  done

  cp /aglio/assets/googlewebfonts/googlewebfonts.css $output_dir

  # loosen permissions of static assets
  chmod ugo+rw $output_dir/googlewebfonts.css
fi
