use strict;
use warnings;
use utf8;
use Test::More tests => 3;
use Cache::FileCache;
use File::Temp qw(tempdir);
use Lingua::Translate::Wikipedia;

use constant {
    WORD_EN         => 'CLANNAD ~AFTER STORY~',
    CORRECT_WORD_JA => 'CLANNAD 〜AFTER STORY〜',
};

my $t = Lingua::Translate::Wikipedia->new(
    from  => 'en',
    to    => 'ja',
    cache => Cache::FileCache->new({ cache_root => tempdir() })
);

isnt $t->translate(WORD_EN), CORRECT_WORD_JA;

$t->correct(WORD_EN, CORRECT_WORD_JA);

is $t->translate(WORD_EN), CORRECT_WORD_JA;

$t->correct(WORD_EN, undef);

isnt $t->translate(WORD_EN), CORRECT_WORD_JA;
