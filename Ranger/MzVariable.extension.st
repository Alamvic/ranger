Extension { #name : 'MzVariable' }

{ #category : '*Ranger' }
MzVariable >> evaluateWith: anObjectBuilder [ 
	
	^ self value
]

{ #category : '*Ranger' }
MzVariable >> isConstant [
	
	^ false
]

{ #category : '*Ranger' }
MzVariable >> mzConstraintOnInterpreter: aCogVMSimulatorLSB [ 

	^ self
]
