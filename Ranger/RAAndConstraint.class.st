Class {
	#name : 'RAAndConstraint',
	#superclass : 'RAConstraint',
	#category : 'Ranger-Constraints',
	#package : 'Ranger',
	#tag : 'Constraints'
}

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
