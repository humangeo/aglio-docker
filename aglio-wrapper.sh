#!/bin/bash
#
# aglio-wrapper.sh is a wrapper script that allows you run aglio on all .md files
# in a directory and write out corresponding .html files to an output directory.
#

print_usage() {
	echo "Usage: -i <input dir> -o <output dir> [-l]"
}

input_dir=""
output_dir=""
local_assets=""

# Note: place a colon after every option for which there should be an additional
# option argument (e..g, -i <indir> means "i:").
while getopts "i:o:l" opt; do
	case $opt in
		i)  input_dir=$OPTARG
			;;
		o)  output_dir=$OPTARG
			;;
        l) local_assets="--theme-template /aglio/templates/index.jade"
           ;;
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

if [ ! -d "$output_dir" ]; then
	echo "Error: can't read directory: '$output_dir'"
	exit 1;
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

# copy in local assets
if [ ! -z "$local_assets" ]; then
  cp -R /aglio/assets/css $output_dir
  cp -R /aglio/assets/fonts $output_dir
fi
