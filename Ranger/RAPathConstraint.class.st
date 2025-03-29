Class {
	#name : 'RAPathConstraint',
	#superclass : 'RAConstraint',
	#category : 'Ranger-Constraints',
	#package : 'Ranger',
	#tag : 'Constraints'
}

{ #category : 'evaluating' }
RAPathConstraint >> evaluateWith: anObjectBuilder [
	
	self subclassResponsibility
]

{ #category : 'evaluating' }
RAPathConstraint >> removeRedundances [
	
	operands := operands collect: #removeRedundances.
	
	^ self
]
