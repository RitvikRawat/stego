#!/bin/bash
i=0
for i in `seq 0 9`; 
do
	mv ~/Desktop/3rd_summer/converter/grey/$i/*.png ~/Desktop/3rd_summer/converter/grey/collected
	let i=i+1
done
