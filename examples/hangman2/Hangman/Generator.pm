package Hangman::Generator;

use strict;
use OpenFrame::Config;
use OpenFrame::Response;
use OpenFrame::Constants;
use Template;

my $tt;

sub what {
  return ['OpenFrame::Session', 'OpenFrame::Request', 'OpenFrame::Cookietin'];
}

sub action {
  my $class   = shift;
  my $config  = shift;
  my $session = shift;
  my $request = shift;
  my $cookie  = shift;

  my $templatedir = $config->{presentation};

  my $name = $session->{application}->{current}->{name};

  if (not defined $tt) {
    $tt = Template->new({
			 INCLUDE_PATH => $templatedir,
			 POST_CHOMP   => 1,
			 LOAD_PERL    => 1,
			});
  }

  my $output;


  if (substr($request->uri()->path, -1) eq '/') {
    warn "[slot::generator] no file, using index.html" if ($OpenFrame::DEBUG);
    $request->uri( URI->new( $request->uri()->canonical() . 'index.html' ) );
  }

  my $filename = substr($request->uri()->path(), 1);

  unless (-e $templatedir . $filename && -r _) {
    warn "[slot::generator] couldn't find file $templatedir$filename" if $OpenFrame::DEBUG;
    return;
  }

  $tt->process($filename, $session, \$output) || ($output = $tt->error);
  delete $session->{template}; # delete spurious entry by TT


  my $response = OpenFrame::Response->new();
  $response->message($output);
  $response->code(ofOK);
  $response->mimetype('text/html');
  $response->cookies($cookie);

  return $response;
}

1;

__END__

=head1 NAME

Hangman::Generator - A templated output generator for hangman

=head1 DESCRIPTION

C<Hangman::Generator> is a templated output generator for hangman. The
session is passed to a Template Toolkit template, which generates
output, and the code then generates a response.

Note that it explicity checks if the request is meant for the
application, rather than an image, by checking for "index.html" and
seeing if it can read the template file.

The template used is "templates/index.html" so investigate that to
understand the clear seperation between logic and presentation present
in this example hangman game.

=head1 AUTHOR

Leon Brocard <leon@fotango.com>

=head1 COPYRIGHT

Copyright (C) 2001-2, Fotango Ltd.

This module is free software; you can redistribute it or modify it
under the same terms as Perl itself.



