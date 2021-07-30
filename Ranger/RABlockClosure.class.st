Class {
	#name : #RABlockClosure,
	#superclass : #Object,
	#instVars : [
		'home',
		'ast'
	],
	#category : #'Ranger-Interpreter'
}

{ #category : #'as yet unclassified' }
RABlockClosure class >> on: aRBBlockNode home: aFrame [

	^ self new
		ast: aRBBlockNode;
		home: aFrame;
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

	^ home
]

{ #category : #accessing }
RABlockClosure >> home: anObject [

	home := anObject
]

{ #category : #evaluating }
RABlockClosure >> value [
]
