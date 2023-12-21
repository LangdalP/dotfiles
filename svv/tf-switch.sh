#! /usr/bin/env bash

function tf13() {
  brew unlink terraform@0.12
  brew link terraform
}

function tf12() {
  brew unlink terraform
  brew link --force terraform@0.12
}
