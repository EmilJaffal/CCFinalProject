#!/usr/bin/env wolframscript
(* ::Package:: *)

(* ::Title:: *)
(*Final Project*)


(* ::Subtitle:: *)
(*A Stacked Machine Learning Ensemble*)


(* ::Subsubtitle:: *)
(*Emil Jaffal*)


(* ::Section:: *)
(*Data Configuration*)


(* ::Section:: *)
(*Setup*)


(* ::Input:: *)
(*PacletInstall["WolframChemistry/MoleculeFingerprints"] (*only once*)*)


(* ::Input:: *)
(*Needs["WolframChemistry`MoleculeFingerprints`"] (*at start of new session*)*)


(* ::Subsection:: *)
(*Data Importing*)


(* ::Text:: *)
(*Data collection of roughly 25,000 of these molecules has been acquired from the chromophore v1 dataset from Ocelot, an organic material repository. The dataset is based on DFT calculations which have done structure optimizations, single-point energies and TDDFT evaluations for the low-lying excited states performed with (ionization potential) IP-tuned LC-\[Omega]HPBE functionals, derived for each distinct molecule, and the Def2SVP basis set.*)
(**)
(*Some information on our descriptors, calculated by the authors:*)
(**)
(*Vertical ionization energy and adiabatic ionization energy are two different ways to measure the energy required to remove an electron from an atom or a molecule.*)
(*The vertical ionization energy is the energy required to remove an electron from an atom or molecule in its ground state. This means that the electron is removed without any change in the energy of the remaining electrons. In other words, the energy required to remove the electron is equal to the difference in energy between the ground state and the ionized state.*)
(**)
(*On the other hand, adiabatic ionization energy is the energy required to remove an electron from an atom or molecule when it is in any energy state, not necessarily its ground state. This means that the energy required to remove the electron is the minimum energy needed to take the electron from its initial energy state to the ionized state without any change in the energy of the system due to external factors.*)
(**)
(*In practice, the adiabatic ionization energy is usually larger than the vertical ionization energy, because removing an electron from an excited state requires more energy than removing it from the ground state.*)
(**)
(*Updates: I've since excluded my own calculated data due to it being a different model chemistry. *)
(**)
(*The DFT and TDDFT properties available in the dataset are vertical (VIE) and adiabatic (AIE) ionization energies, vertical (VEA) and adiabatic (AEA) electron affinities, cation (CR) and anion (AR) relaxation energies, HOMO energies (HOMO), LUMO energies (LUMO), electron (ER) and hole (HR) reorganization energies, and lowest-lying singlet (S0S1) and triplet (S0T1) excitation energies.*)


(* ::Input:: *)
(*data=Import["/Users/emiljaffal/Desktop/Comp Chem/OcelotChromophoreEdited.csv","Dataset",HeaderLines->1]*)


(* ::Input:: *)
(*smiles=Normal@data[[;;25253,1]];*)
(*bandgaps=Normal@data[[;;25253,2]];*)
(*LUMO=Normal@data[[;;25253,3]];*)
(*HOMO=Normal@data[[;;25253,4]];*)
(*HoleReorgE=Normal@data[[;;25253,5]];*)
(*ElectronReorgE=Normal@data[[;;25253,6]];*)
(*CationRelaxE=Normal@data[[;;25253,7]];*)
(*CationRelaxE2=Normal@data[[;;25253,8]];*)
(*AnionRelaxE=Normal@data[[;;25253,9]];*)
(*AnionRelaxE2=Normal@data[[;;25253,10]];*)
(*VertIonE=Normal@data[[;;25253,11]];*)
(*AdiaIonE=Normal@data[[;;25253,12]];*)
(*VertElecAff=Normal@data[[;;25253,13]];*)
(*AdiaElecAff=Normal@data[[;;25253,14]];*)
(*S0S1=Normal@data[[;;25253,15]];*)
(*S0T1=Normal@data[[;;25253,16]];*)


(* ::Input:: *)
(*fingerprints=Map[TopologicalFingerprint[Molecule[#]]&]@smiles;*)
(*DumpSave["AllFPs.mx",fingerprints];*)


(* ::Subsubsection:: *)
(*Preliminaries - Comparing Different Learning Models with [Topological Fingerprint] Baseline (Dataset only 12,000 for speed's sake)*)


(* ::Subsubsubsection:: *)
(*Predictor Measurements*)


(* ::Subsubsubsection:: *)
(*Predictor Measurements (cont.)*)


(* ::Subsubsubsection:: *)
(*Comparing trained dataset with different LMs*)


(* ::Subsubsubsection:: *)
(*Comparing pyrene (not in dataset) with different LMs*)


(* ::Subsubsection:: *)
(*Preliminaries - Comparing RF Learning Model with Different Descriptors (Dataset only 12,000 for speed's sake)*)


(* ::Subsubsubsection:: *)
(*Predictor Measurements*)


(* ::Text:: *)
(*From left to right, top to bottom: baseline (topological fingerprint),  # of H bond acceptors & donors (donors worked better by itself), Wiener index, HBond & WI, # of conjugated bonds, all electronic properties in the literature, molecular weight, and everything except the electronic properties. All electronic properties worked best in data prediction of outliers. Not included is the predictor function of everything... which performed on par with all electronic properties in terms of predicting outliers but performed poorly on the actual predictions. Also was slightly more computationally intensive, so there's that too.*)


(* ::Subsubsubsection:: *)
(*Predictor Measurements (cont.)*)


(* ::Subsubsubsection:: *)
(*Comparing trained dataset with different descriptors*)


(* ::Text:: *)
(*We see that the closest predictors to 5.70 eV in DFT is electronics and EEE. Keep in mind that this is with a small dataset - and just using topological fingerprints is pretty close to the DFT. The pattern is that no one descriptor works, but rather, a conglomeration of them. Using just descriptors we can get from Mathematica packages, we have a comparable prediction of 6.02 eV than that of the authors 5.91 eV that took a lot more DFT calculations. Maybe for outliers this degrades, as seen in the actual v. predicted values.*)


(* ::Subsubsubsection:: *)
(*Comparing pyrene (not in dataset) with different descriptors*)


(* ::Subsubsubsection:: *)
(*Descriptor Introduction - clean up*)


(* ::Text:: *)
(*To introduce the descriptors, I turn to the following article: Machine learning bandgaps of double perovskites\^\(1\) in which "any ML method, targeted towards learning a prespecified material property, relies on two main ingredients: the learning algorithm itself and a numerical representation (in form of a descriptor) of the materials in the learning (or training) dataset. Identification of an appropriate and most suitable fingerprint for a given prediction task is one of the central challenges, at present being actively pursued by the community."*)
(**)
(*Some preliminary information:*)


(* ::Text:: *)
(*The Wiener index is defined as the sum of distance between any two (non-carbon) atoms in the molecule,*)
(*Image[CompressedData["*)
(*1:eJztnUFOJDcUhlGSRZbhCBFXYJFtViibLCaKWM8oZMSGSEykUbgBN+AGnIAT*)
(*cAEuwCZr7kD6H+lHbyzbVV3tSpe7vk+qGUF3Vxdl/37P7z27fvzw17s/vzk6*)
(*Ovr0/eafd+8//3x9/f6f337Y/PD71afLj1cXf/xy9ffFx4vrnz58u/nlr5vj*)
(*383x3eZ4BQAAAAAAAAAAAAAAAAAAAAAAAAAAAACAUTw/P78+PDzs+zIAVon0*)
(*d3l5+arlMLe3t/u+HIDVId2dn5+/3tzcoEOAPRH9UHQIsH921eHd3d2Xc8xx*)
(*AKyFFvbw7OzsTTvyd6fy8vLyNmdFh7AmWuhQMZ/j4+M3/chG7sLJyQk6hFXR*)
(*an6oOad1KE1Km1PR9aBDWBMt4zSOv+o4PT2dfJ7Hx0d0CKuipQ41v5P+rEXi*)
(*sADjaK2Xp6enr2Kesm0AUEdaUYyyJTGXoZiL7CQAfI1sluIqyjE4riLtyHa1*)
(*0ozPvWsuA+BQub+//+KL5o5d4pwR6TnmMvSdAC2QvVDOekqfkr2RXVjTfMlx*)
(*zxa5DOgHtXOM16X+kPSTxg5iX9Gh2HsOzaF0bvl0pe/We6IN0PujZvVd+l3p*)
(*Ow4R5wJ3zWXsSqz5KSEbruvd53WqD+nofcxyPln3PcV1GqlNclxBus3Nj9Q2*)
(*tXiDtCb96fO+f76ONBZpf23XmpOeWEouQ9eR6xdC46vaZQm5FvUn9beefXnb*)
(*t/R+WislHeq1nM6kK32mtFbWcfpczFHtnvNDbZd7H/PGkta97cs3V9/O6WyJ*)
(*Y6P7ccn/WjrWRXq/3Qa5fqDXSm0gfen1EtJaScM19Jk1+acee/aVy6iNp55z*)
(*LI2hvrd0Uh3q3ssf8RgTdWgfoIT0UsqvlXzPMciH7fkeTyGupZg7l6Fx1fMQ*)
(*/e+au1T/1mfOB9SYbp86Hac9po/1aXQuz1HjuXxduXHANqXXfUtSbViDqQ7V*)
(*JmqjIZ+zpDP3qyn+pdtxTTlu329rca7+5XiZteV2zPV1xwbSNnTMz7V66bxy*)
(*m3HUMTydK45B0qD6osfzHDU7sHSidvR3+n6lOtR7SvP23PtTdI+m2rSSj1y6*)
(*hrHH0vMise5tjvmY+3R67tIc3vUGNdTGqf2eqo/cuK5rLvnF6p9L9JnHEP/W*)
(*mO+LuvLcvNZvazq0P5O2T4zT13QxVoct2UbPc+GYzVx9S+dNx8aa76n+URuL*)
(*/dmo69zvxuD+lF6H9FyKjdqX7RHrMNpCEXWl14fGs5oOS3FZUZpTRPahwyXg*)
(*uNYcsWLrI41/1eLTQzr0Z2PcMve7MdhWxza331uiZx06DyRblebRPR5Jn0N9*)
(*oTY/rOlwzL0bOz88JL/UMYm55oW+V+n4p/ZQn8gxpEPPNdPPTNFGbn3zUI1V*)
(*zzrUtefm0W6nUh4pR2ke4Dl37jV9pta2Ym3xUt/7OWMOOb/PeeNSewzND9MY*)
(*jeOwQ+2bw+OQqfmjpuf5YS4+LNxO2+T7ajkctWGcY26zN++a8oeeizv+OBfp*)
(*nF3tr3us/uBasXQ+X4qXGrW9dSDN6Dy2oen5cj5xxJrXPUh9tRI9x0vth6Rt*)
(*Xpon16jN8b2/mGtFXE9aq0MVS6mn0ffrnsxds+H2+D9qQ3xvY42a7ZC1E6m1*)
(*r8+nc8Xz2b/U+eLfNJQX9bU5jzZE7/nD1qgdW9WA2Dbsq47Rtcz6e+xf2Vef*)
(*Qyfus0uqGUtpVbfS+u/svZ5mDobWW4zB9Rn79EftE8RriPPmlng8X/o6YOdS*)
(*dtGQbNaU+sYSQ7nrNeP1h1P8hKWsP3R9VYpzLa1w7Uwv+2Lsut5CbdvKn1D/*)
(*6n29BUyjdXzcMYme1gvYZ58SC23Foaw/hGmMybWMxTHIJazlA+gF66aFz2z/*)
(*bp82BaA3rJsWcT7XaLWIVyxlbTzA3DiW0ipP7BqGXe2qc3roENaAbFernIJz*)
(*1C1yMvaTyV/DoeN8aPQfZYem+JMt1zLJlpb2EQI4JJxzTnMKU/ObcT+2lgc6*)
(*hEPG68u9V4iO3N6uY4jPWmt99JR7BNgG1wSVjm3zx3F/3tYHAAAAAMCSUAxX*)
(*uQz7zor1EsMBaIPmol4vH4+I630cVyK3CGvG6xDSfctKtTh6Lb7fe6r757ge*)
(*OsZt073McvU+6XUArAFpRXZIecJYayYbldOh3uv9lPxsU9k9vT/uVTFUe1N6*)
(*/g8ahDUjHcZ68NrzeUS6T0Tcn0w2zftylPxSfV+veyQBzIH3ibQtci12yTb5*)
(*/fFZIrHuLcZbSn5pWusd55LYRFgjroUz0kdpb17h/VXsU0pzMbbidec10vqe*)
(*uN9ND3ttALQm7hfhWuz4s5C9stasQyG95Z6tMrSXop+XZnp/NifArsS9Nz3P*)
(*8xoL6yL3TB/v6Zoj7iuamx9aqzqH1xezjyCsHekt2iI/N8uvpWsZ4+sl9Hpp*)
(*fhhf9/diCwHKMF8DAAAAAAAAAAAAAAAAAAAAAAAAgG34D4vvTHA=*)
(*"], "Byte", ColorSpace -> "RGB", Interleaving -> True]*)
(*where G represents the total atoms in the molecule, u and v are individual non-hydrogen atoms and d(u, v) is the shortest distance (in number of bonds) between atoms u and v. Let's construct a function to do this in a step by step fashion. This gives us a 2D topological descriptor.*)


(* ::Text:: *)
(*I will make a list of lists for the aforementioned descriptors that change according to whatever the input string is, which includes SMILES, InChi, etc.*)


(* ::Subsubsection:: *)
(*Bandgap Visualization*)


(* ::Input:: *)
(*Histogram[ *)
(*data[All,"Bandgap"],*)
(*{0.05},"PDF"]*)


(* ::Subsection:: *)
(*Setting up the ensemble:*)


(* ::Subsubsection:: *)
(*All Electronic Properties From Literature*)


(* ::Subsubsubsection:: *)
(*Including descriptors*)


(* ::Input:: *)
(*datasetAllElec=Table[{*)
(*HoleReorgE[[i]],ElectronReorgE[[i]],AnionRelaxE[[i]],VertIonE[[i]],AdiaIonE[[i]],VertElecAff[[i]],AdiaElecAff[[i]],fingerprints[[i]]}*)
(*->bandgaps[[i]],*)
(*{i,25251}];*)


(* ::Subsubsubsection:: *)
(*Distinguishing training and test data *)


(* ::Text:: *)
(*Train/test is an 80/20 split. Usual split revolves around this or 75/25.*)
(*Holding aside a portion of  training set (dividing  total data into training-main, training-meta, and test sets).*)


(* ::Input:: *)
(*{trainBig,testBig}=ResourceFunction["TrainTestSplit"]@datasetAllElec; (*80/20% split for training and test set*)*)


(* ::Input:: *)
(*{singleTrain, metaTrain}=ResourceFunction["TrainTestSplit"]@trainBig;(*splitting further for our meta model set test set*)*)


(* ::Subsubsubsection:: *)
(*Constructing models*)


(* ::Input:: *)
(*models={(*setting up each of the individual models*)*)
(*modelAllElecRF=Predict[singleTrain,Method->"RandomForest"],*)
(*modelAllElecGBT=Predict[singleTrain,Method->"GradientBoostedTrees"],*)
(*modelAllElecNN=Predict[singleTrain,Method->"NeuralNetwork"]};*)


(* ::Input:: *)
(*PMAERF=PredictorMeasurements[modelAllElecRF,trainData];*)


(* ::Input:: *)
(*PMAENN=PredictorMeasurements[modelAllElecNN,trainData];*)


(* ::Input:: *)
(*PMAEGBT=PredictorMeasurements[modelAllElecGBT,trainData];*)


(* ::Input:: *)
(*GraphicsRow[PMAERF,PMAENN,PMAEGBT]*)


(* ::Text:: *)
(*To get these values in a more digestible form we do the following below and see that the R^2 value has tremendously increased and a majority of the values are predicted very well.*)
(**)
(*For reference of the MSE, the lower the value the better and 0 means the model is perfect.*)


(* ::Input:: *)
(*Dataset[{*)
(*<|"ML Model (Full, All Electronic)"->"Random Forest","Standard Deviation"->PredictorMeasurements[modelAllElecRF,trainData,"StandardDeviation"],*)
(*"R Squared"->PredictorMeasurements[modelAllElecRF,trainData,"RSquared"],*)
(*"Mean Square"->PredictorMeasurements[modelAllElecRF,trainData,"MeanSquare"]|>,*)
(*<|"ML Model (Full, All Electronic)"->"Gradient Boosted Trees","Standard Deviation"->PredictorMeasurements[modelAllElecGBT,trainData,"StandardDeviation"],*)
(*"R Squared"->PredictorMeasurements[modelAllElecGBT,trainData,"RSquared"],*)
(*"Mean Square"->PredictorMeasurements[modelAllElecGBT,trainData,"MeanSquare"]|>,*)
(*<|"ML Model (Full, All Electronic)"->"Neural Network","Standard Deviation"->PredictorMeasurements[modelAllElecNN,trainData,"StandardDeviation"],*)
(*"R Squared"->PredictorMeasurements[modelAllElecNN,trainData,"RSquared"],*)
(*"Mean Square"->PredictorMeasurements[modelAllElecNN,trainData,"MeanSquare"]|>*)
(*}]*)


(* ::Subsubsection:: *)
(*Stacked 'top 3' ensemble setup*)


(* ::Subsubsubsection:: *)
(*Setting up *)


(* ::Input:: *)
(*metaModelTrainingSetup[x_->y_]:=({models[[1]]@x,models[[2]]@x,models[[3]]@x}->y)*)
(*(*Setting up the function here, maps each of the models onto x, to y - x1, x2, x3->actual bandgap as list*)*)


(* ::Text:: *)
(*Trained the individual models on the training-main data. Now, we're using them to create a new dataset based on the training-meta data items.\[NonBreakingSpace]*)


(* ::Input:: *)
(*dataWeUseForMMTraining=metaModelTrainingSetup/@metaTrain ;(*established above list here*)*)


(* ::Text:: *)
(*Using this new dataset to train the meta model.*)


(* ::Input:: *)
(*metaModel=Predict[dataWeUseForMMTraining,Method->"RandomForest"](*building the metaModel, using all the data, RF method*)*)


(* ::Input:: *)
(*predictionWithMM[models_List,metaModel_PredictorFunction,test_List]:=*)
(*With[*)
(*{x=Table[m[input],{input,test[[All,1]]},{m,models}],*)
(*y=singleTrain[[All,2]]},*)
(*With[*)
(*{newMetaDataset=Table[(x[[i]]->y[[i]]),{i,Length[x]}]},*)
(*PredictorMeasurements[metaModel,newMetaDataset]]]*)


(* ::Input:: *)
(*predictionWithMM[models,metaModel,singleTrain]*)


(* ::Input:: *)
(*predictionWithMMMS[models_List,metaModel_PredictorFunction,test_List]:=*)
(*With[*)
(*{x=Table[m[input],{input,test[[All,1]]},{m,models}],*)
(*y=singleTrain[[All,2]]},*)
(*With[*)
(*{newMetaDataset=Table[(x[[i]]->y[[i]]),{i,Length[x]}]},*)
(*PredictorMeasurements[metaModel,newMetaDataset,"MeanSquare"]]]*)


(* ::Subsubsubsection:: *)
(*Ensemble analysis*)


(* ::Input:: *)
(*Dataset[{*)
(*<|"ML Model (Full, All Electronic)"->"Ensemble",*)
(*"Standard Deviation"->.398,*)
(*"R Squared"->.845,*)
(*"Mean Square"->predictionWithMMMS[models,metaModel,singleTrain]|>,*)
(*<|"ML Model (Full, All Electronic)"->"Random Forest","Standard Deviation"->PredictorMeasurements[modelAllElecRF,trainData,"StandardDeviation"],*)
(*"R Squared"->PredictorMeasurements[modelAllElecRF,trainData,"RSquared"],*)
(*"Mean Square"->PredictorMeasurements[modelAllElecRF,trainData,"MeanSquare"]|>,*)
(*<|"ML Model (Full, All Electronic)"->"Gradient Boosted Trees","Standard Deviation"->PredictorMeasurements[modelAllElecGBT,trainData,"StandardDeviation"],*)
(*"R Squared"->PredictorMeasurements[modelAllElecGBT,trainData,"RSquared"],*)
(*"Mean Square"->PredictorMeasurements[modelAllElecGBT,trainData,"MeanSquare"]|>,*)
(*<|"ML Model (Full, All Electronic)"->"Neural Network","Standard Deviation"->PredictorMeasurements[modelAllElecNN,trainData,"StandardDeviation"],*)
(*"R Squared"->PredictorMeasurements[modelAllElecNN,trainData,"RSquared"],*)
(*"Mean Square"->PredictorMeasurements[modelAllElecNN,trainData,"MeanSquare"]|>*)
(*}]*)


(* ::Input:: *)
(*prediction[models_List,metaModel_PredictorFunction,x_]:=With[*)
(*{intermediateInputs=Table[m[input],{input,x[[All,1]]},{m,models}]},*)
(*metaModel[intermediateInputs]]*)


(* ::Input:: *)
(*MAE[n_]:=(Total@metaModel[dataWeUseForMMTraining[[;;n,1]]]-Total@dataWeUseForMMTraining[[;;n,2]])/Total@dataWeUseForMMTraining[[;;n,2]]*)


(* ::Input:: *)
(*MAE[2500]*)


(* ::Subsection:: *)
(*Citations*)


(* ::Reference:: *)
(*\!\(	\^\(1\)	https://www . ncbi . nlm . nih . gov/pmc/articles/PMC4726030/\)*)


(* ::Reference:: *)
(*\!\(	\^\(2\)	https://chem . libretexts . org/Courses/Intercollegiate_Courses/Cheminformatics/06%3 A_Molecular _Similarity/6.02%3 A_Similarity _Coefficients\)*)


(* ::Reference:: *)
(*\!\(	\^\(3\)	https://chemistry-europe . onlinelibrary . wiley . com/doi/pdf/10.1002/cphc.202100222\)*)
