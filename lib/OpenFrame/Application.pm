package OpenFrame::Application;

##
## OpenFrame::App - base class for all applications, also the default application
##

use strict;
use warnings::register;

use Data::Dumper;
use OpenFrame::Config;

our $VERSION = (split(/ /, q{$Id: Application.pm,v 1.6 2001/11/12 13:57:04 james Exp $ }))[2];
our $epoints = {};

sub new {
  my $class = shift;
  my $self  = {};
  bless $self, $class;
}

sub enter {
  my $self    = shift;
  my $request = shift;
  my $session = shift;

  {
    no strict 'refs';

    my $epnts = $ {ref($self) . "::epoints"};
    my $enter;
    my %entry_choose;
    foreach my $entry ( keys %{ $epnts } ) {
      my $num_m = 0;
      my $params = $epnts->{$entry};
      my $num_to_match = scalar( @{$params} );
      foreach my $param (@{ $params }) {	
	if (exists $request->arguments()->{ $param }) {
	  $num_m++;
	}
      }
      warnings::warn("[application] examining $num_m vs $num_to_match") if (warnings::enabled || $OpenFrame::DEBUG);
      if ($num_m == $num_to_match) {
	$num_m = 0;
	warnings::warn("[application] entering $entry") if (warnings::enabled || $OpenFrame::DEBUG);
      $session->{application}->{current}->{entrypoint} = $entry;
	if ($self->can($entry)) {
	  $self->$entry( $session, $request );
	  return;
	}
      }
    }
    warnings::warn("[application] using default entry point") if (warnings::enabled || $OpenFrame::DEBUG);
    $session->{application}->{current}->{entrypoint} = 'default';
    $self->default( $session );
    return;
  }
}

sub default {
  my $self = shift;
  my $config = OpenFrame::Config->new();
  $self->{version} = $config->getKey( 'VERSION' );
}


1;