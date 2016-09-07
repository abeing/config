# Find four achievements on which to focus.

# Read every line in the input file. Put each line into an array unless it
# starts with '#', '*' or '!'. Lines that start with '#' are comments to be
# ignored. Lines that start with '*' are black-holed achievements to be
# ignored. Lines that start with '!' are focused achievements and should be
# added to the focus list immediately.
#
# Once every line is read, if the number of achievements in the focus list is
# less than the desired number, select random achievements and add them to the
# list until the desired number are focused.
#
# Output to standard out the list of focused achievements.


def read_datafile(data_filename, achievements):
    """Read achievements from data file. Ignore disabled achievements and
    focus focued achievements."""
    with open(data_filename, 'r') as datafile:
        for line in datafile:
            achievements.append(line)
    datafile.close()
