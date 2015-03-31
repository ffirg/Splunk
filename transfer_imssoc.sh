#!/bin/bash

#
# transfer_imssoc.sh: send Splunk IMSI output to T-systems for input into Excalibur for IMS SOC
#

# variables
datadir="/opt/splunk/var/run/splunk/"
outputfile="imssoc.txt"
datafile="${datadir}${outputfile}"
archivefile="$datafile.old"
logdir="/opt/local/log/"
logfile="`basename $0.log`"
log="${logdir}${logfile}"
datestamp="--- `date`"
mailto="someone@somewhere"

# clean up any deadwood created/left behind by this script
function clean_up {
  #trap "rm -f $tmpa $tmpb; exit" ERR EXIT INT TERM
  :
}

# generic error handler
function catch_errs {
  "$@"
  local status=$?
  if [ $status -ne 0 ]; then
    echo "Around here... $@" | mail -s "Problem with $0 on `hostname`" $mailto
    clean_up >/dev/null 2>&1
    exit
  fi
}

check_if_exists() {
# basic sanity checks
  if [ ! -r $1 ]
  then
    echo "Nothing found to transfer"
    exit 1
  else
    echo -n "Will transfer $1 "
    echo -n "[`wc -l $1 | awk '{print $1}'` IMSIs] "
    echo "[`stat -c %z $1`]"
  fi
}

strip_header_line() {
# remove first line which will contain just the word IMSI
  sed -i '1d' $1
}

transfer_file() {
# scp over file to remote host port 22 using username=xxx and dir=xxx
  chmod 644 $1
  remote_name="newport.`date +%d%m%y%H%M`.forud"
  scp $1 xxx@remote_host:in/$remote_name && echo "Transferred over $remote_name"

}

archive_file(){
# move datafile to .old so we have a clean new run
  mv $1 ${1}.old
}

# Start doing the real work...

# Log everything we do to the log file
exec >>$log
echo $datestamp

# check for the outputfile, bail if not readable
catch_errs check_if_exists $datafile
catch_errs strip_header_line $datafile
catch_errs transfer_file $datafile
catch_errs archive_file $datafile
