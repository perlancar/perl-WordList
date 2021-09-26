package WordList::Test::Dynamic::OneTwo_EachParam;

use strict;

use WordList::Test::Dynamic::OneTwo_Each;
our @ISA = qw(WordList::Test::Dynamic::OneTwo_Each);

use Role::Tiny::With;
with 'WordListRole::FirstNextResetFromEach';

# AUTHORITY
# DATE
# DIST
# VERSION

our $DYNAMIC = 1;

our %PARAMS = (
    foo => {
        summary => 'Just a dummy, required parameter',
        schema => 'str*',
        req => 1,
    },
);

1;
# ABSTRACT: Wordlist that returns one, two (via implementing each_word())

=head1 DESCRIPTION

Just like L<WordList::Test::Dynamic::OneTwo_Each>, except it accepts a required
parameter (C<foo>).
