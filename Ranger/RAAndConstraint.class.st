Class {
	#name : 'RAAndConstraint',
	#superclass : 'RAConstraint',
	#category : 'Ranger-Constraints',
	#package : 'Ranger',
	#tag : 'Constraints'
}

{ #category : 'accessing' }
RAAndConstraint >> distributeDisjunctions [
	| _operands |
	
	_operands := operands collect: #distributeDisjunctions.
	^ self class new operands: _operands
]

{ #category : 'microzinc' }
RAAndConstraint >> fndConjunctionOperands [
	^ operands
]

{ #category : 'testing' }
RAAndConstraint >> isAnd [

	^ true
]

{ #category : 'as yet unclassified' }
RAAndConstraint >> mutate: mutator [

	^ mutator mutateAndConstraint: self
]

{ #category : 'microzinc' }
RAAndConstraint >> mzConstraintOnInterpreter: anInterpreter [
	
	^ (operands first mzConstraintOnInterpreter: anInterpreter)
		and: (operands second mzConstraintOnInterpreter: anInterpreter)
]

{ #category : 'negating' }
RAAndConstraint >> negated [
	
	^ RAOrConstraint operands: (operands collect: [ :e | e negated ])
]

{ #category : 'accessing' }
RAAndConstraint >> operator [

	^ 'AND'
]

{ #category : 'accessing' }
RAAndConstraint >> removeRedundances [
	
	operands := operands collect: #removeRedundances.
	operands first = operands second ifTrue: [ ^ operands first ].
	
	^ self
]
