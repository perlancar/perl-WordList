package WordList;

# AUTHORITY
# DATE
# DIST
# VERSION

use strict 'subs', 'vars';

# IFUNBUILT
use Role::Tiny::With;
with 'WordListRole::WordList';
# END IFUNBUILT

sub new {
    my $class = shift;
    my $fh = \*{"$class\::DATA"};
    binmode $fh, "encoding(utf8)";
    unless (defined ${"$class\::DATA_POS"}) {
        ${"$class\::DATA_POS"} = tell $fh;
    }

    # check for known and required parameters
    my %params = @_;
    my $param_spec = \%{"$class\::PARAMS"};
    for my $param_name (keys %params) {
        die "Unknown parameter '$param_name'" unless $param_spec->{$param_name};
    }
    for my $param_name (keys %$param_spec) {
        die "Missing required parameter '$param_name'"
            if $param_spec->{$param_name}{req} && !exists($params{$param_name});
    }

    bless {
        params => \%params,

        # we store this because applying roles to object will rebless the object
        # into some other package.
        orig_class => $class,
    }, $class;
}

sub each_word {
    my ($self, $code) = @_;

    my $class = ref($self);

    my $fh = \*{"$class\::DATA"};

    seek $fh, ${"$class\::DATA_POS"}, 0;
    while (defined(my $word = <$fh>)) {
        chomp $word;
        my $res = $code->($word);
        last if defined $res && $res == -2;
    }
}

sub next_word {
    my $self = shift;

    my $class = ref($self);
    my $fh = \*{"$class\::DATA"};
    my $word = <$fh>;
    chomp $word if defined $word;
    $word;
}

sub reset_iterator {
    my $self = shift;

    my $class = ref($self);
    my $fh = \*{"$class\::DATA"};
    seek $fh, ${"$class\::DATA_POS"}, 0;
}

sub first_word {
    my $self = shift;

    $self->reset_iterator;
    $self->next_word;
}

sub pick {
    my ($self, $n, $allow_duplicates) = @_; # but this implementaiton never produces duplicates

    $n = 1 if !defined $n;
    die "Please specify a positive number of words to pick" if $n < 1;

    if ($n == 1) {
        my $i = 0;
        my $word;
        # algorithm from Learning Perl
        $self->each_word(
            sub {
                $i++;
                $word = $_[0] if rand($i) < 1;
            }
        );
        return $word;
    }

    my $i = 0;
    my @words;
    $self->each_word(
        sub {
            $i++;
            if (@words < $n) {
                # we haven't reached $n, put word to result in a random position
                splice @words, rand(@words+1), 0, $_[0];
            } else {
                # we have reached $n, just replace a word randomly, using
                # algorithm from Learning Perl, slightly modified
                rand($i) < @words and splice @words, rand(@words), 1, $_[0];
            }
        }
    );
    @words;
}

sub word_exists {
    my ($self, $word) = @_;

    my $found = 0;
    $self->each_word(
        sub {
            if ($word eq $_[0]) {
                $found = 1;
                return -2;
            }
        }
    );
    $found;
}

sub all_words {
    my ($self) = @_;

    my @words;
    $self->each_word(
        sub {
            push @words, $_[0];
        }
    );
    @words;
}

1;
# ABSTRACT: Word lists

=head1 SYNOPSIS

Use one of the C<WordList::*> modules.


=head1 DESCRIPTION

C<WordList::*> modules are modules that contain, well, list of words. This
module, C<WordList>, serves as a base class and establishes convention for such
modules.

C<WordList> is an alternative interface for L<Games::Word::Wordlist> and
C<Games::Word::Wordlist::*>. Its main difference is: C<WordList::*> wordlists
are read-only/immutable and the modules are designed to have low startup
overhead. This makes them more suitable for use in CLI scripts which often only
want to pick a word from one or several lists.

Unless you are defining a dynamic wordlist (see below), words (or phrases) must
be put in C<__DATA__> section, one per line. Putting the wordlist in the
C<__DATA__> section relieves perl from having to parse the list during the
loading of the module. To search for words or picking some random words from the
list, the module also need not slurp the whole list into memory (and will not do
so unless explicitly instructed).

