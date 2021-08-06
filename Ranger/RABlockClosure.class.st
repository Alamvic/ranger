Class {
	#name : #RABlockClosure,
	#superclass : #Object,
	#instVars : [
		'ast',
		'outerContext'
	],
	#category : #'Ranger-Interpreter'
}

{ #category : #'as yet unclassified' }
RABlockClosure class >> on: aRBBlockNode home: aFrame [

	^ self new
		ast: aRBBlockNode;
		outerContext: aFrame;
		yourself
]

{ #category : #accessing }
RABlockClosure >> ast [

	^ ast
]

{ #category : #accessing }
RABlockClosure >> ast: anObject [

	ast := anObject
]

{ #category : #evaluating }
RABlockClosure >> cull: arg [
]

{ #category : #accessing }
RABlockClosure >> home [

	^ outerContext home
]

{ #category : #accessing }
RABlockClosure >> outerContext: anObject [

	outerContext := anObject
]

{ #category : #evaluating }
RABlockClosure >> value [
]
