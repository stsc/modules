#!/usr/bin/perl

use strict;
use warnings;

use DateTime::Format::Natural;

use constant LANG_DEFAULT => 'en';

my $debug = 0;
my $lang  = LANG_DEFAULT;
my @supported_languages = qw(de en);
my %valid_languages     = map { $_ => 1 } @supported_languages;

parse_switches() if @ARGV;

sub parse_switches {
    use Getopt::Long qw(:config no_auto_abbrev no_ignore_case);

    my %opts;
    GetOptions(\%opts,'d|debug','h|help','l|lang=s', 's|supported', 'V|version') or usage();

    usage()     if $opts{h};
    version()   if $opts{V};
    supported() if $opts{s};

    $debug = $opts{d};
    $lang  = $opts{l};
}

sub usage {
    print <<USAGE;
Usage: $0 [switches]
  -d, --debug            debugging mode (experimental)
  -h, --help             help screen
  -l, --language code    language (country code)
  -s, --supported	 list of supported languages
  -V, --version          print version
USAGE
    exit;
}

sub version {
    print "  DateTime::Format::Natural $DateTime::Format::Natural::VERSION\n";
    exit;
}

sub supported {
    print "$_\n" foreach @supported_languages;
    exit;
}

unless ($valid_languages{$lang}) {
    warn "Language [$lang] isn't supported, switching to default [", LANG_DEFAULT, "]\n";
    $lang = LANG_DEFAULT;
}

my $parse = DateTime::Format::Natural->new(lang => $lang);

while (1) {
    print 'Input date string: ';
    chomp(my $input = <STDIN>);

    my $dt = $parse->parse_datetime(string => $input, debug => $debug);
    printf("%02s.%02s.%4s %02s:%02s\n", $dt->day, $dt->month, $dt->year, $dt->hour, $dt->min);
}