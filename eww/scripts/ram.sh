#!/bin/bash

free -m | grep Mem | awk '{print int(($3/$2)*100)}'
