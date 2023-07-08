#!/usr/bin/env perl
my $USAGE = "Usage: $0 [--inifile inifile.ini] [--section section] [--recmark lx] [--eolrep #] [--reptag __hash__] [--debug] [file.sfm]\n";
=pod
This script processes an SFM lexical file to display all entries and subentries in a format that makes it easy to compare them.

The ini file should have sections with syntax like this:
[CfEntSub]
RecordMarker=lx
SubentryMarkers=se
Label1=LEX:
Fields1=lx,se
Label2=POS:
Fields2=ps
Label3=DEF:
Fields3=de

=cut
use 5.020;
use utf8;
use open qw/:std :utf8/;

use strict;
use warnings;
use English;
use Data::Dumper qw(Dumper);


use File::Basename;
my $scriptname = fileparse($0, qr/\.[^.]*/); # script name without the .pl

use Getopt::Long;
GetOptions (
	'inifile:s'   => \(my $inifilename = "$scriptname.ini"), # ini filename
	'section:s'   => \(my $inisection = "CfEntSub"), # section of ini file to use
# additional options go here.
# 'sampleoption:s' => \(my $sampleoption = "optiondefault"),
	'recmark:s' => \(my $recmark = "lx"), # record marker, default lx
	'eolrep:s' => \(my $eolrep = "#"), # character used to replace EOL
	'reptag:s' => \(my $reptag = "__hash__"), # tag to use in place of the EOL replacement character
	# e.g., an alternative is --eolrep % --reptag __percent__

	# Be aware # is the bash comment character, so quote it if you want to specify it.
	#	Better yet, just don't specify it -- it's the default.
	'debug'       => \my $debug,
	) or die $USAGE;

# check your options and assign their information to variables here
$recmark = clean_marks($recmark); # no backslashes or spaces in record marker

use Config::Tiny;
my $config = Config::Tiny->read($inifilename, 'crlf');
die "Quitting: couldn't find the INI file $inifilename\n$USAGE\n" if !$config;

$recmark = $config->{"$inisection"}->{RecordMarker} if $config->{"$inisection"}->{RecordMarker};
my $semarks = "se";
$semarks = $config->{"$inisection"}->{SubentryMarkers} if $config->{"$inisection"}->{SubentryMarkers};
$semarks=clean_marks($semarks);
my $srchSEmarks = qr/$semarks/;
my @labels_ary;
my @fields_ary;
my $allfields;
for (1..10) {
	my $lstring="Label$_";
	my $fstring="Fields$_";
	last if ! $config->{"$inisection"}->{$lstring};
	last if ! $config->{"$inisection"}->{$fstring};
	$labels_ary[$_] = $config->{"$inisection"}->{$lstring};
	$fields_ary[$_] = clean_marks($config->{"$inisection"}->{$fstring});
	$allfields = $allfields . $fields_ary[$_] . "|";
	}
$allfields =~ s/\|$//;
# =cut

say STDERR "Record marker:$recmark" if $debug;
say STDERR "Subentry marker:$semarks" if $debug;
say STDERR "Filter on:$allfields" if $debug;
say STDERR "Label:", Dumper @labels_ary if $debug;
say STDERR "Fields:", Dumper  @fields_ary if $debug;


die;
# generate array of the input file with one SFM record per line (opl)
my @opledfile_in;
my $line = ""; # accumulated SFM record
while (<>) {
	s/\R//g; # chomp that doesn't care about Linux & Windows
	#perhaps s/\R*$//; if we want to leave in \r characters in the middle of a line
	s/$eolrep/$reptag/g;
	$_ .= "$eolrep";
	if (/^\\$recmark /) {
		$line =~ s/$eolrep$/\n/;
		push @opledfile_in, $line;
		$line = $_;
		}
	else { $line .= $_ }
	}
push @opledfile_in, $line;

for my $oplline (@opledfile_in) {
# Insert code here to perform on each opl'ed line.
# Note that a next command will prevent the line from printing

say STDERR "oplline:", Dumper($oplline) if $debug;
#de_opl this line
	for ($oplline) {
		s/$eolrep/\n/g;
		s/$reptag/$eolrep/g;
		print;
		}
	}

sub clean_marks {
# converts an SFM list into a search string
my ($marks) = @_;
for ($marks) {
	s/\\//g;
	s/ //g;
	s/\,*$//; # no trailing commas
	s/\,/\|/g;  # use bars for or'ing
	}
return $marks;
}
