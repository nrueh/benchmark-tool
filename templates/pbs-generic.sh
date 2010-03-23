#!/bin/bash

function abort()
{{
	echo TIMEOUT!
	kill $MPI_PID > /dev/null 2>&1
}}

function run()
{{
	trap abort SIGUSR1
	/usr/bin/time -f "Real time (s): %e" -o runsolver.watcher \
	mpiexec -machinefile $PBS_NODEFILE -n $PBS_NODES \
	"{run.root}/programs/{run.solver}" {run.args} \
	-f "{run.file}" \
	> runsolver.solver 2>&1 &
	export MPI_PID=$!
	export BASH_PID=$$
	(sleep $[{run.timeout}+10]; kill -SIGUSR1 $BASH_PID) &
	sleep_pid=$!
	wait $MPI_PID > /dev/null 2>&1
	kill $sleep_pid
}}

cd "$(dirname $0)"

[[ .finished -nt start.sh ]] || run

touch .finished