#!/bin/bash
(yes | nc -Nvkl -p 9091) &
yes | nc -Nvkl -p 9092
