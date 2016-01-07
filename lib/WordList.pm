package WordList;

# DATE
# VERSION

1;
# ABSTRACT: Word lists

=head1 SYNOPSIS

Use one of the C<WordList::*> modules.


=head1 DESCRIPTION

B<EARLY DEVELOPMENT, SPECIFICATION MIGHT STILL CHANGE CONSIDERABLY.>

C<WordList::*> modules are modules that contain, well, list of words. This
module, C<WordList>, serves as a base class and establishes convention for such
modules.

C<WordList> is an alternative interface for L<Games::Word::Wordlist> and
C<Games::Word::Wordlist::*>. Its main difference is: C<WordList::*> modules are
designed to have low startup overhead and optimized for use in CLI scripts.
Words (or phrases) must be put in __DATA__ section, *sorted*, one per line. By
putting it in the __DATA__ section, perl doesn't have to parse the list. To
search for words or picking some random words from the list, the module need not
slurp the whole list into memory (and will not do so unless explicitly
instructed.) Sorting must be asciibetical/by Unicode codepoint. This makes it
more convenient to diff different versions of the module, as well as performing
binary search.

Since this is a new and non-backward compatible interface from
Games::Word::Wordlist, I also make some other changes:

=over

=item * The interface is (currently) simpler

The methods provided are just:

C<pick> (pick one or several random entries)

C<is_word> (check whether a word is in the list)

C<each_word> (run code for each entry),

=item * The namespace is more language-neutral and not English-centric

=back


=head1 SEE ALSO

L<Bencher::Scenario::GamesWordlistModules>

L<Bencher::Scenario::WordListModules>
