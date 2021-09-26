package WordListRole::EachFromFirstNextReset;

use Role::Tiny;

requires 'first_word';
requires 'next_word';
requires 'reset_iterator';

# AUTHORITY
# DATE
# DIST
# VERSION

sub each_word {
    no warnings 'numeric';

    my ($self, $code) = @_;

    $self->reset_iterator;
    my $word = $self->first_word;
    return undef unless defined $word; ## no critic: Subroutines::ProhibitExplicitReturnUndef
    my $ret = $code->($word);
    return undef if defined $ret && $ret == -2; ## no critic: Subroutines::ProhibitExplicitReturnUndef
    while (1) {
        $word = $self->next_word;
        return undef unless defined $word; ## no critic: Subroutines::ProhibitExplicitReturnUndef
        $ret = $code->($word);
        return undef if defined $ret && $ret == -2; ## no critic: Subroutines::ProhibitExplicitReturnUndef
    }
}

1;
# ABSTRACT: Provide each_word(); relies on first_word(), next_word(), reset_iterator()

=for Pod::Coverage .+

=head1 DESCRIPTION

This role can be used if you want to construct a dynamic wordlist module by
providing providing C<first_word()>, C<next_word()>, C<reset_iterator()>. This
role will add an C<each_word()> method that uses the former three methods.


=head1 REQUIRED METHODS

=head2 first_word

=head2 next_word

=head2 reset_iterator


=head1 PROVIDED METHODS

=head2 each_word


=head1 SEE ALSO

L<WordListRole::FirstNextResetFromEach>
