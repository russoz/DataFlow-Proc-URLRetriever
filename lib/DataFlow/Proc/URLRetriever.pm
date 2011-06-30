package DataFlow::Proc::URLRetriever;

use strict;
use warnings;

# ABSTRACT: An URL-retriever processor

# VERSION

use Moose;
extends 'DataFlow::Proc';

use namespace::autoclean;
use LWP::UserAgent;

has 'ua' => (
    'is'      => 'ro',
    'isa'     => 'LWP::UserAgent',
    'lazy'    => 1,
    'default' => sub { LWP::UserAgent->new( $_[0]->ua_options ) }
);

has 'ua_options' => (
    'is'  => 'ro',
    'isa' => 'Any',
);

has 'baseurl' => (
    'is'        => 'ro',
    'isa'       => 'Str',
    'predicate' => 'has_baseurl',
);

sub _build_p {
    my $self = shift;

    return sub {
        my $url =
          $self->has_baseurl
          ? URI->new_abs( $_, $self->baseurl )->as_string
          : $_;

        return $self->ua->get($url)->decoded_content;

        # TODO allow ArrayRef's instead of Str, and use the other elements
        #      as parameters for the get() method
    };
}

__PACKAGE__->meta->make_immutable;

1;

