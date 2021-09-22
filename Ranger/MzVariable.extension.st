Extension { #name : #MzVariable }

{ #category : #'*Ranger' }
MzVariable >> evaluateWith: aCogVMSimulatorLSB [ 
	
	^ self value
]

{ #category : #'*Ranger' }
MzVariable >> isConstant [
	
	^ false
]

{ #category : #'*Ranger' }
MzVariable >> mzConstraintOnInterpreter: aCogVMSimulatorLSB [ 

	^ self
]
