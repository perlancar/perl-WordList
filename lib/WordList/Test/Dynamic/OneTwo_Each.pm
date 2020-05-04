package WordList::Test::Dynamic::OneTwo_Each;

# AUTHORITY
# DATE
# DIST
# VERSION

use strict;

use WordList;
our @ISA = qw(WordList);

use Role::Tiny::With;
with 'WordListRole::FirstNextResetFromEach';

our $DYNAMIC = 1;

sub each_word {
    no warnings 'numeric';

    my ($self, $code) = @_;

    for ("one", "two") {
        my $ret = $code->($_);
        return undef if defined $ret && $ret == -2;
    }
}

# STATS

1;
# ABSTRACT: Wordlist that returns one, two (via implementing each_word())

=head1 DESCRIPTION
