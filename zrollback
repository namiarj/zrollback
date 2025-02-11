!/bin/sh

#
# Functions
#
progname=${0##*/}

cleanup ()
{
	rm $tmpfile 2>/dev/null
}

error ()
{
	echo "$progname: $*" >&2
	exit 1
}

gen_tmp ()
{
	tmpfile="/tmp/$progname"."`awk 'BEGIN {srand();printf "%d\n", rand() * 10^10}'`"
}

get_snaps ()
{
	snaps=`zfs list -t snapshot -o name -H`
}

zfs_props ()
{
	props=`zfs get -o property,value all $snap` 
	dialog --msgbox "$props" 24 64
}

zfs_destroy ()
{
	dialog --default-button No --yesno "Destroy $snap?" 6 44
	case $? in
	0)
		zfs destroy $snap
		;;
	*)
		;;
	esac
}

zfs_rollback ()
{
	dialog --default-button No --yesno "Rollback $snap?" 6 44
	case $? in
	0)
		zfs rollback $snap
		;;
	*)
		;;
	esac
}

list_snaps ()
{
	get_snaps
	dialogcmd="dialog --ok-label Props --extra-button --extra-label Rollback --help-button --help-label Destroy --no-tags --menu Snapshots 20 46 40"
	for snap in $snaps
	do
		dialogcmd="$dialogcmd $snap `echo $snap`"
	done
	gen_tmp
	$dialogcmd 2> $tmpfile
	case $? in
	0)
		# Props 
		snap=`more $tmpfile`
		zfs_props
		;;
	2)
		# Destroy
		snap=`more $tmpfile | tail -c +5`
		zfs_destroy
		;;
	3)
		# Rollback
		snap=`more $tmpfile`
		zfs_rollback
		;;
	*)
		exit 0
	esac
	rm $tmpfile
}

#
# Main
#
main ()
{
	trap "cleanup; exit" INT TERM HUP EXIT
	while true
	do
	  list_snaps
  done
}

main $@
