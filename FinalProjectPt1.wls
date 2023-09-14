#!/usr/bin/env wolframscript
(* ::Package:: *)

(* ::Section:: *)
(*Setup*)


(* ::Input:: *)
(*PacletInstall["WolframChemistry/MoleculeFingerprints"] (*only once*)*)


(* ::Input:: *)
(*Needs["WolframChemistry`MoleculeFingerprints`"] (*at start of new session*)*)


(* ::Section:: *)
(*Preliminaries*)


(* ::Input:: *)
(*mols=Molecule/@{ex1,ex2,ex3}*)
(*MoleculeDistance[mols[[1]],mols[[3]]]*)


(* ::Input:: *)
(*MoleculeDistance[mols[[1]],mols[[3]], "FingerprintType"->MACCSKeysFingerprint]*)


(* ::Input:: *)
(*$DefaultFingerprintType*)


(* ::Input:: *)
(*MoleculeDistanceMatrix[mols]//MatrixForm*)


(* ::Input:: *)
(*fp=Map[MACCSKeysFingerprint]@mols*)


(* ::Section:: *)
(*What to do?*)


(* ::Input:: *)
(*data=Import["/Users/emiljaffal/Desktop/Comp Chem/OcelotChromophoreEdited.csv","Dataset",HeaderLines->1]*)


(* ::Text:: *)
(*Updates: I've since excluded my data due to it being a different model chemistry. *)
(**)
(*The DFT and TDDFT properties available in the dataset are vertical (VIE) and adiabatic (AIE) ionization energies, vertical (VEA) and adiabatic (AEA) electron affinities, cation (CR) and anion (AR) relaxation energies, HOMO energies (HOMO), LUMO energies (LUMO), HOMO\[Dash]LUMO energy gaps (H\[Dash]L), electron (ER) and hole (HR) reorganization energies, and lowest-lying singlet (S0S1) and triplet (S0T1) excitation energies.*)
(**)
(*Vertical ionization energy and adiabatic ionization energy are two different ways to measure the energy required to remove an electron from an atom or a molecule.*)
(*The vertical ionization energy is the energy required to remove an electron from an atom or molecule in its ground state. This means that the electron is removed without any change in the energy of the remaining electrons. In other words, the energy required to remove the electron is equal to the difference in energy between the ground state and the ionized state.*)
(**)
(*On the other hand, adiabatic ionization energy is the energy required to remove an electron from an atom or molecule when it is in any energy state, not necessarily its ground state. This means that the energy required to remove the electron is the minimum energy needed to take the electron from its initial energy state to the ionized state without any change in the energy of the system due to external factors. In practice, the adiabatic ionization energy is usually larger than the vertical ionization energy, because removing an electron from an excited state requires more energy than removing it from the ground state.*)


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
(*fingerprints=Map[TopologicalFingerprint[Molecule[#]]&]@smiles*)
(*DumpSave["AllFPs.mx",fingerprints];*)


(* ::Input:: *)
(*fullDataset=Table[fingerprints[[i]]->bandgaps[[i]],{i,25251}](*baseline, topological fingerprints*)*)


(* ::Input:: *)
(*{trainFullBase,testFullBase}=ResourceFunction["TrainTestSplit"][fullDataset]; (* 80/20% split *)*)
(*baselineModel=Predict[trainFullBase,Method->"RandomForest"]*)


(* ::Text:: *)
(*RF LM with just baseline works pretty good on predicting trained dataset*)


(* ::Input:: *)
(*example=trainFullBase[[1,1]];(*example from trained dataset*)*)
(*t=trainFullBase[[1,2]]*)
(*bm=baselineModel[example]*)
(*percentError=(t-bm)/t*100*)


(* ::Text:: *)
(*But poorly on extrapolating data, a common theme in ML algorithms*)


(* ::Input:: *)
(*baselineModel[TopologicalFingerprint@Molecule["Pyrene"]](*works better than prev. ML w/ all descriptors... NN on the other hand is 6.15*)*)


(* ::Input:: *)
(*PMSupaSmolRFTrain=PredictorMeasurements[baselineModel,trainFullBase](*which is more affective? ie.) diff. btw train and test?*)*)
(*PMSupaSmolRFTest=PredictorMeasurements[baselineModel,testFullBase]*)


(* ::Input:: *)
(*(*use loss functions that emphasize extremes...*)*)


(* ::Section:: *)
(*Compare diff LMs with smaller dataset - 12K, topological fingerprints as the baseline (explain)*)


(* ::Input:: *)
(*datasetSmol=Table[ fingerprints[[i]]->bandgaps[[i]],{i,12000}];(*baseline to compare to other descriptors, RF*)*)


(* ::Input:: *)
(*{trainSmol,testSmol}=ResourceFunction["TrainTestSplit"][datasetSmol]; (* 80/20% split *)*)


(* ::Input:: *)
(*modelSmolRF=Predict[trainSmol,Method->"RandomForest"]*)


(* ::Input:: *)
(*modelSmolKNN=Predict[trainSmol,Method->"NearestNeighbors"]*)


(* ::Input:: *)
(*modelSmolNN=Predict[trainSmol,Method->"NeuralNetwork"]*)


(* ::Input:: *)
(*modelSmolDT=Predict[trainSmol,Method->"DecisionTree"]*)


(* ::Input:: *)
(*modelSmolLR=Predict[trainSmol,Method->"LinearRegression"]*)


(* ::Input:: *)
(*modelSmolGBT=Predict[trainSmol,Method->"GradientBoostedTrees"]*)


(* ::Input:: *)
(*modelSmolGP=Predict[trainSmol,Method->"GaussianProcess"]*)


(* ::Input:: *)
(*PMDT=PredictorMeasurements[modelSmolDT,trainSmol];*)
(*PMKNN=PredictorMeasurements[modelSmolKNN,trainSmol];*)
(*PMNN=PredictorMeasurements[modelSmolNN,trainSmol];*)
(*PMRF=PredictorMeasurements[modelSmolRF,trainSmol];*)
(*PMLR=PredictorMeasurements[modelSmolLR,trainSmol];*)
(*PMGBT=PredictorMeasurements[modelSmolGBT,trainSmol];*)
(*PMGP=PredictorMeasurements[modelSmolGP,trainSmol];*)


(* ::Input:: *)
(*GraphicsRow[PMDT,PMKNN,PMNN,PMRF,PMLR,PMGBT,PMGP]*)


(* ::Input:: *)
(*TableForm[{*)
(*PredictorMeasurements[modelSmolGBT,trainSmol,{"StandardDeviation","RSquared","MeanSquare"}],*)
(*PredictorMeasurements[modelSmolKNN,trainSmol,{"StandardDeviation","RSquared","MeanSquare"}],*)
(*PredictorMeasurements[modelSmolRF,trainSmol,{"StandardDeviation","RSquared","MeanSquare"}],*)
(*PredictorMeasurements[modelSmolGP,trainSmol,{"StandardDeviation","RSquared","MeanSquare"}],*)
(*PredictorMeasurements[modelSmolLR,trainSmol,{"StandardDeviation","RSquared","MeanSquare"}],*)
(*PredictorMeasurements[modelSmolNN,trainSmol,{"StandardDeviation","RSquared","MeanSquare"}],*)
(*PredictorMeasurements[modelSmolDT,trainSmol,{"StandardDeviation","RSquared","MeanSquare"}]},*)
(**)
(*TableHeadings->{{"Gradient Boosted Trees","K-Nearest Neighbors","Random Forest","Gaussian Process","Linear Regression","Neural Network","Decision Tree"},{"Standard Deviation","R Squared","Mean Square"}}](*Closest to full dataset: NN, RF, GBT*)*)
(**)


(* ::Input:: *)
(*Dataset[{*)
(*<|"ML Model"->"Linear Regression","Standard Deviation"->PredictorMeasurements[modelSmolLR,trainSmol,"StandardDeviation"],*)
(*"R Squared"->PredictorMeasurements[modelSmolLR,trainSmol,"RSquared"],*)
(*"Mean Square"->PredictorMeasurements[modelSmolLR,trainSmol,"MeanSquare"]|>,*)
(*<|"ML Model"->"Neural Network","Standard Deviation"->PredictorMeasurements[modelSmolNN,trainSmol,"StandardDeviation"],*)
(*"R Squared"->PredictorMeasurements[modelSmolNN,trainSmol,"RSquared"],*)
(*"Mean Square"->PredictorMeasurements[modelSmolNN,trainSmol,"MeanSquare"]|>,*)
(*<|"ML Model"->"Gradient Boosted Trees","Standard Deviation"->PredictorMeasurements[modelSmolGBT,trainSmol,"StandardDeviation"],*)
(*"R Squared"->PredictorMeasurements[modelSmolGBT,trainSmol,"RSquared"],*)
(*"Mean Square"->PredictorMeasurements[modelSmolGBT,trainSmol,"MeanSquare"]|>,*)
(*<|"ML Model"->"Gaussian Process","Standard Deviation"->PredictorMeasurements[modelSmolGP,trainSmol,"StandardDeviation"],*)
(*"R Squared"->PredictorMeasurements[modelSmolGP,trainSmol,"RSquared"],*)
(*"Mean Square"->PredictorMeasurements[modelSmolGP,trainSmol,"MeanSquare"]|>,*)
(*<|"ML Model"->"Decision Tree","Standard Deviation"->PredictorMeasurements[modelSmolDT,trainSmol,"StandardDeviation"],*)
(*"R Squared"->PredictorMeasurements[modelSmolDT,trainSmol,"RSquared"],*)
(*"Mean Square"->PredictorMeasurements[modelSmolDT,trainSmol,"MeanSquare"]|>,*)
(*<|"ML Model"->"Random Forest","Standard Deviation"->PredictorMeasurements[modelSmolRF,trainSmol,"StandardDeviation"],*)
(*"R Squared"->PredictorMeasurements[modelSmolRF,trainSmol,"RSquared"],*)
(*"Mean Square"->PredictorMeasurements[modelSmolRF,trainSmol,"MeanSquare"]|>,*)
(*<|"ML Model"->"K-Nearest Neighbors","Standard Deviation"->PredictorMeasurements[modelSmolKNN,trainSmol,"StandardDeviation"],*)
(*"R Squared"->PredictorMeasurements[modelSmolKNN,trainSmol,"RSquared"],*)
(*"Mean Square"->PredictorMeasurements[modelSmolKNN,trainSmol,"MeanSquare"]|>*)
(*}]*)


(* ::Input:: *)
(*TableForm[{trainFullBase[[1,2]],*)
(*modelSmolGBT[example],*)
(*modelSmolKNN[example],*)
(*modelSmolRF[example],*)
(*modelSmolGP[example],*)
(*modelSmolLR[example],*)
(*modelSmolNN[example],*)
(*modelSmolDT[example]},*)
(*TableHeadings->{{"First Trained, DFT","Gradient Boosted Trees","K-Nearest Neighbors","Random Forest","Gaussian Process","Linear Regression","Neural Network","Decision Tree"},{"Predicted Values of 1st Trained Molecule"}}](*Closest to full dataset: NN, RF, GBT*)*)
(**)


(* ::Input:: *)
(*Dataset[{*)
(*<|"ML Model (Comparing 1st Trained, Different LMs)"->"DFT","Predicted Value (eV)"->trainFullBase[[1,2]]|>,*)
(*<|"ML Model (Comparing 1st Trained, Different LMs)"->"Linear Regression","Predicted Value (eV)"->modelSmolLR[example] |>,*)
(*<|"ML Model (Comparing 1st Trained, Different LMs)"->"Neural Network","Predicted Value (eV)"->modelSmolNN[example]|>,*)
(*<|"ML Model (Comparing 1st Trained, Different LMs)"->"Gradient Boosted Trees","Predicted Value (eV)"->modelSmolGBT[example]|>,*)
(*<|"ML Model (Comparing 1st Trained, Different LMs)"->"K-Nearest Neighbors","Predicted Value (eV)"->modelSmolKNN[example]|>,*)
(*<|"ML Model (Comparing 1st Trained, Different LMs)"->"Gaussian Process","Predicted Value (eV)"->modelSmolGP[example]|>,*)
(*<|"ML Model (Comparing 1st Trained, Different LMs)"->"Random Forest","Predicted Value (eV)"->modelSmolRF[example]|>,*)
(*<|"ML Model (Comparing 1st Trained, Different LMs)"->"Decision Tree","Predicted Value (eV)"->modelSmolDT[example]|>}]*)


(* ::Input:: *)
(*(*Try using same model chemistry on pyrene... technically can't b/c of IPs - purpose?*)*)
(*TableForm[{modelSmolLR[TopologicalFingerprint@Molecule["Pyrene"]],*)
(*modelSmolNN[TopologicalFingerprint@Molecule["Pyrene"]],*)
(*modelSmolGBT[TopologicalFingerprint@Molecule["Pyrene"]],*)
(*modelSmolKNN[TopologicalFingerprint@Molecule["Pyrene"]],*)
(*modelSmolGP[TopologicalFingerprint@Molecule["Pyrene"]],*)
(*modelSmolRF[TopologicalFingerprint@Molecule["Pyrene"]],*)
(*modelSmolDT[TopologicalFingerprint@Molecule["Pyrene"]]},*)
(*TableHeadings->{{"Linear Regression","Neural Network","Gradient Boosted Trees","K-Nearest Neighbors","Gaussian Process","Random Forest","Decision Tree"},{"Predicted Values of Pyrene"}}]*)


(* ::Input:: *)
(*Dataset[{<|"ML Model (Comparing Pyrene, Different LMs)"->"Linear Regression","Predicted Value (eV)"->modelSmolLR[TopologicalFingerprint@Molecule["Pyrene"]] |>,*)
(*<|"ML Model (Comparing Pyrene, Different LMs)"->"Neural Network","Predicted Value (eV)"->modelSmolNN[TopologicalFingerprint@Molecule["Pyrene"]]|>,*)
(*<|"ML Model (Comparing Pyrene, Different LMs)"->"Gradient Boosted Trees","Predicted Value (eV)"->modelSmolGBT[TopologicalFingerprint@Molecule["Pyrene"]]|>,*)
(*<|"ML Model (Comparing Pyrene, Different LMs)"->"K-Nearest Neighbors","Predicted Value (eV)"->modelSmolKNN[TopologicalFingerprint@Molecule["Pyrene"]]|>,*)
(*<|"ML Model (Comparing Pyrene, Different LMs)"->"Gaussian Process","Predicted Value (eV)"->modelSmolGP[TopologicalFingerprint@Molecule["Pyrene"]]|>,*)
(*<|"ML Model (Comparing Pyrene, Different LMs)"->"Random Forest","Predicted Value (eV)"->modelSmolRF[TopologicalFingerprint@Molecule["Pyrene"]]|>,*)
(*<|"ML Model (Comparing Pyrene, Different LMs)"->"Decision Tree","Predicted Value (eV)"->modelSmolDT[TopologicalFingerprint@Molecule["Pyrene"]]|>}]*)


(* ::Subsection:: *)
(*Stacked 'top 3' ensemble with smaller dataset - Based on above, using: GBT, NN, RF*)


(* ::Subsubsection:: *)
(*Practicing formatting of meta learner (inputs/outputs)*)


(* ::Input:: *)
(*datasetSmoller=Table[{*)
(*HoleReorgE[[i]],ElectronReorgE[[i]],AnionRelaxE[[i]],VertIonE[[i]],AdiaIonE[[i]],VertElecAff[[i]],AdiaElecAff[[i]],fingerprints[[i]]}*)
(*->bandgaps[[i]],*)
(*{i,4000}];*)


(* ::Text:: *)
(*trainBig = 60%, trainModel*)
(*singleTrain = 20%, testData*)
(*metaTrain = 20%, trainMetaData*)


(* ::Input:: *)
(*{trainBig,testBig}=ResourceFunction["TrainTestSplit"]@datasetSmoller; (* 80/20% split for training and test set - testBig gets cut down, dont use*)*)


(* ::Input:: *)
(*{singleTrain, metaTrain}=ResourceFunction["TrainTestSplit"]@trainBig;(*splitting further for our meta model set test set*)*)


(* ::Input:: *)
(*models={(*setting up each of the individual models*)*)
(*Predict[singleTrain,Method->"RandomForest"],*)
(*Predict[singleTrain,Method->"GradientBoostedTrees"],*)
(*Predict[singleTrain,Method->"NeuralNetwork"]};*)


(* ::Input:: *)
(*metaModelTrainingSetup[x_->y_]:=({models[[1]]@x,models[[2]]@x,models[[3]]@x}->y)*)
(*(*Setting up the function here, maps each of the models onto x, to y - x1, x2, x3->actual bandgap as list*)*)


(* ::Input:: *)
(*dataWeUseForMMTraining=metaModelTrainingSetup/@metaTrain ;(*established above list here*)*)


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
(*prediction[models_List,metaModel_PredictorFunction,x_]:=With[*)
(*{intermediateInputs=Table[m[input],{input,x[[All,1]]},{m,models}]},*)
(*metaModel[intermediateInputs]]*)


(* ::Input:: *)
(*a=prediction[models,metaModel,singleTrain];*)
(*a[[;;10]]*)
(*singleTrain[[;;10,2]]*)


(* ::Input:: *)
(*datasetSmoller[[;;4,2]]*)


(* ::Input:: *)
(*Total@((a[[;;2500]]-singleTrain[[;;2500,2]])/singleTrain[[;;2500,2]])/2500 (*error btw. single trained dataset and *)*)


(* ::Input:: *)
(*Total@((a[[;;2500]]-datasetSmoller[[;;2500,2]])/datasetSmoller[[;;2500,2]])/2500 (*on average, our meta learner predicts bandgap to be .023 eV more than the dataset*)*)


(* ::Section:: *)
(*Comparing Descriptors:*)


(* ::Subsubsection:: *)
(*# of H Bond Donors & Acceptors*)


(* ::Input:: *)
(*HBondDon[Molecule_]:=MoleculeValue[Molecule,"HBondDonorCount"](*MOLECULE -> BANG!*)*)
(*HBondAcc[Molecule_]:=MoleculeValue[Molecule,"HBondAcceptorCount"]*)


(* ::Input:: *)
(*HBondDon2=Map[HBondDon[Molecule[#]]&]@smiles;*)
(*HBondAcc2=Map[HBondAcc[Molecule[#]]&]@smiles;*)


(* ::Input:: *)
(*datasetSmolHBond=Table[{*)
(*HBondDon2[[i]],HBondAcc2[[i]],fingerprints[[i]]}->bandgaps[[i]],*)
(*{i,12000}];*)


(* ::Input:: *)
(*{trainSmolHBond,testSmolHBond}=ResourceFunction["TrainTestSplit"][datasetSmolHBond]; (* 80/20% split *)*)
(*modelSmolHBondRF=Predict[trainSmolHBond,Method->"RandomForest"]*)


(* ::Input:: *)
(*PMHBondRF=PredictorMeasurements[modelSmolHBondRF,trainSmolHBond];*)


(* ::Subsubsection:: *)
(*Wiener Index*)


(* ::Input:: *)
(*WienerIndex[m_Molecule]:=With[*)
(*{distances=m["GraphDistanceMatrix",IncludeHydrogens->False] },*)
(*(Total[distances,2]/2)]*)
(*WienerIndex[Molecule_]:=WienerIndex@Molecule*)


(* ::Input:: *)
(*WienerIndex2=Map[WienerIndex[Molecule[#]]&]@smiles;*)


(* ::Input:: *)
(*datasetSmolWiener=Table[{*)
(*WienerIndex2[[i]],fingerprints[[i]]}->bandgaps[[i]],*)
(*{i,12000}];*)


(* ::Input:: *)
(*{trainSmolWiener,testSmolWiener}=ResourceFunction["TrainTestSplit"][datasetSmolWiener]; (* 80/20% split *)*)
(*modelSmolWienerRF=Predict[trainSmolWiener,Method->"RandomForest"]*)


(* ::Input:: *)
(*PMWienerRF=PredictorMeasurements[modelSmolWienerRF,trainSmolWiener];*)


(* ::Subsubsection:: *)
(*Wiener Index & # H Bond Donors*)


(* ::Input:: *)
(*datasetSmolHBondDonWiener=Table[{*)
(*HBondDon2[[i]],WienerIndex2[[i]],fingerprints[[i]]}->bandgaps[[i]],*)
(*{i,12000}];*)


(* ::Input:: *)
(*{trainSmolHBondDonWiener,testSmolHBondDonWiener}=ResourceFunction["TrainTestSplit"][datasetSmolHBondDonWiener]; (* 80/20% split *)*)
(*modelSmolHBondDonWienerRF=Predict[trainSmolHBondDonWiener,Method->"RandomForest"]*)


(* ::Input:: *)
(*PMHBondDonWienerRF=PredictorMeasurements[modelSmolHBondDonWienerRF,trainSmolHBondDonWiener];*)


(* ::Subsubsection:: *)
(*# of Conj Bonds*)


(* ::Input:: *)
(*ConjBonds[Molecule_]:=Count[MoleculeValue[Molecule,"ConjugatedBondQ"],True]*)


(* ::Input:: *)
(*ConjBonds2=Map[ConjBonds[Molecule[#]]&]@smiles;*)


(* ::Input:: *)
(*datasetSmolConjBonds=Table[{*)
(*ConjBonds2[[i]],fingerprints[[i]]}->bandgaps[[i]],*)
(*{i,12000}];*)


(* ::Input:: *)
(*{trainSmolConjBonds,testSmolConjBonds}=ResourceFunction["TrainTestSplit"][datasetSmolConjBonds]; (* 80/20% split *)*)
(*modelSmolConjBondsRF=Predict[trainSmolConjBonds,Method->"RandomForest"]*)


(* ::Input:: *)
(*PMConjBondsRF=PredictorMeasurements[modelSmolConjBondsRF,trainSmolConjBonds];*)


(* ::Subsubsection:: *)
(*All Electronic Properties From Before*)


(* ::Input:: *)
(*datasetAllElecRF=Table[{*)
(*HoleReorgE[[i]],ElectronReorgE[[i]],AnionRelaxE[[i]],VertIonE[[i]],AdiaIonE[[i]],VertElecAff[[i]],AdiaElecAff[[i]],fingerprints[[i]]}*)
(*->bandgaps[[i]],*)
(*{i,12000}];*)


(* ::Input:: *)
(*{trainSmolAllElec,testSmolAllElec}=ResourceFunction["TrainTestSplit"][datasetAllElecRF]; (* 80/20% split *)*)
(*modelSmolAllElecRF=Predict[trainSmolAllElec,Method->"RandomForest"]*)


(* ::Input:: *)
(*PMAllElecRF=PredictorMeasurements[modelSmolAllElecRF,trainSmolAllElec];*)


(* ::Subsubsection:: *)
(*Molecular Weights*)


(* ::Input:: *)
(*MolW[Molecule_]:=QuantityMagnitude[MoleculeValue[Molecule,"MolecularMass"]]*)


(* ::Input:: *)
(*MolW2=Map[MolW[Molecule[#]]&]@smiles;*)


(* ::Input:: *)
(*datasetSmolMW=Table[{*)
(*MolW2[[i]],fingerprints[[i]]}->bandgaps[[i]],*)
(*{i,12000}];*)


(* ::Input:: *)
(*{trainSmolMolW,testSmolMolW}=ResourceFunction["TrainTestSplit"][datasetSmolMW]; (* 80/20% split *)*)
(*modelSmolMolWRF=Predict[trainSmolMolW,Method->"RandomForest"]*)


(* ::Input:: *)
(*PMMolWRF=PredictorMeasurements[modelSmolMolWRF,trainSmolMolW];*)


(* ::Subsubsection:: *)
(*Everything Except Electronics*)


(* ::Input:: *)
(*datasetSmolEverythingEE=Table[{*)
(*HBondDon2[[i]],HBondAcc2[[i]],WienerIndex2[[i]],ConjBonds2[[i]],MolW2[[i]],fingerprints[[i]]}->bandgaps[[i]],*)
(*{i,12000}];*)


(* ::Input:: *)
(*{trainSmolEverythingEE,testSmolEverythingEE}=ResourceFunction["TrainTestSplit"][datasetSmolEverythingEE]; (* 80/20% split *)*)
(*modelSmolEverythingEERF=Predict[trainSmolEverythingEE,Method->"RandomForest"]*)


(* ::Input:: *)
(*PMEverythingEERF=PredictorMeasurements[modelSmolEverythingEERF,trainSmolEverythingEE];*)


(* ::Subsubsection:: *)
(*Comparing RF LM W/ Diff. Descriptors*)


(* ::Subsubsubsection:: *)
(*Predictor Measurements*)


(* ::Input:: *)
(*GraphicsRow[PMRF,PMHBondRF,PMWienerRF,PMHBondDonWienerRF,PMConjBondsRF,PMAllElecRF,PMMolWRF,PMEverythingEERF]*)


(* ::Subsubsubsection:: *)
(*Comparing each RF w/ descriptors to example in training data*)


(* ::Input:: *)
(*TableForm[{trainFullBase[[1,2]] ,(*DFT bandgap value of 1st trained molecule*)*)
(*baselineModel[example], (*Baseline = topological fingerprint @ RF, FULL DATASET*)*)
(*modelSmolRF[example],(*Baseline = topological fingerprint, smaller dataset for comparison purposes to descriptors*)*)
(*modelSmolHBondRF[trainSmolHBond[[1,1]]],*)
(*modelSmolWienerRF[trainSmolWiener[[1,1]]],*)
(*modelSmolHBondDonWienerRF[trainSmolHBondDonWiener[[1,1]]],*)
(*modelSmolConjBondsRF[trainSmolConjBonds[[1,1]]],*)
(*modelSmolMolWRF[trainSmolMolW[[1,1]]],*)
(*modelSmolEverythingEERF[trainSmolEverythingEE[[1,1]]],*)
(*modelSmolAllElecRF[trainSmolAllElec[[1,1]]]},TableHeadings->{{"First Trained, DFT","RF Full Baseline","RF Small Baseline","Small  H Bond Dons/Accs","Small Wiener Index","Small H Bond & WI","Small Conjugated Bonds","Small Molecular Weight","Small Everything Except Electronics", "Small Electronics"},{"Predicted Values of Pyrene"}}](*Pattern... more descriptors = better - 2 routes...*)*)


(* ::Input:: *)
(*Dataset[{<|"ML Model (Comparing 1st Trained, Descriptors)"->"DFT","Predicted Value (eV)"->trainFullBase[[1,2]] |>,*)
(*<|"ML Model (Comparing 1st Trained, Descriptors)"->"RF Full Baseline","Predicted Value (eV)"->baselineModel[example]|>,*)
(*<|"ML Model (Comparing 1st Trained, Descriptors)"->"RF Small Baseline","Predicted Value (eV)"->modelSmolRF[example]|>,*)
(*<|"ML Model (Comparing 1st Trained, Descriptors)"->"Small  H Bond Dons/Accs","Predicted Value (eV)"->modelSmolHBondRF[trainSmolHBond[[1,1]]]|>,*)
(*<|"ML Model (Comparing 1st Trained, Descriptors)"->"Small Wiener Index","Predicted Value (eV)"->modelSmolWienerRF[trainSmolWiener[[1,1]]]|>,*)
(*<|"ML Model (Comparing 1st Trained, Descriptors)"->"Small Conjugated Bonds","Predicted Value (eV)"->modelSmolConjBondsRF[trainSmolConjBonds[[1,1]]]|>,*)
(*<|"ML Model (Comparing 1st Trained, Descriptors)"->"Small H Bond & WI","Predicted Value (eV)"->modelSmolHBondDonWienerRF[trainSmolHBondDonWiener[[1,1]]]|>,*)
(*<|"ML Model (Comparing 1st Trained, Descriptors)"->"Small Molecular Weight","Predicted Value (eV)"->modelSmolMolWRF[trainSmolMolW[[1,1]]]|>,*)
(*<|"ML Model (Comparing 1st Trained, Descriptors)"->"Small Everything Except Electronics","Predicted Value (eV)"->modelSmolEverythingEERF[trainSmolEverythingEE[[1,1]]]|>,*)
(*<|"ML Model (Comparing 1st Trained, Descriptors)"->"Electronics","Predicted Value (eV)"->modelSmolAllElecRF[trainSmolAllElec[[1,1]]]|>}]*)


(* ::Subsubsubsection:: *)
(*Comparing each to pyrene - affects of extrapolation (pyrene = 3.83 eV DFT (*what about scientists DFT>>>..., 3.75 exp.)*)


(* ::Text:: *)
(*Checked SMILES with Excel file... not in...*)


(* ::Input:: *)
(*ChemicalData["Pyrene","SMILES"]*)


(* ::Input:: *)
(*TableForm[{baselineModel[TopologicalFingerprint@Molecule["Pyrene"]],*)
(*modelSmolRF[TopologicalFingerprint@Molecule["Pyrene"]],*)
(*modelSmolHBondRF[{HBondDon@Molecule["Pyrene"],HBondAcc@Molecule["Pyrene"],TopologicalFingerprint@Molecule["Pyrene"]}],*)
(*modelSmolWienerRF[{WienerIndex@Molecule["Pyrene"],TopologicalFingerprint@Molecule["Pyrene"]}],*)
(*modelSmolConjBondsRF[{ConjBonds@Molecule["Pyrene"],TopologicalFingerprint@Molecule["Pyrene"]}],*)
(*modelSmolHBondDonWienerRF[{HBondDon@Molecule["Pyrene"],WienerIndex@Molecule["Pyrene"],TopologicalFingerprint@Molecule["Pyrene"]}],*)
(*modelSmolMolWRF[{MolW@Molecule["Pyrene"],TopologicalFingerprint@Molecule["Pyrene"]}],*)
(*modelSmolEverythingEERF[{HBondDon@Molecule["Pyrene"],HBondAcc@Molecule["Pyrene"],WienerIndex@Molecule["Pyrene"],ConjBonds@Molecule["Pyrene"],MolW@Molecule["Pyrene"],TopologicalFingerprint@Molecule["Pyrene"]}]},*)
(**)
(*TableHeadings->{{"RF Full Baseline","RF Small Baseline","Small  H Bond Dons/Accs","Small Wiener Index","Small Conjugated Bonds","Small H Bond & WI","Small Molecular Weight","Small Everything Except Electronics"},{"Predicted Values of Pyrene"}}]*)


(* ::Input:: *)
(*SortBy[Dataset[{<|"ML Model (Comparing Pyrene, Descriptors)"->"RF Full Baseline","Predicted Value (eV)"->baselineModel[TopologicalFingerprint@Molecule["Pyrene"]]|>,*)
(*<|"ML Model (Comparing Pyrene, Descriptors)"->"RF Small Baseline","Predicted Value (eV)"->modelSmolRF[TopologicalFingerprint@Molecule["Pyrene"]]|>,*)
(*<|"ML Model (Comparing Pyrene, Descriptors)"->"Small  H Bond Dons/Accs","Predicted Value (eV)"->modelSmolHBondRF[{HBondDon@Molecule["Pyrene"],HBondAcc@Molecule["Pyrene"],TopologicalFingerprint@Molecule["Pyrene"]}]|>,*)
(*<|"ML Model (Comparing Pyrene, Descriptors)"->"Small Wiener Index","Predicted Value (eV)"->modelSmolWienerRF[{WienerIndex@Molecule["Pyrene"],TopologicalFingerprint@Molecule["Pyrene"]}]|>,*)
(*<|"ML Model (Comparing Pyrene, Descriptors)"->"Small Conjugated Bonds","Predicted Value (eV)"->modelSmolConjBondsRF[{ConjBonds@Molecule["Pyrene"],TopologicalFingerprint@Molecule["Pyrene"]}]|>,*)
(*<|"ML Model (Comparing Pyrene, Descriptors)"->"Small H Bond & WI","Predicted Value (eV)"->modelSmolHBondDonWienerRF[{HBondDon@Molecule["Pyrene"],WienerIndex@Molecule["Pyrene"],TopologicalFingerprint@Molecule["Pyrene"]}]|>,*)
(*<|"ML Model (Comparing Pyrene, Descriptors)"->"Small Molecular Weight","Predicted Value (eV)"->modelSmolMolWRF[{MolW@Molecule["Pyrene"],TopologicalFingerprint@Molecule["Pyrene"]}]|>,*)
(*<|"ML Model (Comparing Pyrene, Descriptors)"->"Small Everything Except Electronics","Predicted Value (eV)"->modelSmolEverythingEERF[{HBondDon@Molecule["Pyrene"],HBondAcc@Molecule["Pyrene"],WienerIndex@Molecule["Pyrene"],ConjBonds@Molecule["Pyrene"],MolW@Molecule["Pyrene"],TopologicalFingerprint@Molecule["Pyrene"]}]|>}],1]*)


(* ::Subsubsubsection:: *)
(*Proposed Best Model By Looking At Comparisons: Everything*)


(* ::Input:: *)
(*datasetEverythingRF=Table[{*)
(*MolW2[[i]],HBondDon2[[i]],HBondAcc2[[i]],ConjBonds2[[i]],WienerIndex2[[i]],HoleReorgE[[i]],ElectronReorgE[[i]],AnionRelaxE[[i]],VertIonE[[i]],AdiaIonE[[i]],VertElecAff[[i]],AdiaElecAff[[i]],fingerprints[[i]]}*)
(*->bandgaps[[i]],*)
(*{i,12000}];*)


(* ::Input:: *)
(*{trainSmolEverything,testSmolEverything}=ResourceFunction["TrainTestSplit"][datasetEverythingRF]; (* 80/20% split *)*)
(*modelSmolEverythingRF=Predict[trainSmolEverything,Method->"RandomForest"]*)


(* ::Input:: *)
(*PMEverythingRF=PredictorMeasurements[modelSmolEverythingRF,trainSmolEverything]*)


(* ::Subsubsubsection:: *)
(*Compare:*)


(* ::Input:: *)
(*GraphicsRow[PMEverythingRF,PMEverythingEERF,PMRF,PMAllElecRF]*)


(* ::Input:: *)
(*modelSmolEverythingRF[trainSmolEverything[[1,1]] ] *)


(* ::Subsubsection:: *)
(*Other:*)


(* ::Input:: *)
(*Dimensions/@{train,test}(*confirms number*)*)


(* ::Input:: *)
(*train[[1;;5]](*displays 1-5 of training data*)*)


(* ::Input:: *)
(*fullDataset[[1054]](*bandgap of molecule 1054*)*)


(* ::Input:: *)
(*trainFullBase[[;;10]]*)


(* ::Input:: *)
(*trainFullBase[[;;10,{1,2}]](*first 10 topological fingerprints and bandgaps of trained dataset for full baseline RF model*)*)
