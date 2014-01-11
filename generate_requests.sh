#!/bin/bash

while read especie; do
	echo "#####################
### Input section ###

# Coordinate system and projection in WKT format.
#
WKT Coord System = GEOGCS["WGS84", DATUM["WGS84", SPHEROID["WGS84", 6378137.0, 298.257223563]], PRIMEM["Greenwich", 0.0], UNIT["degree", 0.017453292519943295], AXIS["Longitude",EAST], AXIS["Latitude",NORTH]]

# Here you can specify:
#
# 1) The location (in your file system) of a TAB-delimited file with a 
#    list of occurrences. Each line is a record
#    with: <id> <label> <longitude> <latitude> <abundance>
# 2) The location (in your file system) of an XML file containing 
#    occurrence data following the openModeller serialization format.
# 3) The GBIF Web Service address to search for occurrence data:
#    http://data.gbif.org/ws/rest/occurrence/list
# 4) A TAPIR Web Service address that mapped DarwinCore 1.4, such as the
#    speciesLink TAPIR service:
#    http://tapir.cria.org.br/tapirlink/tapir.php/specieslink
# 
Occurrences source = teste.txt

# Only occurrences with this label (group id) will be used.
# Defaults to the last label found.
#
Occurrences group = $especie

# Uncomment the following line to automatically ignore duplicate points (same coordinates).
#
#Spatially unique = true

# Uncomment the following line to automatically ignore duplicate points (same environment values).
#
#Environmentally unique = true

# Maps to be used as environmental variables to generate the model
# For TerraLib rasters, use the following pattern:
# terralib>yourusername>yourpassword@PostgreSQL>localhost>terralib>5432>rain_coolest
# WCS rasters can be directly accessed with this pattern:
# wcs>wcs url>wcs layer
# To specify a categorical map use: Categorical map = 
#
Map = workshop/Brasil_ASC/alt.asc
Map = workshop/Brasil_ASC/bio1.asc
Map = workshop/Brasil_ASC/bio12.asc

# Mask to delimit the region to be used to generate the model (filter
# the species ocurrencies/absences points).
# Note: Mask layers need to support nodata value assignment. Masked
# areas will be those with nodata (areas with zero as data will not 
# be masked at all).
#
Mask = workshop/Brasil_ASC/bio12.asc

# Uncomment the following lines to disable model statistics.
#
#Confusion matrix = false
#AUC = false

######################
### Output section ###

# File to be used as the output format.
#
Output format = workshop/Brasil_ASC/bio12.asc

# Maps to be used as environmental variables to project the model
# to create the output distribution map.
# To specify a categorical map use: Categorical output map = 
Output map = workshop/Brasil_ASC/alt.asc
Output map = workshop/Brasil_ASC/bio1.asc
Output map = workshop/Brasil_ASC/bio12.asc


# Mask to delimit the region to project the model onto.
# Note: Mask layers need to support nodata value assignment. Masked
# areas will be those with nodata (areas with zero as data will not 
# be masked at all).
#
Output mask = workshop/Brasil_ASC/bio12.asc

# Output model name (serialized model).
#
Output model = output_$especie.xml

# Output file name (projected map).
# Make sure to use the correct extension as shown in the Output file type
# documentation shown below!
#
Output file = output_$especie.img

# Output file type. Options:
#
# GreyTiff = grey scale GeoTiff (0 <= cell value <= 255). Default. (*.tif)
# GreyTiff100 = grey scale GeoTiff (0 <= cell value <= 100). (*.tif)
# FloatingTiff = floating point GeoTiff (cell value = probability of presence) (*.tif)
# GreyBMP = grey scale BMP (*.bmp)
# FloatingHFA = Erdas Imagine Floating Point (cell value = probability of presence)
#               NoData will be written as -1. (*.img) 
# ByteHFA = Erdas Imagine Byte representation (0 <= cell value <= 100)
#           NoData will be written as 101. (*.img) 
# ByteASC = ARC/Info ASCII grid Byte representation (0 <= cell value <= 100)
#           NoData will be written as 101. (*.asc) 
# FloatingASC = ARC/Info ASCII grid Floating Point (cell value = probability of presence)
#           NoData will be written as -9999. (*.asc) 
#
Output file type = GreyBMP


#########################
### Algorithm section ###

# Id of the algorithm to construct the model
# and algorithm specific parameters. Only one
# algorithm can be run at a time. Uncommenting
# one of the algorithms will make om_console run
# without asking for additional input.

########
# AquaMaps
#
#Algorithm = AQUAMAPS
#Parameter = UseSurfaceLayers -1
#Parameter = UseDepthRange 1
#Parameter = UseIceConcentration 1
#Parameter = UseDistanceToLand 0
#Parameter = UsePrimaryProduction 1
#Parameter = UseSalinity 1
#Parameter = UseTemperature 1

########
# Bioclim
#
#Algorithm = BIOCLIM
#Parameter = StandardDeviationCutoff 0.674

