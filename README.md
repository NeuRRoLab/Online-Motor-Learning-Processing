# Motor learning app processing

This repository contains all the Matlab code to process the resulting files from the replication experiment done with the motor learning app. The experiment that it can process is the one with 72 blocks, 36 with one hand, and 36 with the other. The sequence for the left hand was 41324 and for the right, 70897.

It works for the following experiments:

1. 5P6U: supervised experiment started with the left hand.
2. C6XN: unsupervised experiment started with the left hand.


## Files

1. [src/process_experiment.m](src/process_experiment.m): takes the processed data file of an experiment, calculates microscale learning and converts it to Excel and a Matlab struct.
2. [src/compute_accuracy.m](src/compute_accuracy.m): takes the Matlab struct of all the experiments and updates them to include the accuracy: both the regular one and the one computed in the way Bonstrup did.
3. [src/stats.m](src/stats.m): takes in the Matlab struct for each of the experiments and computes the variables that were used in the paper for the statistical analysis. Also creates violin and microscale learning plots.
4. [src/early_learning.m](src/early_learning.m): computes how many trials would be considered early learning according to the methods used in both the original Bonstrup paper, and the crowdsourcing paper.
5. [src/aggregated_microscale.m](src/aggregated_microscale.m): plots aggregated microscale learning across groups.
6. [src/microscale_figures.m](src/microscale_figures.m): takes the data from all experiments and saves them together, while creating multiple microscale learning figures per group.
7. [src/plot_subject_data.m](src/plot_subject_data.m): script to plot one subject's data, to debug possible issues.
8. [src/tap_speed_visualization.m](src/tap_speed_visualization.m): creates visualization of the tapping speed across the experiment based on the visualization by Bonstrup on their crowdsourcing paper.

## Usage

```Matlab
addpath("src")
% Change the data path (line 9) to the experiment file we're interested in
process_experiment
% Once done for all different experiments, compute accuracy
compute_accuracy
% Finally, compute stats
stats
```
