package WordList::Test::Dynamic::OneTwo_FirstNextReset;

# AUTHORITY
# DATE
# DIST
# VERSION

use strict;

use WordList;
our @ISA = qw(WordList);

use Role::Tiny::With;
with 'WordListRole::EachFromFirstNextReset';

our $DYNAMIC = 1;

sub reset_iterator {
    my $self = shift;
    $self->[0] = 0;
}

sub first_word {
    my $self = shift;
    $self->reset_iterator;
    $self->next_word;
}

sub next_word {
    my $self = shift;
    $self->[0] = 0 unless defined $self->[0];

    $self->[0]++;
    if    ($self->[0] == 1) { return "one" }
    elsif ($self->[0] == 2) { return "two" }
    else { return undef }
}

# STATS

1;
# ABSTRACT: Wordlist that returns one, two (via implementing first_word(), next_word(), and reset_iterator())

=head1 DESCRIPTION