########
# Climate Space Model - Broken-Stick
#
#Algorithm = CSMBS
#Parameter = Randomisations 8
#Parameter = StandardDeviations 2
#Parameter = MinComponents 1
#Parameter = VerboseDebugging 1

########
# GARP: Genetic Algorithm for Rule Set Production (new implementation)
#
#Algorithm = GARP
#Parameter = MaxGenerations 400
#Parameter = ConvergenceLimit 0.01
#Parameter = PopulationSize 50
#Parameter = Resamples 2500

########
# GARP: Genetic Algorithm for Rule Set Production (original DesktopGarp implementation)
#
#Algorithm = DG_GARP
#Parameter = MaxGenerations 100
#Parameter = ConvergenceLimit 0.05
#Parameter = PopulationSize 50
#Parameter = Resamples 2500
#Parameter = MutationRate 0.25
#Parameter = CrossoverRate 0.25

########
# GARP with Best Subsets Procedure (using the new implementation)
#
#Algorithm = GARP_BS
#Parameter = TrainingProportion 50
#Parameter = TotalRuns 20
#Parameter = HardOmissionThreshold 100
#Parameter = ModelsUnderOmissionThreshold 20
#Parameter = CommissionThreshold 50
#Parameter = CommissionSampleSize 10000
#Parameter = MaxThreads 1
#Parameter = MaxGenerations 400
#Parameter = ConvergenceLimit 0.01
#Parameter = PopulationSize 50
#Parameter = Resamples 2500

########
# GARP with Best Subsets Procedure (using the DesktopGarp implementation)
#
#Algorithm = DG_GARP_BS
#Parameter = TrainingProportion 50
#Parameter = TotalRuns 10
#Parameter = HardOmissionThreshold 100
#Parameter = ModelsUnderOmissionThreshold 20
#Parameter = CommissionThreshold 50
#Parameter = CommissionSampleSize 10000
#Parameter = MaxThreads 5
#Parameter = MaxGenerations 20
#Parameter = ConvergenceLimit 0.05
#Parameter = PopulationSize 50
#Parameter = Resamples 2500
#Parameter = MutationRate 0.25
#Parameter = CrossoverRate 0.25

########
# Environmental distance
#
#Algorithm = ENVDIST
# Valid values for the parameter DistanceType:
# 1=Euclidean, 2=Mahalanobis, 3=Manhattan, 4=Chebyshev
#Parameter = DistanceType 1
#Parameter = NearestPoints 1
#Parameter = MaxDistance 0.1

########
# SVM
#
Algorithm = SVM
Parameter = SvmType 0
Parameter = KernelType 2
Parameter = Degree 3
Parameter = Gamma 0
Parameter = C 1
Parameter = Coef0 0
Parameter = Nu 0.5
Parameter = ProbabilisticOutput 0
Parameter = NumberOfPseudoAbsences 500

########
# Maximum Entropy
#
#Algorithm = MAXENT
#Parameter = NumberOfBackgroundPoints 10000
#Parameter = UseAbsencesAsBackground 0
#Parameter = IncludePresencePointsInBackground 1
#Parameter = NumberOfIterations 500
#Parameter = TerminateTolerance 0.00001
# Valid values for the parameter Output Format:
# 1 = Raw, 2 = Logistic.
#Parameter = OutputFormat 2
# Valid values: enable = 1, disable = 0
#Parameter = QuadraticFeatures 1
# Valid values: enable = 1, disable = 0
#Parameter = ProductFeatures 1
# Valid values: enable = 1, disable = 0
#Parameter = HingeFeatures 1
# Valid values: enable = 1, disable = 0
#Parameter = ThresholdFeatures 1
# Valid values: enable = 1, disable = 0
#Parameter = AutoFeatures 1
#Parameter = MinSamplesForProductThreshold 80
#Parameter = MinSamplesForQuadratic 10
#Parameter = MinSamplesForHinge 15

########
# Artificial Neural Networks
#
#Algorithm = ANN
#Parameter = HiddenLayerNeurons 14
#Parameter = LearningRate 0.3
#Parameter = Momentum 0.05
#Parameter = Choice 1
#Parameter = Epoch 5000000
#Parameter = MinimunError 0.01

########
# ENFA
#
#Algorithm = ENFA
#Parameter = NumberOfBackgroundPoints 10000
#Parameter = NumberOfRetries 5
#Parameter = DiscardMethod 2
#Parameter = RetainComponents 2
#Parameter = RetainVariation 0.75
#Parameter = DisplayLoadings 0
#Parameter = VerboseDebug 0

########
# Envelope score
#
#Algorithm = ENVSCORE

########
# Niche Mosaic
#
#Algorithm = NICHE_MOSAIC
#Parameter = NumberOfIterations 2000

########
# Random Forests
#
#Algorithm = RF
#Parameter = NumTrees 10
#Parameter = VarsPerTree 0
#Parameter = ForceUnsupervisedLearning 0" > "request_$especie.txt"
done < <(awk -F'\t' '/^[0-9]/ { print $2 }' "$1" | sort | uniq)
