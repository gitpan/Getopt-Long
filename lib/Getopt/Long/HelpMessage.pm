#!/usr/bin/perl -w

package Getopt::Long::HelpMessage;

use strict;

my $PUout;

sub helpmessage($$$;$) {
    package Getopt::Long;
    use constant INDENT => 20;

    my ($pkg, $vv, $args, $fh) = @_;

    my $usepod = 1;
    foreach my $o ( @$args ) {
	if ( !ref($o) || defined($o->[CTL_DESCR]) ) {
	    $usepod = 0;
	    last;
	}
    }

    if ( $usepod ) {
	# Load Pod::Usage only if needed.
	require Pod::Usage;
	import Pod::Usage;
	my $outstr = "";
	local($^W) = 0;
	*Pod::Usage::output = sub {
	    $_[1] =~ tr/\01/ /;
	    if ( $fh ) {
		print $fh $_[1];
	    }
	    else {
		$outstr .= $_[1];
	    }
	};

	pod2usage({ -exitval => "NOEXIT" });
	return $outstr;
    }

    my $lret = "";
    foreach my $o ( @$args ) {

	unless ( ref($o) ) {
	    $lret .= $o . "\n";
	    next;
	}

	my @o = @$o;
	my $type    = $o->[CTL_TYPE];
	#my $cname   = $o->[CTL_CNAME];
	my $mand    = $o->[CTL_MAND];
	my $dest    = $o->[CTL_DEST];
	my $default = $o->[CTL_DEFAULT];
	my $descr   = $o->[CTL_DESCR];

	my @names = @o[CTL_DESCR+1 ... $#o];

	my $arg = '';
	if ( $type =~ /^[siofn]$/i ) {

	    # If the help text contains <<<...>>> it will be used to
	    # show the option 'parameter'.
	    if ( $descr && $descr =~ /^(.*)<<<([^>]+)>>>(.*)/s ) {
		$descr = $1.$2.$3;
		$arg = $2;
	    }

	    # Argument for this option.
	    unless ( $arg ) {
		if ( lc($type) eq 's' ) {	# string
		    $arg = "XXX";
		}
		elsif ( $type =~ /^[ion+]$/i ) {# integer
		    $arg = "NNN";
		}
		elsif ( lc($type) eq 'f' ) {	# float
		    $arg = "N.NN";
		}
	    }
	    # Hash takes key/value.
	    $arg = "key=" . $arg if $dest == CTL_DEST_HASH;

	    $arg = "=" . $arg;

	    # Show [] if optional.
	    $arg = "[$arg]" unless $mand;
	}

	my $ret = '';

	if ( $bundling ) {
	    $ret = '  ';
	    my $haveshort = 0;
	    foreach ( @names ) {
		next if length > 1;
		$ret .= "-";
		$ret .= $_ . ", ";
		$haveshort++;
	    }
	    my $havelong = 0;
	    foreach ( @names ) {
		next unless length > 1;
		if ( $havelong++ ) {
		    $lret .= $ret . "\n";
		    $ret = "  ";
		}
		if ( !$haveshort ) {
		    $ret .= "    ";
		}
		$haveshort = 0;
		$ret .= "--";
		$ret .= "[no-]" if $type eq '!';
		$ret .= $_ . $arg;
	    }
	    if ( $haveshort && !$havelong ) {
		$arg =~ s/=//;
		substr($ret,-2) = " ".$arg;
	    }
	}
	else {
	    foreach ( @names ) {
		$lret .= $ret . "\n" if $ret;
		$ret = "  --";
		$ret .= "[no-]" if $type eq '!';
		$ret .= $_ . $arg;
	    }
	}

	# Do we have a help text?
	if ( $descr ) {
	    my @descr = split(/\n/, $descr);
	    if ( length($ret) < INDENT ) {
		$ret .= (" " x (INDENT-length($ret))) . shift(@descr);
	    }
	    foreach ( @descr ) {
		$lret .= $ret . "\n";
		$ret = (" " x INDENT) . $_;
	    }
	}
	$lret .= $ret . "\n";
    }

    if ( $fh ) {
	print $fh ($lret);
    }
    $lret;
}

1;
