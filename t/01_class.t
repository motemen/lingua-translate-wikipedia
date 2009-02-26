use strict;
use warnings;
use Test::More tests => 1;
use Lingua::Translate::Wikipedia;

my $t = Lingua::Translate::Wikipedia->new(from => 'ja', to => 'en');
isa_ok $t, 'Lingua::Translate::Wikipedia';
