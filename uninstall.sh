#!/bin/bash
cd setup

ls setup*.sh | while read X; do bash $X uninstall; done

cd ..
