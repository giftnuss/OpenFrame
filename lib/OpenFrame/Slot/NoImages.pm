package OpenFrame::Slot::NoImages;

use strict;
use warnings::register;

use OpenFrame::Slot;
use OpenFrame::AbstractResponse;

use base qw ( OpenFrame::Slot );

sub what {
  return ['OpenFrame::AbstractRequest'];
}

sub action {
  my $class = shift;
  my $absrq = shift;
  my $uri = $absrq->getURI();


  warnings::warn("[slot:noimages] checking to make sure we are processing images") if (warnings::enabled || $OpenFrame::DEBUG);
  
  
  if ($uri->path() =~ /\/$/) {
    return;
  }

  if ($uri->path() !~ /\.html$/) {
    warnings::warn("[slot:noimages] DECLINING " . $uri->path()) if (warnings::enabled || $OpenFrame::DEBUG);
    my $response = OpenFrame::AbstractResponse->new();
    $response->setMessageCode( ofDECLINED );
    $response->setMessage( "not a request for an HTML page" );
    return $response;
  } else {
    warnings::warn("[slot:noimages] accepting request for " . $uri->path()) if (warnings::enabled || $OpenFrame::DEBUG);
  }
}

1;


