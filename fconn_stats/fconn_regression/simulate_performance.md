# Approach to estimate generalizability of PLSR models

1. Calculate surrogate imaging data

## From the experimental data
1. Obtain the weights using the entire sample
1. Obtain the estimated out-of-sample error from the cross-validation schema used in PLSR
  1. read the errors: mu and sigma

## Estimation of associations between sample size and out-of-sample performance

### Parameters to define
1. Number of repetitions
1. Sample sizes to be explored: 10, 13, 15, 20, 30, 40, 60, 80, 100
1. cross-validation schema
  1. Using the same n-left out used with the real dataset?
  1. Using the same proportion within/out of sample

### For each run
1. Read the imaging data
1. Select the functional system pair
3. Calculate expected scores given the model and the noise
4. Run models and keep track of the error

### Required inputs

1. Path to PLSR results
1. Path to surrogate dataset
1. options

### Pseudocode
- load imaging dataset
- symmetrize connectivity matrices (to accomodate connectotyping)
- make table
- calculate expected scores
- select system


-precalculate partitions
