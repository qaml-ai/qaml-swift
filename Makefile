# Makefile for Swift Package Manager project

# Package name
PACKAGE_NAME = qaml

build:
	swift build

# Targets
all: clean build test

test:
	swift test

clean:
	swift package clean

generate-xcodeproj:
	swift package generate-xcodeproj

update:
	swift package update

resolve:
	swift package resolve

.PHONY: all build test clean generate-xcodeproj update resolve
