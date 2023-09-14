# CCFinalProject
Houses both Mathematica notebooks for the final project in my undergrad computational chemistry class.

My process
  1. Start with the "baseline" approach, trying each of the single models.
  2. Addressing the organic molecule problem using the RDKit MolecularFingerprint package.
  3. Compare LMs
  4. Compare descriptors
  5. Build the ensemble
     a. Hold aside a portion of the training set (dividing your total data into training-main, training-meta, and test sets).
     b. After training the individual models on the training-main data, use them to create a NEW dataset based on the training-meta data items.
     c. The inputs to the metamodel are the outputs from my trained single models {model1, m2, m3} -> band gap.
     d. Use this new dataset to train the meta model
     e. Evaluate performances
       I. Is this any better than just applying each of the models? We’ll find out…
