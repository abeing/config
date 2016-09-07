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

import random

DESIRED_FOCUS = 4


def is_ignored_achievement(achievement):
    """True if this achievement is to be ignored."""
    return achievement[0] == '#' or achievement[0] == '*'


def is_focused_achievement(achievement):
    """True if this achievement has been marked for focus."""
    return achievement[0] == '!'


def process_datafile(data_filename):
    """Read achievements from data file. Ignore disabled achievements and
    focus focued achievements."""
    focus_achievements = []
    other_achievements = []
    with open(data_filename, 'r') as datafile:
        for achievement in datafile:
            achievement = achievement.rstrip()
            if len(achievement) == 0:
                continue
            if is_focused_achievement(achievement):
                focus_achievements.append(achievement)
            elif not is_ignored_achievement(achievement):
                other_achievements.append(achievement)
    datafile.close()
    while len(focus_achievements) < DESIRED_FOCUS:
        focus_achievements.append(random.choice(other_achievements))
    return focus_achievements


def main():
    focus_achievements = process_datafile("aephos.data")
    for achievement in focus_achievements:
        print achievement


if __name__ == "__main__":
    main()
