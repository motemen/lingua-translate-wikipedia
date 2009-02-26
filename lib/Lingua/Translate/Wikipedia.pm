package Lingua::Translate::Wikipedia;
use strict;
use warnings;
use Carp;
use LWP::UserAgent;
use URI::Escape;
use HTML::Entities;

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
    my ($self, $text) = @_;

    if ($self->cache && defined (my $cached = $self->cache->get($text))) {
        return $cached;
    }

    my $res;
    $res = $self->ua->get("http://$self->{src}.wikipedia.org/wiki/Special:Search?go=Go&search=" . uri_escape_utf8($text));
    $res->decoded_content =~ m(<li class="interwiki-$self->{dest}"><a href="(http://$self->{dest}.wikipedia.org/wiki/.+?)">)
        or return $self->may_cache($text => $text);
    
    $res = $self->ua->get($1);
    $res->decoded_content =~ m'<h1[^>]*>(.+?)</h1>'
        or return $self->may_cache($text => $text);
    
    $self->may_cache($text => decode_entities($1));
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

sub ua {
    my $self = shift;
    $self->{ua} ||= LWP::UserAgent->new;
}

sub _canonicalize {
    my ($string) = @_;
    $string =~ s/^ +| +$//g;
    $string =~ s/\s+/ /g;
    $string;
}

1;
