package WordList::Namespace;

# DATE
# VERSION

use strict;
use warnings;

use Exporter 'import';
our @EXPORT_OK = qw(is_actual_wordlist_module);

our %Non_WordList_Modules = (
    'WordList'                  => 1,
    'WordList::Namespace'       => 1, # us!
    'WordList::MetaSyntactic'   => 1, # base class for WordList::MetaSyntactic::*
);

our %Non_WordList_Namespaces = (
    'WordList::Role'            => 1,
);

our $Non_WordList_Namespaces_RE = join(
    '|', map {quotemeta} sort {length($b) <=> length($a)}
        keys %Non_WordList_Namespaces);
$Non_WordList_Namespaces_RE =
    qr/\A(?:$Non_WordList_Namespaces_RE)(?:::|\z)/;

sub is_actual_wordlist_module {
    my $mod = shift;

    $mod =~ /\AWordList::/ or return 0;
    $Non_WordList_Modules{$mod} and return 0;
    $mod =~ $Non_WordList_Namespaces_RE and return 0;
    1;
}

# ABSTRACT: List WordList::* namespaces

=head1 DESCRIPTION

This module might be useful if you want to know exactly which C<WordList::*>
modules actually contain a word list and which contain something else. Initially
all C<WordList::*> were actual wordlists, but some modules under this namespace
end up being used for something else.

=head1 SE

=head1 SEE ALSO

Some modules that are known to use this module: L<App::wordlist>.
