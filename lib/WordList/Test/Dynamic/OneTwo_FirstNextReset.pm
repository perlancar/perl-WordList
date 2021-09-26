package WordList::Test::Dynamic::OneTwo_FirstNextReset;

use strict;

use WordList;
our @ISA = qw(WordList);

use Role::Tiny::With;
with 'WordListRole::EachFromFirstNextReset';

# AUTHORITY
# DATE
# DIST
# VERSION

our $DYNAMIC = 1;

sub reset_iterator {
    my $self = shift;
    $self->{_iterator_idx} = 0;
}

sub first_word {
    my $self = shift;
    $self->reset_iterator;
    $self->next_word;
}

sub next_word {
    my $self = shift;
    $self->{_iterator_idx} = 0 unless defined $self->{_iterator_idx};

    $self->{_iterator_idx}++;
    if    ($self->{_iterator_idx} == 1) { return "one" }
    elsif ($self->{_iterator_idx} == 2) { return "two" }
    else { return undef } ## no critic: Subroutines::ProhibitExplicitReturnUndef
}

# STATS

1;
# ABSTRACT: Wordlist that returns one, two (via implementing first_word(), next_word(), and reset_iterator())

=head1 DESCRIPTION
