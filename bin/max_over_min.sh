#!/usr/bin/env bash


python -c """
try: 
  print(max([float(${1}), float(${2})])/min([float(${1}), float(${2})])) 
except ZeroDivisionError: 
  print(-1)
""" > ${3}