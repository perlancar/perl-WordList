package WordListRole::FromArray;

# AUTHORITY
# DATE
# DIST
# VERSION

use Role::Tiny;
use Role::Tiny::With;

with 'WordListRole::FirstNextResetFromEach';
requires '_array';

sub each_word {
    my ($self, $code) = @_;

    my $array = $self->_array;
    for my $i (0 .. $#{$array}) {
        my $res = $code->($array->[$i]);
        last if defined $res && $res == -2;
    }
}

# STATS

1;
# ABSTRACT: Provide first_word(), next_word(), reset_iterator(), each_word() from _array()

=for Pod::Coverage .+

=head1 DESCRIPTION

This role can be used if you want to construct a dynamic wordlist module from an
array of words. You provide _array(), and this role will provide C<each_word()>,
C<first_word()>, C<next_word()>, C<reset_iterator()>.


=head1 REQUIRED METHODS

=head2 _array

Must return an arrayref of words.


=head1 PROVIDED METHODS

=head2 each_word

=head2 first_word

=head2 next_word

=head2 reset_iterator
