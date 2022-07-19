#!/usr/bin/env bash

# create data directory if configure script fails
export out
$python $out/scripts/configure.py