You must sort your words ascibetically (or by Unicode code point). Sorting makes
it more convenient to diff different versions of the module, as well as
performing binary search. If you have a different sort order other than
ascibetical, you must set package variable C<$SORT> with some true value (say,
C<frequency>).

There must not be any duplicate entry in the word list.

B<Dynamic and non-deterministic wordlist.> A dynamic wordlist must set package
variable C<$DYNAMIC> to either 1 (deterministic) or 2 (non-deterministic). A
dynamic wordlist does not put the wordlist in the DATA section; instead, user
relies on C<first_word()> + C<next_word()>, or C<each_word()>, or C<all_words()>
to get the list. A deterministic wordlist returns the same list everytime
C<each_word()> or C<all_words()> is called. A non-deterministic list can return
a different list for a different C<each_word()> or C<all_words()> call. See
L<WordListRole::Dynamic::FirstNextResetFromEach> and
L<WordListRole::Dynamic::EachFromFirstNextReset> if you want to write a dynamic
wordlist module. It is possible for a dynamic list to return unordered or
duplicate entries, but it is not encouraged.

B<Parameterized wordlist.> When instantiating a wordlist class instance, user
can pass a list of key-value pairs as parameters. Normally only a dynamic
wordlist would accept parameters. Parameters are defined in the C<%PARAMS>
package variable. It is a hash of parameter names as keys and parameter
specification as values. Parameter specification follows function argument
metadata specified in L<Rinci::function>.


=head1 DIFFERENCES WITH GAMES::WORD::WORDLIST

Since this is a new and non-backward compatible interface from
Games::Word::Wordlist, I also make some other changes:

=over

=item * Namespace is put outside C<Games::>

Because obviously word lists are not only useful for games.

=item * Interface is simpler

This is partly due to the list being read-only. The methods provided are just:

- C<pick> (pick one or several random entries)

- C<word_exists> (check whether a word is in the list)

- C<each_word> (run code for each entry)

- C<all_words> (return all the words in a list)

A couple of other functions might be added, with careful consideration.

=item * Namespace is more language-neutral and not English-centric

=back


=head1 METHODS

=head2 new

Usage:

 $wl = WordList::Module->new => obj

Constructor.

=head2 each_word

Usage:

 $wl->each_word($code)

Call C<$code> for each word in the list. The code will receive the word as its
first argument.

If code return -2 will exit early.

=head2 first_word

Another way to iterate the word list is by calling L</first_word> to get the
first word, then L</next_word> repeatedly until you get C<undef>.

=head2 next_word

Get the next word. See L</first_word> for more details.

=head2 reset_iterator

Reset iterator. Basically L</first_word> is equivalent to C<reset_iterator> +
L</next_word>.

=head2 pick

Usage:

 $wl->pick([ $n , [ $allow_duplicates ] ]) => list

Pick C<$n> (default: 1) random word(s) from the list, without duplicates (unless
C<$allow_duplicates> is set to true). If there are less then C<$n> words in the
list and duplicates are not allowed, only that many will be returned.

The algorithm used is from perlfaq ("perldoc -q "random line""), which scans the
whole list once (a.k.a. each_word() once). The algorithm is for returning a
single entry and is modified to support returning multiple entries.

=head2 word_exists

Usage:

 $wl->word_exists($word) => bool

Check whether C<$word> is in the list.

Algorithm in this implementation is linear scan (O(n)). Check out
L<WordListRole::BinarySearch> for an O(log n) implementation, or
L<WordListRole::Bloom> for O(1) implementation.

=head2 all_words

Usage:

 $wl->all_words() => list

Return all the words in a list, in order. Note that if wordlist is very large
you might want to use L</"each_word"> instead to avoid slurping all words into
memory.


=head1 SEE ALSO

C<WordListRole::*> modules.

C<WordList::*> modules.

L<Rinci>.
