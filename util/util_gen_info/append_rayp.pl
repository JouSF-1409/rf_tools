#!/usr/bin/env perl
# append ray_para to user0 
# run this script like perl append_rayp.pl dirname phase

use strict;
use warnings;

@ARGV == 2 or die "Usage: append_rayp.pl dirname phase\n";

my ($dir,$phase) = @ARGV;
chdir $dir or die "failing while changing to $dir\n";
open RECORD, ">>", "rf.lst";

# if you want a different suffix, modify line here and line 19
#foreach my $info (split(/\n/,`saclst gcarc evdp f *.ri`)){
foreach my $info (split(/\n/,`saclst gcarc evdp f *.spr`)){
    my ($trace, $gcarc, $evdp) = split(/\s+/,$info);

    my $rayp = `taup time -ph $phase -h $evdp -deg $gcarc --rayp`;
    chomp $rayp;
    $rayp = -1 if($rayp eq ""|| $rayp eq "\n");
    $rayp /= 111.2;
    #$trace =~ s/ri$/\*/;
    # run it quietly
    print(RECORD "$trace\t$rayp\n");

    #`sachd user0 $rayp user1 $rayp f $trace >& /dev/null`;
    #`sachd user0 $rayp user1 $rayp f $trace`;
}
close RECORD;
