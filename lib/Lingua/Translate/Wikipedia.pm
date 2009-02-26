package Lingua::Translate::Wikipedia;
use strict;
use warnings;
use Carp;
use URI;
use Web::Scraper;

our $VERSION = '0.01';

sub new {
    my ($class, %options) = @_;
    $options{src} ||= $options{from};
    $options{dest} ||= $options{to};
    Carp::croak "src parameter is required" unless $options{src};
    Carp::croak "dest parameter is required" unless $options{dest};
    bless \%options, $class;
}

sub translate {
    my ($self, $word) = @_;

    if ($self->cache && defined (my $cached = $self->cache->get($word))) {
        return $cached;
    }

    my $scraper = scraper {
        process "li.interwiki-$self->{dest} a", link => ['@href', sub {
            my $res = $Web::Scraper::UserAgent->get($_);
            $res->code(200) if $res->code == 404;
            scraper { process 'h1', title => 'TEXT' }->scrape($res);
        }];
    };
    my $uri = URI->new("http://$self->{src}.wikipedia.org/wiki/Special:Search");
       $uri->query_form(go => 'Go', search => $word);
    my $res = $scraper->scrape($uri);

    $self->may_cache($word => $res->{link}->{title} || $word);
}

sub correct {
    my ($self, $word, $correct) = @_;
    my $cache = $self->cache or return;
    $cache->set($word => $correct);
}

sub may_cache {
    my ($self, $key, $value) = @_;
    $self->cache->set($key => $value) if $self->cache;
    $value;
}

sub cache { $_[0]->{cache} }

sub _canonicalize {
    my ($string) = @_;
    $string =~ s/^ +| +$//g;
    $string =~ s/\s+/ /g;
    $string;
}

1;
