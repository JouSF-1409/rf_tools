tools_dir=`pwd`

PlotTrace.gmt: util_Plot/by_rayp.gmt
	echo -e "#!/bin/bash;tools_dir=${tools_dir}\n">$@;
	cat $^>>$@;

PlotSummary.sh: util_Plot/event_120.gmt
	echo -e "#!/bin/bash;tools_dir=${tools_dir}\n">$@;
	cat $^ >> $@
