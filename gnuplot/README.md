# Gnuplot scripts

Gnuplot 5.0+ is required to run these scripts.

## Histogram

<img src="histogram.png" width="300" />

```
inputfile = "histogram.txt"
```

## CDF

<img src="cdf.png" width="300" />

```
N=2
array datafiles[N] = ["normal.txt", "normal2.txt"]
array titles[N] = ["Distribution 1", "Distribution 2"]
```

It doesn't need to sort the data files.

## Stacked bar

<img src="stack.png" width="300" />

```
inputfile = "stack.txt"
```
