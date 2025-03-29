Class {
	#name : 'RAOrConstraint',
	#superclass : 'RAConstraint',
	#category : 'Ranger-Constraints',
	#package : 'Ranger',
	#tag : 'Constraints'
}

{ #category : 'accessing' }
RAOrConstraint >> distributeDisjunctions [
	"Distribute disjunction (v) over conjunction (^):
        - A v (B ^ C) is (A v B) ^ (A v C)
		  - (A v B) v (B ^ C) 
	"
	| _operands |
	
	_operands := operands collect: #distributeDisjunctions.
	_operands first isAnd ifTrue: [ ^ RAAndConstraint new operands: { 
			RAOrConstraint new operands: { _operands first operands first . _operands second } .
			RAOrConstraint new operands: { _operands first operands second . _operands second } .
		}; distributeDisjunctions
	].
	
	_operands second isAnd ifTrue: [ ^ RAAndConstraint new operands: { 
			RAOrConstraint new operands: { _operands second operands first . _operands first } .
			RAOrConstraint new operands: { _operands second operands second . _operands first } .
		}; distributeDisjunctions
	].
	
	^ self

]

{ #category : 'as yet unclassified' }
RAOrConstraint >> mutate: mutator [

	^ mutator mutateOrConstraint: self
]

{ #category : 'microzinc' }
RAOrConstraint >> mzConstraintOnInterpreter: anInterpreter [
	
	^ (operands first mzConstraintOnInterpreter: anInterpreter)
		or: (operands second mzConstraintOnInterpreter: anInterpreter)
]

{ #category : 'negating' }
RAOrConstraint >> negated [
	
	^ RAAndConstraint operands: (operands collect: [ :e | e negated ]) 
]

{ #category : 'accessing' }
RAOrConstraint >> operator [

	^ 'OR'
]

{ #category : 'accessing' }
RAOrConstraint >> removeRedundances [
	
	operands := operands collect: #removeRedundances.
	operands first = operands second ifTrue: [ ^ operands first ].
	
	^ self
]
