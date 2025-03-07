Class {
	#name : 'RAShiftableIntMutator',
	#superclass : 'RASyntacticPathMutator',
	#instVars : [
		'shiftableValues'
	],
	#category : 'Ranger-Exploring-Mutation',
	#package : 'Ranger-Exploring',
	#tag : 'Mutation'
}

{ #category : 'initialization' }
RAShiftableIntMutator >> initialize [ 
	super initialize.
	shiftableValues := {
		1020 . 1069547520 . 3221225535 . 66846720 . 255
	} collect: [ :n | RAConstant new value: n ]
]

{ #category : 'testing' }
RAShiftableIntMutator >> isMutableConstraint: aConstraint [

	^ self isIntObjVar: aConstraint 
]

{ #category : 'as yet unclassified' }
RAShiftableIntMutator >> mutantVariants: constraint [
		
	| var |
	var := constraint operands first.
	"1 halt."
	^ shiftableValues collect: [ :value | 
		"Var = shiftableValue"
		RAEqualsConstraint new operands: { var . value }
	]
]

{ #category : 'as yet unclassified' }
RAShiftableIntMutator >> mutations: constraints [
	^ self mutateByEachConstraint: constraints
]
