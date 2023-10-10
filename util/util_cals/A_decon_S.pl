#!/usr/bin/env perl
# use Parallel::ForkManager to Parallel cal Srf
# if dont want this Parallel feature, rm all line related to $pm
# assuming b e has been set to 
# -300 300 rel to S arrival, taper for influence of potential SKS, ScS or so

use strict;
use warnings;
use Parallel::ForkManager;

my ($wkdir) = @ARGV;
chdir $wkdir or die "cannot switch to dir\n";
my $pm = Parallel::ForkManager->new(8);

#`rm -rf 2016*/*i`;
#`rm -rf 2017*/*i`;
my $t1 = -35;
my $t2 = -5;
my $t3 = -5;
my $t4 = 30;
my $time = "-C-5/200/350";
bp($wkdir);

foreach my $info (<$wkdir/*.r>){
    my $pid = $pm->start and next;
    
    # do SNR select
    my ($file,$b,$e) = split(/\s+/,$info);
    #if($t1 < $b || $t4 > $e){next;}
    #my $SNR = snr($file,$t1,$t2,$t3,$t4);
    #if ($SNR < 3){next;}

    $file =~ s/r$//;
    # iter_decon: from Lupei Zhu
    # -C for times -Cmark/t1/t2: windowing data with [tmark+t1,tmark+t2] (off).
    # mark = -5(b), -3(o), -2(a), 0-9 (t0-t9).
    # -F for filter to output (n=1), src (n=2), and data (n=3)
    # -T for taper 0.1 for percentage(strictly lower than 0.5)

    `iter_decon $time -F3/1.2/-5 -N500 -T0.2 -S $file"r" $file"z" $file"t"`;
    `mv $file"zi" $file"ri"`;
    #`iter_decon $time -F3/1.2/-5 -N500 -T0.1 -S $file"r" $file"t"`;

    $pm -> finish;
}
$pm -> wait_all_children;

filt($wkdir);


sub bp{
    # bp sac file ahead
    my ($dir) = @_;
    my $bp = "rmean\nrtr\n\nbp c 0.03 1\nw over\n";
    open(my $sac_flow, "|sac");
    print $sac_flow "r $dir/*r\n$bp";
    print $sac_flow "r $dir/*t\n$bp";
    print $sac_flow "r $dir/*z\n$bp";
    print $sac_flow "q\n";
    close $sac_flow;
}



sub snr{
    my ($file,$t1,$t2,$t3,$t4) = @_;

    my $E1 = (split(/\s+/,`sac_e $t1 $t2 $file`))[1];
    my $E2 = (split(/\s+/,`sac_e $t3 $t4 $file`))[1];

    return $E2/$E1;
}

sub filt{
    my ($dir) = @_;

    open(sac_flow,"|sac >&/dev/null");
    print sac_flow "r $dir/*i;\nw over;\n";
    print sac_flow "quit\n";
    close sac_flow;
    unlink $dir/rf.lst if( -e $dir/rf.lst )
    open(RF_LIST, ">>", "$wkdir/rf.lst")

    foreach my $info (split(/\n/, `saclst depmen depmax depmin f $dir/*ri`)){
        my ($file, $depmen, $depmax, $depmin) = split(/\s+/, $info);

        if(($depmen == "nan") || ($depmax > 1) || ($depmin < -1)){
            print RF_LIST "$file   0   0\n";
        }else{
            print RF_LIST "$file   0   1\n";
        }
    }

    close RF_LIST;
}
