#!/usr/bin/perl -w

use strict;

use Config::Tiny;
use Getopt::Long;
use XML::Simple;

my $help;
my $group = 'ssh';

GetOptions(
    'help'      => \$help,
    'group=s'   => \$group,
);
if ($help) {
    print "usage: $0 [--group <groupname>] [part-of-hostname]\n";
    exit 0;
}

my $known_hosts = $ENV{HOME} . '/.ssh/known_hosts';
my $conffile = $ENV{HOME} . '/.iterm-launcher.conf';

open(my $fh, $known_hosts) or die "Unable to open file: $known_hosts: $!";
my %hosts = ();
while (<$fh>) {
    if (/^(.+?)[,\s]/) {
        $hosts{$1}++;
    }
}
close $fh;

my $conf = {};
if ($group and -f $conffile) {
    $conf = Config::Tiny->read($conffile);
    if (exists $conf->{$group}) {
        $hosts{$_}++ foreach keys %{ $conf->{$group} };
    }
}
my $smart_hostname_matching = (exists $conf->{_}->{smart_hostname_matching}
    ? $conf->{_}->{smart_hostname_matching} : 1);

my @hosts;
if (@ARGV) {
    my $hostpat = shift;
    $hosts{$hostpat}++;
    my $re;
    if ($smart_hostname_matching and not $hostpat =~ /\./) {
        $re = join('[^\.]*', split('', $hostpat));
        $re = qr/$re/i;
    } else {
         $re = qr/\Q$hostpat\E/i;
     }
    @hosts = grep (/$re/, keys %hosts);
} else {
    @hosts = keys %hosts;
}

my @items = map { {
    title => [ $_ ],
    subtitle => [ "$group $_" ],
    icon => [ 'icon.png' ],
    arg => "\"$_\" \"$group\"",
    valid => 'YES',
    autocomplete => $_,
    uid => "$group+$_",
} } @hosts;

my $xml = XMLout({ item => \@items });
$xml =~ s#<(/?)opt>#<$1items>#mg;
print $xml;
