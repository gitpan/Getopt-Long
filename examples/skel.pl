#!/usr/bin/perl -w
my $RCS_Id = '$Id: skel.pl,v 1.13 2003-09-21 13:21:49+02 jv Exp jv $ ';

# Skeleton for Getopt::Long.

# Author          : Johan Vromans
# Created On      : Tue Sep 15 15:59:04 1992
# Last Modified By: Johan Vromans
# Last Modified On: Sun Sep 21 13:24:54 2003
# Update Count    : 78
# Status          : Unknown, Use with caution!

################ Common stuff ################

use strict;

# Package name.
my $my_package = 'Sciurix';
# Program name and version.
my ($my_name, $my_version) = $RCS_Id =~ /: (.+).pl,v ([\d.]+)/;
# Tack '*' if it is not checked in into RCS.
$my_version .= '*' if length('$Locker: jv $ ') > 12;

################ Command line parameters ################

my $verbose = 0;		# more verbosity

# Development options (not shown with --help).
my $debug = 0;			# debugging
my $trace = 0;			# trace (show process)
my $test = 0;			# test mode.

# Process command line options.
app_options();

# Post-processing.
$trace |= ($debug || $test);

################ Presets ################

my $TMPDIR = $ENV{TMPDIR} || $ENV{TEMP} || '/usr/tmp';

################ The Process ################

exit 0;

################ Subroutines ################

################ Command Line Options ################

use Getopt::Long 2.3303;		# will enable help/version

sub app_options {

    GetOptions(ident	   => \&app_ident,
	       verbose	   => \$verbose,
	       # application specific options go here

	       # development options
	       test	   => \$test,
	       trace	   => \$trace,
	       debug	   => \$debug)
      or Getopt::Long::HelpMessage(2);
}

sub app_ident {
    print STDOUT ("This is $my_package [$my_name $my_version]\n");
}

__END__

=head1 NAME

sample - skeleton for Getopt::Long applications

=head1 SYNOPSIS

sample [options] [file ...]

Options:

   --ident		show identification
   --help		brief help message
   --verbose		verbose information

=head1 OPTIONS

=over 8

=item B<--verbose>

More verbose information.

=item B<--version>

Print a version identification to standard output and exits.

=item B<--help>

Print a brief help message to standard output and exits.

=item B<--ident>

Prints a program identification.

=item I<file>

Input file(s).

=back

=head1 DESCRIPTION

B<This program> will read the given input file(s) and do someting
useful with the contents thereof.

=head1 AUTHOR

Johan Vromans <jvromans@squirrel.nl>

=head1 COPYRIGHT

This programs is Copyright 2003, Squirrel Consultancy.

This program is free software; you can redistribute it and/or modify
it under the terms of the Perl Artistic License or the GNU General
Public License as published by the Free Software Foundation; either
version 2 of the License, or (at your option) any later version.

=cut
