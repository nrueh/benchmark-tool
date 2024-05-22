#!/bin/bash
# http://www.cril.univ-artois.fr/~roussel/runsolver/

cd "$(dirname $0)"

#top -n 1 -b > top.txt

[[ -e .finished ]] || "{run.root}/programs/runlim" \
	--output-file=runsolver.watcher --space-limit=16000 \
	--time-limit={run.timeout} \
	"{run.root}/programs/{run.solver}" {run.args} {run.file} > runsolver.solver

touch .finished
