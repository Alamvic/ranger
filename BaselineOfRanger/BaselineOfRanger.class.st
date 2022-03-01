Class {
	#name : #BaselineOfRanger,
	#superclass : #BaselineOf,
	#category : #BaselineOfRanger
}

{ #category : #baselines }
BaselineOfRanger >> baseline: spec [

	<baseline>
	spec for: #common do: [ spec package: 'Ranger' ]
]
