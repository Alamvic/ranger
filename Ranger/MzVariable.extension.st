Extension { #name : #MzVariable }

{ #category : #'*Ranger' }
MzVariable >> isConstant [
	
	^ false
]

{ #category : #'*Ranger' }
MzVariable >> mzConstraintOnInterpreter: aCogVMSimulatorLSB [ 

	^ self
]
