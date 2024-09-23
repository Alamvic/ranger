Class {
	#name : 'RAOrConstraint',
	#superclass : 'RAConstraint',
	#category : 'Ranger-Constraints',
	#package : 'Ranger',
	#tag : 'Constraints'
}

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
