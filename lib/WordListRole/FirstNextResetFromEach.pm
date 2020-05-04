package WordListRole::FirstNextResetFromEach;

# AUTHORITY
# DATE
# DIST
# VERSION

use Role::Tiny;

requires 'each_word';

sub first_word {
    my $self = shift;

    $self->reset_iterator;
    $self->next_word;
}

sub next_word {
    my $self = shift;

    unless ($self->[1]) {
        my @wordlist;
        $self->each_word(sub { push @wordlist, $_[0] });
        $self->[1] = \@wordlist;
    }
    $self->[0] = 0 unless defined $self->[0];

    return undef if $self->[0] > $#{ $self->[1] };
    $self->[1][ $self->[0]++ ];
}

sub reset_iterator {
    my $self = shift;

    $self->[0] = 0;
}

1;
# ABSTRACT: Provide first_word(), next_word(), reset_iterator(); relies on each_word()

=head1 DESCRIPTION

This role can be used if you want to construct a dynamic wordlist module by
providing C<each_word()>. This role will provide the C<first_word()>,
C<next_word()>, C<reset_iterator()> that uses C<each_word()>.
