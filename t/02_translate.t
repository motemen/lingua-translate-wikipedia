use strict;
use warnings;
use utf8;
use Test::More tests => 5;
use Lingua::Translate::Wikipedia;

binmode Test::More->builder->output, ':utf8';

{
    my %Cases = (
        'Toradora!' => 'とらドラ!',
        'Akikan'    => 'アキカン!',
    );

    my $t = Lingua::Translate::Wikipedia->new(from => 'en', to => 'ja');

    while (my ($en, $ja) = each %Cases) {
        is $t->translate($en), $ja, qq("$en" translates to "$ja");
    }
}

{
    my %Cases = (
        '宇宙をかける少女' => 'Sora Kake Girl',
        '変愚蛮怒' => 'Hengband',
        '魔女の宅急便' => 'Kiki\'s Delivery Service (novel)',
    );

    my $t = Lingua::Translate::Wikipedia->new(from => 'ja', to => 'en');

    while (my ($ja, $en) = each %Cases) {
        is $t->translate($ja), $en, qq("$ja" translates to "$en");
    }
}
