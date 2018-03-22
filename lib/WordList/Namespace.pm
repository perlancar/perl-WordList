package WordList::Namespace;

# DATE
# VERSION

use strict;
use warnings;

use Exporter 'import';
our @EXPORT_OK = qw(is_actual_wordlist_module);

our %WordList_Modules = (
);

our %WordList_Namespaces = (
    'WordList::Char'            => 1,
    'WordList::Phrase'          => 1,
    'WordList::Password'        => 1,
    'WordList::MetaSyntactic'   => 1,
);

our $WordList_Namespaces_RE = join(
    '|', map {quotemeta} sort {length($b) <=> length($a)}
        keys %WordList_Namespaces);
$WordList_Namespaces_RE =
    qr/\A(?:$WordList_Namespaces_RE)(?:::|\z)/;

our %Non_WordList_Modules = (
    'WordList'                  => 1,
    'WordList::Namespace'       => 1, # us!
    'WordList::MetaSyntactic'   => 1, # base class for WordList::MetaSyntactic::*
);

our %Non_WordList_Namespaces = (
    'WordList::Role'            => 1, # addons/roles
    'WordList::Bloom'           => 1, # to store bloom filters
);

our $Non_WordList_Namespaces_RE = join(
    '|', map {quotemeta} sort {length($b) <=> length($a)}
        keys %Non_WordList_Namespaces);
$Non_WordList_Namespaces_RE =
    qr/\A(?:$Non_WordList_Namespaces_RE)(?:::|\z)/;

sub is_actual_wordlist_module {
    my $mod = shift;

    $mod =~ /\AWordList::/ or return 0;
    $WordList_Modules{$mod} and return 3;
    $Non_WordList_Modules{$mod} and return 0;
    $mod =~ $WordList_Namespaces_RE and return 2;
    $mod =~ $Non_WordList_Namespaces_RE and return 0;
    1;
}

1;
# ABSTRACT: Catalog of WordList::* namespaces

=head1 DESCRIPTION

This module might be useful if you want to know exactly which C<WordList::*>
modules actually contain a word list and which contain something else. Initially
all C<WordList::*> were actual wordlists, but some modules under this namespace
end up being used for something else.

=head1 FUNCTIONS

=head2 is_actual_wordlist_module


=head1 SEE ALSO

Some modules that are known to use this module: L<App::wordlist>.
