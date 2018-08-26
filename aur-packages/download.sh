#!/bin/sh
wget -c -i file.list && sha256sum -c SHA256SUMS && echo ok
