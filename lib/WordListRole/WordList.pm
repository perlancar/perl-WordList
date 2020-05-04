package WordListRole::WordList;

# AUTHORITY
# DATE
# DIST
# VERSION

use Role::Tiny;

requires 'new';
requires 'each_word';
requires 'first_word';
requires 'next_word';
requires 'reset_iterator';
requires 'pick';
requires 'word_exists';
requires 'all_words';

1;
# ABSTRACT: The WordList methods
