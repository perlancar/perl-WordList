package WordListBase;

use strict 'subs', 'vars';

# AUTHORITY
# DATE
# DIST
# VERSION

sub new {
    my $class = shift;

    # check for known and required parameters
    my %params = @_;
    my $param_spec = \%{"$class\::PARAMS"};
    for my $param_name (keys %params) {
        die "Unknown parameter '$param_name'" unless $param_spec->{$param_name};
    }
    for my $param_name (keys %$param_spec) {
        die "Missing required parameter '$param_name'"
            if $param_spec->{$param_name}{req} && !exists($params{$param_name});
        # apply default
        $params{$param_name} = $param_spec->{$param_name}{default}
            if !defined($params{$param_name}) &&
            exists $param_spec->{$param_name}{default};
    }

    bless {
        params => \%params,

        # we store this because applying roles to object will rebless the object
        # into some other package.
        orig_class => $class,
    }, $class;
}

1;
# ABSTRACT: WordList base class

=head1 DESCRIPTION

This base class only provides new() and nothing else.


=head1 METHODS

=head2 new


=head1 SEE ALSO

L<WordList>
